-- collision table
collTable = {}
collTable["tank"] = {}
collTable["tank"]["wall"] = true
collTable["tank"]["tank"] = true
collTable["bullet"] = {}
collTable["bullet"]["wall"] = true
collTable["bullet"]["tank"] = true
collTable["bullet"]["bullet"] = false


 function addColl( collider )
     colliders[#colliders + 1] = collider
     return #colliders + 1
 end

 function newColl( item, x, y, w, h )
   local collider = {}
   addColl( collider )
   if( type( item ) == "string" ) then
       collider.item = {}
       collider.item.what = item
   else
       collider.item = item
   end
   collider.x = x
   collider.y = y
   collider.w = w
   collider.h = h

   return collider
 end

-- remove collider ???
function removeColl( collider )
    for i = 1, #colliders do
        if( colliders[i] == collider ) then
            table.remove( colliders, i )
            break
        end
    end
end

function drawColliders( )
    setColorRGB( 0, 0, 255 )
    for i = 1, #colliders do
        love.graphics.rectangle("line", colliders[i].x, colliders[i].y, colliders[i].w, colliders[i].h )
    end
    setColorRGB( 255, 255, 255 )
end

function isColliding( coll1, coll2 )
    return  coll1.x < coll2.x + coll2.w and coll2.x < coll1.x + coll1.w and coll1.y < coll2.y + coll2.h and coll2.y < coll1.y + coll1.h
end

-- THIS IS WORKS BUT IT IS SHIT
function collide( collider, movement )
    local newcoll = {}
    newcoll.x = collider.x + movement.x
    newcoll.y = collider.y
    newcoll.w = collider.w
    newcoll.h = collider.h

    local rcollided = {}
    rcollided.item = {}
    rcollided.item.what = "nothing"

    for i = 1, #colliders, 1 do
        if( not(collider == colliders[i]) and collTable[collider.item.what][colliders[i].item.what] == true ) then
            local collided = colliders[i]
            if( isColliding( collided, newcoll ) ) then
                    movement.x = 0
                    rcollided = collided
            end
        end
    end
    newcoll.x = collider.x + movement.x
    newcoll.y = collider.y + movement.y
    for i = 1, #colliders, 1 do
        if( not(collider == colliders[i]) and collTable[collider.item.what][colliders[i].item.what] == true ) then
            local collided = colliders[i]
            if( isColliding( collided, newcoll ) ) then
                    movement.y = 0
                    rcollided = collided
            end
        end
    end


    collider.x = collider.x + movement.x
    collider.y = collider.y + movement.y
    return movement, rcollided.item
end
