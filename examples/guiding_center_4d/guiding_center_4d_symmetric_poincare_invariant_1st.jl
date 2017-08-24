
include("../matplotlib_settings.jl")

using GeometricIntegrators
using ChargedParticleDynamics.GuidingCenter4d.SymmetricLoop

using ChargedParticleDynamics.GuidingCenter4d: plot_integral_error, plot_loop, plot_trajectories

include("guiding_center_4d_settings_vprk.jl")
include("guiding_center_4d_poincare_invariant_1st.jl")
