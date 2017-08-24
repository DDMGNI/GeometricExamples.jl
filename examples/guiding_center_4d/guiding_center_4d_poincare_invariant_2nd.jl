
using DataStructures

const out_dir = "../../docs/src/diagnostics/poincare_2nd/guiding_center_4d/"

# create list of figures to put in list
figures = (
    "_poincare_2nd_q",
    "_poincare_2nd_p",
    "_poincare_2nd_l"
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
        filename   = out_dir * "/" * fig_dir * "/" * prefix*runid*"_nx"*string(pinv.nx)*"_ny"*string(pinv.ny)*"_nt"*string(pinv.ntime)

        sim = Simulation(pinv.equ, integrator, tableau, pinv.Δt, runid, filename * "_solution.h5", pinv.ntime, pinv.nsave)
        sol = run!(sim)

        I, J, K, L = evaluate_poincare_invariant(pinv, sol)

        write_to_hdf5(pinv, sol, filename * "_poincare_2nd.h5")


        info("Plotting results...")

        plot_integral_error(sol.t.t, I, filename * "_poincare_2nd_q" * fig_suff;
                            plot_title=L"$\Delta \int_S \omega_{ij} (q) \, dq^i \wedge dq^j$")

        if isdefined(sol, :p)
            plot_integral_error(sol.t.t, J, filename * "_poincare_2nd_p" * fig_suff;
                                plot_title=L"$\Delta \int_S dp_i \, dq^i$")
        end

        if isdefined(sol, :λ)
            plot_integral_error(sol.t.t, L, filename * "_poincare_2nd_l" * fig_suff;
                                plot_title=L"$\Delta \int_S ( \omega_{ij} (q) \, dq^i \wedge dq^j - \Delta t^2 \, \omega_{ij} (q) \, d\lambda^i \wedge d\lambda^j$")
        end

        plot_poincare_surface(sol, nplot, filename * "_area" * fig_suff; xmin=XMIN, xmax=XMAX, ymin=YMIN, ymax=YMAX)

    end
end


run_tableau_list(tableau_list, pinv, prefix, out_dir, fig_dir, nplot)


# generate HTML file
