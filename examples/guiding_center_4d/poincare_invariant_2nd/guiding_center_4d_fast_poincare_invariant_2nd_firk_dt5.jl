
using GeometricIntegrators
using ChargedParticleDynamics.GuidingCenter4d.TokamakFastSurface
using GeometricExamples

const Δt     = 5.
const ntime  = 5000
const nx     = 200
const ny     = 200
const nsave  = 10
const nplot  = 5
const run_id = "poincare_2nd_fast_firk_dt5"

include("guiding_center_4d_settings_firk.jl")

tableau_list = get_tableau_list_firk()

pinv = guiding_center_4d_ode_poincare_invariant_2nd(Δt, nx, ny, ntime, nsave)

include("guiding_center_4d_fast_poincare_invariant_2nd.jl")
