
using GeometricIntegrators
using GeometricExamples
using ImportMacros

@import GeometricProblems.LotkaVolterra2d as problem

include("lotka_volterra_2d_settings_vprk.jl")

tableau_list = get_tableau_list_vprk_projection()

equ = problem.lotka_volterra_2d_iode()

include("lotka_volterra_2d.jl")

run_tableau_list(tableau_list, equ, Δt, ntime)

generate_html(tableau_list, figures, prefix, fig_suff, fig_dir, out_dir, html_file;
              title=coll_title, params=get_params(Δt, ntime, problem))
