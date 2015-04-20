local collision = {}

function collision.cc(x1, y1, r1, x2, y2, r2)
  local d = math.sqrt(math.pow(y2 - y1, 2) + math.pow(x2 - x1, 2))
  if d <= r1 + r2 then
    return true
  else
    return false
  end
end

return collision
