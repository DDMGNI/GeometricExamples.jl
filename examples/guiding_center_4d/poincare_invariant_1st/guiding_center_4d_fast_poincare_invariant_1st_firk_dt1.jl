
using GeometricIntegrators
using ChargedParticleDynamics.GuidingCenter4d.TokamakFastLoop
using GeometricExamples

const Δt     = 1.
const ntime  = 50000
const nloop  = 200
const nsave  = 50
const nplot  = 10
const run_id = "poincare_1st_fast_firk_dt1"

include("../guiding_center_4d_settings_firk.jl")

tableau_list = get_tableau_list_firk()

pinv = guiding_center_4d_ode_poincare_invariant_1st(Δt, nloop, ntime, nsave)

include("guiding_center_4d_fast_poincare_invariant_1st.jl")
