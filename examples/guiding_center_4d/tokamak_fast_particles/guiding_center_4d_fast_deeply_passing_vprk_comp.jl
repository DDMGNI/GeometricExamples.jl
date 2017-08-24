
using GeometricIntegrators

set_config(:tab_compensated_summation, true)

const out_dir = "../../docs/src/integrators/projection_methods/guiding_center_4d/"
const run_id  = "fast_deeply_passing_vprk_comp"

include("guiding_center_4d_fast_deeply_passing.jl")
include("../guiding_center_4d_vprk.jl")
