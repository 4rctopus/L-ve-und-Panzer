require "collision"
require "keybindings"

local create = require "create"

local tank = {}

tankImage = love.graphics.newImage("files/tank3.png")


local function getStatsFromPlayer( this )
    this.speed = globalStats.tankSpeed + this.player.stats.speed * globalStats.tankSpeed / 10
    this.ammo = globalStats.tankStartAmmo + this.player.stats.ammo
    this.bulletSpeed = globalStats.bulletSpeed + this.player.stats.bulletSpeed * globalStats.bulletSpeed / 10
    this.radianSpeed = globalStats.radianSpeed + this.player.stats.radianSpeed * globalStats.radianSpeed / 25
end

function create.tank( posx, posy, player )
    local this = {}
    this.what = "tank"
    this.player = player
    getStatsFromPlayer( this )

    --pos
    this.x = posx
    this.y = posy

    --size
    this.ox = 16
    this.oy = 16
    this.scale = 1
    this.rotation = 0
    this.image = tankImage
    --movement
    this.velocity = {}
    this.velocity.x = 0
    this.velocity.y = 0

    this.collider = newColl( this, this.x - 7, this.y - 7, 15, 14 )


    this.draw = function( this )
        setColorRGB( this.player.color.red, this.player.color.green, this.player.color.blue )
        love.graphics.draw( this.image, this.x, this.y, this.rotation, this.scale, this.scale, this.ox, this.oy )
        setColorRGB( 255, 255, 255 )
    end

    this.update = function( this, dt )
        --getStatsFromPlayer( this )
        this:input( dt )
        -- movement
        local movement = {}
        movement.x = this.velocity.x * dt
        movement.y = this.velocity.y * dt
        movement = collide( this.collider, movement )
        this.x = this.x + movement.x
        this.y = this.y + movement.y
    end

    this.input = function( this, dt )
        local movement = {}
        movement.x = 0
        movement.y = 0
        if( love.keyboard.isDown( this.player.keybind.left ) ) then
            this.rotation = this.rotation - this.radianSpeed * dt
        end
        if( love.keyboard.isDown( this.player.keybind.right ) ) then
            this.rotation = this.rotation + this.radianSpeed * dt
        end
        if( love.keyboard.isDown( this.player.keybind.forward ) ) then
            -- separate speed vector to x and y components
            movement.y = movement.y + math.sin( this.rotation )
            movement.x = movement.x + math.cos( this.rotation )
        end
    
        if( love.keyboard.isDown( this.player.keybind.shoot ) ) then
            -- continous shooting here
        end
    
        this.velocity.x = movement.x * this.speed
        this.velocity.y = movement.y * this.speed
        if( love.keyboard.isDown( this.player.keybind.back ) ) then
            -- same thing but backwards
            movement.y = movement.y - math.sin( this.rotation )
            movement.x = movement.x - math.cos( this.rotation )
            this.velocity.x = movement.x * this.speed / 2
            this.velocity.y = movement.y * this.speed / 2
        end
    end


    this.keypressed = function( this, key )
        if( this.player.keybind.shoot == key and this.ammo > 0) then
            this.ammo = this.ammo - 1
            local len = 13
            local bullet = create.bullet( this.x + math.cos( this.rotation ) * len, this.y + math.sin( this.rotation ) * len, this.rotation, this.bulletSpeed )
            local movement = {}
            local item
            movement.x, movement.y = 0, 0
            movement, item = collide( bullet.collider, movement )
            if( item.what == "wall" ) then
                -- remove bullet
                table.remove( colliders, #colliders )
                table.remove( bullets, #bullets )
                -- remove tank
                this:remove()
            end
            -- muzzle flash
            create.muzzleFlash(  bullet.x, bullet.y, 1, 0.1, 50 )
        end
    end


    this.remove = function(this)
        -- shake screen
        shakeCamera( camera, 10, 5 )
        --removeColl( tank.collider ) -- the collider remains cause the tanks wreck is still there
        create.broken( this )
        for i = 1, 3 do
            create.muzzleFlash( this.x + love.math.random(-10, 10), this.y + love.math.random(-10, 10), 0, 0.4, love.math.random(30, 340) )
        end
    
        for i = 1, #tanks do
            if( tanks[i] == this ) then
                table.remove( tanks, i )
                break
            end
        end
    end

    return this
end




return tank