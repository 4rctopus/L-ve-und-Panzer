betweenState = {}

local playersCpy

local time
function betweenState.load()
    playersCpy = {}
    for i = 1, #players do
        playersCpy[i] = players[i]
    end

    table.sort(playersCpy, function(a, b) return a.score > b.score end)

    time = 1.5
end

function betweenState.update( dt )
    time = time - dt

    if( time < 0 and playersCpy[1].score < globalStats.scoreMax ) then
        newMap()
        nextRoundTimer = 0
        loadState( gameState )
    elseif( time < 0 and playersCpy[1].score >= globalStats.scoreMax ) then
        newMap()
        nextRoundTimer = 0
        loadState( winnerState, playersCpy[1] )
    end
end

function betweenState.draw()
    gameState.draw()


    -- darkening thing over the game
    setColorRGB( 0, 0, 0, 180 )
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight() )

    love.graphics.origin()
    love.graphics.setFont( veryBigFont )
    setColorRGB( 255, 255, 255 )
    love.graphics.printf( "S t a n d i n g s", 0, 0, love.graphics.getWidth(), "center" )

    local sx = love.graphics.getWidth()/6;
    local sy = veryBigFont:getHeight() + love.graphics.getHeight()/12;

    local cx = sx
    local cy = sy
    local rh = bigFont:getHeight()
    local rw = love.graphics.getWidth() - sx - love.graphics.getWidth() / 4

    love.graphics.setFont( bigFont )

    for i = 1, #playersCpy do
        local mathx = rw / globalStats.scoreMax * playersCpy[i].score
        setColorRGB( playersCpy[i].color.red, playersCpy[i].color.green, playersCpy[i].color.blue )
        love.graphics.rectangle( "fill", cx, cy, mathx, rh )
        setColorRGB( playersCpy[i].color.red, playersCpy[i].color.green, playersCpy[i].color.blue, 50 )
        love.graphics.rectangle( "fill", cx + mathx, cy, rw - mathx, rh )

        setColorRGB( playersCpy[i].color.red, playersCpy[i].color.green, playersCpy[i].color.blue )
        love.graphics.printf( playersCpy[i].name, cx + rw + love.graphics.getWidth()/25, cy, love.graphics.getWidth()/5 )
        love.graphics.printf( playersCpy[i].score, cx - love.graphics.getWidth()/8, cy, love.graphics.getWidth()/10, "right" )
        

        cy = cy + rh + love.graphics.getHeight()/15
    end
end