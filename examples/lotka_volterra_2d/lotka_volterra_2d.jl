
using DataStructures
using Pkg
using Plots

using GeometricProblems.LotkaVolterra2d
using GeometricProblems.Diagnostics


# select Plots backend
gr()
# pgfplots()
# plotly()
# plotlyjs()

# create output directory
if !isdir(out_dir * "/" * fig_dir)
    mkpath(out_dir * "/" * fig_dir)
end

# create list of figures to put in list
figures = (
    "_solution",
    "_energy_error"
)

# suffix of figure files
fig_suff = ".png"

# collect simulation parameters
function get_params(Δt, ntime, problem)
    params = OrderedDict()
    params["Δt"] = Δt
    params["nt"] = ntime
    params["problem"] = problem
    params["GeometricIntegrators.jl"] = Pkg.installed()["GeometricIntegrators"]
    params["GeometricProblems.jl"] = Pkg.installed()["GeometricProblems"]
    params
end



function run_lotka_volterra_2d(int::Integrator, ode::Equation, Δt, nt, filename; kwargs...)
    sim = Simulation(ode, int, Δt, "Lotka-Volterra 2d", prefix * filename * ".hdf5", nt; kwargs...)
    sol = run!(sim)
    run_diagnostics(sol, Δt, nt, filename)
end


function run_lotka_volterra_2d(tableau::AbstractTableau, ode::Equation, Δt, nt; integrator=Integrator, filename=nothing)
    int = integrator(ode, tableau, Δt)

    println()
    println("Running ", tableau.name, " (", filename, ") for ", nt, " time steps...")

    run_lotka_volterra_2d(int, ode, Δt, nt, filename)
end


function run_lotka_volterra_2d(basis::Basis, quadrature::Quadrature, ode::Equation, Δt, nt; integrator=Integrator, filename=nothing)
    int = IntegratorCGVI(ode, basis, quadrature, Δt)

    println()
    println("Running ", filename, " for ", nt, " time steps of Δt = ", Δt, "...")

    run_lotka_volterra_2d(int, ode, Δt, nt, filename)
end


function run_diagnostics(sol, Δt, nt, filename)
    if filename ≠ nothing
        ndrift = div(nt, 10)

        if nt > 100000
            npl = nplot
        else
            npl = 1
        end

        if nt ≤ 200
            markersize=5
        else
            markersize=.5
        end


        # plot overview
        plotlotkavolterra2d(sol)
        savefig(out_dir * "/" * fig_dir * "/" * prefix * filename * fig_suff)

        # plot solution
        plotlotkavolterra2dsolution(sol)
        # markersize=markersize
        # xlim(XLIM)
        # ylim(YLIM)
        # xlabel(L"$q_{1} (t)$", labelpad=10, fontsize=20)
        # ylabel(L"$q_{2} (t)$", labelpad=10, fontsize=20)
        savefig(out_dir * "/" * fig_dir * "/" * prefix * filename * "_solution" * fig_suff)

        # plot energy error
        H, ΔH = compute_energy_error(sol.t, sol.q);
        plotenergyerror(sol.t, ΔH)
        savefig(out_dir * "/" * fig_dir * "/" * prefix * filename * "_energy_error" * fig_suff)

        # plot energy drift
        Tdrift, Hdrift = compute_error_drift(sol.t, ΔH, ndrift)
        plotenergydrift(Tdrift, Hdrift)
        savefig(out_dir * "/" * fig_dir * "/" * prefix * filename * "_energy_drift" * fig_suff)

        # plot momentum error
        if isdefined(sol, :p)
            Δp = compute_momentum_error(sol.t, sol.q, sol.p)
            plotmomentumerror(sol.t, Δp)
            savefig(out_dir * "/" * fig_dir * "/" * prefix * filename * "_momentum_error" * fig_suff)
        end

        # plot Lagrange multiplier
        if isdefined(sol, :λ)
            plotlagrangemultiplier(sol.t, sol.λ)
            savefig(out_dir * "/" * fig_dir * "/" * prefix * filename * "_lambda" * fig_suff)
        end
    end
end


function run_tableau_list(tableaus, ode, Δt, ntime)
    for tab in tableaus
        if length(tab) ≥ 4
            nt = tab[4]
        else
            nt = ntime
        end

        if length(tab) ≥ 5
            dt = tab[5]
        else
            dt = Δt
        end

        run_lotka_volterra_2d(tab[2], ode, dt, nt; integrator=tab[1], filename=tab[3])
    end
end


function run_tableau_list_cgvi(tableaus, ode, Δt, ntime)
    for tab in tableaus
        if length(tab) ≥ 4
            nt = tab[4]
        else
            nt = ntime
        end

        if length(tab) ≥ 5
            dt = tab[5]
        else
            dt = Δt
        end

        run_lotka_volterra_2d(tab[1], tab[2], ode, dt, nt; filename=tab[3])
    end
end
