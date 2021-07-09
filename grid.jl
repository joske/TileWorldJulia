const COLS = 40
const ROWS = 40

mutable struct Grid
    objects::Array
    agents::Array
    tiles::Array
    holes::Array

    function Grid(numAgents, numObjects)
        objects = Array{Union{Missing, GridObject}}(missing, COLS, ROWS)
        agents = Array{Union{Missing, Agent}}(missing, numAgents)
        tiles = Array{Union{Missing, Tile}}(missing, numObjects)
        holes = Array{Union{Missing, Hole}}(missing, numObjects)
        grid = new(objects, agents, tiles, holes)
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

function isValid(grid::Grid, l::Location)
    return l.c > 0 && l.c <= COLS && l.r > 0 && l.r <= ROWS && isFree(grid, l)
end

function isFree(grid::Grid, location::Location)
    return grid.objects[location.c, location.r] === missing
end

function randomFreeLocation(grid::Grid)
    c = rand(1:COLS)
    r = rand(1:ROWS)
    l = Location(c, r)
    while (!isFree(grid, l))
        c = rand(1:10)
        r = rand(1:10)
        l = Location(c, r)    
    end
    return l
end

function getClosestTile(grid::Grid, l::Location)
    minDist = 1000000
    best = missing
    for t in grid.tiles
        d = distance(t.location, l)
        if (d < minDist)
            minDist = d
            best = t
        end
    end
    return best
end

function getClosestHole(grid::Grid, l::Location)
    minDist = 1000000
    best = missing
    for h in grid.holes
        d = distance(h.location, l)
        if (d < minDist)
            minDist = d
            best = h
        end
    end
    return best
end

function removeTile(grid::Grid, t::Tile, a::Agent)
    grid.objects[t.location.c, t.location.r] = a
    t.location = randomFreeLocation(grid)
    grid.objects[t.location.c, t.location.r] = t
end

function removeHole(grid::Grid, h::Hole, a::Agent)
    grid.objects[h.location.c, h.location.r] = a
    h.location = randomFreeLocation(grid)
    grid.objects[h.location.c, h.location.r] = h
end

function printGrid(grid)
    println("tiles:$(grid.tiles)")
    println("holes:$(grid.holes)")
    for r in 1:ROWS
        for c in 1:COLS
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
    for a in grid.agents
        println("Agent $(a.id) : $(a.score)")
    end
end

function move(grid::Grid, a::Agent, l::Location)
    println("move agent $a from $(a.location) to $(l)")
    grid.objects[a.location.c, a.location.r] = missing
    grid.objects[l.c, l.r] = a
    a.location = l
end

function update(grid::Grid, a::Agent)
    println("$a")
    if (a.state == 0)
        idle(grid, a)
    elseif (a.state == 1)
        moveToTile(grid, a)
    elseif (a.state == 2)
        moveToHole(grid, a)
    end
end

function idle(grid::Grid, a::Agent)
    a.tile = missing
    a.hole = missing
    a.hasTile = false
    a.tile = getClosestTile(grid, a.location)
    a.state = 1
end

function moveToTile(grid::Grid, a::Agent)
    if (equal(a.location, a.tile.location))
        # arrived
        pickTile(grid, a)
        return
    end
    if (grid.objects[a.tile.location.c, a.tile.location.r] isa Missing || a.tile != grid.objects[a.tile.location.c, a.tile.location.r])
        a.tile = getClosestTile(grid, a.location)
        a.path = missing
    end
    if (a.path isa Missing || isempty(a.path))
        a.path = astar(grid, a.location, a.tile.location)
        println("agent $a: path=$(a.path)")
    end
    if (!isempty(a.path))
        nextLoc = popfirst!(a.path)
        if (isValid(grid, nextLoc) || equal(nextLoc, a.tile.location))
            move(grid, a, nextLoc)
        else
            println("path no longer valid - force recalculate")
            a.tile = getClosestTile(grid, a.location)
            a.path = missing
        end
    end
end

function moveToHole(grid::Grid, a::Agent)
    if (equal(a.location, a.hole.location))
        # arrived
        dumpTile(grid, a)
        return
    end
    if (grid.objects[a.hole.location.c, a.hole.location.r] isa Missing || a.hole != grid.objects[a.hole.location.c, a.hole.location.r])
        a.hole = getClosestHole(grid, a.location)
        a.path = missing
    end
    if (a.path isa Missing || isempty(a.path))
        a.path = astar(grid, a.location, a.hole.location)
        println("agent $a: path=$(a.path)")
    end
    if (!isempty(a.path))
        nextLoc = popfirst!(a.path)
        if (isValid(grid, nextLoc) || equal(nextLoc, a.hole.location))
            move(grid, a, nextLoc)
        else
            a.hole = getClosestHole(grid, a.location)
            a.path = missing
        end
    end
end

function pickTile(grid::Grid, a::Agent)
    a.hasTile = true
    a.hole = getClosestHole(grid, a.location)
    a.state=2
    a.path = missing
    removeTile(grid, a.tile, a)
end

function dumpTile(grid::Grid, a::Agent)
    removeHole(grid, a.hole, a)
    a.score += a.tile.score
    a.hasTile = false
    a.tile = getClosestTile(grid, a.location)
    a.hole = missing
    a.path = missing
    a.state = 1
end