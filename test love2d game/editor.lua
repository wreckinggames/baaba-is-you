editor_curr_objects = {}
ineditor = true
function addobject(heldtile,x,y,dir)
  if not ineditor then
    return
  end

  local obj = {}
  obj.size = 1
  obj.x = x *  tilesize
  obj.y = y * tilesize
  obj.tilex = x
  obj.tiley = y


  obj.name = heldtile
      obj.type = getspritevalues(obj.name).type
  obj.sprite = obj.name
  obj.color = getspritevalues(obj.name).color
  obj.dir = dir

  obj.id = #Objects + 1
  obj.transformable = true


  obj.active = true

  updatesprite(obj)

  if obj.tilex > 0 and obj.tilex < (levelx - 1) and obj.tiley > 0 and obj.tiley < levely then
    table.insert(editor_curr_objects,obj)
  end


end



function delobject (x,y)
  if not ineditor then
    return
  end
  local deleted = false
  for i, j in ipairs(editor_curr_objects) do

    if j.tilex == math.floor(x/tilesize) and j.tiley == math.floor(y/tilesize) then
      table.remove(editor_curr_objects, i)
      deleted = true
    end
  end
  if deleted then
    love.audio.play(love.audio.newSource("sound/editordelete.wav","static"))
  end

end

function draweditor()
  -- Don't draw the editor if we're not already in the editor
  if not ineditor then
    return
  end



  love.graphics.setBackgroundColor(palettecolors[1][5])



  for i, c in ipairs(editor_curr_objects) do

    -- copied from main.lua
   local t = palettecolors[c.color[1]]

   if(t ~= nil) and (t[c.color[2]] ~= nil)then
     love.graphics.setColor(t[c.color[2]])
     if c._active == false then
       local a1 = { t[c.color[2]][1] * 0.5, t[c.color[2]][2] * 0.5, t[c.color[2]][3] * 0.5}
       love.graphics.setColor(a1)
     end
   end



   if(c.active == true)then
     local xchange = -((c.sprite:getWidth() - 24) / 2) * (tilesize / 24)
     local ychange = -((c.sprite:getHeight() - 24) / 2) * (tilesize / 24)

     love.graphics.draw(c.sprite,c.x  + x_offset + xchange,c.y  + y_offset + ychange,0,c.size  * (tilesize / 24))
     love.graphics.setColor(1,1,1)

   end

   love.graphics.setColor(1,0,0)

   if string.sub(c.name,1,10) == "text_text_" then
     love.graphics.setColor(1,0,0.5)
     love.graphics.draw(textmeta,c.x  + x_offset,c.y  + y_offset,0,c.size * (tilesize / 24))
   end

   if(c.name == "clock")then
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

     love.graphics.print(hour .. ":" .. min,c.x + 1 + x_offset,c.y+tilesize/3+1  + y_offset,0,1.3)
   elseif c.name == "calendar" then
     love.graphics.setColor(0,0,0)
     local date = os.date("*t",os.time()).day
     love.graphics.draw(love.graphics.newImage("sprite/calendarnumbers/c" .. tostring(date) .. ".png"),c.x  + x_offset,c.y  + y_offset,0,c.size * (tilesize / 24))

   end

  end

  if heldtile ~= "" then
      -- copied from main.lua
     local heldsprite = heldtile
     local place_x, place_y = math.floor(love.mouse.getX()/  tilesize  ) * tilesize, math.floor(love.mouse.getY()/  tilesize  ) * tilesize
     if place_x > 0 and place_x < (levelx - 1) * tilesize and place_y > 0 and place_y < levely * tilesize then
       local heldrotate = getspritevalues(heldtile).rotate
       if ((heldrotate == 4) or (heldrotate == 6)) and type(helddir) == "string" then

         heldsprite =  heldtile .. "-" .. helddir

       end

      local tcolor = getspritevalues(heldtile).color
       local t = palettecolors[tcolor[1]]

       if(t ~= nil) and (t[tcolor[2]] ~= nil)then
         love.graphics.setColor(t[tcolor[2]][1], t[tcolor[2]][2], t[tcolor[2]][3], 0.5)

       end


         local csprite = nil
         if string.sub(heldsprite,1,10) == "text_text_" then
           csprite = love.graphics.newImage("sprite/" .. string.sub(heldsprite,6,-1) .. ".png")
         else
           csprite = love.graphics.newImage("sprite/" .. heldsprite .. ".png")
         end
         local xchange = -((csprite:getWidth() - 24) / 2) * (tilesize / 24)
         local ychange = -((csprite:getHeight() - 24) / 2) * (tilesize / 24)
         love.graphics.draw(csprite,place_x  + x_offset + xchange,place_y + y_offset + ychange,0,(tilesize / 24))

       love.graphics.setColor(1,0,0)

       if metaval == 1 then
         love.graphics.setColor(1,0,0.5, 0.5)
         love.graphics.draw(love.graphics.newImage("sprite/textMeta.png"),place_x  + x_offset,place_y  + y_offset,0,(tilesize / 24))
       end
     end

   end

