
using GeometricIntegrators

set_config(:tab_compensated_summation, true)

const out_dir = "../../docs/src/integrators/runge_kutta/guiding_center_4d/"
const run_id  = "fast_deeply_trapped_firk_comp"

include("guiding_center_4d_fast_deeply_trapped.jl")
include("../guiding_center_4d_firk.jl")
