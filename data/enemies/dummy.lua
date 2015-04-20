image = 'assets/ghost.png'

aset(function()
  animation 'default' {
    frame {
      source = rectangle(0, 0, 64, 64),
      attachment('radius', 32, 0)
    }
  }
end)

local counter = 0

function spawn(context, userdata)
  context:setv(userdata.vx, userdata.vy)
end

function update(context)
  counter = counter + 1
  if counter >= 5 then
    context:spawnbulletangular('bullet-c', context:angletoplayer(), 8)
    counter = 0
  end

    --[[
  counter = counter + 1
  if counter < 5 then
    local mypos = context.mypos()
    local playerpos = context.playerpos()

    local relpos = playerpos - mypos
    local angle = math.atan2(relpos[2], relpos[1])

    context:spawnbullet('bullet-a', angle)
  end
  ]]
end


