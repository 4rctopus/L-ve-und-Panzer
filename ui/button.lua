local lume = require "lib/lume"
local event = require "event"

ui.buttonSettings = {
    name = "noname", x = 0, y = 0, w = 100, h = 100, text = "", font = nil, align = "center",
    hoverColor = { 37, 41, 49 },
    downColor = { 44, 49, 58 },
    color = { 33, 37, 43 },
}

function ui.button( settings )
    local s = lume.merge( ui.buttonSettings, settings )
    --local name, x, y, w, h, text, font, align = s.name, s.x, s.y, s.w, s.h, s.text, s.font, s.align

    local state = {
        hover = false,
        down = { false, false, false},
        pressed = { 0, 0, 0 },
        released = { 0, 0, 0},
    }

    -- check if mouse is hovering above button, and set color accordingly
    if( mouseOver( s.x,s.y,s.w,s.h ) and ui.enableInput ) then
        state.hover = true
        setColorRGB( s.hoverColor  )

        -- check if mousebuttons are down
        for i = 1, 3 do
            if( love.mouse.isDown( i ) ) then
                state.down[i] = true
                -- change color if a mouseButton is pressed
                setColorRGB( s.downColor  )
            end
        end
    else -- if not hovering
        state.hover = false
        setColorRGB( s.color )
    end

    -- calc things from events, eventinput
    if( ui.enableInput ) then 
        for i, input in ipairs( event.mousepressed ) do
            if( pointInsideRectangle( input.x, input.y, s.x,s.y,s.w,s.h ) ) then
                state.pressed[input.button] = state.pressed[input.button] + 1
            end 
        end
        for i, input in ipairs( event.mousereleased ) do
            if( pointInsideRectangle( input.x, input.y, s.x,s.y,s.w,s.h ) ) then
                state.released[input.button] = state.released[input.button] + 1
            end
        end
    end

    -- draw the button
    love.graphics.rectangle("fill", s.x,s.y,s.w,s.h )
    -- s.text
    if( s.text ~= nil ) then
        setColorRGB( 255, 255, 255, 255 )
        if( s.font ~= nil ) then love.graphics.setFont( s.font ) else
            s.font = love.graphics.getFont() end 
        if( s.align ) then love.graphics.printf( s.text, s.x,s.y + ( s.h - s.font:getHeight( s.text ) ) / 2,s.w, s.align ) end
    end

    return state
end
