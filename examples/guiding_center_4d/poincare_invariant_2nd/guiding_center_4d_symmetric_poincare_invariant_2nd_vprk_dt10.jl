
using GeometricIntegrators
using ChargedParticleDynamics.GuidingCenter4d.SymmetricSurface
using GeometricExamples

const Δt     = 10.
const ntime  = 1000
const nx     = 100
const ny     = 100
const nsave  = 2
const nplot  = 4
const run_id = "poincare_2nd_symmetric_vprk_dt10"

include("../guiding_center_4d_settings_vprk.jl")

tableau_list = get_tableau_list_vprk_projection()

pinv = guiding_center_4d_iode_poincare_invariant_2nd(Δt, nx, ny, ntime, nsave)

include("guiding_center_4d_symmetric_poincare_invariant_2nd.jl")
