
using DataStructures

# create output directory
if !isdir(out_dir * "/" * fig_dir)
    mkpath(out_dir * "/" * fig_dir)
end

# create list of figures to put in list
figures = (
    "",
    "_energy_error",
    "_toroidal_momentum_error"
)

# suffix of figure files
fig_suff = ".png"

# collect simulation parameters
function get_params(Δt, ntime, problem)
    params = OrderedDict()
    params["Δt"] = Δt
    params["nt"] = ntime
    params["problem"] = problem
    params["GeometricIntegrators.jl"] = package_version("GeometricIntegrators")
    params["ChargedParticleDynamics.jl"] = package_version("ChargedParticleDynamics")
    params["MagneticEquilibria.jl"] = package_version("MagneticEquilibria")
    params
end


function compute_error_drift(t, err, lint=100)
    const nint = div(t.n, lint)

    drift = zeros(eltype(err), nint)

    for i in 1:nint
        i1 = lint*(i-1)+1
        i2 = lint*i
        drift[i] = maximum(err[i1:i2])
    end

    drift - drift[1]
end

function compute_energy_error(t, q)
    h = zeros(eltype(q), q.nt+1)
    for i in 1:(q.nt+1)
        h[i] = problem.hamiltonian(t.t[i], q.d[:,i])
    end
    h_error = (h - h[1]) / h[1]
end

function compute_toroidal_momentum_error(t, q)
    P = zeros(eltype(q), q.nt+1)
    for i in 1:(q.nt+1)
        P[i] = problem.toroidal_momentum(t.t[i], q.d[:,i])
    end
    P_error = (P - P[1]) / P[1]
end

# function compute_toroidal_momentum_error(t, q)
#     Q = (q.d[:,1:end-1] .+ q.d[:,2:end]) ./ 2
#     P = zeros(eltype(q), q.nt)
#     for i in 1:(q.nt)
#         P[i] = toroidal_momentum(t.t[i], Q[:,i])
#     end
#     P_error = (P - P[1]) / P[1]
# end

function compute_momentum_error(t, q, p)
    p1_error = zeros(q.nt+1)
    p2_error = zeros(q.nt+1)
    p3_error = zeros(q.nt+1)
    p4_error = zeros(q.nt+1)

    for i in 1:(q.nt+1)
        p1_error[i] = p.d[1,i] - problem.α1(t.t[i], q.d[:,i])
        p2_error[i] = p.d[2,i] - problem.α2(t.t[i], q.d[:,i])
        p3_error[i] = p.d[3,i] - problem.α3(t.t[i], q.d[:,i])
        p4_error[i] = p.d[4,i] - problem.α4(t.t[i], q.d[:,i])
    end

    (p1_error, p2_error, p3_error, p4_error)
end


function compute_one_form(t, q)
    p1 = zeros(q.nt+1)
    p2 = zeros(q.nt+1)
    p3 = zeros(q.nt+1)
    p4 = zeros(q.nt+1)

    for i in 1:(q.nt+1)
        p1[i] = problem.α1(t.t[i], q.d[:,i])
        p2[i] = problem.α2(t.t[i], q.d[:,i])
        p3[i] = problem.α3(t.t[i], q.d[:,i])
        p4[i] = problem.α4(t.t[i], q.d[:,i])
    end

    (p1, p2, p3, p4)
end


function power10ticks(x, pos)
    if x == 0
        return "\$ 0 \$"
    end

    exponent    = @sprintf("%2d",   floor(Int64, log10(x)))
    coefficient = @sprintf("%2.0f", x / (10^floor(log10(x))))

    return "\$ $coefficient \\times 10^\{ $exponent \} \$"
end

xf = matplotlib[:ticker][:FuncFormatter](power10ticks)

yf = matplotlib[:ticker][:ScalarFormatter]()
yf[:set_powerlimits]((-1,+1))
yf[:set_scientific](true)
yf[:set_useOffset](true)


