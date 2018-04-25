local create = require "create"

function create.bullet( x, y, rot, speed )
    local this = {}
    this.what = "bullet"
    this.x = x
    this.y = y
    this.velocity = {}
    this.velocity.x = math.cos( rot ) * speed
    this.velocity.y = math.sin( rot ) * speed

    this.time = 0
    this.lifeTime = 10

    this.collider = newColl( this, this.x - 1.5, this.y - 1.5, 3, 3 )


    this.draw = function(this)
        setColorRGB( 0, 0, 0 )
        love.graphics.circle("fill", this.x, this.y, 2 )
        setColorRGB( 255, 255, 255 )
    end



    this.update = function( this, dt )
        local movement = {}
        local item
        movement.x =  this.velocity.x * dt
        movement.y =  this.velocity.y * dt
        movement, item = collide( this.collider, movement )
        this.x = this.x + movement.x
        this.y = this.y + movement.y
    
        if( movement.x == 0 ) then
            this.velocity.x = -this.velocity.x
        end
        if( movement.y == 0 ) then
            this.velocity.y = -this.velocity.y
        end
    
    
        this.time = this.time + dt
    
        if( item.what == "tank" ) then
            item:remove()
            this:remove()
        end
    end

    this.remove = function( this )
        removeColl( this.collider )
        for i = 1, #bullets do
            if( bullets[i] == this ) then
                table.remove( bullets, i )
                break
            end
        end
    end

    bullets[#bullets + 1] = this
    return this
end







