love.filesystem.load("rules.lua")()
love.filesystem.load("main.lua")()
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
    color = {5,1}
  }
}
local dirblocks = {
  "up"
}
local dir
function findproperties()
  winning = true
  for i,c in ipairs(Objects) do
    c.color = getspritevalues(c.sprite).color
    c.transformable = true
    c.customcolor = false
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

  for a,b in ipairs(rules) do
    if(b[1] == "icon")then
      if love.filesystem.getInfo("sprite/" .. b[3] .. ".png",{}) ~= nil then
        love.window.setIcon(love.image.newImageData("sprite/" .. b[3] .. ".png"))
        currenticon = b[3]
      end
    end
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

  local issmall = objectswithproperty("small")
  for i,c in ipairs(issmall) do
    c.size = c.size / 2
  end

  local istextify2 = objectswithproperty("text")
   for i,c in ipairs(istextify2) do
     if c.transformable then
       makeobject(c.tilex,c.tiley,"text_" .. c.name,c.dir)

       handledels({c})

     end
   end

   local istextify = objectswithproperty("meta")
    for i,c in ipairs(istextify) do
      if c.transformable then


        makeobject(c.tilex,c.tiley,"text_" .. c.name,c.dir)


        handledels({c})

      end
    end

 for f,g in ipairs(images) do
    for a,b in ipairs(g) do
  local isother = objectswithproperty(b)
  for i,c in ipairs(isother) do
  if(c.transformable == true) then
  c.name=b
  c.sprite=b
  c.color=getspritevalues(b).color
  c.type = getspritevalues(b).type
  end
  end
end
 end
 local iswhat = objectswithproperty("what")
 for a,b in ipairs(iswhat)do
   love.system.openURL("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
 end
  for i, j in ipairs(Objects) do
    j.size = 1
  end
  local issmall = objectswithproperty("small")
  for i,c in ipairs(issmall) do
    c.size = c.size / 2
  end
 local dels = {}
 local ishot = objectswithproperty("hot")
  for i,hotunit in ipairs(ishot) do

     local melts = objectswithproperty("melt")
       for m,melt in ipairs(melts) do
         local hotmelt = false
         local onmelt = on(melt)
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
 dels = handledels(dels)
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

 for i,direct in ipairs(dirblocks)do
  local isdir = objectswithproperty(direct)
  for j,c in ipairs(isdir)do
   c.dir = direct
  end
 end
 
 dels = handledels(dels)


 local isopen = objectswithproperty("open")
  for i,key in ipairs(isopen) do
   local onhere = on(key)
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
  local onhere = on(c)
  for h,here in ipairs(onhere) do
   if ruleexists(here.id,here.name,"is","you") and ruleexists(here.id, nil ,"is","float") == ruleexists(c.id, nil ,"is","float") then
    table.insert(dels,here)
   end
  end
  end
   dels = handledels(dels)
 local wins = objectswithproperty("win")
          winning = true

end
function handledels(dels)

  for d, del in ipairs(dels) do
    for e, el in ipairs(dels) do
      if d ~= e and del == el then
        table.remove(dels,e)
      end
    end
  end

 for d,del in ipairs(dels) do
   love.audio.play(love.audio.newSource("sound/destroy.wav","static"))
   for i,rule in ipairs(rules) do
    if(rule[1] == del.name) and (rule[2] == "have")then
      if(rule[3] ~= "text")then
        makeobject(del.tilex,del.tiley,rule[3],del.dir)
      else
        makeobject(del.tilex,del.tiley,"text_" .. rule[1],del.dir)
      end
    end
   end
  removeunit(del)
 end
 return {}
end
function canwin()
 local wins = objectswithproperty("win")
 for i,win in ipairs(wins) do
  local onwin = on(win)
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
