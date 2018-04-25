local lume = require "lib/lume"

local selectedPlayer = 1
settingKeybind = nil

function settingsDraw( addremove )
    -- reset camera to window, so we can draw UI
    love.graphics.origin()
    love.graphics.setFont( bigFont )
    setColorRGB( 255, 255, 255 )
    love.graphics.printf( "s e t t i n g s", 0, 0, love.graphics.getWidth(), "center" )

    --love.graphics.rectangle("fill", 0, bigFont:getHeight(), love.graphics.getWidth(), 3)

    local topy = bigFont:getHeight() + 10
    local sectionMinus = 10


    local w = love.graphics.getWidth() / 3 - 2 * sectionMinus
    -- player selection buttons
    -- in the first third of the screen
    local sy = topy
    local hp = 10 -- push
    local h = bigFont:getHeight() + hp
    for i, player in pairs( players ) do
        local button = ui.button( { name = i, x = hp, y = sy, w = w, h = h, text = player.name, font = bigFont } )
        if( button.released[1] > 0 ) then
            selectedPlayer = i
        end
        if( i == selectedPlayer ) then
            setColorRGB( 9,8,8 )
            love.graphics.setLineWidth( 5 )
            love.graphics.rectangle("line", hp, sy, w, h )
            love.graphics.setLineWidth( 1 )
        end
        sy = sy + bigFont:getHeight() + hp + 3
    end
    -- player selection buttons



    if( addremove ) then
        if( #players < 5 ) then
            local nPush = w / 3 + hp
            local newButton = ui.button( { name = "newb", x = nPush, y = sy, w=  w - 2 * nPush, h = h, text = "+", font = bigFont } )
            if( newButton.released[1] > 0 ) then
                print( #players + 1 )
                players[#players + 1] = {}
                players[#players].name = defaultPlayers[#players][1]
                players[#players].keybind = {}
                players[#players].keybind.forward = defaultPlayers[#players][2]
                players[#players].keybind.left = defaultPlayers[#players][3]
                players[#players].keybind.right = defaultPlayers[#players][4]
                players[#players].keybind.back = defaultPlayers[#players][5]
                players[#players].keybind.shoot = defaultPlayers[#players][6]
                players[#players].color = {}
                players[#players].color.red = defaultPlayers[#players][7]
                players[#players].color.green = defaultPlayers[#players][8]
                players[#players].color.blue = defaultPlayers[#players][9]
                players[#players].score = 0

                players[#players].stats = {}
                for j, name in ipairs( statNames ) do
                    players[#players].stats[name] = 1
                end
                players[#players].budget = 10
            end
        end
    end

    -- player settings
    local sy = topy
    local sx = love.graphics.getWidth() / 3 + sectionMinus
    local sxend = love.graphics.getWidth() / 3 * 2 - sectionMinus
    -- player name change:
    local playerTextBox = ui.textBox( { name = "pname" .. selectedPlayer, x = sx, y = sy, w = w, font = bigFont, text = players[selectedPlayer].name } )
    players[selectedPlayer].name = playerTextBox.text

    setColorRGB( 255, 255, 255, 255 )
    love.graphics.setFont( bigFont )
    -- keybindings
    sy = sy + bigFont:getHeight(  ) + 3
    for key, bind in pairs( players[selectedPlayer].keybind ) do
        love.graphics.printf( key .. ":", sx, sy, w, "left" )
        local button = ui.button( { name = "w", x = sxend - bigFont:getWidth("WWWWW"), y = sy, w = bigFont:getWidth("WWWWW"), h = bigFont:getHeight(), text = bind, font = bigFont } )
        if( button.released[1] > 0 ) then
            settingKeybind = {}
            settingKeybind.keybind = players[selectedPlayer].keybind
            settingKeybind.key = key

            ui.enableInput = false
        end
        sy = sy + bigFont:getHeight() + 3
    end
    -- keybindings end
    -- color change
    love.graphics.printf("color", sx, sy, w, "center" )
    sy = sy + bigFont:getHeight()
    for color, value in pairs( players[selectedPlayer].color ) do
        local slider = ui.slider( { name = "slider" .. color .. selectedPlayer, x = sx, y = sy, w = w, h = bigFont:getHeight(), value = players[selectedPlayer].color[color] / 255 } )
        players[selectedPlayer].color[color] =  slider.value * 255
        setColorRGB(255, 255, 255, 255 )
        love.graphics.printf( color .. ": " .. math.floor( players[selectedPlayer].color[color] ), sx, sy, w, "center" )
        sy = sy + bigFont:getHeight( ) + 3
    end
    -- color change end

    -- color viewer
    setColorRGB( players[selectedPlayer].color.red, players[selectedPlayer].color.green, players[selectedPlayer].color.blue )
    love.graphics.rectangle( "fill", sx + w / 4, sy, w - 2 * ( w / 4 ), bigFont:getHeight() )
    sy = sy + bigFont:getHeight() + 10

    -- removebutton
    if( addremove and #players > 2 and selectedPlayer > 2 ) then
        local removeButton = ui.button( { name = "rb", x = sx, y = sy, w = w, h = bigFont:getHeight(), text = "remove player", font = bigFont } )
        if( removeButton.released[1] > 0 ) then
            table.remove( players, selectedPlayer  )
            if( selectedPlayer > #players ) then
                selectedPlayer = #players
            end
        end
    end


    local selectedPlayer = players[selectedPlayer]

    -- other settings
    sx = love.graphics.getWidth() / 3 * 2 + sectionMinus
    sy = topy

    love.graphics.setColor( 1, 1, 1 )
    --[[
    love.graphics.setFont( bigFont )
    love.graphics.printf( "other settings", sx, sy, w, "center" )
    ]]

    local budget = globalStats.budget
    for i, statName in ipairs( statNames ) do
        budget = budget - selectedPlayer.stats[statName]
    end


    for i, statName in ipairs( statNames ) do
        love.graphics.printf( statName, sx, sy, w, "center" )

        sy = sy + bigFont:getHeight() + 10

        love.graphics.printf(selectedPlayer.stats[statName], sx, sy, w, "center" )

        cfg = { x = sx, y = sy, h = bigFont:getHeight(), w = bigFont:getHeight(), font = bigFont }
        local minButton = ui.button( lume.merge( cfg, { name = statName .. "-", text = "-" } ) )

        if( minButton.pressed[1] > 0 ) then
            if( selectedPlayer.stats[statName] > 0 ) then
                selectedPlayer.stats[statName] = selectedPlayer.stats[statName] - 1
                budget = budget + 1
            end
        end

        local addButton = ui.button( lume.merge( cfg, { name = statName .. "+", text = "+", x = sx + w - cfg.w } ) )

        if( addButton.pressed[1] > 0 ) then
            if( budget > 0 and selectedPlayer.stats[statName] + 1 <= globalStats.maxStatScore ) then
                selectedPlayer.stats[statName] = selectedPlayer.stats[statName] + 1
                budget = budget - 1
            end
        end

        sy = sy + bigFont:getHeight() + 10
    end
    love.graphics.printf( "budget: " .. budget, sx, sy, w, "center" )

    local button = ui.button( {name = "gsb", x = sx, y = love.graphics.getHeight() - hp - cfg.h - 5, h = cfg.h + 5, w = w, text = "global settings", font = bigFont } )
    if( button.pressed[1] > 0 ) then
        loadState( gSettingsState, state )
    end

    -- setting Keybind
    -- darkening thing over
    if( settingKeybind ~= nil ) then
        setColorRGB( 0, 0, 0, 150 )
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight() )
        setColorRGB(255, 255, 255, 255)
        love.graphics.printf( "set " .. selectedPlayer.name .. "'s " .. settingKeybind.key .. " keybind", 0, love.graphics.getHeight() / 2 - bigFont:getHeight() / 2, love.graphics.getWidth(), "center" )
    end
end