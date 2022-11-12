palettecolors = {}
palette = ""
function loadPalette(name)
  local pimage = love.image.newImageData("sprite/"..name..".png")
  palettecolors = {}
  for eye = 0,6 do--Palleteimage:getHeight()-1 do
    local tempcolors = {}
    for eyee = 0,4 do--Palleteimage:getWidth()-1 do
      local a,b,c = pimage:getPixel(eye,eyee)

      table.insert(tempcolors,{a,b,c})
    end
    table.insert(palettecolors,tempcolors)
  end
  palette = name
end
loadPalette("testpalette")
