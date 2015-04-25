image = 'assets/blade.png'
hp = 10
points = 1000

aset(function()
  animation 'default' {
    frame {
      source = rectangle(0, 0, 64, 64), duration = '100ms',
      attachment('radius', 31, 0)
    },
    frame {
      source = rectangle(64, 0, 64, 64), duration = '100ms',
      attachment('radius', 31, 0)
    },
    frame {
      source = rectangle(0, 64, 64, 64), duration = '100ms',
      attachment('radius', 31, 0)
    },
    frame {
      source = rectangle(64, 64, 64, 64), duration = '100ms',
      attachment('radius', 31, 0)
    }
  }
end)

function spawn(context, userdata)
  local r = context:angletoplayer()
  local m = 10
  context:setv(math.cos(r) * m, math.sin(r) * m)
end

local counter = 0
function update(context)
  if not context:onscreen() then
    return
  end
  counter = counter + 1
  if counter >= 10 then
    local r = context:angletoplayer()
    for i = -1,1 do
      context:spawnbulletangular('bullet-b-red', r + i * math.pi / 4, 5)
      context:playsound('pop2')
    end
    counter = 0
  end
end


