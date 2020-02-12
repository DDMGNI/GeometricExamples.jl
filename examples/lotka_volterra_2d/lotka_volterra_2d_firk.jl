
using GeometricIntegrators
using GeometricExamples
using ImportMacros

@import GeometricProblems.LotkaVolterra2d as problem

include("lotka_volterra_2d_settings_firk.jl")

tableau_list = get_tableau_list_firk()

equ = problem.lotka_volterra_2d_ode()

include("lotka_volterra_2d.jl")

run_tableau_list(tableau_list, equ, Δt, ntime)

generate_html(tableau_list, figures, figures_detail, prefix, fig_suff, fig_dir, out_dir, html_file;
              title=coll_title, params=get_params(Δt, ntime, problem))
