editor_curr_objects = {}
ineditor = true
function addobject(heldtile,x,y)
  if not ineditor then
    return
  end

  local obj = {}
  obj.size = 1
  obj.x = math.floor(love.mouse.getX()/  tilesize  )*  tilesize
  obj.y = math.floor(love.mouse.getY()/ tilesize )* tilesize
  obj.tilex = math.floor(obj.x/ tilesize )
  obj.tiley = math.floor(obj.y/ tilesize )


  obj.name = heldtile
      obj.type = getspritevalues(obj.name).type
  obj.sprite = obj.name
  obj.color = getspritevalues(obj.name).color
  obj.dir = "right"

  obj.id = #Objects + 1
  obj.transformable = true

  obj.active = true
  if obj.tilex > 0 and obj.tiley > 0 then
    table.insert(editor_curr_objects,obj)
  end

end



function delobject (x,y)
  if not ineditor then
    return
  end
  for i, j in ipairs(editor_curr_objects) do

    if j.tilex == math.floor(x/tilesize) and j.tiley == math.floor(y/tilesize) then
      table.remove(editor_curr_objects, i)
    end
  end

end

function draweditor()
  -- Don't draw the editor if we're not already in the editor
  if not ineditor then
    return
  end





  for i, c in ipairs(editor_curr_objects) do

    -- copied from main.lua
   if(getspritevalues(c.name).rotate == 4) and type(c.dir) == "string" then

     c.sprite =  c.name .. "-" .. c.dir

     if(c.customcolor == false)then

       c.color = getspritevalues(c.name).color

     end

   end
   local t = palettecolors[c.color[1]]

   if(t ~= nil) and (t[c.color[2]] ~= nil)then
     love.graphics.setColor(t[c.color[2]])
     if c._active == false then
       local a1 = { t[c.color[2]][1] * 0.5, t[c.color[2]][2] * 0.5, t[c.color[2]][3] * 0.5}
       love.graphics.setColor(a1)
     end
   end

   love.graphics.setBackgroundColor(palettecolors[1][5])

   if(c.active == true)then
     local csprite = nil
     if string.sub(c.sprite,1,10) == "text_text_" then
       csprite = love.graphics.newImage("sprite/" .. string.sub(c.sprite,6,-1) .. ".png")
     else
       csprite = love.graphics.newImage("sprite/" .. c.sprite .. ".png")
     end
     love.graphics.draw(csprite,c.x,c.y,0,c.size)
     love.graphics.setColor(1,1,1)

   end

   love.graphics.setColor(1,0,0)

   if string.sub(c.sprite,1,10) == "text_text_" then
     love.graphics.setColor(1,0,0.5)
     love.graphics.draw(love.graphics.newImage("sprite/textMeta.png"),c.x,c.y,0,c.size)
   end

   local hour = os.date("*t",os.time()).hour

   if(tonumber(hour) == 0)then
     hour = "12"
   end

   if(string.len(hour) == 1)then
     hour = "0" .. hour
   end

   if(tonumber(hour) > 12)then
     hour = tostring(tonumber(hour) - 12)
   end

   local min = os.date("*t",os.time()).min

   if(string.len(min) == 1)then
     min = "0" .. min
   end

   if(c.name == "clock")then
     love.graphics.print(hour .. ":" .. min,c.x-3,c.y+tilesize/3+1,0,0.8)
   end

  end

end


function loadlevel()
  ineditor = false
  for i, j in ipairs(editor_curr_objects) do

      makeobject(j.tilex,j.tiley,j.name,"right",j.meta)

  end
  rules = {}
    Parser:init()
    Parser:makeFirstWords()
    Parser:MakeRules()
    Parser:ParseRules()
    rules = {}
    for i,b in ipairs(baserules) do
      table.insert(rules,b)
    end
    Parser:AddRules()
    -- oh boy debugging
    -- Parser:Debug()
end

function dielevel()
  ineditor = true
  Objects = {}

  currenticon = "baaba"
  love.window.setIcon(love.image.newImageData("sprite/baaba.png"))

end

function handletilething()

    if (love.mouse.getX() > 740 and love.mouse.getY() > 520 and love.mouse.getX() < 800 and love.mouse.getY() < 580) then return end
    metaval = 0
   if love.mouse.isDown(1) and ineditor and not (love.mouse.getX() > 740 and love.mouse.getY() > 520 and love.mouse.getX() < 800 and love.mouse.getY() < 580) then

     if not hideui then
      for i2,c in ipairs(buttons) do
       if (dist(love.mouse.getX(),c.buttonsize+c.y1,c.buttonsize+c.x1,love.mouse.getY()) < c.buttonsize*2) then
       heldtile = c.buttonname
       --love.window.setPosition(4,6)
       end
      end
    end
   end
   if(heldtile ~= "")then
   if love.mouse.isDown(1) then
     if not hideui then
      for i6,c in ipairs(buttons) do
        if (dist(love.mouse.getX(),c.buttonsize+c.y1,c.buttonsize+c.x1,love.mouse.getY()) < c.buttonsize*2 )then
        onbutton = true
        end
      end
    end
    if hideui then
      onbuton = false
    end
    if(onbutton==false) then
      if(love.keyboard.isDown("m")) then
      metaval = 1 -- sorry
      end
    --getobject()
    local dot = true

    for i, j in ipairs(editor_curr_objects) do
      if j.tilex == math.floor(love.mouse.getX()/ tilesize ) and j.tiley == math.floor(love.mouse.getY()/ tilesize ) and (j.name == heldtile or (string.sub(j.name,1,5) == "text_" and string.sub(heldtile,1,5) == "text_")) then
        dot = false
      end
    end
     if dot then

       if metaval ~= 1 then
         addobject(heldtile,love.mouse.getX(),love.mouse.getY())
       else
         addobject("text_"..heldtile,love.mouse.getX(),love.mouse.getY())
       end
     end

    end
    onbutton = false
   end
   end


   if love.mouse.isDown(2) and ineditor then
    for i3,c3 in ipairs(buttons) do
     if(dist(c3.x1+50+c3.buttonsize/2,c3.y1+c3.buttonsize/2,love.mouse.getX(),love.mouse.getY()) < c3.buttonsize/1.5) then
    --do function on right click
     end
    end
    for i5,c5 in ipairs(editor_curr_objects) do
     if(dist(c5.x+tilesize/2,c5.y+tilesize/2,love.mouse.getX(),love.mouse.getY()) < tilesize/1.5) then
     --c5.active = false
      if(love.keyboard.isDown("q") == false)then
       delobject(love.mouse.getX(),love.mouse.getY())
      else
        AllLevels[c5.id] = levelname

      end
     end
    end
   end
   --drawui()
 end
