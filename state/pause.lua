pauseState = {}

function pauseState.update( dt )
end

local showButtons = false

local function pauseDrawPause()
    -- we are drawing ui so we reset the thing
    love.graphics.origin()

    -- darkening thing over the game
    setColorRGB( 0, 0, 0, 150 )
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight() )

    love.graphics.origin()
    love.graphics.setColor( 1, 1, 1 )
    local h = bigFont:getHeight() + love.graphics.getHeight() / 8
    local w = 3 * h
    local sy = love.graphics.getHeight() / 16
    local sx = love.graphics.getWidth() / 16


    -- game name
    love.graphics.setFont( veryBigFont )
    love.graphics.print( "Löve und Panzer", sx, sy )

    -- continue
    sy = sy + love.graphics.getHeight() / 12 + veryBigFont:getHeight()
    local continueButton = ui.button( { name = "cntb", x = sx, y = sy, w = w, h = h, text = "Continue", font = bigFont } )
    if( continueButton.released[1] > 0 ) then
        ui.clear()
        state = gameState
    end
    love.graphics.setFont( bigFont )
    love.graphics.printf( "Note: tank settings will only be effective from the next round", sx + w*1.05, sy * 0.8, love.graphics.getWidth() * 0.4 )

    -- settings
    sy = sy + h + love.graphics.getHeight() / 12
    local settingsButton = ui.button( { name = "stsbt", x = sx, y = sy, w = w, h = h, text = "Settings", font = bigFont } )
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
            loadState( settings2State )
        end

        sy = sy + h * 1.02
        -- global settings
        local button = ui.button( { name = "tstgb", x = sx, y = sy, w = w, h = h, text = "global settings", font = bigFont } )
        if( button.pressed[1] > 0 ) then
            ui.clear()
            loadState( gSettingsState, state )
        end
    end


    -- back to menu
    local h = bigFont:getHeight()
    local sy = love.graphics.getHeight() - h * 2
    sx = love.graphics.getWidth() / 16

    local menuButton = ui.button( { name = "mnubt", x = sx, y = sy, w = w, h = h * 1.2, text = "back to menu", font = bigFont } )
    if( menuButton.released[1] > 0 ) then
        ui.clear()
        state = menuState
    end
end

function pauseState.draw()
    gameState.draw()
    pauseDrawPause()
end

function pauseState.keypressed( key, scancode, isrepeat )
    if( key == "escape" ) then
        state = gameState
    end
end
