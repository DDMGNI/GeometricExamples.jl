
const out_dir = "../../docs/src/integrators/projection_methods/lotka_volterra_2d/"
const run_id  = "lotka_volterra_2d_vprk_radau"

# create list of figures to put in list
figures_custom = ("_momentum_error",)

include("lotka_volterra_2d_settings.jl")

# solver settings
set_config(:nls_atol, 8eps())
set_config(:nls_rtol, 2eps())
set_config(:nls_stol, 2eps())
set_config(:nls_nmax, 20)
