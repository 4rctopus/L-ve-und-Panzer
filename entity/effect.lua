local create = require "create"

effects = {}

brokenImage = love.graphics.newImage("files/broken.png")

function create.broken( tank )
    local this = tank
    this.update = nil
    --this.draw = tank.draw
    this.image = brokenImage
    this.what = "wall"


    effects[#effects + 1] = this
    return this
end

function create.muzzleFlash(  posx, posy, size, lifeTime, growSpeed )
    local this = {}
    this.x, this.y = posx, posy
    if( size == nil ) then this.size = 5 else this.size = size end
    if( growSpeed == nil ) then this.growSpeed = 0 else this.growSpeed = growSpeed end
    if( lifeTime == nil ) then this.lifeTime = 0.07 else this.lifeTime = lifeTime end
    this.time = 0

    this.update = updateMuzzleFlash
    this.draw = drawMuzzleFlash


    this.update = function( this, dt )
        this.time = this.time + dt
        this.size = this.size + dt * this.growSpeed
        if( this.time > this.lifeTime ) then
            removeEffect( this )
        end
    end

    this.draw = function( this )
        setColorRGB(255, 255, 255 )
        love.graphics.rectangle("fill", this.x - this.size / 2, this.y - this.size / 2, this.size, this.size )
    end

    effects[#effects + 1] = this
    return this
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
