
using DataStructures
using GeometricExamples

const out_dir = "../../docs/src/diagnostics/poincare_1st/guiding_center_4d/"

# create list of figures to put in list
figures = (
    "_poincare_1st_q",
    "_poincare_1st_p",
    "_poincare_1st_l"
)

# suffix of figure files
fig_suff = ".png"

# collect simulation parameters
function get_params(Δt, ntime, problem)
    params = OrderedDict()
    params["Δt"] = Δt
    params["nt"] = ntime
    params["nloop"] = nloop
    params["nsave"] = nsave
    params["nplot"] = nplot
    params["GeometricIntegrators.jl"] = package_version("GeometricIntegrators")
    params["ChargedParticleDynamics.jl"] = package_version("ChargedParticleDynamics")
    params["MagneticEquilibria.jl"] = package_version("MagneticEquilibria")
    params
end


function run_tableau_list(tableaus, pinv, prefix, out_dir, fig_dir, nplot)
    # create output directory
    if !isdir(out_dir * "/" * fig_dir)
        mkpath(out_dir * "/" * fig_dir)
    end

    for tab in tableaus
        integrator = tab[1]
        tableau    = tab[2]
        runid      = tab[3]
        filename   = out_dir * "/" * fig_dir * "/" * prefix*runid*"_nl"*string(pinv.nloop)*"_nt"*string(pinv.ntime)

        sim = Simulation(pinv.equ, integrator, tableau, pinv.Δt, runid, filename * "_solution.h5", pinv.ntime, pinv.nsave)
        sol = run!(sim)

        info("Computing loop integrals...")

        I, J, L = evaluate_poincare_invariant(pinv, sol)

        write_to_hdf5(pinv, sol, filename * "_poincare_1st.h5")


        info("Plotting results...")

        plot_integral_error(sol.t.t, I, filename * "_poincare_1st_q" * fig_suff;
                            plot_title=L"$\Delta \int_\gamma \theta_i (q) \, dq^i$")

        if isdefined(sol, :p)
            plot_integral_error(sol.t.t, J, filename * "_poincare_1st_p" * fig_suff;
                                plot_title=L"$\Delta \int_\gamma p_i \, dq^i$")
        end

        if isdefined(sol, :λ)
            plot_integral_error(sol.t.t, L, filename * "_poincare_1st_l" * fig_suff;
                                plot_title=L"$\Delta \int_\gamma ( \theta_i (q) - \Delta t \, \lambda^{k} \theta_{k,i} (q) ) ( dq^i - \Delta t \, d\lambda^i )$")
        end

        plot_poincare_loop(sol, nplot, filename * "_loop" * fig_suff; xmin=XMIN, xmax=XMAX, ymin=YMIN, ymax=YMAX)
        plot_poincare_trajectories(sol, nplot, filename * "_trajectories" * fig_suff; xmin=XMIN, xmax=XMAX, ymin=YMIN, ymax=YMAX)

    end
end


run_tableau_list(tableau_list, pinv, prefix, out_dir, fig_dir, nplot)


# generate HTML file
