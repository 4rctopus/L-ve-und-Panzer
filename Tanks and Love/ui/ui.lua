ui = {}


require "ui/button"
require "ui/slider"
require "ui/checkBox"
require "ui/textBox"


function mouseOver( x, y, w, h )
    local mx = love.mouse.getX()
    local my = love.mouse.getY()
    return mx >= x and mx <= x + w and my >= y and my <= y + h
end

function pointInsideRectangle( mx, my, x, y, w, h )
    return mx >= x and mx <= x + w and my >= y and my <= y + h
end

function setColor( color, r, g, b, a )
    if( a == nil ) then a = 255 end
    color.r, color.g, color.b, color.a = r, g, b, a
end


function colorTorgb( color )
    return color.r, color.g, color.b, color.a
end



function ui.init()
    ui.elements = {}

    -- set theme ???
    ui.color = {}
    setColor( ui.color, 112, 128, 144 )
    ui.hoverColor = {}
    setColor( ui.hoverColor, 96, 125, 139 )
    ui.downColor = {}
    setColor( ui.downColor,47,79,79 )
    ui.sliderGrabColor = {}
    setColor( ui.sliderGrabColor, 63, 81, 181 )
    ui.sliderGrabColorDown = {}
    setColor( ui.sliderGrabColorDown, 106, 27, 154)

    ui.cursorBlinkTime = 1
    ui.enableInput = true
    ui.input = {}
end

function ui.clear()
    ui.elements = {}
end
function ui.update()
    ui.input = {}
    ui.cursorBlinkTime = ui.cursorBlinkTime - gdt
    if( ui.cursorBlinkTime < 0 ) then ui.cursorBlinkTime = 1 end
end

function ui.mousepressed( x, y, button, isTouch )
    ui.input[#ui.input + 1] = {}
    local i = #ui.input
    ui.input[i].type = "mousepressed"
    ui.input[i].x, ui.input[i].y, ui.input[i].button, ui.input[i].isTouch = x, y, button, isTouch

    ui.cursorBlinkTime = 1
end

function ui.mousereleased( x, y, button, isTouch )
    ui.input[#ui.input + 1] = {}
    local i = #ui.input
    ui.input[i].type = "mousereleased"
    ui.input[i].x, ui.input[i].y, ui.input[i].button, ui.input[i].isTouch = x, y, button, isTouch
end

function ui.mousemoved( x, y, dx, dy, isTouch )
    ui.input[#ui.input + 1] = {}
    local i = #ui.input
    ui.input[i].type = "mousemoved"
    ui.input[i].x, ui.input[i].y, ui.input[i].dx, ui.input[i].dy, ui.input[i].isTouch = x, y, dx, dy, isTouch
end

function ui.keypressed(  key, scancode, isrepeat )
    ui.input[#ui.input + 1] = {}
    local i = #ui.input
    ui.input[i].type = "keypressed"
    ui.input[i].key, ui.input[i].scancode, ui.input[i].isrepeat = key, scancode, isrepeat
end

function ui.textinput( text )
    ui.input[#ui.input + 1] = {}
    local i = #ui.input
    ui.input[i].type = "textinput"
    ui.input[i].text = text
end


-- Button +
-- TextButton +
-- Check Box +
-- Slider
-- TextBox
-- Scrollable canvas thingy
