love.filesystem.load("rules.lua")()
love.filesystem.load("main.lua")()
love.filesystem.load("tool.lua")()
local colorblocks = {
  {
    name = "red",
    color = {1,1}
  },
  {
    name = "orange",
    color = {2,1}
  },
  {
    name = "blue",
    color = {6,1}
  },
  {
    name = "yellow",
    color = {3,1}
  },
  {
    name = "green",
    color = {5,1}
  },
  {
    name = "gellow",
    color = {3,2}
  },
  {
    name = "purple",
    color = {7,1}
  },
  {
    name = "pink",
    color = {4,4}
  }
}
local dirblocks = {
  "up",
  "right",
  "left",
  "down"
}
local dir
function startproperties()
  for i,c in ipairs(Objects) do
    if c.file == nil then
      c.color = getspritevalues(c.name).color
    else
      c.color = {1,2}
    end
    c.transformable = true
    c.customcolor = false
    c.hide = false
    if(c.name == "text_clipboard")then
      local found  = false
      for i,val in ipairs(objectValues)do
        if(love.system.getClipboardText() == val.name) or ("text_" .. love.system.getClipboardText() == val.name)then
          found = true
        end
      end
      if found == false then
        c.color = {1,4}
      end
    end
  end
  local newicon = false

    for a,b in ipairs(rules) do
      if  (b[1] == "icon") and (b[2] == "is") and testcond(b[4], "icon") then
        if love.filesystem.getInfo("sprite/" .. b[3] .. ".png",{}) ~= nil then
          local baseimage = love.image.newImageData("sprite/" .. b[3] .. ".png")
          local bcolor = getspritevalues(b[3]).color
          tint_icon(baseimage, bcolor)
          currenticon = b[3]
        elseif b[3] == "meta" and string.sub(currenticon, 1, 5) ~= "text_" then
          local baseimage = love.image.newImageData("sprite/text_" .. currenticon .. ".png")
          local bcolor = getspritevalues("text_" .. currenticon).color
          tint_icon(baseimage, bcolor)
          currenticon = "text_" .. currenticon
        elseif b[3] == "unmeta" and string.sub(currenticon, 1, 5) == "text_" then
          local baseimage = love.image.newImageData("sprite/" .. string.sub(currenticon, 6) .. ".png")
          local bcolor = getspritevalues(string.sub(currenticon, 6)).color
          tint_icon(baseimage, bcolor)
          currenticon = string.sub(currenticon, 6)
        elseif b[3] == "sleep" and getspritevalues(currenticon).rotate == 6 then
          local baseimage = love.image.newImageData("sprite/" .. currenticon .. "-right-sleep.png")
          local bcolor = getspritevalues(currenticon).color
          tint_icon(baseimage, bcolor)
          newicon = true
        else
          for i,color in ipairs(colorblocks)do
            if b[3] == color.name then
              local baseimage = love.image.newImageData("sprite/" .. currenticon .. ".png")
              tint_icon(baseimage, color.color)
              newicon = true
            end
          end
        end

      end
    end

    if not newicon and love.filesystem.getInfo("sprite/" .. currenticon .. ".png",{}) ~= nil then
      local baseimage = love.image.newImageData("sprite/" .. currenticon .. ".png")
      local bcolor = getspritevalues(currenticon).color
      tint_icon(baseimage, bcolor)
    end



    active = true

    local isplace = objectswithproperty("place")

    for i, j in ipairs(isplace) do
      local onj = on(j)
      local thisfailed = true
      for k, l in ipairs(onj) do
        if ruleexists(l.id,nil,"is","placed") then
          thisfailed = false
        end
      end
      if thisfailed then
        active = false
        break
      end
    end


    for i,color in ipairs(colorblocks)do
      local iscolor = objectswithproperty(color.name)
      for j,c in ipairs(iscolor)do
        c.color = color.color
        c.customcolor = true
      end
    end

    for c,g in ipairs(images) do
      for a,b in ipairs(g) do
        local isother = objectswithproperty(b)
        for i,c in ipairs(isother) do
          if(c.name == b)then
            c.transformable = false
          end
        end
      end
    end




    local issleep = objectswithproperty("sleep")
    for i,c in ipairs(issleep) do
      c.sleep = true
    end

    local isold = objectswithproperty("old")
    for i,c in ipairs(isold) do
      c.old = true
      if c.name == "keeke" or c.name == "text_keeke" then
        c.color = {1,1}
        c.customcolor = true
      elseif c.name == "stone" or c.name == "text_stone" then
        c.color = {2,3}
        c.customcolor = true
      end
    end


     for i, j in ipairs(Objects) do
       j.size = 1
     end
     local issmall = objectswithproperty("small")
     for i,c in ipairs(issmall) do
       c.size = c.size / 2
     end
     local isbig = objectswithproperty("big")
     for i,c in ipairs(isbig) do
       c.size = c.size * 2
       c.small = c.small * 2
     end

     local ishide = objectswithproperty("hide")
     for i, c in ipairs(ishide) do
       c.hide = true
     end

