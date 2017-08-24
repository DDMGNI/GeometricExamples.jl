
using GeometricIntegrators

set_config(:tab_compensated_summation, true)

const out_dir = "../../docs/src/integrators/runge_kutta/guiding_center_4d/"
const run_id  = "fast_barely_trapped_firk_comp"

include("guiding_center_4d_fast_barely_trapped.jl")
include("../guiding_center_4d_firk.jl")
