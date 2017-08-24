
using GeometricIntegrators
using ChargedParticleDynamics.GuidingCenter4d.SymmetricLoop
using GeometricExamples

const Δt     = 10.
const ntime  = 5000
const nloop  = 2000
const nsave  = 5
const nplot  = 5
const run_id = "poincare_1st_symmetric_vprk_dt10"

include("../guiding_center_4d_settings_vprk.jl")

tableau_list = get_tableau_list_vprk_projection()

pinv = guiding_center_4d_iode_poincare_invariant_1st(Δt, nloop, ntime, nsave)

include("guiding_center_4d_symmetric_poincare_invariant_1st.jl")
