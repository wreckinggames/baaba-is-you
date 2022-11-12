function newturn()
  for i,playerkey in ipairs(keys) do
   if love.keyboard.isDown(playerkey) then
    return true
   end
  end
end
function realname(name)
if(string.sub(name,1,5) == "text_")then
return string.sub(name,6,string.len(name))
end
return name
end
function istext_or_word(name,noword_)
  -- What

  if name == nil then
    return false
  end
  local noword = noword_ or false
  if(noword == false)then
   return string.sub(name,1,5) == "text_"
  else
   return string.sub(name,1,5) == "text_"
  end
end


function unitingroup(group, id)
  if ingroup[id] == nil then
    return false
  end
  for i, j in pairs(ingroup[id]) do
    if j == group then return true end
  end
  return false
end

function revdir(d)
  if d == "right" then return "left" end
  if d == "left" then return "right" end
  if d == "up" then return "down" end
  if d == "down" then return "up" end
end

function matches(word, unit, justname_)
  local justname = justname_ or false
  local name = ""
  local id = -15
  if not justname then
    name = unit.name
    id = unit.id
  else
    name = unit
  end



  if word == name then
    return true
  end

  if word == "text" and istext_or_word(name, 1) then
    return true
  end

  if word == "clipboard" and love.system.getClipboardText() == name then
    return true
  end

  if word == "group"  and unitingroup("group", id) then
    return true
  end

  if word == "icon" and name == currenticon then
    return true
  end

  if word == "this" and name == "text_this" then
    return true
  end

  if word == "all" and not istext_or_word(name, 1) then
    return true
  end

  return false


end

function float(ob1,ob2)
  local float1 = ruleexists(ob1, Objects[ob1].name ,"is","float")
  local float2 = ruleexists(ob2, Objects[ob2].name ,"is","float")
  return float1 == float2
end
