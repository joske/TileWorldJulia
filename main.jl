module Tileworld
include("objects.jl")
include("grid.jl")

x = Grid(5)
Base.show(x.objects)
end