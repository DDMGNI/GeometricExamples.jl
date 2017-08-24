
@import ChargedParticleDynamics.GuidingCenter4d.TokamakBarelyPassing as problem

# run configuration
const Δt    = 800.
const ntime = 1250000

# plot configuration
const nplot = 1
const splot = true
const XLIM  = ( 0.90,  1.10)
const YLIM  = (-0.10, +0.10)

# output configuration
const title     = "Guiding Center 4D Tokamak Barely Passing"
const fig_dir   = run_id
const html_file = run_id * ".html"
