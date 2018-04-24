gSettingsState = {}

local lastState

function gSettingsState.load( last  )
    lastState = last
end

function gSettingsState.draw()
    if( lastState == settings2State ) then
        gameState.draw()

        -- darkening thing over the game
        setColorRGB( 0, 0, 0, 150 )
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight() )
    end

    -- draw back button
    local p = 10
    local w = love.graphics.getWidth() / 6
    local h = bigFont:getHeight()
    local sx = love.graphics.getWidth() - w - p
    local sy = p
    local backButton = ui.button( { name = "bbt", x = sx, y = sy, w = w, h = h, text = "back", font = bigFont} )
    if( backButton.released[1] > 0 ) then
        ui.clear()
        state = lastState
        return
    end

    -- global settings
    w = love.graphics.getWidth() - p * 2
    sy = sy + bigFont:getHeight()
    sx = p


    -- speed
    love.graphics.printf( "speed", sx + p, sy, w )
    sy = sy + bigFont:getHeight() + p
    local slider = ui.slider( { name = "speeds", x = sx + p, y = sy, h = h, w = w - 2 * p, noChangeValue = true } )
    tankSpeed = 50 + slider.value * 200
    love.graphics.setColor( 1, 1, 1 )
    love.graphics.printf( math.floor( tankSpeed ), sx, sy, w, "center" )
    
    

end