
local create = require "create"

function newWall( x, y, w, h )
    walls[#walls + 1] = newColl( "wall", x, y, w, h )
end

function lineToRect( x1, y1, x2, y2, size )
    if( x1 == x2 ) then
        local x = x1
        local y = math.min( y1, y2 )
        local w = size
        local h = math.max( y1, y2 ) - y + size

        return x, y, w, h
    else
        local x = math.min( x1, x2 )
        local y = y1a
        local w = math.max( x1, x2 ) - x + size
        local h = size

        return x, y, w, h
    end
end

function newMap()
    -- reset stuff ( or make them for the first time )
    walls = {}
    effects = {}
    tanks = {}
    bullets = {}
    colliders = {}
    --

    local minMapSize = 300
    local maxMapSize = 200
    local minWallCount = 20
    local maxWallCount = 40
    local minWallSize = 10
    local maxWallSize = 100


    -- generate walls
    -- rect of the whole map
    local top = love.math.random( -minMapSize, -maxMapSize )
--    local left = love.math.random( -300, -200 )
    local left =  top * love.graphics.getWidth() / love.graphics.getHeight()
    local down = -top
    local right = -left

    camera.scale = ( love.graphics.getHeight() - 30 ) / ( down - top )

    -- big border walls
    newWall( -3000, -3000, left + 3000, 6000 )
    newWall( -3000, -3000, 6000, top + 3000 )
    newWall( -3000, down, 6000, 3000 )
    newWall( right, -3000, 3000, 6000 )


    -- generating the maze
    local wallCount = love.math.random( minWallCount, maxWallCount )
    for i = 1, wallCount do
        local ok = false
        while( not ok ) do
            local new = {}
            new.x = love.math.random( left, right )
            new.y =  love.math.random( top, down )
            new.w = love.math.random( minWallSize, maxWallSize )
            new.h = love.math.random(minWallSize, maxWallSize )
            ok = true
            
            for j, wall in ipairs( walls ) do
                if( wall.x and isColliding( wall, new ) ) then
                    ok = false
                    break
                end
            end

            if( ok )then
                
                newWall( new.x, new.y, new.w, new.h )
            end
        end
        --newWall( love.math.random( left, right ), love.math.random( top, down ), love.math.random( minWallSize, maxWallSize ), love.math.random(minWallSize, maxWallSize ) )
    end



    -- make the tanks from the player table
    for i = 1, #players do
        tanks[i] = create.tank( 0, 0, players[i] )
    end

    -- put the players somewhere nice
    for i = 1, #tanks do
        while( true ) do
            local x, y = love.math.random( top + 20, down - 20), love.math.random( left + 20, right - 20)

            local mov = {}
            local item
            mov.x, mov.y = x - tanks[i].x, y - tanks[i].y
            mov, item = collide( tanks[i].collider, mov )
            tanks[i].x = tanks[i].x + mov.x
            tanks[i].y = tanks[i].y + mov.y
            if( item.what == "nothing" ) then
                break
            end
        end
    end
end
