require "settings"

menuState = {}

function menuState.update( dt )
end

function menuState.draw()
    --[[
    -- reset camera to window, so we can draw UI
    love.graphics.origin()
    love.graphics.setFont( veryBigFont )
    setColorRGB(255, 255, 255 )
    love.graphics.printf( "Press SPACE to start!", 0, love.graphics.getHeight() / 3, love.graphics.getWidth(), "center" )
    --]]
    love.graphics.origin()
    local h = bigFont:getHeight() + love.graphics.getHeight() / 8
    local w = 3 * h
    local sy = love.graphics.getHeight() / 4
    local sx = love.graphics.getWidth() / 2 - w / 2
    local startButton = ui.button( { name = "sb", x =sx, y = sy, w = w, h = h, text = "Start game", font =bigFont } )
    if( startButton.released[1] > 0 ) then
        ui.clear()
        nextRoundTimer = 0
        newMap()
        state = gameState
    end
    sy = sy + h + love.graphics.getHeight() / 8
    local settingsButton = ui.button( { name = "cb", x = sx, y = sy, w = w, h = h, text = "Settings", font = bigFont } )
    if( settingsButton.released[1] > 0 ) then
        ui.clear()
        state = settingsState
    end

    --settingsDraw()
end


function menuState.keypressed( key, scancode, isrepeat )
end
