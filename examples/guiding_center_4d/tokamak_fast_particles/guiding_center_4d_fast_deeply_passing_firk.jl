
using GeometricIntegrators

set_config(:tab_compensated_summation, false)

const out_dir = "../../docs/src/integrators/runge_kutta/guiding_center_4d/"
const run_id  = "fast_deeply_passing_firk"

include("guiding_center_4d_fast_deeply_passing.jl")
include("../guiding_center_4d_firk.jl")
