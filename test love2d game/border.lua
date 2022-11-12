function drawborders()
  local i = 0
  local j = 1
  love.graphics.setColor(palettecolors[7][4])
  local csprite = love.graphics.newImage("sprite/pixel.png")
  while i < levelx do
    love.graphics.draw(csprite,i*tilesize,0,0,1)
    i = i + 1
  end
  while j < levely do
    love.graphics.draw(csprite,0,j*tilesize,0,1)
    j = j + 1
  end
  i = 0
  j = 0
  while i < levelx do
    love.graphics.draw(csprite,i*tilesize,levely*tilesize,0,1)
    i = i + 1
  end
  while j < levely do
    love.graphics.draw(csprite,(levelx-1)*tilesize,j*tilesize,0,1)
    j = j + 1
  end
end
