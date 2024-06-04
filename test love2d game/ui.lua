  love.filesystem.load("main.lua")()
      buttons = {}

function initui()
  buttons = {}

  for i,c in ipairs(editor_tabs[curr_tab]) do
      for j,d in ipairs(c) do
        Button1={}

        local t = palettecolors[getspritevalues(d).color[1]]
        Button1.color1 =  t[getspritevalues(d).color[2]]
        Button1.inactivecolor = {Button1.color1[1] * 0.45, Button1.color1[2] * 0.45, Button1.color1[3] * 0.55}


        --Button1.color1 = getspritevalues(d).color--{0.5,0.5,0.5}
        Button1.buttonname = d

        Button1.buttonsprite = love.graphics.newImage("sprite/" .. d .. ".png")

        Button1.buttonsize = 10 * windowtilesize
        Button1.x1 = (j-1)*Button1.buttonsize*3.3
        Button1.y1 = 13+(i-1)*Button1.buttonsize*3.3
        table.insert(buttons,Button1)
      end
  end
end

function drawui()

  for i,c in ipairs(buttons) do
    local hover = false



      if love.mouse.getX() > c.x1 and love.mouse.getX() < c.x1 + (3.3 * c.buttonsize) and  love.mouse.getY() > c.y1 and love.mouse.getY() < c.y1 + (3.3 * c.buttonsize) then
        hover = true
      end




    local c1, c2, c3, cc = c.color1[1], c.color1[2], c.color1[3], c.color1
    if hover then
      c1, c2, c3, cc = c.inactivecolor[1], c.inactivecolor[2], c.inactivecolor[3], c.inactivecolor
    end
    love.graphics.setColor(c1 * 0.58,c2 * 0.58,c3 * 0.62)
    love.graphics.rectangle("fill",c.x1,c.y1,c.buttonsize*3.3,c.buttonsize*3.3)
    love.graphics.setColor(c1 * 0.37,c2 * 0.37,c3 * 0.43) --Button1.color1[1] * 0.4,Button1.color1[2] * 0.4,Button1.color1[3] * 0.4
    love.graphics.rectangle("fill",Button1.buttonsize/6+c.x1,Button1.buttonsize/6+c.y1,c.buttonsize*3,c.buttonsize*3,c.buttonsize/3,c.buttonsize/3) --c.buttonsize/6,c.buttonsize*3,c.buttonsize*3,c.buttonsize/3,c.buttonsize/3)
    love.graphics.setColor(cc)
    love.graphics.draw(c.buttonsprite,c.buttonsize/3+c.x1,c.buttonsize/3+c.y1,0,c.buttonsize/10)

    if c.buttonname == heldtile then
      love.graphics.setColor(1, 1, 0)
      love.graphics.rectangle("line",c.x1 + 1,c.y1 + 1,c.buttonsize*3.3 - 2,c.buttonsize*3.3 - 2)
    end
  end
end

function drawtabs()

  for i, j in ipairs(tab_names) do
    local tcolor = tab_colors[i]
    local t = palettecolors[tcolor[1]]

    if(t ~= nil) and (t[tcolor[2]] ~= nil)then
      love.graphics.setColor(t[tcolor[2]][1], t[tcolor[2]][2], t[tcolor[2]][3])
    end
    love.graphics.draw(miscsprites["tab_" .. j], (i - 1) * 40,1,0,1)
  end
end

function newalert(alertx,alerty,alertmessage,alertbuttons,alertmessages,alertbuttonsizes,alertbuttonstart)
 for i,c in ipairs(alertmessages) do
   love.graphics.setColor(0.25,0.5,1)
 love.graphics.rectangle("fill", alertx, alerty, 300, 100)
  for j = 1,alertbuttons do
    love.graphics.setColor(0,0.25,1)
    love.graphics.rectangle("fill",  alertbuttonstart[1]+j*(alertbuttonstart[1]-1), alertbuttonstart[2], alertbuttonsizes[j][1], alertbuttonsizes[j][2])
    love.graphics.setColor(0,0,0)
    love.graphics.print(alertmessages[j], alertbuttonstart[1]+j*(alertbuttonstart[1]-1), alertbuttonstart[2])
  end
 end


end

current_textinput = ""
levelname = ""
editlevelname = false
function love.textinput(text)
  if (editlevelname == true) and (text ~= "@")then
   current_textinput = current_textinput .. text
  end
  if(text == "@")then
    editlevelname = not editlevelname
    if not editlevelname then
      levelname = current_textinput
      current_textinput = ""
    end
  end
end
