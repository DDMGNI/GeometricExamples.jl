
# run configuration
const Δt    = 0.01
const ntime = 10000

# plot configuration
const nplot = 1
const splot = true
# const XLIM  = ( 0.90,  1.10)
# const YLIM  = (-0.10, +0.10)

# output configuration
const title     = "Lotka-Volterra 2D"
const prefix    = "lotka_volterra_2d_"
const fig_dir   = run_id
const html_file = run_id * ".html"
const coll_title = "Lotka-Volterra 2D"

# set_config(:nls_atol_break, 1E-3)
# set_config(:nls_rtol_break, 1E-3)
# set_config(:nls_stol_break, 1E-3)
