
using ImportMacros

@import ChargedParticleDynamics.GuidingCenter4d.TokamakFastBarelyPassing as problem

# run configuration
const Δt    = 2.5
const ntime = 1250000

# plot configuration
const nplot = 1
const splot = true
const XLIM  = ( 0.90,  2.70)
const YLIM  = (-0.80, +0.80)

# output configuration
const coll_title = "Guiding Center 4D Fast Barely Passing"
