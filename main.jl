module Tileworld
    using Gtk
    
    include("objects.jl")
    include("grid.jl")
    include("astar.jl")
    include("view.jl")

    canvas = @GtkCanvas(COLS*MAG + 200, ROWS * MAG)
    win = GtkWindow(canvas, "TileWorld", COLS * MAG + 200, ROWS * MAG)
    showall(win)

    grid = Grid(6, 10)
    g_timeout_add(update, 200) # run update every 200 millis


    function update() 
        for a in grid.agents
            update(grid, a)
        end
        drawGrid(canvas, grid)
        printGrid(grid)
        Cint(true) # continue
    end

    if !isinteractive()
        cond = Condition()
        signal_connect(win, :destroy) do widget
            notify(cond)
        end
        wait(cond)
    end

end