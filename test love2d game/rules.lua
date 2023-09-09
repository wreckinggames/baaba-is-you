love.filesystem.load("conditions.lua")()

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
function objectswithproperty(property, p)
 local objs1 = {}
 for i,ob in ipairs(rules) do
    if matches(ob[3], property, true) and (ob[2] == "is")then
      for j,job in ipairs(Objects) do

       if matches(ob[1], job) then
          if not isruleblocked(job.id, "is", property) then
            if testcond(ob[4], job.id, p) then
             table.insert(objs1,job)
            end
          end
        end
      end
    end

 end

return objs1
end

function objectswithverb(verb, p)
 local objs1 = {}
 for i,ob in ipairs(rules) do
    if (ob[2] == verb)then
      for j,job in ipairs(Objects) do

       if matches(ob[1], job) then
          if not isruleblocked(job.id, verb, ob[3]) then
            if testcond(ob[4], job.id, p) then
             table.insert(objs1, {
               noun = job.name,
               target = ob[3],
               unit = job
             })
            end
          end
        end
      end
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

function isruleblocked(id,verb,prop)

  local unit = Objects[id]
  for i,ob in ipairs(rules) do
    if ob[4] ~= nil then
      local hasno = false
      local non_no_conds = {}
      for j,k in ipairs(ob[4]) do
        if k[1] == "no" then
          hasno = true
        elseif k[1] ~= "never" then
          table.insert(non_no_conds, k)
        end
      end
      if hasno then
        if matches(ob[3], prop, true) and (ob[2] == verb) and (matches(ob[1], unit)) then
          if testcond(non_no_conds, id) then
            return true
          end
        end
      end
    end
  end
  return false

end
function ruleexists(id, noun,verb,property)

  if isruleblocked(id, verb, property) then
    return false
  end

  local unit = Objects[id]
  for i,ob in ipairs(rules) do

     if matches(ob[3], property, true) and (ob[2] == verb)then

        if matches(ob[1], unit) then
           if testcond(ob[4], id) then
            return true
           end

       end
     end

  end

 return false
end

function rulecount(id, verb,property)

  if isruleblocked(id, verb, property) then
    return false
  end

  count = 0
  for i,ob in ipairs(rules) do

     if matches(ob[3], property, true) and (ob[2] == verb)then

        if matches(ob[1], Objects[id]) then

           if testcond(ob[4], id) then
            count = count + 1
           end

       end
     end

  end

 return count
end

function hasrule(name1,verb1,prop1)
  local finals = {}
  for useless,getrule in ipairs(rules) do
   if matches(getrule[1], name1, true)then
    if(getrule[2] == verb1)then
     if matches(getrule[3], prop1, true)then
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

function letters_to_text(letters, start)

  local str = ""
  local letterobjs = {}

  for i, v in ipairs(letters) do
    if i > start then

      local obj = Objects[v]
      local gsv = getspritevalues(obj.name)

      if gsv.type == 5 then
        str = str .. realname(obj.name)
        table.insert(letterobjs, v)
      else
        break
      end

    end

  end

  return getspritevalues("text_" .. str), letterobjs

end

Parser = {}

function Parser:init()
  self.words = {}
  self.wordsToParse = {}
  self.parsed_rules = {}
  for i, unit in ipairs(Objects) do
    if istext_or_word(unit.name,true) then
      unit._active = false
    end
  end
end

function Parser:makeFirstWords()

  i = 1
  while i < levelx do
    j = 1
    while j < levely do
      local here = allhere(i,j)
      for _, ob in ipairs(here) do
        local name = ob.name
        local type = ob.type

        -- Actual first word checks

        -- Right now, fancy stuff like conditions exist, so uh oh no



        if type == 3 or type == 5 then
          table.insert(self.words, {ob.id, "right"})
          table.insert(self.words, {ob.id, "down"})
        end

        if type == 0 then

          local lft = gettiles("left",ob.tilex,ob.tiley,1)
          local ups = gettiles("up",ob.tilex,ob.tiley,1)

          local lft2 = gettiles("left",ob.tilex,ob.tiley,2)
          local ups2 = gettiles("up",ob.tilex,ob.tiley,2)

          local rt = gettiles("right",ob.tilex,ob.tiley,1)

          local blft, bup = false,false

          local hasand = false
          for i, j in ipairs(lft) do
            if j.type == 3 then
              blft = true
            elseif j.type == 4 or j.type == 7 then
              hasand = true
            end
          end
          for i, j in ipairs(lft2) do
            if hasand and j.type == 0 then
              blft = true
            end
          end
          for i, j in ipairs(ups) do
            if j.type == 3 then
              bup = true
            elseif j.type == 4 or j.type == 7 then
              hasand = true
            end
          end
          for i, j in ipairs(ups2) do
            if hasand and j.type == 0 then
              bup = true
            end
          end

          if not blft then
            table.insert(self.words, {ob.id, "right"})
          end
          if not bup then
            table.insert(self.words, {ob.id, "down"})
          end
        end



      end
      j = j + 1
    end
    i = i + 1
  end

