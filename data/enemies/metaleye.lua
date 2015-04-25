image = 'assets/metalboss.png'
hp = 400
points = 100000
boss = true

aset(function()
  animation 'default' {
    frame {
      source = rectangle(0, 0, 256, 256), duration = '2s',
      attachment('radius', 128, 0)
    },
    frame {
      source = rectangle(256, 0, 256, 256), duration = '200ms',
      attachment('radius', 128, 0)
    },
    frame {
      source = rectangle(0, 256, 256, 256), duration = '200ms',
      attachment('radius', 128, 0)
    },
    frame {
      source = rectangle(256, 0, 256, 256), duration = '200ms',
      attachment('radius', 128, 0)
    }
  }
end)

local counter = 0
local counter2 = 0
local accumulator = 0
local accumulator2 = 0

local state = 'spawning'
local bladeside = 'left'

local gravitybullets = {}

function spawn(context, userdata)
  context:setv(0, 10)
end

function update(context)
  if state == 'spawning' then
    local x, y = context:getp()
    if y >= 200 then
      context:setv(0, 0)
      --context:setmusic('boss')
      state = 'fight-1'
    end
  elseif state == 'fight-1' then
    counter = counter + 1
    if counter >= 10 then
      for i = 1, 32 do
        local b = context:spawnbulletangular('bullet-b-red', 2*math.pi/32 * i + accumulator*math.pi/256, 4)
        context:playsound('pop2')
        b.accelmag = 0.1
      end
      counter = 0
    end
    accumulator = accumulator + 1
    accumulator2 = accumulator2 + 3

    if context:gethp() < 10 then
      context:sethp(400)
      state = 'fight-2'
      counter = -50
      context:setbulletzone(8,8)
    end
  elseif state == 'fight-2' then
    counter = counter + 1
    accumulator = accumulator + 1
    if counter >= 5 then
      local r = context:angletoplayer()
      for i = -7,7 do
        local b = context:spawnbulletangular('bullet-b-red-huge', 3*math.pi/2 + i * math.pi / 4 + accumulator*math.pi/256, 5)
        b.accelmag = 0.1
        b.accelangle = math.pi / 2
        context:playsound('pop2')
      end
      counter = 0
    end
    if context:gethp() < 10 then
      context:sethp(800)
      state = 'fight-3'
      counter = -50
      context:resetbulletzone()
    end
  elseif state == 'fight-3' then
    counter = counter + 1
    if counter >= 50 then
      context:spawnenemy('blade', context:spawnzone(bladeside), context:spawnzone('top'), 100)
      if bladeside == 'left' then
        bladeside = 'right'
      else
        bladeside = 'left'
      end
      counter = 0
    end
    counter2 = counter2 + 1
    if counter2 >= 30 then
      local r = context:angletoplayer()
      context:spawnbulletangular('bullet-a-huge', r, 5)
      context:playsound('pop2')
      counter2 = 0
    end
    if context:gethp() < 10 then
      context:sethp(800)
      state = 'fight-4'
      counter = -50
      counter2 = 0
    end
  elseif state == 'fight-4' then
    counter = counter + 1
    counter2 = counter2 + 1
    if counter >= 30 then
      local r = context:angletoplayer()
      for i = -8,8 do
        local b = context:spawnbulletangular('flame', r + i * math.pi / 8, 5)
        table.insert(gravitybullets, b)
        context:playsound('pop2')
      end
      context:spawnenemy('drone', context:spawnzone('xcenter') - 200, context:spawnzone('top'), {vy=6, fires=true, fireticks=100})
      context:spawnenemy('drone', context:spawnzone('xcenter') + 200, context:spawnzone('top'), {vy=6, fires=true, fireticks=100})
      counter = 0
    end

    if counter2 >= 200 then
      local r = context:angletoplayer()
      context:spawnbulletangular('bullet-b-red-huge', r, 10)
      context:playsound('pop2')
      counter2 = 150
    end

    if context:gethp() < 10 then
      --context:sethp(200)
      --state = 'fight-5'
      --counter = -50
    end
  elseif state == 'fight-5' then
    counter = counter + 1
    counter2 = counter2 + 1
    if counter >= 50 then
      for j = -3,3 do
        context:spawnenemy('drone', context:spawnzone('xcenter')+100*j, context:spawnzone('top'), {vy=5})
      end
      for j = -3,3 do
        context:spawnenemy('drone', context:spawnzone('left'), context:spawnzone('ycenter')+100*j, {vx=5})
      end

      --for j = -3,3 do
      --  context:spawnenemy('drone', context:spawnzone('right'), 50+context:spawnzone('ycenter')+100*j, {vx=-5})
      --end
      counter = 0
    end

    accumulator = accumulator + 1
    if counter2 >= 200 then
      local r = context:angletoplayer()

      for i = -2,2 do
        context:spawnbulletangular('bullet-b-red-huge', r + i*math.pi/4, 10)
      end
      context:playsound('pop2')
      counter2 = 150
    end
  end

  for i = #gravitybullets,1,-1 do
    local b = gravitybullets[i]
    b.v:add(0, 0.1)
    if not b.alive then
      table.remove(gravitybullets, i)
    end
  end
end


