function spawn(context, userdata)
  context:setscrollv(userdata.xv or nil, userdata.yv or nil)
  context:kill()
end
