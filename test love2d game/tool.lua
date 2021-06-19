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
  local noword = noword_ or false
  if(noword == false)then
   return string.sub(name,1,5) == "text_" or ruleexists(name,"is","word")
  else
   return string.sub(name,1,5) == "text_"
  end
end
