using Random

struct Grid
    objects::Array
    agents::Array
    tiles::Array
    holes::Array

    function Grid(numAgents, numObjects)
        objects = Array{Union{Missing, GridObject}}(missing, 10, 10)
        agents = Array{Union{Missing, Agent}}(missing, numAgents)
        tiles = Array{Union{Missing, Tile}}(missing, numObjects)
        holes = Array{Union{Missing, Hole}}(missing, numObjects)
        grid = new(objects, agents, tiles)
        for i in 1:numAgents
            l = randomFreeLocation(grid)
            agents[i] = Agent(i, l)
            objects[l.c, l.r] = agents[i]
        end
        for i in 1:numObjects
            l = randomFreeLocation(grid)
            tiles[i] = Tile(i, l, rand(1:6))
            objects[l.c, l.r] = tiles[i]
        end
        for i in 1:numObjects
            l = randomFreeLocation(grid)
            holes[i] = Hole(i, l)
            objects[l.c, l.r] = holes[i]
        end
        for i in 1:numObjects
            l = randomFreeLocation(grid)
            objects[l.c, l.r] = Obstacle(i, l)
        end
        return grid
    end

end

function isFree(grid, location)
    return grid.objects[location.c, location.r] === missing
end

function randomFreeLocation(grid)
    c = rand(1:10)
    r = rand(1:10)
    l = Location(c, r)
    while (!isFree(grid, l))
        c = rand(1:10)
        r = rand(1:10)
        l = Location(c, r)    
    end
    return l
end

function printGrid(grid)
    for r in 1:10
        for c in 1:10
            if grid.objects[c, r] !== missing
                if grid.objects[c, r] isa Agent
                    print("A")
                elseif grid.objects[c, r] isa Tile
                    print("T")
                elseif grid.objects[c, r] isa Hole
                    print("H")
                elseif grid.objects[c, r] isa Obstacle
                    print("#")
                end
            else
                print(".")
            end
        end
        println()
    end
end