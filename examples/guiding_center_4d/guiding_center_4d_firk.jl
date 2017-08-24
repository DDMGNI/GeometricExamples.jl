
include("../matplotlib_settings.jl")

using GeometricExamples

include("guiding_center_4d_settings_firk.jl")

tableau_list = get_tableau_list_firk()

equ = problem.guiding_center_4d_ode()

include("guiding_center_4d.jl")

run_tableau_list(tableau_list, equ, Δt, ntime)

generate_html(tableau_list, figures, prefix, fig_suff, fig_dir, out_dir, html_file;
              title=coll_title, params=get_params(Δt, ntime, problem))
