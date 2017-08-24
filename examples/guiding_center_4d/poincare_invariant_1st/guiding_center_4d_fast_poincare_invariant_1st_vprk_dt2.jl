
using GeometricIntegrators
using ChargedParticleDynamics.GuidingCenter4d.TokamakFastLoop
using GeometricExamples

const Δt     = 2.
const ntime  = 25000
const nloop  = 200
const nsave  = 25
const nplot  = 10
const run_id = "poincare_1st_fast_vprk_dt2"

include("../guiding_center_4d_settings_vprk.jl")

tableau_list = get_tableau_list_vprk_projection()

pinv = guiding_center_4d_iode_poincare_invariant_1st(Δt, nloop, ntime, nsave)

include("guiding_center_4d_fast_poincare_invariant_1st.jl")
