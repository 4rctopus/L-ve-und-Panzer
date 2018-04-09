
bullets = {}

function newBullet( x, y, rot, speed )
    local bullet = {}
    bullet.what = "bullet"
    bullet.x = x
    bullet.y = y
    bullet.velocity = {}
    bullet.velocity.x = math.cos( rot ) * speed
    bullet.velocity.y = math.sin( rot ) * speed

    bullet.time = 0
    bullet.lifeTime = 10

    bullet.collider = newColl( bullet, bullet.x - 1.5, bullet.y - 1.5, 3, 3 )

    bullets[#bullets + 1] = bullet
    return bullet
end

function removeBullet( bullet )
    removeColl( bullet.collider )
    for i = 1, #bullets do
        if( bullets[i] == bullet ) then
            table.remove( bullets, i )
            break
        end
    end
end

function updateBullet( bullet, dt )
    local movement = {}
    local item
    movement.x =  bullet.velocity.x * dt
    movement.y =  bullet.velocity.y * dt
    movement, item = collide( bullet.collider, movement )
    bullet.x = bullet.x + movement.x
    bullet.y = bullet.y + movement.y

    if( movement.x == 0 ) then
        bullet.velocity.x = -bullet.velocity.x
    end
    if( movement.y == 0 ) then
        bullet.velocity.y = -bullet.velocity.y
    end


    bullet.time = bullet.time + dt

    if( item.what == "tank" ) then
        removeTank( item )
        removeBullet( bullet )
    end
end


function drawBullet( bullet )
    setColorRGB( 0, 0, 0 )
    love.graphics.circle("fill", bullet.x, bullet.y, 2 )
    setColorRGB( 255, 255, 255 )

end
