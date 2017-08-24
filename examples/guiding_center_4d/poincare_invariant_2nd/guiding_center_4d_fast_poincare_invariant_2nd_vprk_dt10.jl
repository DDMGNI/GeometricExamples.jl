
using GeometricIntegrators
using ChargedParticleDynamics.GuidingCenter4d.TokamakFastSurface
using GeometricExamples

const Δt     = 10.
const ntime  = 2500
const nx     = 200
const ny     = 200
const nsave  = 5
const nplot  = 5
const run_id = "poincare_2nd_fast_vprk_dt10"

include("guiding_center_4d_settings_vprk.jl")

tableau_list = get_tableau_list_vprk_projection()

pinv = guiding_center_4d_iode_poincare_invariant_2nd(Δt, nx, ny, ntime, nsave)

include("guiding_center_4d_fast_poincare_invariant_2nd.jl")
