betweenState = {}

local time
function betweenState.load()
    time = 10
end

function betweenState.update( dt )
    time = time - dt

    if( time < 0 ) then
        newMap()
            nextRoundTimer = 0
            loadState( gameState )
    end
end

function betweenState.draw()
    gameState.draw()

    -- darkening thing over the game
    setColorRGB( 0, 0, 0, 150 )
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight() )



end