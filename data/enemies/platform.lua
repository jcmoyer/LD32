image = 'assets/platform.png'
hp = 10

aset(function()
  animation 'default' {
    frame {
      source = rectangle(0, 0, 96, 96), duration = '70ms',
      attachment('radius', 32, 0)
    },
    frame {
      source = rectangle(96, 0, 96, 96), duration = '70ms',
      attachment('radius', 32, 0)
    },
    frame {
      source = rectangle(0, 96, 96, 96), duration = '70ms',
      attachment('radius', 32, 0)
    },
    frame {
      source = rectangle(96, 96, 96, 96), duration = '70ms',
      attachment('radius', 32, 0)
    }
  }
end)

local ticks = 0
local fires = false
local fireticks = 50

function spawn(context, userdata)
  local vx = userdata.vx or 0
  local vy = userdata.vy or 0

  local aa = userdata.aa or 0
  local am = userdata.am or 0

  context:setv(vx, vy)
  context:seta(aa, am)

  fires = userdata.fires or fires
  fireticks = userdata.fireticks or fireticks
end

function update(context)
  if not context:onscreen() then
    return
  end
  if fires then
    ticks = ticks + 1
    if ticks >= fireticks then
      local r = context:angletoplayer()
      context:spawnbulletangular('bullet-a-huge', r, 6)
      context:playsound('multishot')
      ticks = 0
    end
  end
end


