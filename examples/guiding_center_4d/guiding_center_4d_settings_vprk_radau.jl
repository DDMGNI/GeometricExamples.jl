
include("guiding_center_4d_settings.jl")

set_config(:quasi_newton_refactorize, 1)
set_config(:nls_atol, 4eps())
set_config(:nls_rtol, 2eps())
set_config(:nls_stol, 1E-15)
set_config(:nls_nmin, 2)
set_config(:nls_nmax, 20)
