
-- button and TextButton
local defaultSettings = { name = "noname", x = 0, y = 0, w = 100, h = 100, text = "no text", font = nil, align = "center" }
function ui.button( name, x, y, w, h, text, font, align )
    local state = {}
    state.hover = false
    state.down = {}
    state.down[1] , state.down[2], state.down[3] = false, false, false
    state.pressed = {}
    state.pressed[1] , state.pressed[2], state.pressed[3] = 0, 0, 0
    state.released = {}
    state.released[1] , state.released[2], state.released[3] = 0, 0, 0

    -- check if mouse is hovering above button, and set color accordingly
    if( mouseOver( x, y, w, h ) and ui.enableInput ) then
        state.hover = true
        love.graphics.setColor( ui.hoverColor.r, ui.hoverColor.g, ui.hoverColor.b, ui.hoverColor.a )

        -- check if mousebuttons are down
        for i = 1, 3 do
            if( love.mouse.isDown( i ) ) then
                state.down[i] = true
                -- change color if a mouseButton is pressed
                love.graphics.setColor( ui.downColor.r, ui.downColor.g, ui.downColor.b, ui.downColor.a )
            end
        end
    else -- if not hovering
        state.hover = false
        love.graphics.setColor( ui.color.r, ui.color.g, ui.color.b, ui.color.a )
    end

    -- calc things from events, eventinput
    if( ui.enableInput ) then
    for i, input in pairs( ui.input ) do
        if( input.type == "mousepressed" ) then
            if( pointInsideRectangle( input.x, input.y, x, y, w, h ) ) then
                state.pressed[input.button] = state.pressed[input.button] + 1
            end
        end
        if( input.type == "mousereleased" ) then
            if( pointInsideRectangle( input.x, input.y, x, y, w, h ) ) then
                state.released[input.button] = state.released[input.button] + 1
            end
        end
    end
    end


    -- draw the button
    love.graphics.rectangle("fill", x, y, w, h )


    -- text
    if( text ~= nil ) then
        love.graphics.setColor( 255, 255, 255, 255 )
        if( font ~= nil ) then love.graphics.setFont( font ) end
        if( align ) then love.graphics.printf( text, x, y + ( h - font:getHeight( text ) ) / 2, w, align ) else
        love.graphics.printf( text, x, y + ( h - font:getHeight( text ) ) / 2, w, "center" ) end
    end

    return state
end
