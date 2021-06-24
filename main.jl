module Tileworld
    using Random: include
    
    include("objects.jl")
    include("grid.jl")
    include("astar.jl")

    grid = Grid(1, 5)
    for i in 1:10 # 10 timesteps
        for a in grid.agents
            update(grid, a)
        end
        printGrid(grid)
        sleep(2)
    end
end