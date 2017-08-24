
include("../../matplotlib_settings.jl")

set_config(:tab_compensated_summation, false)

using ChargedParticleDynamics.GuidingCenter4d: plot_integral_error, plot_poincare_loop, plot_poincare_trajectories

const coll_title = "Guiding Center 4D Symmetric 1st Poincaré Integral Invariant"

const XMIN = -0.5
const XMAX = +0.5
const YMIN = -0.5
const YMAX = +0.5

include("../guiding_center_4d_poincare_invariant_1st.jl")
