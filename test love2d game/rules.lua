function gettiles(directiontype,xpos,ypos,tileamount)
  local finalobjects = {}
 for e,f in ipairs(Objects) do
   local oxpos = math.floor(f.x/tilesize)
   local oypos = math.floor(f.y/tilesize)
   if(oxpos-xpos == tileamount) and (oypos == ypos) and (directiontype == "right") then
    table.insert(finalobjects,f)
   end
   if(oxpos-xpos == -tileamount) and (oypos == ypos) and (directiontype == "left") then
    table.insert(finalobjects,f)
   end
   if(oypos-ypos == tileamount) and (oxpos == xpos) and (directiontype == "down") then
    table.insert(finalobjects,f)
   end
   if(oypos-ypos == -tileamount) and (oxpos == xpos) and (directiontype == "up") then
    table.insert(finalobjects,f)
   end
 end
 return finalobjects
end
function objectswithproperty(property)
 local objs1 = {}
 for i,ob in ipairs(Objects) do
   if((ob.rule[3] == property) or ((ob.rule[3] == "clipboard") and (love.system.getClipboardText() == property))) and (ob.rule[2] == "is")then
     for j,job in ipairs(Objects) do
     if(job.name == ob.rule[1]) or (ingroup[job.name] == ob.rule[1]) or ((string.sub(job.name,1,5)=="text_") and (ob.rule[1] == "text")) or ((string.sub(job.name,1,5)~="text_") and (ob.rule[1] == "all"))  or ((job.name == currenticon) and (ob.rule[1] == "icon")) or ((ob.rule[1] == "clipboard" ) and (job.name == love.system.getClipboardText())) then
       table.insert(objs1,job)
     end
   end
  --   love.window.setPosition(45, 45)
   end
 end
   for i,baserule in ipairs(baserules) do
     if(baserule[3] == property)then
       for j,job in ipairs(Objects) do

       if(job.name == baserule[1]) or ((string.sub(job.name,1,5)=="text_") and (baserule[1] == "text"))then
         table.insert(objs1,job)
       end
     end
    --   love.window.setPosition(45, 45)
     end
 end
return objs1
end
function on(thisobj)
  local finalobjs2 = {}
  local xpos1 = thisobj.x
    local ypos1 = thisobj.y
    for a,b in ipairs(Objects) do
  if(xpos1 == b.x) and (ypos1 == b.y) then
    if not (b==thisobj)then
   table.insert(finalobjs2,b)
    end
  end
end
return finalobjs2
end
function ison(thisobj,otherobj)
  local finalobjs2 = {}
  local xpos1 = thisobj.tilex
  local ypos1 = thisobj.tiley
  local xpos2 = otherobj.tilex
  local ypos2 = otherobj.tiley
  return (xpos1 == xpos2) and (ypos1 == ypos2)
end
function ruleexists(noun,verb,property)
 for i,k in ipairs(Objects) do
  if(k.rule[1] == noun) and (k.rule[2] == verb) and (k.rule[3] == property)then
  return true
  end
end
  return false
end
function find_sentence(x,y,dir)
 local continue = true
 local i = 0
 local texts = {}
 local unitids = {}
 while continue do
  i = i + 1
  local prevtiles = gettiles(dir,x,y,i-1)
  local tiles = gettiles(dir,x,y,i)
  if #tiles == 0 then
    continue = false
  end
  local textsfound = false
  for j,tile in ipairs(tiles) do
   if istext_or_word(tile.name) then
     textfound = true
   end
  end
  if textfound then
    for i,tile in ipairs(tiles)do
     table.insert(texts,{tile.name,tile.id,getspritevalues(tile.name).type})
    end
  else
    continue = false
  end
 end
 return texts
end
function writerules()
  local rulestowrite = {}
 for i,obj in ipairs(Objects) do
  if(#obj.rule > 2)then
    table.insert(rulestowrite,obj.rule[1] .. " " .. obj.rule[2] .. " " .. obj.rule[3])
  end
 end
  for i,wrule in ipairs(rulestowrite) do
 love.graphics.print(wrule, 10, 60*i)
  end
end
function hasrule(name1,verb1,s)
  local finals = {}
  for useless,getrule in ipairs(allrules) do
   if(getrule[1] == name1)then
    if(getrule[2] == verb1)then
     if(getrule[3] == s)then
        return true
     end
    end
   end
  end
  return false
end
function getletters(x,y,dir,flip_)
 local k = true
 local i = 0
 local finalletters = {}
 local try = ""
 local flip = flip_ or false
 while k == true do

  i = i + 1
  local tile = gettiles(dir,x,y,i)
  if(#tile < 1)then
   k = false
  else
   if(getspritevalues(tile[1].name).type == 5)then

     table.insert(finalletters,tile[1])
   else
   k = false
   end
  end
 end
 if flip then
--  finalletters = ReverseTable(finalletters)
 end
 for i,letter in ipairs(finalletters)do
   try = try .. realname(letter.name)
   to = try
   for j,obj in ipairs(objectValues)do
    if((obj.name == try) and not flip)then
      return try
    end
    to = string.reverse(try)
    if((obj.name == string.reverse(try)) and flip)then
      return string.reverse(try)
    end
   end
 end
return ""


end

--[[
to do:
write a real parsing system
add conditions
add shift
make levels
]]
