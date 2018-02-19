function defaultUpdate() end
function defaultDraw() end
function defaultKeypressed() end
function defaultMousepressed() end
function defaultMousereleased() end
function defaultTextinput() end
function defaultKeyreleased() end
function defaultMousemoved() end

function newState()
    local newState = {}
    newState.update = defaultUpdate
    newState.draw = defaultDraw
    newState.keypressed = defaultKeypressed
    newState.keyreleased = defaultKeyreleased
    newState.mousepressed = defaultMousepressed
    newState.mousereleased = defaultMousereleased
    newState.mousemoved = defaultMousemoved
    newState.textinput = defaultTextinput

    return newState
end

require "state/game"
require "state/menu"
require "state/pause"
require "state/settings"
require "state/settings2"
