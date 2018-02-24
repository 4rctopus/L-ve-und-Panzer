function newKeybind( forward, left, right, back, shoot )
    local keybind = {}
    keybind.forward = forward
    keybind.left = left
    keybind.right = right
    keybind.back = back
    keybind.shoot = shoot

    return keybind
end

defaultKeybind = newKeybind( "w", "a", "d", "s", "q" )
player2Keybind = newKeybind( "up", "left", "right", "down", "kp1" )