end


function loadlevel()

  menu_state = "editor_test"
  ineditor = false
  filecount = 0
  fileimages = {}
  currenticon = "baaba"
  for i, j in ipairs(editor_curr_objects) do

      makeobject(j.tilex,j.tiley,j.name,j.dir,j.meta)

  end
  parse_text()

  local cb = love.system.getClipboardText()
  for a, b in ipairs(rules) do
    if b[3] == "uncopy" and (matches(b[1], cb, true) or (matches(b[1], "text_" .. cb, true) and is_prop(cb))) then
      love.system.setClipboardText("oops!")
    end
  end

  ingroup = {}
  local groups = objectswithproperty("group")
  for i,group in ipairs(groups) do
    if ingroup[group.id] then
      table.insert(ingroup[group.id], "group")
    else
      ingroup[group.id] = {"group"}
    end
  end
  startproperties()

  for i, j in ipairs(Objects) do
    dotiling(j)
    updatesprite(j)
  end

  if not music:isPlaying() then
    music:play()
    music:setLooping(true)
  end

end

function dielevel()
  menu_state = "editor"
  ineditor = true
  Objects = {}

  currenticon = "baaba"
  wewinning = false
  theloop = false
  love.window.setIcon(love.image.newImageData("sprite/baaba.png"))

  if not music:isPlaying() then
    music:play()
    music:setLooping(true)
  end

end

function handletilething()
  local width, height = love.graphics.getDimensions()

    if (love.mouse.getX() > (width - 100) and love.mouse.getY() > (height - 100) and love.mouse.getX() < (width - 20) and love.mouse.getY() < (height - 40)) then return end
    metaval = 0
   if love.mouse.isDown(1) and ineditor and not (love.mouse.getX() > (width - 100) and love.mouse.getY() > (height - 100) and love.mouse.getX() < (width - 20) and love.mouse.getY() < (height - 40)) then

     if not hideui then
      for i2,c in ipairs(buttons) do
       if love.mouse.getX() > c.x1 and love.mouse.getX() < c.x1 + (3.3 * c.buttonsize) and  love.mouse.getY() > c.y1 and love.mouse.getY() < c.y1 + (3.3 * c.buttonsize) then
         if heldtile ~= c.buttonname then
           love.audio.play(love.audio.newSource("sound/select.wav","static"))
         end
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
        if love.mouse.getX() > c.x1 - 1 and love.mouse.getX() < c.x1 + (3.3 * c.buttonsize) + 1 and  love.mouse.getY() > c.y1 - 1 and love.mouse.getY() < c.y1 + (3.3 * c.buttonsize) + 1 then
          onbutton = true
        end
      end
    end
    if hideui then
      onbuton = false
    end
    if(onbutton==false) then
      if(love.keyboard.isDown("m")) then
      metaval = 1
      end
    --getobject()
    local dot = true

    for i, j in ipairs(editor_curr_objects) do
      if j.tilex == math.floor(love.mouse.getX()/ tilesize ) and j.tiley == math.floor(love.mouse.getY()/ tilesize ) and (j.name == heldtile or (string.sub(j.name,1,5) == "text_" and string.sub(heldtile,1,5) == "text_")) then
        dot = false
      end
    end
    local obx, oby = math.floor(love.mouse.getX()/  tilesize  ),math.floor(love.mouse.getY()/  tilesize  )
     if obx > 0 and obx < (levelx - 1) and oby > 0 and oby < levely and not love.mouse.isDown(2) then
       if dot then
         love.audio.play(love.audio.newSource("sound/place.wav","static"))
         if metaval ~= 1 then
           addobject(heldtile,obx,oby, helddir )
         else
           addobject("text_"..heldtile,obx,oby, helddir )
         end
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
