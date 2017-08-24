
@import ChargedParticleDynamics.GuidingCenter4d.TokamakBarelyTrapped as problem

# run configuration
const Δt    = 800.
const ntime = 1250000

# plot configuration
const nplot = 1
const splot = true
const XLIM  = ( 0.90,  1.125)
const YLIM  = (-0.10, +0.10)

# output configuration
const title     = "Guiding Center 4D Tokamak Barely Trapped"
const fig_dir   = run_id
const html_file = run_id * ".html"
