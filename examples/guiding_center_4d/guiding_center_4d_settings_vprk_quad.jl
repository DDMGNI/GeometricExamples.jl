
include("guiding_center_4d_settings.jl")

set_config(:ls_solver, :julia)
set_config(:quasi_newton_refactorize, 1)
set_config(:nls_atol, Dec128(1E-32))
set_config(:nls_rtol, Dec128(1E-32))
set_config(:nls_stol, Dec128(1E-32))
set_config(:nls_nmax, 20)
