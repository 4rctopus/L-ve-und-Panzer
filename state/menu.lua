require "settings"

menuState = {}

function menuState.update( dt )
end

local showButtons = false

function menuState.draw()
    love.graphics.origin()
    local h = bigFont:getHeight() + love.graphics.getHeight() / 8
    local w = 3 * h
    local sy = love.graphics.getHeight() / 16
    local sx = love.graphics.getWidth() / 16


    -- game name
    love.graphics.setFont( veryBigFont )
    love.graphics.print( "Löve und Panzer", sx, sy )


    -- start game button
    sy = sy + love.graphics.getHeight() / 12 + veryBigFont:getHeight()
    local startButton = ui.button( { name = "sb", x =sx, y = sy, w = w, h = h, text = "Start game", font =bigFont } )
    if( startButton.released[1] > 0 ) then
        ui.clear()
        nextRoundTimer = 0
        newMap()
        state = gameState
    end

    

    -- settings button
    sy = sy + h + love.graphics.getHeight() / 12
    local settingsButton = ui.button( { name = "cb", x = sx, y = sy, w = w, h = h, text = "Settings", font = bigFont } )
    if( settingsButton.released[1] > 0 ) then
        showButtons = not showButtons
    end

    -- buttons
    if( showButtons ) then
        sx = sx + w * 1.02
        sy = sy - h / 2
        --tank settings
        local button = ui.button( { name = "tst", x = sx, y = sy, w = w, h = h, text = "tank settings", font = bigFont } )
        if( button.pressed[1] > 0 ) then
            ui.clear()
            loadState( settingsState )
        end

        sy = sy + h * 1.02
        -- global settings
        local button = ui.button( { name = "tstgb", x = sx, y = sy, w = w, h = h, text = "global settings", font = bigFont } )
        if( button.pressed[1] > 0 ) then
            ui.clear()
            loadState( gSettingsState, state )
        end
    end
end