end

function findproperties()
  winning = true
  startproperties()



  local istextify2 = objectswithproperty("text")
   for i,c in ipairs(istextify2) do
     if c.transformable and string.sub(c.name, 1, 10) ~= "text_text_" then
       makeobject(c.tilex,c.tiley,"text_" .. c.name,c.dir)

       handledels({c}, false)

     end
   end

   local istextify = objectswithproperty("meta")
    for i,c in ipairs(istextify) do
      if c.transformable and string.sub(c.name, 1, 10) ~= "text_text_" then


        makeobject(c.tilex,c.tiley,"text_" .. c.name,c.dir)


        handledels({c}, false)

      end
    end

    local istextify = objectswithproperty("unmeta")
     for i,c in ipairs(istextify) do
       if c.transformable then

         if string.sub(c.name, 1, 5) == "text_" and getspritevalues(string.sub(c.name, 6)).nope == nil then
           makeobject(c.tilex,c.tiley,string.sub(c.name, 6),c.dir)


           handledels({c}, false)
         end

       end
     end

     if turnkey == "Absolutely Not" then
       local isfile = objectswithproperty("file")
       for i,c in ipairs(isfile) do
         if c.transformable then

             makefile(c.tilex,c.tiley,c.dir)


             handledels({c}, false)

         end
       end
     end

 for f,g in ipairs(images) do
    for a,b in ipairs(g) do
  local isother = objectswithproperty(b)
  for i,c in ipairs(isother) do
  if(c.transformable == true) and b ~= "group" and b ~= "clipboard" and b ~= "text" and b ~= "file" then
  c.name=b
  c.sprite=b
  c.color=getspritevalues(b).color
  c.type = getspritevalues(b).type
  c._active = true
  c.file = nil
  dotiling(c)
  updatesprite(c)
  end
  end
