
using DecFP
using DecFP: Dec128

Base.convert(::Type{Dec128}, x::Int64) = convert(Dec128, convert(Float64, x))

include("../matplotlib_settings.jl")

using GeometricExamples

include("guiding_center_4d_settings_vprk_quad.jl")

tableau_list = get_tableau_list_vprk_projection(T=Dec128)

equ = problem.guiding_center_4d_iode_dec128()

include("guiding_center_4d.jl")

run_tableau_list(tableau_list, equ, Dec128(Δt), ntime)

generate_html(tableau_list, figures, prefix, fig_suff, fig_dir, out_dir, html_file;
              title=coll_title, params=get_params(Δt, ntime, problem))
