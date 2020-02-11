
const out_dir   = "../../docs/src/integrators/runge_kutta/lotka_volterra_2d/"
const run_id    = "lotka_volterra_2d_firk"

include("lotka_volterra_2d_settings.jl")

# set_config(:quasi_newton_refactorize, 1)
# set_config(:nls_atol, 1E-20)
# set_config(:nls_rtol, 2eps())
set_config(:nls_nmax, 20)
