local utf8 = require 'utf8'

local function split(str, pos)
	local offset = utf8.offset(str, pos) or 0
	return str:sub(1, offset-1), str:sub(offset)
end




function ui.textBox( name, x, y, w, font, text, noChangeText )
    local state = {}
    h = font:getHeight()
    -- add this slider to elements
    if( ui.elements[name] == nil ) then
        ui.elements[name] = {}
        ui.elements[name].text = ""
        ui.elements[name].textx = x
        ui.elements[name].focused = false
        ui.elements[name].cursorPos = 1
        if( text ~= nil ) then
            ui.elements[name].text = text
        end
    end
    local element = ui.elements[name]
	if( noChangeText ~= true ) then
		element.text = text
	end

    local xPush = 3
    local textx = x

    local a, b = split( element.text, element.cursorPos )
    local cx = textx + xPush + font:getWidth( a .. "W" )
    if( cx >= x + w ) then
        textx = textx - ( cx - ( x + w ) )
    elseif( cx - font:getWidth( "W" ) <= x ) then
        textx = textx + ( x - ( cx - font:getWidth( "W" ) ) ) + xPush
    end

    --element.textx = textx
    if( ui.enableInput ) then
    for i, input in pairs( ui.input ) do
        if( input.type == "mousepressed" ) then
            if( pointInsideRectangle( input.x, input.y, x, y, w, h ) ) then
                element.focused = true
                -- set cursor position
                local rightOfText = true
                local mx = input.x - ( textx + xPush )
                for c = 1, string.len( element.text ) + 1 do
                    local s = element.text:sub( 0, utf8.offset( element.text, c) - 1 )
                    if( font:getWidth( s ) >= mx ) then
                        element.cursorPos = c - 1
                        rightOfText = false
                        break
                    end
                end
                if( rightOfText ) then
                    element.cursorPos = string.len( element.text ) + 1
                end
            else
                element.focused = false
            end
        end

        if( element.focused ) then
            if( input.type == "textinput"  ) then
                -- add input.text to element.text at element.cursosPos
                local a, b = split( element.text, element.cursorPos )
                element.text = a .. input.text .. b
                element.cursorPos = element.cursorPos + utf8.len( input.text )
            end
            if( input.type == "mousemoved" and love.mouse.isDown( 1 ) ) then
                local mx = input.x + input.dx
                local rightOfText = true
                local mx = mx - ( textx + xPush )
                for c = 1, string.len( element.text ) + 1 do
                    local s = element.text:sub( 0, utf8.offset( element.text, c) - 1 )
                    if( font:getWidth( s ) >= mx ) then
                        element.cursorPos = c - 1
                        rightOfText = false
                        break
                    end
                end
                if( rightOfText ) then
                    element.cursorPos = string.len( element.text ) + 1
                end
            end
            if( input.type == "keypressed" ) then
                if( input.key == "backspace" and element.cursorPos > 0 ) then
                    -- remove a character from element.text at element.cursorPos
                    local a, b = split( element.text, element.cursorPos )
                    element.text = split( a, utf8.len( a ) ) .. b
                    element.cursorPos = math.max( element.cursorPos - 1, 1 )
                end
                if( input.key == "home" ) then
                    element.cursorPos = 1 -- or 0?
                end
                if( input.key == "end" ) then
                    element.cursorPos = string.len( element.text ) + 1 -- ???
                end
                if( input.key == "right" ) then
                    element.cursorPos = math.min( element.cursorPos + 1, string.len( element.text ) + 1 ) -- ???
                end
                if( input.key == "left" ) then
                    element.cursorPos = math.max( element.cursorPos - 1, 1 ) -- ??
                end
            end
        end
    end
    end
    -- draw background rectangle
    love.graphics.setColor( 120, 120, 120 )
    love.graphics.rectangle("fill", x, y, w, h )

    -- draw text
    love.graphics.setScissor( x + xPush, y, w - 2 * xPush, h )
    love.graphics.setFont( font )
    love.graphics.setColor(255, 255, 255, 255 )
    love.graphics.print( element.text, textx + xPush, y )

    -- draw blinking thingy
    if( ui.enableInput ) then
    if( element.focused and ui.cursorBlinkTime > 0.5 ) then
        love.graphics.setColor( 2, 119, 189 )
        local a, b = split( element.text, element.cursorPos )
        local cx = textx + xPush + font:getWidth( a )
        love.graphics.rectangle("fill", cx, y, 5, h )
    end
    end
    love.graphics.setScissor( )


    state.text = element.text
    return state
end
