winnerState = {}

local winner = {}

function winnerState.load( wplayer )
    winner = wplayer
end

function winnerState.update( dt )
end

function winnerState.draw()
    gameState.draw()

    -- darkening thing over the game
    setColorRGB( 0, 0, 0, 200 )
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight() )

    love.graphics.origin()
    love.graphics.setFont( veryBigFont )
    setColorRGB( winner.color.red, winner.color.green, winner.color.blue )
    love.graphics.printf( winner.name, 0, 0, love.graphics.getWidth()/2, "right" )
    love.graphics.printf( " won!", love.graphics.getWidth()/2, 0, love.graphics.getWidth()/2, "left" )

    local sx = love.graphics.getWidth() / 3;
    local sy = veryBigFont:getHeight() + love.graphics.getHeight()/8;

    local cx = sx
    local cy = sy
    --local rh = bigFont:getHeight()
    --local rw = love.graphics.getWidth()
    
    local buttonNewGame = ui.button( { name = "newGameButton", x = cx, y = cy, w = sx, h = bigFont:getHeight() * 2, text = "R E V E N G E", font = bigFont, align = "center" } )

    cy = cy + bigFont:getHeight() * 2 + love.graphics.getHeight()/8;

    local buttonMenu = ui.button( { name = "menuButton", x = cx, y = cy, w = sx, h = bigFont:getHeight() * 2, text = "B a c k", font = bigFont , align = "center" } )

    if( buttonNewGame.released[1] > 0 ) then

        for i = 1, #players do
            players[i].score = 0
        end

        loadState( gameState )
    end

    if( buttonMenu.released[1] > 0 ) then
        for i = 1, #players do
            players[i].score = 0
        end

        loadState( menuState )
    end

    
end