function run_guiding_center_4d(int::Integrator, ode::Equation, Δt, nt, filename)
    sol = Solution(ode, Δt, nt)

    try
        integrate!(int, sol)
    catch ex
        if isa(ex, DomainError)
            warn("DOMAIN ERROR")
        elseif isa(ex, ErrorException)
            warn("Simulation exited early.")
            warn(ex.msg)
        end
    end

    run_diagnostics(sol, Δt, nt, filename)
end


function run_guiding_center_4d(tableau::AbstractTableau, ode::Equation, Δt, nt; integrator=Integrator, filename=nothing)
    int = integrator(ode, tableau, Δt)

    println()
    println("Running ", tableau.name, " (", filename, ") for ", nt, " time steps...")

    run_guiding_center_4d(int, ode, Δt, nt, filename)
end


function run_guiding_center_4d(basis::Basis, quadrature::Quadrature, ode::Equation, Δt, nt; integrator=Integrator, filename=nothing)
    int = IntegratorCGVI(ode, basis, quadrature, Δt)

    println()
    println("Running ", filename, " for ", nt, " time steps of Δt = ", Δt, "...")

    run_guiding_center_4d(int, ode, Δt, nt, filename)
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

        # plot solution
        fig = figure(figsize=(5,5))
        subplots_adjust(left=0.25, right=0.95, top=0.96, bottom=0.16)
        plot(sol.q.d[1,1:npl:sol.counter+1], sol.q.d[2,1:npl:sol.counter+1], ".", markersize=markersize)
        xlim(XLIM)
        ylim(YLIM)
        xlabel(L"$q_{1} (t)$", labelpad=10, fontsize=20)
        ylabel(L"$q_{2} (t)$", labelpad=10, fontsize=20)
        savefig(out_dir * "/" * fig_dir * "/" * prefix * filename * fig_suff)
        close(fig)

        # plot energy error
        h_error = compute_energy_error(sol.t, sol.q)

        fig = figure(figsize=(8,5))
        subplots_adjust(left=0.16, right=0.95, top=0.95, bottom=0.16)
        plot(sol.t.t[1:npl:sol.counter+1], h_error[1:npl:sol.counter+1], ".", markersize=markersize)
        sol.counter > 0 ? xlim(sol.t[0], sol.t[sol.counter]) : xlim(sol.t[0], sol.t[end])
        xlabel(L"$t$", labelpad=10, fontsize=20)
        ylabel(L"$[H(t) - H(0)] / H(0)$", fontsize=20)
        ax = gca()
        ax[:xaxis][:set_major_formatter](xf)
        ax[:yaxis][:set_major_formatter](yf)
        savefig(out_dir * "/" * fig_dir * "/" * prefix * filename * "_energy_error" * fig_suff)
        close(fig)

        # plot energy drift
        h_drift = compute_error_drift(sol.t, h_error, ndrift)

        fig = figure(figsize=(8,5))
        subplots_adjust(left=0.16, right=0.95, top=0.95, bottom=0.16)
        plot(sol.t.t[div(ndrift,2)+1:ndrift:end], h_drift, ".", markersize=10)
        xlim(sol.t[0], sol.t[end])
        xlabel(L"$t$", labelpad=10, fontsize=20)
        ylabel(L"$H_{drift}(t)$", fontsize=20)
        ax = gca()
        ax[:xaxis][:set_major_formatter](xf)
        ax[:yaxis][:set_major_formatter](yf)
        savefig(out_dir * "/" * fig_dir * "/" * prefix * filename * "_energy_drift.png")
        close(fig)

        # plot toroidal momentum error
        P_error = compute_toroidal_momentum_error(sol.t, sol.q)

        fig = figure(figsize=(8,5))
        subplots_adjust(left=0.16, right=0.95, top=0.95, bottom=0.16)
        plot(sol.t.t[1:npl:sol.counter+1], P_error[1:npl:sol.counter+1], ".", markersize=markersize)
        sol.counter > 0 ? xlim(sol.t[0], sol.t[sol.counter]) : xlim(sol.t[0], sol.t[end])
        xlabel(L"$t$", labelpad=10, fontsize=20)
        ylabel(L"$[P(t) - P(0)] / P(0)$", fontsize=20)
        ax = gca()
        ax[:xaxis][:set_major_formatter](xf)
        ax[:yaxis][:set_major_formatter](yf)
        savefig(out_dir * "/" * fig_dir * "/" * prefix * filename * "_toroidal_momentum_error" * fig_suff)
        close(fig)

        # # plot one-form
        # theta = compute_one_form(sol.t, sol.q)
        #
        # for i in 1:sol.q.nd
        #     fig = figure(figsize=(6,5))
        #     subplots_adjust(left=0.18, right=0.95, top=0.95, bottom=0.16)
        #     plot(sol.t.t[1:npl:end], theta[i][1:npl:end], ".", markersize=markersize)
        #     xlim(sol.t[0], sol.t[end])
        #     if maximum(theta[i]) == 0.
        #         ylim(-2E-16, +2E-16)
        #     end
        #     xlabel("\$ t \$", labelpad=10, fontsize=20)
        #     ylabel("\$ \\vartheta_\{ {i} \} (q(t)) \$", labelpad=6, fontsize=20)
        #     ax = gca()
        #     ax[:xaxis][:set_major_formatter](xf)
        #     ax[:yaxis][:set_major_formatter](yf)
        #     savefig(out_dir * "/" * fig_dir * "/" * prefix * filename * "_one_form" * string(i) * fig_suff)
        #     close(fig)
        # end

        # plot momentum error
        if isdefined(sol, :p)
            p_error = compute_momentum_error(sol.t, sol.q, sol.p)

            for i in 1:sol.p.nd
                fig = figure(figsize=(6,5))
                subplots_adjust(left=0.18, right=0.95, top=0.95, bottom=0.16)
                plot(sol.t.t[1:npl:sol.counter+1], p_error[i][1:npl:sol.counter+1], ".", markersize=markersize)
                sol.counter > 0 ? xlim(sol.t[0], sol.t[sol.counter]) : xlim(sol.t[0], sol.t[end])
                maximum(p_error[i]) == zero(eltype(p_error[i])) ? ylim(-2E-16, +2E-16) : nothing
                xlabel("\$ t \$", labelpad=10, fontsize=20)
                ylabel("\$ p_\{ {i} \} (t) - \\vartheta_\{ {i} \} (q(t)) \$", labelpad=6, fontsize=20)
                ax = gca()
                ax[:xaxis][:set_major_formatter](xf)
                ax[:yaxis][:set_major_formatter](yf)
                savefig(out_dir * "/" * fig_dir * "/" * prefix * filename * "_momentum_error" * string(i) * fig_suff)
                close(fig)
            end
        end

        # plot Lagrange multiplier
        if isdefined(sol, :λ)
            for i in 1:sol.λ.nd
                fig = figure(figsize=(6,5))
                subplots_adjust(left=0.16, right=0.95, top=0.95, bottom=0.16)
                plot(sol.t.t[1:npl:sol.counter+1], sol.λ.d[i,1:npl:sol.counter+1], ".", markersize=markersize)
                sol.counter > 0 ? xlim(sol.t[0], sol.t[sol.counter]) : xlim(sol.t[0], sol.t[end])
                maximum(sol.λ.d[i,:]) == zero(eltype(sol.λ.d)) ? ylim(-2E-16, +2E-16) : nothing
                xlabel("\$t\$", labelpad=10, fontsize=20)
                ylabel("\$\\lambda_\{{i}\} (t)\$", labelpad=6, fontsize=20)
                ax = gca()
                ax[:xaxis][:set_major_formatter](xf)
                ax[:yaxis][:set_major_formatter](yf)
                savefig(out_dir * "/" * fig_dir * "/" * prefix * filename * "_lambda" * string(i) * fig_suff)
                close(fig)
            end
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

        run_guiding_center_4d(tab[2], ode, dt, nt; integrator=tab[1], filename=tab[3])
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

        run_guiding_center_4d(tab[1], tab[2], ode, dt, nt; filename=tab[3])
    end
end
