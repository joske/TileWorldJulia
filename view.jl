using Gtk, Graphics

const MAG = 20

function drawGrid(canvas::GtkCanvas, grid::Grid)
    @guarded draw(canvas) do widget
        ctx = getgc(canvas)
        reset_clip(ctx)
        set_source_rgb(ctx, 0, 0, 0)
        rectangle(ctx, 0, 0, COLS * MAG, COLS * MAG)
        stroke(ctx)
        for row in 1:10
            for col in 1:10
                if grid.objects[col, row] !== missing
                    o = grid.objects[col, row]
                    x = col * MAG
                    y = row * MAG
                    set_source_rgb(ctx, 0, 0, 0)
                    if o isa Agent
                        new_path(ctx)
                        r, g, b = getColor(o.id)
                        set_source_rgb(ctx, r, g, b)
                        rectangle(ctx, x, y, MAG, MAG)
                        stroke(ctx)
                    elseif o isa Tile
                        new_path(ctx)
                    arc(ctx, x + MAG / 2, y + MAG / 2, MAG / 2, 0, 2pi)
                    stroke(ctx)
                elseif o isa Hole
                    new_path(ctx)
                    arc(ctx, x + MAG / 2, y + MAG / 2, MAG / 2, 0, 2pi)
                    fill(ctx)
                elseif o isa Obstacle
                    new_path(ctx)
                    rectangle(ctx, x, y, MAG, MAG)
                    stroke(ctx)
                    end
                end
            end
        end
    # for a in grid.agents
    #     println("Agent $(a.id) : $(a.score)")
    # end
    end
    show(canvas)
end

function getColor(id::Int)
    if id == 1
        return (0, 0, 1)
    elseif id == 2
        return (0, 1, 0)
    elseif id == 3
        return (1, 0, 0)
    elseif id == 4
        return (1, 1, 0)
    elseif id == 5
        return (1, 0, 1)
    else
        return (0, 1, 1)
    end    
end