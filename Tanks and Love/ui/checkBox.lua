-- checkBox
function ui.checkBox( name, x, y, w, h, checked )
    local state = {}

    -- add this checkbox to the elements if it isn't htere yet
    if( ui.elements[name] == nil ) then
        ui.elements[name] = {}
        ui.elements[name].checked = false
    end
    if( checked ~= nil ) then
        ui.elements[name].checked = checked
    end

    -- event input
    if( ui.enableInput ) then
    for i, input in pairs( ui.input ) do
        if( input.type == "mousereleased" and pointInsideRectangle( input.x, input.y, x, y, w, h ) ) then
            ui.elements[name].checked = not ui.elements[name].checked
        end
    end
    end


    -- draw outline rectangle
    if( mouseOver( x, y, w, h ) ) then
        if( ui.enableInput ) then
        love.graphics.setColor( ui.hoverColor.r, ui.hoverColor.g, ui.hoverColor.b, ui.hoverColor.a )
        end
    else
        love.graphics.setColor( ui.color.r, ui.color.g, ui.color.b, ui.color.a )
    end

    love.graphics.rectangle("line", x, y, w, h )

    -- draw checked rectangle
    if( ui.elements[name].checked ) then
        love.graphics.setColor( ui.color.r, ui.color.g, ui.color.b, ui.color.a )
        love.graphics.rectangle("fill", x + 5, y + 5, w - 10, h - 10 )
    end


    state.checked = ui.elements[name].checked
    return state
end
