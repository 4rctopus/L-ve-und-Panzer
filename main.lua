-- set this thing so that I can properly scale images
love.graphics.setDefaultFilter( "nearest", "nearest" )

jupiter = require "jupiter"
require "lib/require"
require.tree("entity")

-- the names of the Love2D callbacks so we can override them easier
lovecallbacks = {
    "load",
    "update",
    "draw",

    "mousepressed",
    "mousereleased",
    "mousemoved",
    "wheelmoved",
    "keypressed",
    "keyreleased",
    "textinput",
    "textedited",
    "touchmoved",
    "touchpressed",
    "touchreleased",

    "resize",
    "focus",
    "quit",
    "filedropped",
}


function setColorRGB( ... )
    local col = {}
    if( type( select( 1, ... ) ) == "table" ) then
        local arg = select( 1, ... )
        for i = 1, 4 do
            if( arg[i] ) then
                col[i] = arg[i] / 255
            end
        end
    else
        for i = 1, 4 do
            if( select( i, ... ) ) then
                col[i] = select( i, ... ) / 255
            end
        end
    end
    love.graphics.setColor( col[1], col[2], col[3], col[4] )
end

-- #includes lmao
require "camera"
require "keybindings"
require "mapgen"

require "ui/ui"

require.tree( "state" )

local event = require "event"

local bump = require "lib/bump"
collisionWorld = bump.newWorld( 64 )

defaultPlayers = {}
defaultPlayers[1] = { "Saori", "up", "left", "right", "down", "rshift", 210, 82, 127   }
defaultPlayers[2] = { "Miho", "w", "a", "d", "s", "q", 0, 177, 106 }
defaultPlayers[3] = { "Hana", "kp8", "kp4", "kp6", "kp5", "kp9", 142, 68, 173  }
defaultPlayers[4] = { "Yukari", "i", "j", "l", "k", "u", 52, 73, 94  }
defaultPlayers[5] = { "Mako", "t", "f", "h", "g", "r", 236, 240, 241  }

statNames = { "speed", "ammo", "bulletSpeed", "radianSpeed" }

function loadDefaultPlayers()
    for i = 1, 5 do
        players[i] = {}
        players[i].name = defaultPlayers[i][1]
        players[i].keybind = {}
        players[i].keybind.forward = defaultPlayers[i][2]
        players[i].keybind.left = defaultPlayers[i][3]
        players[i].keybind.right = defaultPlayers[i][4]
        players[i].keybind.back = defaultPlayers[i][5]
        players[i].keybind.shoot = defaultPlayers[i][6]
        players[i].color = {}
        players[i].color.red = defaultPlayers[i][7]
        players[i].color.green = defaultPlayers[i][8]
        players[i].color.blue = defaultPlayers[i][9]
        players[i].score = 0

        players[i].stats = {}
        for j, name in ipairs( statNames ) do
            players[i].stats[name] = 1
        end
    end
end


-- states are the parts of the game that have different callback functions
-- as an example menuState, gameState, pauseState
state = {}


function loadState( newState, arg )
    print( newState )
    state = newState

    if( state.load ) then state.load( arg ) end
    print( state )
end



-- set up callbacks
for _, callback in pairs( lovecallbacks ) do
    love[callback] = function( arg1, arg2, arg3, arg4, arg5, arg6 )
        if( state[callback] ) then state[callback]( arg1, arg2, arg3, arg4, arg5, arg6 ) end
        event.callback( callback, arg1, arg2, arg3, arg4, arg5, arg6 )
    end
end

function love.load()
    -- game state
    state = menuState


    camera = newCamera()
    camera.scale = 4

    love.keyboard.setKeyRepeat( true )

    local fthing = love.graphics.getHeight() * 1 / 1600
    smallFontScale = 16
    bigFontScale = 80
    veryBigFontScale = 180
    smallFont = love.graphics.newFont( "files/font.ttf", smallFontScale * fthing  )
    bigFont = love.graphics.newFont( "files/font.ttf", bigFontScale * fthing )
    veryBigFont = love.graphics.newFont( "files/font.ttf", veryBigFontScale * fthing )



    ui.init()

    -- load players
	--data = jupiter.load("test.txt")
    players = {}
    if( data == nil ) then
        loadDefaultPlayers()
    else
        players = data[1]
    end

end

gTime = 0
function love.update(dt)
    gDt = dt
    gTime = gTime + dt
    --[[
    lovebird.update()
    tween.update( dt )
    lurker.update() ]]
    if( state.update ) then state.update( dt ) end
end

function love.draw()
    if( state.draw ) then state.draw() end
    ui.reset()
    event.reset()

    -- display FPS (  it is in top left corner )
    setColorRGB( 228, 241, 254 )
    love.graphics.setFont( smallFont )
    love.graphics.print( love.timer.getFPS() )
end

-- event Updates
function love.wheelmoved( x, y )
    event.callback( "wheelmoved", x, y )
    -- zooming the camera with mousewheel
	if( camera.scale + y / 10 > 0 ) then
		camera.scale = camera.scale + y / 10
	end
end

function love.resize(w, h)
    if( state.resize ) then state.resize( w, h ) end
    event.callback( "resize", w, h )
    -- change font size
    local fthing =  h  * 1 / 1600
    smallFont = love.graphics.newFont( "files/font.ttf", smallFontScale * fthing  )
    bigFont = love.graphics.newFont( "files/font.ttf", bigFontScale * fthing )
    veryBigFont = love.graphics.newFont( "files/font.ttf", veryBigFontScale * fthing )
end


--[[
Stuff I could do:
powerups
screen shake
tire tracks
]]
