local create = require "create"

gameState = {}

function gameState.update( dt )
    -- new round if there is only one tank left
    allAmmo = 0
    for i = 1, #tanks do
    	allAmmo = allAmmo + tanks[i].ammo
    end
	if( nextRoundTimer == 0 and allAmmo == 0 and #bullets == 0 ) then
		nextRoundTimer = 3
	end
    if( nextRoundTimer == 0 and #tanks == 1 ) then
        nextRoundTimer = 3
    elseif( nextRoundTimer ~= 0 ) then
        nextRoundTimer = nextRoundTimer - dt
        if( nextRoundTimer < 0 ) then   
            -- increase score of winner ( if there is a winner )
            if( tanks[1] ) then
                for i = 1, #players do
                    if( players[i] == tanks[1].player ) then
                        players[i].score = players[i].score + 1
                    end
                end
            end
            newMap()
            nextRoundTimer = 0
        end
    end

    -- update tanks
    for i = 1, #tanks do
        tanks[i]:update( dt )
    end
    -- update bullets
    for i = 1, #bullets do
        if( bullets[i] ) then
            bullets[i]:update( dt )
            -- delete bullets
            if( bullets[i] and bullets[i].time > bullets[i].lifeTime ) then
                create.muzzleFlash( bullets[i].x, bullets[i].y, 1, 0.1, 50 )
                removeColl( bullets[i].collider )
                table.remove( bullets, i )
            end
        end
    end
    --update effects
    for i = 1, #effects do
        if( effects[i] ) then
            if( effects[i].update ) then
                effects[i]:update( dt )
            end
        end
    end

    camera:update(dt)
end

function gameState.draw()
    -- draw background color
    setColorRGB(108, 122, 137 )
    --setColorRGB( love.math.random( 255 ), love.math.random( 255 ), love.math.random( 255 ) )
    love.graphics.rectangle("fill", 0, 0, 2000, 2000 )
    setColorRGB( 255, 255, 255 )

    -- set world camera
    camera:set()

    --setColorRGB( love.math.random( 255 ), love.math.random( 255 ), love.math.random( 255 ) )
    setColorRGB( 34, 49, 63 )
    -- draw walls
    for i = 1, #walls do
        love.graphics.rectangle("fill", walls[i].x, walls[i].y, walls[i].w, walls[i].h )
    end


    -- draw tanks
    for i = 1, #tanks do
        tanks[i]:draw()
    end

    -- draw bullets
    for i = 1, #bullets do
        bullets[i]:draw()
    end

    -- draw effects
    for i = 1, #effects do
        if( effects[i].draw ) then
            effects[i]:draw()
        end
    end

    -- draw colliders
    --drawColliders()

    -- reset camera to window, so we can draw UI
    love.graphics.origin()
    -- set oor to white for UI
    setColorRGB( 228, 241, 254 )
    -- display FPS (  it is in top left corner )
    love.graphics.setFont( smallFont )
    love.graphics.print( love.timer.getFPS() )

    love.graphics.setFont( bigFont )
    local newLines = "\n"
    love.graphics.print( newLines .. "    score  ")

    for i = 1, #players do
        newLines = newLines .. "\n"
        setColorRGB( players[i].color.red, players[i].color.green, players[i].color.blue )
        love.graphics.print( newLines .. "  " .. players[i].name .. ": " .. players[i].score )
    end

    love.graphics.setFont( veryBigFont )
    setColorRGB( 228, 241, 254 )
    if( nextRoundTimer ~= 0 ) then
    	if( allAmmo == 0 and #bullets == 0 and #tanks > 1 ) then
    		love.graphics.printf( "You ran out of ammo!\n" .. math.floor( nextRoundTimer + 1 )  , 0, love.graphics.getHeight() / 4, love.graphics.getWidth(), "center" )
        elseif( tanks[1] ) then
            setColorRGB( 255, 255, 255  )
            local color = { 228, 241, 254  }
            local nameColor = { tanks[1].player.color.red / 255, tanks[1].player.color.green / 255, tanks[1].player.color.blue / 255 }
            local coloredtext = { nameColor, tanks[1].player.name, color, " won!\n" .. math.floor( nextRoundTimer + 1 ) }
            love.graphics.printf( coloredtext, 0, love.graphics.getHeight() / 4, love.graphics.getWidth(), "center" )
        else
            love.graphics.printf( "Everyone is dieded!\n" .. math.floor( nextRoundTimer + 1 )  , 0, love.graphics.getHeight() / 4, love.graphics.getWidth(), "center" )
        end
    end
end



function gameState.keypressed( key, scancode, isrepeat )
    for i = 1, #tanks do
        if( tanks[i] ) then
            tanks[i]:keypressed( key )
        end
    end

    if( key == "escape" ) then
        state = pauseState
    end

    if( key  == "x" ) then
        --shakeCamera( camera, 300, 10 )
    end
end

function gameState.mousepressed( x, y, button, isTouch )

end

function gameState.gameMouseReleased( x, y, button, isTouch )

end