end

function Parser:MakeRules()
  for i, jj in ipairs(self.words) do
    local j = jj[1]
    local thissentence = {}
    table.insert(thissentence, j)
    local checktile = {":"}
    local ind = 1


      while #checktile ~= 0 do
        checktile = gettiles(jj[2],Objects[j].tilex,Objects[j].tiley,ind)
        local found = false
        for k,l in ipairs(checktile) do
          if istext_or_word(l.name) then
            table.insert(thissentence, l.id)
            found = true
            break
          end
        end
        if not found then
          break
        end
        ind = ind + 1
      end

      if #thissentence > 2 then
        table.insert(self.wordsToParse, thissentence)
      end
    end

end

function Parser:ParseRules()

  for i, j in ipairs(self.wordsToParse) do
    local stage = -1
    local stop = false

    local rule_targets = {}

    local rule_subjects = {}

    local rule_conds = {}

    local id_targets = {}
    local id_subjects = {}
    local id_conds = {}

    local fixTHIS = false
    local ids = {}

    local pass = false
    local letterpass = 0
    local thisletterword = ""
    local thisletterids = {}

    for ind, thing in ipairs(j) do

      local obj = Objects[thing]
      local name = realname(obj.name)
      local type = obj.type

      local next = Objects[j[ind + 1]]

      -- handle letters
      if type == 5 and not (letterpass > 0) then
        thisletterword = thisletterword .. name
        table.insert(thisletterids, thing)
        letterpass = 1
        local found = false

        local gsv = getspritevalues("text_" .. thisletterword)

        if not gsv.nope and gsv.type ~= 5 then
          found = true
          name = thisletterword
          type = gsv.type
          letterpass = 0
          for ____, letterid in ipairs(thisletterids) do
            table.insert(ids, letterid)
          end
          thisletterids = {}
          thisletterword = ""
        end

        if not found and next ~= nil and next.type ~= 5 then
          stop = true
        end

      end
