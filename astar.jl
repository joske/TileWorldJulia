using Base: func_for_method_checked
using DataStructures: empty, push!, isempty, SortedSet

struct Node
    location::Location
    path::Array
    fscore::Int
end

struct NodeOrdering <: Base.Ordering 
end

import Base.Order.lt 
lt(o::NodeOrdering, a, b) = isless(a.fscore, b.fscore)

function astar(grid::Grid, from::Location, to::Location)
    println("finding path form $from to $to")
    openList = SortedSet{Node}(NodeOrdering())
    closedList = Set{Location}()
    fromNode = Node(from, [], 0)
    push!(openList, fromNode)
    println("openList=$openList")
    while(!isempty(openList))
        current = pop!(openList)
        println("current=$current")
        if (equal(current.location, to))
            return current.path
        end
        push!(closedList, current.location)
        checkNeighbor(grid, openList, closedList, current, to, 0)
        checkNeighbor(grid, openList, closedList, current, to, 1)
        checkNeighbor(grid, openList, closedList, current, to, 2)
        checkNeighbor(grid, openList, closedList, current, to, 3)
    end
    return []
end

function checkNeighbor(grid::Grid, openList::SortedSet, closedList::Set, current::Node, to::Location, dir::Int)
    println("checking direction $dir")
    nextLoc = nextLocation(current.location, dir)
    println("nextLoc=$nextLoc")
    if (equal(nextLoc, to) || isValid(grid, nextLoc))
        println("valid")
        h = distance(nextLoc, to)
        g = length(current.path) + 1
        if (length(current.path) > 0)
            newPath = deepcopy(current.path)
        else
            newPath = []
        end
        push!(newPath, nextLoc)
        child = Node(nextLoc, newPath, g + h)
        if (!in(child.location, closedList))
            for e in openList
                if (e.location == child.location && e.fscore < child.fscore)
                    return
                end
            end
            println("adding node to openList $child")            
            push!(openList, child)
        end
    end    
end