require "collision"
require "keybindings"
require "bullet"


tankImage = love.graphics.newImage("files/tank3.png")

tankSpeed = 100
tankBackSpeed = 50
bulletSpeed = 150
tankStartAmmo = 6

-- this will be holding the tanks
tanks = {}


function newTank( posx, posy, player )
    local tank = {}
    tank.what = "tank"
    tank.player = player
    --pos
    tank.x = posx
    tank.y = posy

    --size
    tank.ox = 16
    tank.oy = 16
    tank.scale = 1
    tank.rotation = 0

    tank.image = tankImage
    --movement
    tank.velocity = {}
    tank.velocity.x = 0
    tank.velocity.y = 0
    tank.speed = 100
    tank.radianSpeed = 4
    tank.collider = newColl( tank, tank.x - 7, tank.y - 7, 15, 14 )

    tank.ammo = tankStartAmmo

    tank.keybind = defaultKeybind

    return tank
end

function removeTank( tank )

    -- shake screen
    shakeCamera( camera, 10, 5 )
    --removeColl( tank.collider ) -- the collider remains cause the tanks wreck is still there
    newBroken( tank )
    for i = 1, 3 do
        newMuzzleFlash( tank.x + love.math.random(-10, 10), tank.y + love.math.random(-10, 10), 0, 0.4, love.math.random(30, 340) )
    end

    for i = 1, #tanks do
        if( tanks[i] == tank ) then
            table.remove( tanks, i )
            break
        end
    end
end

function keypressedInputTank( tank, key )
    if( tank.player.keybind.shoot == key and tank.ammo > 0) then
        tank.ammo = tank.ammo - 1
        local len = 13
        local bullet = newBullet( tank.x + math.cos( tank.rotation ) * len, tank.y + math.sin( tank.rotation ) * len, tank.rotation, bulletSpeed )
        local movement = {}
        local item
        movement.x, movement.y = 0, 0
        movement, item = collide( bullet.collider, movement )
        if( item.what == "wall" ) then
            -- remove bullet
            table.remove( colliders, #colliders )
            table.remove( bullets, #bullets )
            -- remove tank
            removeTank( tank )
        end
        -- muzzle flash
        newMuzzleFlash( bullet.x, bullet.y, 1, 0.1, 50 )
    end
end

function inputTank( tank, dt )
    local movement = {}
    movement.x = 0
    movement.y = 0
    if( love.keyboard.isDown( tank.player.keybind.left ) ) then
        tank.rotation = tank.rotation - tank.radianSpeed * dt
    end
    if( love.keyboard.isDown( tank.player.keybind.right ) ) then
        tank.rotation = tank.rotation + tank.radianSpeed * dt
    end
    if( love.keyboard.isDown( tank.player.keybind.forward ) ) then
        -- separate speed vector to x and y components
        movement.y = movement.y + math.sin( tank.rotation )
        movement.x = movement.x + math.cos( tank.rotation )
    end

    if( love.keyboard.isDown( tank.player.keybind.shoot ) ) then

    end

    tank.velocity.x = movement.x * tankSpeed
    tank.velocity.y = movement.y * tankSpeed
    if( love.keyboard.isDown( tank.player.keybind.back ) ) then
        -- same thing but backwards
        movement.y = movement.y - math.sin( tank.rotation )
        movement.x = movement.x - math.cos( tank.rotation )
        tank.velocity.x = movement.x * tankBackSpeed
        tank.velocity.y = movement.y * tankBackSpeed
    end

end

function updateTank( tank, dt )
    inputTank( tank, dt )

    -- movement
    local movement = {}
    movement.x = tank.velocity.x * dt
    movement.y = tank.velocity.y * dt
    movement = collide( tank.collider, movement )
    tank.x = tank.x + movement.x
    tank.y = tank.y + movement.y
end



function drawTank( tank )
    love.graphics.setColor( tank.player.color.red, tank.player.color.green, tank.player.color.blue )
    love.graphics.draw( tank.image, tank.x, tank.y, tank.rotation, tank.scale, tank.scale, tank.ox, tank.oy )
    love.graphics.setColor( 255, 255, 255 )
end
