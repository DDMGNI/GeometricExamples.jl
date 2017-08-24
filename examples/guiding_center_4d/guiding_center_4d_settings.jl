
# output configuration
const prefix    = "guiding_center_4d_"
const fig_dir   = run_id
const html_file = run_id * ".html"

set_config(:nls_atol_break, 1E-3)
set_config(:nls_rtol_break, 1E-3)
set_config(:nls_stol_break, 1E-3)
