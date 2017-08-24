
using GeometricIntegrators

set_config(:tab_compensated_summation, false)

const out_dir = "../../docs/src/integrators/projection_methods/guiding_center_4d/"
const run_id  = "fast_barely_passing_vprk"

include("guiding_center_4d_fast_barely_passing.jl")
include("../guiding_center_4d_vprk.jl")
