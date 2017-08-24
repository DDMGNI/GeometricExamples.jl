
using ImportMacros

@import ChargedParticleDynamics.GuidingCenter4d.TokamakFastBarelyTrapped as problem

# run configuration
const Δt    = 3.
const ntime = 1250000

# plot configuration
const nplot = 1
const splot = true
const XLIM  = ( 0.75,  3.75)
const YLIM  = (-1.50, +1.50)

# output configuration
const coll_title = "Guiding Center 4D Fast Barely Trapped"
