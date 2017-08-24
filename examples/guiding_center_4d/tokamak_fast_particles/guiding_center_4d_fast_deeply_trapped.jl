
using ImportMacros

@import ChargedParticleDynamics.GuidingCenter4d.TokamakFastDeeplyTrapped as problem

# run configuration
const Δt    = 5.
const ntime = 1250000

# plot configuration
const nplot = 1
const splot = true
const XLIM  = ( 2.10,  3.00)
const YLIM  = (-0.80, +0.80)

# output configuration
const coll_title = "Guiding Center 4D Fast Deeply Trapped"
