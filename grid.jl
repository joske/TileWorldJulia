using Random

struct Grid
    objects::Array
    agents::Array

    function Grid(numAgents)
        objects = Array{Union{Missing, GridObject}}(missing, 10, 10)
        agents = Array{Union{Missing, Agent}}(missing, numAgents)
        grid = new(objects, agents)
        for i in 1:numAgents
            l = randomFreeLocation(grid)
            agents[i] = Agent(i, l)
            objects[l.c, l.r] = agents[i]
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
