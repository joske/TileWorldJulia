using Gtk, Graphics, Cairo

const MAG = 20

function drawGrid(canvas::GtkCanvas, grid::Grid)
    @guarded draw(canvas) do widget
        ctx = getgc(canvas)
        set_source_rgb(ctx, 1, 1, 1)
        rectangle(ctx, 0, 0, COLS * MAG + 200, COLS * MAG)
        fill(ctx)
        set_source_rgb(ctx, 0, 0, 0)
        rectangle(ctx, 0, 0, COLS * MAG, COLS * MAG)
        stroke(ctx)
        for row in 1:ROWS
            for col in 1:COLS
                if grid.objects[col, row] !== missing
                    o = grid.objects[col, row]
                    x = (col - 1) * MAG
                    y = (row - 1) * MAG
                    set_source_rgb(ctx, 0, 0, 0)
                    if o isa Agent
                        r, g, b = getColor(o.id)
                        set_source_rgb(ctx, r, g, b)
                        rectangle(ctx, x, y, MAG, MAG)
                        stroke(ctx)
                        if (o.hasTile)
                            new_path(ctx)
                            arc(ctx, x + MAG / 2, y + MAG / 2, MAG / 2, 0, 2pi)
                            move_to(ctx, x + MAG / 2, y + MAG / 2)
                            show_text(ctx, "$(o.tile.score)")
                            stroke(ctx)
                        end
                    elseif o isa Tile
                        new_path(ctx)
                        arc(ctx, x + MAG / 2, y + MAG / 2, MAG / 2, 0, 2pi)
                        move_to(ctx, x + MAG / 2, y + MAG / 2)
                        show_text(ctx, "$(o.score)")
                        stroke(ctx)
                    elseif o isa Hole
                        new_path(ctx)
                        arc(ctx, x + MAG / 2, y + MAG / 2, MAG / 2, 0, 2pi)
                        fill(ctx)
                    elseif o isa Obstacle
                        new_path(ctx)
                        rectangle(ctx, x, y, MAG, MAG)
                        fill(ctx)
                    end 
                end # not empty
            end # col
        end # row
        x = COLS * MAG + 50
        y = 20
        new_path(ctx)
        for a in grid.agents
            r, g, b = getColor(a.id)
            set_source_rgb(ctx, r, g, b)
            move_to(ctx, x, y + a.id * MAG)
            show_text(ctx, "Agent $(a.id) : $(a.score)")
            stroke(ctx)
        end
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