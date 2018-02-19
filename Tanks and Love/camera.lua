-- camera and stuff

function newCamera()
    local camera = {}

    -- origin coordinates
    camera.x = 0
    camera.y = 0
    camera.scale = 1

    camera.shakex = 0
    camera.shakey = 0
    camera.shakeRadius = 0
    camera.shakeSpeed = 0

    return camera
end

function setCamera( camera )
	love.graphics.origin()
    love.graphics.scale( camera.scale )
    love.graphics.translate( love.graphics.getWidth() / camera.scale / 2,
                             love.graphics.getHeight() / camera.scale / 2  )
	love.graphics.translate( camera.x + camera.shakex, camera.y + camera.shakey )
end

function updateCamera( camera, dt )
    if( camera.shakeRadius > 0.5 ) then
        camera.shakeRadius = camera.shakeRadius * ( 1 - dt * camera.shakeSpeed )
        local randomAngle = love.math.random() * 360
        camera.shakex = math.sin( randomAngle ) * camera.shakeRadius
        camera.shakey = math.cos( randomAngle ) * camera.shakeRadius
    else
        camera.shakex = 0
        camera.shakey = 0
    end
end

function moveCamera( camera, x, y )
    camera.x = camera.x - x
    camera.y = camera.y - y
end

function setCameraPos( camera, x, y )
    camera.x = -x
    camera.y = -y
end

function shakeCamera( camera, radius, speed )
    camera.shakeRadius = radius
    camera.shakeSpeed = speed
end
