struct Location
    c::Int
    r::Int
end

function nextLocation(l::Location, dir::Int)
    if (dir == 0) 
        return Location(l.c, l.r - 1)
    elseif (dir == 1)
        return Location(l.c, l.r + 1)
    elseif (dir == 2)
        return Location(l.c - 1, l.r)
    else
        return Location(l.c + 1, l.r)
    end
end

function distance(l::Location, other::Location)
    return abs(l.c - other.c) + abs(l.r - other.r)
end

function equal(l::Location, other::Location)
    return l.c == other.c && l.r == other.r
end

abstract type GridObject end

mutable struct Tile <: GridObject
    id::Int
    location::Location
    score::Int
end

mutable struct Hole <: GridObject
    id::Int
    location::Location
end

struct Obstacle <: GridObject
    id::Int
    location::Location
end

mutable struct Agent <: GridObject
    id::Int
    location::Location
    score::Int
    tile::Union{Missing, Tile}
    hole::Union{Missing, Hole}
    hasTile::Bool
    state::Int

    function Agent(id, location)
        new(id, location, 0, missing, missing, false, 0)
    end
end

