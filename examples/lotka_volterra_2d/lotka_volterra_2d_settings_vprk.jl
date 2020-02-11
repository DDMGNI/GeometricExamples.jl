
const out_dir = "../../docs/src/integrators/projection_methods/lotka_volterra_2d/"
const run_id  = "lotka_volterra_2d_vprk"

include("lotka_volterra_2d_settings.jl")

# set_config(:quasi_newton_refactorize, 1)
set_config(:nls_atol, 8eps())
set_config(:nls_rtol, 2eps())
set_config(:nls_stol, 2eps())
# set_config(:nls_nmin, 2)
set_config(:nls_nmax, 20)
