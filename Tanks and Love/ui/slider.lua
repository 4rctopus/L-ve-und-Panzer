function ui.slider( name, x, y, w, h, value, noChangeValue )
    local state = {}

    -- add this slider to elements
    local element
    if( ui.elements[name] == nil ) then
        ui.elements[name] = {}
        ui.elements[name].value = 0.5
        ui.elements[name].grabbed = false
        if( value ~= nil ) then
            ui.elements[name].value = value
        end
    end
    element = ui.elements[name]
    if( noChangeValue ~= true ) then
        element.value = value
    end



    -- position of the slider line
    local sx = x
    local sy = y
    -- position of the slider grab
    local hPush = 3 -- space above and below the grab
    local grabWidth = w / 13 -- this one makes the grab smaller/ bigger
    local grabHeight = h - hPush * 2;
    -- the interval in which we can actually move the slider )
    local slideWidth = w - 2 * ( grabWidth / 2 + hPush )
    local slidex = sx + hPush + grabWidth / 2

    local grabsx = slidex + element.value * slideWidth - grabWidth / 2
    local grabsy = y + hPush

    -- event input
    if( ui.enableInput ) then
    for i, input in pairs( ui.input ) do
        if( input.type == "mousepressed" and pointInsideRectangle( input.x, input.y, sx, sy, w, h ) ) then
            element.grabbed = true
            element.value = ( input.x - slidex ) / slideWidth
        end
        if( input.type == "mousereleased" ) then
             element.grabbed = false
        end

        if( element.grabbed and input.type == "mousemoved" and input.x < sx + w and input.x > sx ) then
            element.value = element.value + input.dx / slideWidth
        end
    end
    end
    if( element.value < 0 ) then element.value = 0 end
    if( element.value > 1 ) then element.value = 1 end
    local grabsx = slidex + element.value * slideWidth - grabWidth / 2


    -- draw line of slider
    love.graphics.setColor( colorTorgb( ui.color ) )
    love.graphics.rectangle("fill", sx, sy, w, h )



    love.graphics.setColor( colorTorgb( ui.sliderGrabColor ) )
    if( element.grabbed ) then
        love.graphics.setColor( colorTorgb( ui.sliderGrabColorDown ) )
    end
    love.graphics.rectangle( "fill", grabsx, grabsy, grabWidth, grabHeight )


    state.value = element.value
    return state
end
