
using PyCall

@pyimport matplotlib as mpl
mpl.use("Agg")
mpl.interactive(false)

using PyPlot

# rc("font", size=12)
rc("axes.formatter", use_mathtext=true)
rc("axes.formatter", useoffset=false)
