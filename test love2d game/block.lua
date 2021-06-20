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
  ingroup = {}
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
  local groups = objectswithproperty("group")
  for i,group in ipairs(groups) do
   ingroup[group.name] = "group"
  end
  for a,b in ipairs(Objects) do
  if(b.rule[1] == "icon")then
    if love.filesystem.getInfo("sprite/" .. b.rule[3] .. ".png",{}) ~= nil then
   love.window.setIcon(love.image.newImageData("sprite/" .. b.rule[3] .. ".png"))
   currenticon = b.rule[3]
   end
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
 for f,g in ipairs(images) do
    for a,b in ipairs(g) do
  local isother = objectswithproperty(b)
  for i,c in ipairs(isother) do
  if(c.transformable == true) then
  c.name=b
  c.meta = 0
  c.sprite=b
  c.color=getspritevalues(b).color
  c.rule = {"","",""}
  end
  end
end
 end
  
 local iswhat = objectswithproperty("?")
 for a,b in ipairs(iswhat)do
   love.system.openURL("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
 end
  
 local istextify = objectswithproperty("meta")
  for i,c in ipairs(istextify) do
    if c.transformable then
    c.meta = 1
    c.name = "text_" .. c.name
    if not(string.sub(c.name,1,10) == "text_text_")then
    c.sprite = c.name
        c.meta = 0
      end
    end
  end
  local istextify2 = objectswithproperty("text")
   for i,c in ipairs(istextify2) do
     if c.transformable then
     c.meta = 1
     c.name = "text_" .. c.name
     if not(string.sub(c.name,1,10) == "text_text_")then
     c.sprite = c.name
         c.meta = 0
       end
     end
   end
 local dels = {}
 local ishot = objectswithproperty("hot")
  for i,hotunit in ipairs(ishot) do
     local melts = objectswithproperty("melt")
       for m,melt in ipairs(melts) do
      local onmelt = on(melt)
      local hotmelt = false
      for n,onm in ipairs(onmelt) do
       if(onm == hotunit)then
        hotmelt = true
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
    table.insert(dels,sinker)
     for o,here in ipairs(onhere) do
      table.insert(dels,here)
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
         if(here == door)then
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
   if ruleexists(here.name,"is","you") or (ruleexists("text","is","you") and istext_or_word(here.name,true)) then
    table.insert(dels,here)
   end
  end
  end
   dels = handledels(dels)
 local wins = objectswithproperty("win")
          winning = true

end
function handledels(dels)
 for d,del in ipairs(dels) do
   love.audio.play(love.audio.newSource("sound/destroy.wav","static"))
   for i,unit in ipairs(Objects) do
    if(unit.rule[1] == del.name) and (unit.rule[2] == "have")then
      if(unit.rule[3] ~= "text")then
        makeobject(del.tilex,del.tiley,unit.rule[3],del.dir)
      else
        makeobject(del.tilex,del.tiley,"text_" .. unit.rule[1],del.dir)
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
     if(you == here)then
      return true
     end
    end
   end

 end
 return false
end