end
 end
 local dels = {}
 local iswrite = objectswithverb("write")

 for i, write in ipairs(iswrite) do

   local c = write.unit
   if write.target ~= nil then --????
     local totransform = "text_" .. write.target
     if c.transformable then

       if getspritevalues(totransform).nope == nil then
         makeobject(c.tilex,c.tiley,totransform,c.dir)

         table.insert(dels, c)
       end

     end
   end

 end
 dels = handledels(dels)

 local isfall = objectswithproperty("fall")
 for i,faller in ipairs(isfall) do
   local limit = 0
   local to_x = faller.tilex
   local to_y = faller.tiley
   local done = false
   while limit < 300 and not done do
     to_y = to_y + 1
     local here = allhere(to_x, to_y)
     local fail = false
     for a, b in ipairs(here) do
       if ruleexists(b.id, nil, "is", "stop") or ruleexists(b.id, nil, "is", "push") then
         fail = true
       end
     end
     if fail or to_y > levely - 1 then
       to_y = to_y - 1
       update(faller.id, to_x, to_y)
       --[[faller.x = to_x * tilesize
       faller.y = to_y * tilesize
       faller.tilex = to_x
       faller.tiley = to_y]]
       done = true
     end
     limit = limit + 1
   end

 end

 local isselect = objectswithproperty("select")
 for i, select in ipairs(isselect) do
   local dir = ""
   if((love.keyboard.isDown("w")) or love.keyboard.isDown("up"))then dir = "up"
   elseif((love.keyboard.isDown("a"))or love.keyboard.isDown("left"))then dir = "left"
   elseif((love.keyboard.isDown("s"))or love.keyboard.isDown("down"))then dir = "down"
   elseif((love.keyboard.isDown("d"))or love.keyboard.isDown("right"))then dir = "right" end
   local nx, ny = select.tilex, select.tiley
   if(dir == "right")then nx = nx+1
   elseif(dir == "left")then nx = nx-1
   elseif(dir == "down")then ny = ny+1
   elseif(dir == "up")then ny = ny-1 end
   local there = allhere(nx, ny)
   for a, b in ipairs(there) do
     if ruleexists(b.id, nil, "is", "path") or b.name == "leevel" then
       update(select.id, nx, ny)
       select.dir = dir
     end
   end
 end

 local teles = {}
 local istele = objectswithproperty("tele")
  for i,tele in ipairs(istele)do
   local ontele = on(tele)
   local obj = {}
   local totele = {}
   local telei = 1
   local z = 0
   for k, j in ipairs(istele) do
     if (j.name == tele.name) then
       table.insert(totele, j)
       z = z + 1
     end
     if j.id == tele.id then
       telei = z
     end
   end
   if telei + 1 <= #totele then
     obj = totele[telei + 1]
   else
     obj = totele[1]
   end
   for j,teled in ipairs(ontele)do
     table.insert(teles, {teled.id,obj.tilex,obj.tiley})
   end
  end
  for a, b in ipairs(teles) do
    update(b[1], b[2], b[3])
  end

 local isset = objectswithproperty("set")

 for i, set in ipairs(isset) do
   set.orig_x = set.tilex
   set.orig_y = set.tiley
 end

 local isreset = objectswithproperty("reset")

 for i, reset in ipairs(isreset) do
   update(reset.id, reset.orig_x, reset.orig_y)
 end

 local iswhat = objectswithproperty("what")
 for a,b in ipairs(iswhat)do
   love.system.openURL("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
 end

 local isxnopyt = objectswithproperty("xnopyt")
 for i,xnoped in ipairs(isxnopyt) do
   table.insert(dels,xnoped)
 end
 dels = handledels(dels, false)
 local ishot = objectswithproperty("hot")
  for i,hotunit in ipairs(ishot) do

     local melts = objectswithproperty("melt")
       for m,melt in ipairs(melts) do
         local hotmelt = false
         local onmelt = on_plus(melt)
         if float(melt.id, hotunit.id) then
              for n,onm in ipairs(onmelt) do
               if(onm.id == hotunit.id) then
                hotmelt = true
               end
              end
          end
         if hotmelt then
          table.insert(dels,melt)
         end
   end
 end
 dels = handledels(dels, "burn")
 --local dels = {}
 local issink = objectswithproperty("sink")
  for i,sinker in ipairs(issink) do
   local onhere = on(sinker)
   if #onhere > 0 then
     local floating = ruleexists(sinker.id, nil ,"is","float")

       local sunk = false
       for o,here in ipairs(onhere) do
         local floating2 = ruleexists(here.id, nil ,"is","float")
         if floating2 == floating then
           table.insert(dels,here)
           sunk = true
         end
       end
       if sunk then
         table.insert(dels,sinker)
       end


   end
 end

 dels = handledels(dels, "sink")

 local isburn = objectswithproperty("burn")
  for i,burner in ipairs(isburn) do
   local onhere = on(burner)
   if #onhere > 0 then
     local floating = ruleexists(burner.id, nil ,"is","float")

       for o,here in ipairs(onhere) do
         local floating2 = ruleexists(here.id, nil ,"is","float")
         if floating2 == floating then
           table.insert(dels,here)
         end
       end



   end
 end

 dels = handledels(dels, "burn")

 local isweak = objectswithproperty("weak")
  for i,weaker in ipairs(isweak) do
   local onhere = on(weaker)
   if #onhere > 0 then
     local floating = ruleexists(weaker.id, nil ,"is","float")

       for o,here in ipairs(onhere) do
         local floating2 = ruleexists(here.id, nil ,"is","float")
         if floating2 == floating then
           table.insert(dels,weaker)
         end
       end



   end
 end

 dels = handledels(dels)

 local iseat = objectswithverb("eat")
 for i, eat in ipairs(iseat) do
   local unit = eat.unit
   local toeat = eat.target
   local onhere = on(unit)
   for _, j in ipairs(onhere) do
     if matches(eat.target, j) then
       table.insert(dels, j)
     end
   end
 end

 dels = handledels(dels)


 local isonly = objectswithproperty("only")
  for i,onlier in ipairs(isonly) do
   if i > 1 then
    table.insert(dels,onlier)
   end
 end

 dels = handledels(dels)


  for i,direct in ipairs(dirblocks)do
   local isdir = objectswithproperty(direct)
   for j,c in ipairs(isdir)do
    c.dir = direct
   end
  end


 local isopen = objectswithproperty("open")
  for i,key in ipairs(isopen) do
   local onhere = on_plus(key)
   local doors = objectswithproperty("shut")
   local opened = false
   if #onhere > 0 then
     for o,here in ipairs(onhere) do
       for d,door in ipairs(doors) do
         if(here == door) and ruleexists(here.id, nil ,"is","float") == ruleexists(door.id, nil ,"is","float") then
           table.insert(dels,door)
           table.insert(dels,key)
           break
         end
       end
     end
   end
 end
 dels = handledels(dels)
 local isdefeat = objectswithproperty("defeat")
  for i,c in ipairs(isdefeat) do
  local onhere = on_plus(c)
  for h,here in ipairs(onhere) do
   if ruleexists(here.id,here.name,"is","you") and ruleexists(here.id, nil ,"is","float") == ruleexists(c.id, nil ,"is","float") then
    table.insert(dels,here)
   end
  end
  end
   dels = handledels(dels)


   local ismake = objectswithverb("make")
   for i, make in ipairs(ismake) do
     local unit = make.unit
     local tomake = unitreference(unit, make.target)
     local onhere = on_plus(unit)



     for j, k in ipairs(tomake) do
       local valid = true

       for a, b in ipairs(onhere) do
         if k == b.name then
           valid = false
         end
       end

       if valid then
         makeobject(unit.tilex, unit.tiley, k, unit.dir)
       end
     end



   end

   local iscollect = objectswithproperty("collect")
   for i, collect in ipairs(iscollect) do
     local onhere = on_plus(collect)
     for j, here in ipairs(onhere) do
       if ruleexists(here.id, nil, "is", "you") and ruleexists(here.id, nil ,"is","float") == ruleexists(collect.id, nil ,"is","float") then
        table.insert(dels, collect)
       end
     end
   end
   dels = handledels(dels)
 local wins = objectswithproperty("win")
          winning = true

end
function handledels(dels, dtype_, nolink_)

  local sound = dtype_ or "destroy"
  local no_link = nolink_ or false

  for d, del in ipairs(dels) do
    for e, el in ipairs(dels) do
      if d ~= e and del == el then
        table.remove(dels,e)
      end
    end
  end

  local link = false
  if #dels > 0 and dtype_ ~= false then
    love.audio.play(love.audio.newSource("sound/" .. sound .. ".wav","static"))
  end

 for d,del in ipairs(dels) do
   if dtype_ ~= false then
     for i,rule in ipairs(rules) do
      if(matches(rule[1], del)) and (rule[2] == "have")then
        local matches = unitreference(del, rule[3])
        for i, z in ipairs(matches) do
          makeobject(del.tilex,del.tiley,z,del.dir)
        end
      end
     end
   end
   if not no_link and ruleexists(del.id, nil, "is", "link") then
     link = true
   end
  removeunit(del)
 end
 if link then
   handledels(objectswithproperty("link"), false, false)
 end
 return {}
end

function canwin()
 local wins = objectswithproperty("win")
 for i,win in ipairs(wins) do
  local onwin = on_plus(win)
  local yous = objectswithproperty("you")
   for y,you in ipairs(yous) do
    for o,here in ipairs(onwin) do
     if(you == here) and ruleexists(here.id, nil ,"is","float") == ruleexists(you.id, nil ,"is","float")then
      return true
     end
    end
   end

 end
 return false
end

function tint_icon(baseimage, bcolor)

  local usedimage = baseimage:clone()
  local iwidth, iheight = usedimage:getWidth(), usedimage:getHeight()
  local ccolor = palettecolors[bcolor[1]][bcolor[2]]
  if not (bcolor[1] == 1 and bcolor[2] == 2) then
    for ix = 0, iwidth - 1 do
      for iy = 0, iheight - 1 do
        local rval, gval, bval, aval = usedimage:getPixel(ix, iy)
        usedimage:setPixel(ix, iy, rval * ccolor[1], gval * ccolor[2], bval * ccolor[3], aval)
      end
    end
  end
  love.window.setIcon(usedimage)

end

function on_plus(thisobj)
  local finalobjs2 = {}
  local xpos1 = thisobj.tilex
    local ypos1 = thisobj.tiley
    for a,b in ipairs(Objects) do
  if(xpos1 == b.tilex) and (ypos1 == b.tiley) then
   table.insert(finalobjs2,b)
  end
end
return finalobjs2
end


function makefile(x,y,dir_)

    if getspritevalues(file_name).nope == nil and not string.sub(file_name,1,15) == "text_text_text_" then
      makeobject(x, y, file_name, dir_)
      return
    end
    obj = {}
    obj.size = 1
    obj.tilex = x
    obj.tiley = y
    obj.x = x*tilesize
    obj.y = y*tilesize
    obj.frame = 0
    obj.name = file_name
    if string.sub(file_name, 1, 5) == "text_" then
      obj.type = 0
    end
    obj.color = {1,2}
    obj.sprite = obj.name
    filecount = filecount + 1
    obj.file = filecount
    table.insert(fileimages, file_img)

    obj.dir = dir_ or "right"

    obj.id = #Objects + 1
    obj.transformable = true


    obj.active = true

    obj.tiling = nil
    obj.orig_x = x
    obj.orig_y = y
    obj.small = 1
    dotiling(obj)

    updatesprite(obj)

    table.insert(Objects,obj)


end
