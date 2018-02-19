--[[
    SAVE GAME
	local data = { _fileName = "test.txt", players }
	success = jupiter.save( data )
	print( success )
--]]


--[[
I DON'T KNOW
players = {}

-- load players from file
-- so this looks horrible but it works so I'll change it later

file ,error= io.open( "files/players.txt" )
local n = file:read()
for i = 1, n do
    players[i] = {}
    local line = file:read()
    words = {}
    for i in string.gmatch( line, "%S+" ) do
        words[#words + 1] = i
    end

    players[i].name = words[1]
    players[i].keybind = {}
    players[i].keybind.forward = words[2]
    players[i].keybind.left = words[3]
    players[i].keybind.right = words[4]
    players[i].keybind.back = words[5]
    players[i].keybind.shoot = words[6]
    players[i].color = {}
    players[i].color.red = words[7]
    players[i].color.green = words[8]
    players[i].color.blue = words[9]
    players[i].score = 0
end
--]]
--[[
for i = 1, 10 do
    -- random border
    local border = love.math.random( 1, 4 )
    local x, y = love.math.random( left, right ), love.math.random( top, down )
    if( border == 1 ) then y = top end
    if( border == 2 ) then x = right end
    if( border == 3 ) then y = down end
    if( border == 4 ) then x = left end

    local turns = love.math.random( 2, 5 )
    for j = 1, turns do
        -- generate next point
        local nx, ny
        verhol = love.math.random( 1, 2 )
        if( verhol == 1 ) then
            nx = x
            ny = y + love.math.random( math.max( -60, left - x + 10 ), math.min( 60, right - x - 10 ) )

            --ny = love.math.random( x -20, x + 20 )
        end
        if( verhol == 2 ) then
            ny = y
            nx = x + love.math.random( math.max( -60, top - y + 10 ), math.min( 60, down - y - 10 ) )
        end

        newWall( lineToRect( x, y, nx, ny, 5 ) )
        x, y = nx, ny
    end
end
--]]-- fail lel
