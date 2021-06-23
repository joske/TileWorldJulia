struct Location
    c::Int
    r::Int
end

abstract type GridObject end

struct Tile <: GridObject
    id::Int
    location::Location
    score::Int
end

struct Hole <: GridObject
    id::Int
    location::Location
end

struct Obstacle <: GridObject
    id::Int
    location::Location
end

struct Agent <: GridObject
    id::Int
    location::Location
    score::Int
    tile::Union{Missing, Tile}
    hole::Union{Missing, Hole}
    hasTile::Bool

    function Agent(id, location)
        new(id, location, 0, missing, missing, false)
    end
end

