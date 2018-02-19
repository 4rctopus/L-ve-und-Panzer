require "settings"

settingsState = {}


function settingsState.draw()
    settingsDraw( true )

    -- draw back button
    local p = 10
    local w = love.graphics.getWidth() / 6
    local h = bigFont:getHeight()
    local sy = p
    local sx = love.graphics.getWidth() - w - p
    local backButton = ui.button( "bbt", sx, sy, w, h, "back", bigFont )
    if( backButton.released[1] > 0 ) then
        ui.clear()
        state = menuState
    end
end

function settingsState.keypressed( key )
    if( settingKeybind ~= nil ) then
        if( key ~= "escape" ) then
            settingKeybind.keybind[settingKeybind.key] = key
        end
        ui.enableInput = true
        settingKeybind = nil
    elseif( key == "escape" ) then
        ui.clear()
        state = menuState
    end
end
