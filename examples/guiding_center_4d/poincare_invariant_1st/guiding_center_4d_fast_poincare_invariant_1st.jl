
include("../../matplotlib_settings.jl")

set_config(:tab_compensated_summation, false)

using ChargedParticleDynamics.GuidingCenter4d: plot_integral_error, plot_poincare_loop, plot_poincare_trajectories

const coll_title = "Guiding Center 4D Fast 1st Poincaré Integral Invariant"

XMIN = 1.5
XMAX = 2.0
YMIN = -0.25
YMAX = +0.25

include("../guiding_center_4d_poincare_invariant_1st.jl")
