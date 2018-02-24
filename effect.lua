effects = {}

brokenImage = love.graphics.newImage("files/broken.png")

function newBroken( tank )
    local broken = tank
    broken.update = nil
    broken.draw = drawTank
    broken.image = brokenImage
    broken.what = "wall"


    effects[#effects + 1] = broken
    return broken
end


function newMuzzleFlash( posx, posy, size, lifeTime, growSpeed )
    local flash = {}
    flash.x, flash.y = posx, posy
    if( size == nil ) then flash.size = 5 else flash.size = size end
    if( growSpeed == nil ) then flash.growSpeed = 0 else flash.growSpeed = growSpeed end
    if( lifeTime == nil ) then flash.lifeTime = 0.07 else flash.lifeTime = lifeTime end
    flash.time = 0

    flash.update = updateMuzzleFlash
    flash.draw = drawMuzzleFlash

    --print("$UICIDE")

    effects[#effects + 1] = flash
    return flash
end

function updateMuzzleFlash( flash, dt )
    flash.time = flash.time + dt
    flash.size = flash.size + dt * flash.growSpeed
    if( flash.time > flash.lifeTime ) then
        removeEffect( flash )
    end
end

function drawMuzzleFlash( flash )
    love.graphics.setColor(255, 255, 255 )
    love.graphics.rectangle("fill", flash.x - flash.size / 2, flash.y - flash.size / 2, flash.size, flash.size )
end




function removeEffect( effect )
    if( effect.collider ) then removeColl( effect.collider ) end
    for i = 1, #effects do
        if( effects[i] == effect ) then
            table.remove( effects, i )
            break
        end
    end
end