--[[      if next ~= nil and next.type ~= 5 and thisletterword ~= "" then
        local found = false
        for i, o in ipairs(images) do
          for n, m in ipairs(o) do
            if m == "text_" .. thisletterword and string.len(thisletterword) > 1 then
              for k, l in ipairs(thisletterids) do
                table.insert(ids, l)
              end
              local p = getspritevalues(m)
              type = p.type
              name = realname(m)
              found = true
              pass = false
              break
            end
          end
        end
        if not found then
          stop = true
        end
        thisletterword = ""
      end]]

      if pass then
        pass = false
        table.insert(ids, thing)
      -- Lonely
    elseif letterpass > 0 then
      letterpass = letterpass - 1
    elseif(stage == -1) then
        if type == 0 then
          table.insert(ids, thing)
          table.insert(rule_targets, name)
          stage = 1
        elseif type == 3 then
          table.insert(rule_conds, {name, {}})
          table.insert(ids, thing)
          stage = 0
        else
          stop = true
        end
      -- X
      elseif (stage == 0) then
        if type == 0 then
          table.insert(ids, thing)
          table.insert(rule_targets, name)
          stage = 1
        else
          stop = true
        end
      -- IS X / X AND Y IS Z / x ON Y IS Z
      elseif (stage == 1) then
        if type == 1 then

          if next == nil then

            stop = true

          else

            local accepted_args = getspritevalues("text_" .. name).args or {0}
            local success = false
            local asletter = false
            local lettername = ""
            for i, z in ipairs(accepted_args) do

              if (next.type == z) then
                success = true
                break
              elseif (next.type == 5) then
                local lettergsv, letterids = letters_to_text(j, ind)
                if lettergsv.type == z then
                  success = true
                  asletter = letterids
                  lettername = realname(lettergsv.name)
                  break
                end
              end

            end

            if success then
              table.insert(ids, thing)
              if asletter == false then
                table.insert(ids, next.id)
                table.insert(rule_subjects, {name, realname(next.name)})
              else
                for a, b in ipairs(asletter) do
                  table.insert(ids, b)
                end
                letterpass = #asletter - 1
                table.insert(rule_subjects, {name, lettername})
              end

              pass = true
              if fixTHIS ~= false then
                table.insert(ids, fixTHIS)
                fixTHIS = false
              end
              stage = 2

            else

              stop = true

            end

          end


        elseif type == 4 then
          table.insert(ids, thing)
          stage = 0
        elseif type == 7 and next ~= nil then

          local accepted_args = getspritevalues("text_" .. name).args or {0}
          local success = false
          local asletter = false
          local lettername = ""
          for i, z in ipairs(accepted_args) do

            if (next.type == z) then
              success = true
              break
            elseif (next.type == 5) then
              local lettergsv, letterids = letters_to_text(j, ind)
              if lettergsv.type == z then
                success = true
                asletter = letterids
                lettername = realname(lettergsv.name)
                break
              end
            end

          end

          if success then
            table.insert(ids, thing)
            if asletter == false then
              table.insert(ids, next.id)
              table.insert(rule_conds, {name, {realname(next.name)}})
            else
              for a, b in ipairs(asletter) do
                table.insert(ids, b)
              end
              letterpass = #asletter - 1
              table.insert(rule_conds, {name, {lettername}})
            end

            pass = true

          else

            stop = true

          end
        else
          stop = true
        end
      -- IS Y AND HAVE Z / IS Y AND Z
      elseif (stage == 2) then

        if next ~= nil then

          if type == 4 then



              if next.type == 1 then

                fixTHIS = thing
                stage = 1

              else

                local last_rule_subject = rule_subjects[#rule_subjects][1]
                local accepted_args = getspritevalues("text_" .. last_rule_subject).args or {0}
                local success = false
                local asletter = false
                local lettername = ""

                for i, z in ipairs(accepted_args) do

                  if (next.type == z) then
                    success = true
                    break
                  elseif (next.type == 5) then
                    local lettergsv, letterids = letters_to_text(j, ind)
                    if lettergsv.type == z then
                      success = true
                      asletter = letterids
                      lettername = realname(lettergsv.name)
                      break
                    end
                  end

                end

                if success then
                  table.insert(ids, thing)
                  if asletter == false then
                    table.insert(ids, next.id)
                    table.insert(rule_subjects, {last_rule_subject, realname(next.name)})
                  else
                    for a, b in ipairs(asletter) do
                      table.insert(ids, b)
                    end
                    letterpass = #asletter - 1
                    table.insert(rule_subjects, {last_rule_subject, lettername})
                  end

                  pass = true


                else

                  stop = true

                end

              end



          else
            stop = true
          end
        else
          stop = true
        end
      end

      if ind == #j then
        stop = true
      end

      if stop then
        debug = ""
        local made_sentence = false
        for m, n in ipairs(rule_targets) do
          for i, j in ipairs(rule_subjects) do
            debug = debug .. rule_targets[1] .. " " .. j[1] .. " " .. j[2] .. " "
              table.insert(self.parsed_rules, {n,j[1],j[2],rule_conds,ids})
              made_sentence = true
          end
        end
        if made_sentence then
        for k,l in ipairs(ids) do
          Objects[l]._active = true
        end
      end

        break


      end

    end
  end
end

function Parser:AddRules()
  local blockedrules = {}
  for i, j in ipairs(self.parsed_rules) do
    table.insert(rules, j)
    for k, cond in ipairs(j[4]) do
      if cond[1] == "no" then
        table.insert(blockedrules, j)
      end
    end
  end

  if #blockedrules > 0 then
    for i, j in ipairs(rules) do
      for k, l in ipairs(blockedrules) do

        local valid = true
        if j[4] ~= nil then
          for m, cond in ipairs(j[4]) do
            if cond[1] == "no" then

              valid = false
              break
            end
          end
        end
        if valid then
          if j[1] == l[1] and j[2] == l[2] and j[3] == l[3] then
            if rules[i][4] ~= nil then
              table.insert(rules[i][4], {"never", {}})
            else
              rules[i][4] = {"never", {}}
            end
            if j[5] ~= nil then
              for c, d in ipairs(j[5]) do
                local textobj = Objects[d]
                textobj.blocked = true
              end
            end

            break
          end
        end
      end
    end
  end

end

function Parser:Debug()
  DBG = "Firstwords: " .. tostring(#self.words) .. "\n" .. "sentences to parse: " .. tostring(#self.wordsToParse) .. "\nParsed sentences: " .. tostring(#self.parsed_rules) .. "\nList of parsed sentences:"
  for i, j in ipairs(self.parsed_rules) do
    DBG = "\n" .. DBG .. j[1] .. " " .. j[2] .. " " .. j[3] .. " "
    for k, l in ipairs(j[4]) do
      DBG = DBG .. l[1] .. " "
      for m, n in ipairs(l[2]) do
        DBG = DBG .. n .. " & "
      end
    end
    DBG = DBG .. "\n"

  end

  DBG = DBG .. "Read:\n"
  for i, l in ipairs(self.wordsToParse) do
      for k, j in ipairs(l) do
          DBG = "\n" .. DBG .. realname(Objects[j].name) .. " "
      end
    DBG = DBG .. "\n"

  end
end

--[[
TODO:
write a real parsing system [DONE]
add conditions [DONE]

add check to remove rules if all used IDs are contained in another so that making BAABA ON KEEKE AND FLAG IS YOU is easier
]]
