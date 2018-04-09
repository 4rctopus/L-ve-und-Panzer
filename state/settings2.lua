settings2State = {}


function settings2State.draw()
    gameState.draw()

    -- darkening thing over the game
    setColorRGB( 0, 0, 0, 150 )
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight() )


    -- draw bakc button
    local p = 10
    local w = love.graphics.getWidth() / 6
    local h = bigFont:getHeight()
    local sy = p
    local sx = love.graphics.getWidth() - w - p
    local backButton = ui.button( { name = "bbt", x = sx, y = sy, w = w, h = h, text = "back", font = bigFont } )
    if( backButton.released[1] > 0 ) then
        ui.clear()
        state = pauseState
    end


    settingsDraw( false )

end


function settings2State.keypressed( key )
    if( settingKeybind ~= nil ) then
        if( key ~= "escape" ) then
            settingKeybind.keybind[settingKeybind.key] = key
        end
        ui.enableInput = true
        settingKeybind = nil
    elseif( key == "escape" ) then
        ui.clear()
        state = pauseState
    end
end
