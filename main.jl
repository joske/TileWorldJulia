module Tileworld
    using Random: include
    
    include("objects.jl")
    include("grid.jl")
    include("astar.jl")
    include("view.jl")

    canvas = @GtkCanvas(COLS*MAG + 200, ROWS * MAG)
    win = GtkWindow(canvas, "TileWorld", COLS * MAG + 200, ROWS * MAG)
    showall(win)

    grid = Grid(1, 5)
    for i in 1:20 # 10 timesteps
        for a in grid.agents
            update(grid, a)
        end
        drawGrid(canvas, grid)
        printGrid(grid)
        sleep(1)
    end
end