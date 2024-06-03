love.filesystem.load("border.lua")()
love.filesystem.load("menu.lua")()
love.filesystem.load("levels.lua")()

AllLevels = {}
rules = {}
active = false

local enabledebug = false
 winning = false
 local redraw_objects = true



function love.load()
  current_os = love.system.getOS()
  --love.audio.play(love.audio.newSource("sound/baaba.wav","static"))
  music = love.audio.newSource("sound/baaba.wav","static")
  music:setLooping(true)
  music:play()
  music:setVolume(0.3)

  leveltree = {}
  gamestate = "menu"
  levelx = 24
  levely = 14
  wintimer = -1
  x_offset = 0
  y_offset = 0
  wewinning = false
   love.graphics.setDefaultFilter("nearest", "nearest", 1)
   love.window.setMode(1280,820,{resizable = true})
  DBG = ""
  draw = true
  done = false
  move = false
  writethese = {}
  hideui = true
  levelmusic = 1
  musiclist = {"default", "baaba", "submar", "the song ever", "burning", "nothing", "demo", "flyly", "maptemp", "rocket", "whattimeisnt"}
  Palleteimage = love.graphics.newImage("sprite/testpalette.png")
  textmeta = love.graphics.newImage("sprite/textMeta.png")
  blockerimg = love.graphics.newImage("sprite/blocker.png")
  miscsprites = {}
  miscsprites["play"] = love.graphics.newImage("graphics/playbutton.png")
  miscsprites["flag"] = love.graphics.newImage("sprite/flag.png")
  miscsprites["note"] = love.graphics.newImage("graphics/note.png")
  miscsprites["logo"] = love.graphics.newImage("graphics/baaba_logo.png")
  miscsprites["dots"] = love.graphics.newImage("graphics/uhh.png")
  all_palettes = {"testpalette", "brighter", "AAAAA", "table", "spaceeee", "oooh", "orang", "reswapped", "burning", "yelly","reddy"}
  palette_id = 1
  loop_detector = 0
  theloop = false

  stupid_music_timer = -1
  the_level_is_gone = false
  --leveldata = "testaaa={"
  heldtile = ""
  helddir = "right"
  changedicon = {"",false}
  to = false
  tilesize = 48
  changecolor = {0.5,0.5,0.5}
 Objects = {}
 ingroup = {}
 MovingObjects = {}
 rules = {}
 string_prop_list = {}
 currenticon = "baaba"


 changeicon = love.window.setIcon(love.image.newImageData("sprite/baaba-right.png"))
 keys = {"a","d","w","s","space","left","right","up","down","z"}
images=
{{"baaba","stone","tile","text_tile","text_baaba","text_stone","text_is","text_you","text_meta","text_this","text_red","text_all","text_text","text_move","text_push","text_icon","text_weak","text_open","text_shut","text_stop","keeke","flag","wall"},{"text_keeke","text_flag","text_wall","whater","text_whater","text_sink","lavaaa","text_lavaaa","text_hot","text_melt","text_fofofo","fofofo","text_key","key","text_door","door","text_group","clock","text_clock","text_have","text_win","text_defeat",
"text_clipboard"},{"text_orange","text_skull","skull","level","text_level","text_ice","ice","text_what","pumpkin","text_pumpkin","text_n'", "text_lonely","jelly","text_jelly", "text_often", "text_seldom", "text_powered", "text_power", "text_on", "box", "text_box", "bug","text_bug"},
{ "square", "text_square",
 "circle", "text_circle", "triangle", "text_triangle", "text_fear","grass","text_grass","grubble","text_grubble","rubble","text_rubble", "scribble", "text_scribble","hex","text_hex","pentagon","text_pentagon","text_float", "cake","text_cake","the m"},{"text_the m", "jijiji",
 "text_jijiji","ite","text_ite","text_small","crab","text_crab","robot","text_robot","brick","text_brick","hedge","text_hedge","block","text_block","pa","text_pa","belt","text_belt","fungus","text_fungus","bubble"},{"text_bubble","pillar","text_pillar","flower","text_flower","algae","text_algae","love",
 "text_love","star","text_star","baadbad","text_baadbad","bolt","text_bolt","cog","text_cog","foliage","text_foliage","fruit","text_fruit","ghost","text_ghost"},{"husk","text_husk","leaf","text_leaf","pipe","text_pipe","reed","text_reed","statue","text_statue","tree","text_tree","text_active","text_place","text_placed","text_goal","text_target","goal","target","button","text_button","text_bird","bird"},{"bat",
   "text_bat","sun","text_sun","cliff","text_cliff","fence","text_fence","rose","text_rose","cloud","text_cloud","rocket","text_rocket","dust","text_dust", "text_up", "text_yellow", "text_gellow", "text_green", "text_blue", "text_purple", "text_burn"
 }, {"text_only", "moon","text_moon", "bog", "text_bog", "stump", "text_stump", "sj7ll", "text_sj7ll", "text_make", "text_write", "pants", "text_pants", "text_unmeta", "text_hop", "text_sleep", "bee", "text_bee", "shirt", "text_shirt", "arrow", "text_arrow", "text_you2"},
{"blossom", "text_blossom", "calendar", "text_calendar", "planet", "text_planet", "card", "text_card", "jar", "text_jar", "satelite", "text_satelite", "text_collect", "text_select", "pixel", "text_pixel","text_auto","text_arc","arc","text_dot","dot","text_guy","guy"},
{"text_cursor","cursor","text_gburble","gburble","text_old", "text_no","lever","text_lever","line","text_line","text_still","text_fall","wug","text_wug", "text_near", "text_above", "text_below", "fiiiiire", "text_fiiiiire","fish","text_fish","bell","text_bell"},
{"orb","text_orb","fan","text_fan","gem","text_gem","bucket","text_bucket","turtle","text_turtle","lim","text_lim","bananas","text_bananas","text_eat", "text_a", "text_b", "text_c", "text_d","text_e","text_f","text_g","text_h"},
{"text_i","text_j","text_k","text_l","text_m","text_n","text_o","text_p","text_r","text_s","text_t","text_u","text_v","text_w","text_x","text_y","text_z", "text_pull", "eye", "text_eye", "all", "text", "group"},
{ "clipboard", "icon", "this","monster","text_monster","monitor","text_monitor","question","text_question","text_uncopy","text_textof","text_but","mountain","text_mountain","correct","text_correct","horse","text_horse","battery","text_battery","staple","text_staple", "text_upsilon"},
{"incorrect", "text_incorrect","text_heavy","text_oneway","text_link","text_shift","text_reset","text_set","text_big","text_random", "axe","text_axe","pick","text_pick","sword","text_sword","log","text_log","text_feeling","text_without","text_starts","text_contains","text_ends"},
{"text_path","text_left","text_down","text_right","text_0","text_1","text_2","text_3","text_4","text_5","text_6","text_7","text_8","text_9","hand","text_hand","sqrt9","text_sqrt9","text_tele", "text_file","mathdotsinxword","text_mathdotsinxword","text_dollars"},
{"3dollars","text_3dollars","text_pink","text_ba","ring","text_ring","text_ch","chair","text_chair","lemon","text_lemon","prize","text_prize","car","text_car","text_xnopyt","text_hide","jsdhgous","text_jsdhgous","seastar","text_seastar","lock","text_lock"},
{"cucucu","text_cucucu","wheel","text_wheel","file","choose","text_choose","abba","text_abba","text_none","text_yes","text_the", "stack", "text_stack"} }

require "ui"
require "tool"
require "values"
require "rules"
require "block"
require "move"
require "palette"
require "editor"
require "undo"

  monitor_things = {
    burn = "burn",
    collect = "collect",
    hot = "burn",
    move = "move",
    you = "you",
    you2 = "you",
    win = "win",
    up = "up",
    what = "rick",
    make = "upload",
    have = "upload",
    select = "select",
    still = "off",
    defeat = "crash",
    red = "color",
    orange = "color",
    yellow = "color",
    green = "color",
    gellow = "color",
    blue = "color",
    purple = "color",
    pink = "color",
    reset = "off",
    sleep = "off"
  }

make_tabs()

baserules = {}

table.insert(baserules,{"text","is","push"})
table.insert(baserules,{"level","is","stop"})
table.insert(baserules,{"cursor","is","select"})
table.insert(baserules,{"line","is","path"})
--table.insert(baserules,{"57","is","defeat",{}})
love.keyboard.setKeyRepeat(true)
menu_load()
make_prop_list()
end

levelhandle = nil
function passturn()

  levelhandle = nil

  if #undolist > 0 and #undolist[#undolist] == 0 then
    table.remove(undolist, #undolist)
  end

  table.insert(undolist, {})
  loop_detector = 0
  the_level_is_gone = false

  active = false

   for i,unit in ipairs(Objects) do
     local gsv = getspritevalues(unit.name).rotate
     if(gsv == 4) or (gsv == 6) and type(unit.dir) == "string" then
       unit.sprite =  unit.name .. "-" .. unit.dir
       --unit.color = getspritevalues(unit.name).color
     end
     --[[unit.tilex = math.floor(unit.x/tilesize)
     unit.tiley = math.floor(unit.y/tilesize)]]
     unit.small = 1
     unit.sleep = false
     unit.hide = nil
     unit.old = false
     unit.float = false
     unit.blocked = false
     unit.from_x = unit.x
     unit.from_y = unit.y
     unit.to_x = unit.x
     unit.to_y = unit.y
   end

   chooserule = ""


   local cb = love.system.getClipboardText()
   for a, b in ipairs(rules) do
     if b[3] == "uncopy" and (matches(b[1], cb, true) or (matches(b[1], "text_" .. cb, true) and is_prop(cb))) then
       love.system.setClipboardText("oops!")
     end
   end

   local issmall = objectswithproperty("small")
   for i,c in ipairs(issmall) do
     c.small = c.small / 2
     c.size = c.size / 2
   end

   local isbig = objectswithproperty("big")
   for i,c in ipairs(isbig) do
     c.small = c.small * 2
     c.size = c.size * 2
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

    testmove()
    parse_text()

    for i, j in ipairs(Objects) do
      j.small = 1
    end
    local issmall = objectswithproperty("small")
    for i,c in ipairs(issmall) do
      c.small = c.small / 2
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

    findproperties()


    for i, j in ipairs(Objects) do
      dotiling(j)
      updatesprite(j)
    end


    if the_level_is_gone then
      destroylevel("LOOP!!!")
      return
    end

    parse_text()
    local rulesound = false
    local unrulesound = false
    for a, b in ipairs(Objects) do
      if b.oldactive == false and b._active == true then
        rulesound = true
      end

      if b.oldactive == true and b._active == false then
        unrulesound = true
      end

      b.oldactive = b._active
    end

    if rulesound then
      love.audio.play(love.audio.newSource("sound/rulemade.wav","static"))
    elseif unrulesound then
      love.audio.play(love.audio.newSource("sound/unrule.wav","static"))
    end

    if #getplayers() == 0 then
      music:pause()
    elseif not music:isPlaying() then
      music:play()
    end

    wewinning = canwin()
    if wewinning then
      wintimer = 5
      music:pause()
      love.audio.play(love.audio.newSource("sound/victoryr.wav","static"))
      if menu_state ~= "editor_test" then
        if (love.filesystem.getInfo("progress/levels.txt") == nil) then
          love.filesystem.write("progress/levels.txt","cleared=" .. levelname .. "\n")
        elseif not levelcompleted(levelname) then
          love.filesystem.append("progress/levels.txt","cleared=" .. levelname .. "\n")
        end
      end
      return
    end
end


function dotiling(j)

  j.tiling = nil
    if getspritevalues(j.name).rotate == 5 then


      local tileval = 0
      local l = {{1, 0}, {0, -1}, {-1, 0}, {0, 1}}
      local mult = 1

      for k, m in ipairs(l) do
        for n, o in ipairs(alltilehere(j.tilex + m[1], j.tiley + m[2])) do
          if o.name == j.name or o.name == "level" then
            tileval = tileval + mult
            break
          end
        end
        mult = mult * 2
      end

      j.tiling = tileval

    end

end


function alltilehere(x,y)
    local finalobjs3 = {}
      for a,b in ipairs(Objects) do
    if(x == b.tilex) and (y == b.tiley) then
     table.insert(finalobjs3,b)
    end
  end
  return finalobjs3
end

function alltilehere_editor(x,y)
    local finalobjs3 = {}
      for a,b in ipairs(editor_curr_objects) do
    if(x == b.tilex) and (y == b.tiley) then
     table.insert(finalobjs3,b)
    end
  end
  return finalobjs3
end

candoturn = false

function love.keypressed(key, scancode, isrepeat)
--function love.update(key, scancode, isrepeat)

if(editlevelname == false)then


  if ineditor then
    --[[
    if(key == "x")then
   saveleveldata(levelname)
    end
    if(key == "l")then
      loadleveldata(levelname)
    end
    if(key == "j")then
     loadleveldata("maingame/baaba is you.leevel")

   end]] --removed these hotkeys for now because they are useless!!
    if key == "p" then
      DBG = palette

      palette_id = (palette_id) % (#all_palettes) + 1
      loadPalette(all_palettes[palette_id])

      initui()
    end
    if key == "n" then
      levelmusic = (levelmusic) % (#musiclist) + 1
      playmusic(musiclist[levelmusic])
      stupid_music_timer = 5
    end
    if key == "tab" then
      hideui = not hideui
    end
    if key == "=" then
      levelx = levelx + 1
      levely = levely + 1
    end
    if key == "-" then
      levelx = levelx - 1
      levely = levely - 1
    end
    if key == "s" then
      levely = levely + 1
    end
    if key == "w" then
      levely = levely - 1
    end
    if key == "a" then
      levelx = levelx - 1
    end
    if key == "d" then
      levelx = levelx + 1
    end
    if (key == "-" or key == "w" or key == "a") then
      --didnt work
    end
    if (key == "up" or key == "down" or key == "left" or key == "right") then
      helddir = key
    end
    if key == "o" then
      local heldobj = heldtile .. ""
      if string.sub(heldobj, 1, 5) == "text_" then
        heldobj = string.sub(heldobj, 6)
      end
      --DBG = heldobj
      if not getspritevalues(heldobj).nope then
        if heldobj ~= heldtile then
          heldtile = heldobj
        else
          heldtile = "text_" .. heldtile
        end
      end

    end
    if key == "i" then
      for i5,c5 in ipairs(editor_curr_objects) do
       if(dist(c5.x+tilesize/2,c5.y+tilesize/2,love.mouse.getX(),love.mouse.getY()) < tilesize/1.5) then
       --c5.active = false


           heldtile = c5.name
           break

       end
      end
    end

  else
    if (key == "r") then

      if gamestate == "editor_test" then
        Objects = {}
        wewinning = false
        theloop = false
        loadlevel()
      elseif gamestate == "playing" then
        Objects = {}
        loadlevel()
        gotogame()

        x_offset = (love.graphics.getWidth() - levelx * tilesize) / 2
        y_offset = (love.graphics.getHeight() - (levely + 1) * tilesize) / 2
      end
    end
    if key == "c" then
      dochoose()
    end
  end

--this doesnt work dont try it
  --if key == "rctrl" then
      --debug.debug()
   --end

end
  if (editlevelname == true) then
    if (key == "backspace") and string.len(current_textinput) > 0 then
     current_textinput = string.sub(current_textinput, 1, string.len(current_textinput) - 1)
    end
    if (key == "return") then
      dolevelname()
    end
  end

end
function updatesprite(c)

  if c.file ~= nil then
    c.sprite = love.graphics.newImage(fileimages[c.file])
    return
    --return fileimages[c.file]
  end

  local gsv = getspritevalues(c.name).rotate
  local csprite = c.name
  if c.old and love.filesystem.getInfo("sprite/old/" .. csprite .. ".png",{}) ~= nil then
    csprite = "old/" .. csprite
  else
    if((gsv == 4) or (gsv == 6)) and type(c.dir) == "string" then
     csprite =  c.name .. "-" .. c.dir
     if (gsv == 6) and c.sleep then
       csprite = csprite .. "-sleep"
     end
    elseif (c.tiling ~= nil) then
     csprite = c.name .. " T" .. c.tiling
    end
  end


  if string.sub(c.name,1,10) == "text_text_" then
    csprite = string.sub(csprite,6,-1)
  end

  if c.name == "monitor" then
    local suffix = ""
    if current_os == "OS X" then
      suffix = "mac"
    elseif current_os == "Windows" then
      suffix = "windows"
    elseif current_os == "Linux" then
      suffix = "linux"
    end

    for _, zw in ipairs(rules) do
      if matches(zw[1], c) then -- and zw[2] ~= "write" then       note: dont know if i should add this or not
        for zi, zj in pairs(monitor_things) do
          if matches(zw[3], zi, true) or matches(zw[2], zi, true) then
            suffix = zj
            break
          end
        end
      end
    end

    csprite = csprite .. "-" .. suffix



  end

  c.sprite = love.graphics.newImage("sprite/" .. csprite .. ".png")


end


function love.draw()
  if not love.window.hasFocus() then
    return
  end


  if gamestate == "editor" or gamestate == "playing" then



  drawborders()



    love.graphics.setBackgroundColor(palettecolors[1][5])
   for i,c in ipairs(Objects) do



     local t = palettecolors[c.color[1]]
     if(t ~= nil) and (t[c.color[2]] ~= nil)then
      love.graphics.setColor(t[c.color[2]])
        if c._active == false or c.lock ~= nil then
          local a1 = { t[c.color[2]][1] * 0.46, t[c.color[2]][2] * 0.46, t[c.color[2]][3] * 0.54}
          love.graphics.setColor(a1)
        end
      end

      if(c.active == true) and (c.hide ~= true)then

        local cx = c.x
        local cy = c.y

        if c.float then
          cy = cy - (10 - math.sin(love.timer.getTime()) * 7) * c.size
        end


        if c.size > 1 then
          cx = cx - tilesize / 2
          cy = cy - tilesize
          if c.size > 2 then
            local multval = 2
            for asdf = 1, 7 do
              if c.size > multval then
                cx = cx - tilesize * multval / 2
                cy = cy - tilesize * multval
              else
                break
              end
              multval = multval * 2
            end
          end
        end

        if c.size < 1 then
          cx = cx + tilesize / 4
          cy = cy + tilesize / 2
          if c.size < 0.5 then
            local multval = 0.5
            for asdf = 1, 7 do
              if c.size < multval then
                cx = cx + tilesize * multval / 4
                cy = cy + tilesize * multval / 2
              else
                break
              end
              multval = multval / 2
            end
          end
        end
        --[[
        if c.size < 1 then
          cx = cx + tilesize / 4
          cy = cy + tilesize / 2
        end
        if c.size < 0.5 then
          cx = cx + tilesize / 8
          cy = cy + tilesize / 4
        end

        if c.size < 0.25 then
          cx = cx + tilesize / 16
          cy = cy + tilesize / 8
        end]]

        if c.file == nil then
          local xchange = -((c.sprite:getWidth() - 24) / 2) * (tilesize / 24)
          local ychange = -((c.sprite:getHeight() - 24) / 2) * (tilesize / 24)
          love.graphics.draw(c.sprite,cx + x_offset + xchange,cy + y_offset + ychange,0,c.size * (tilesize / 24))
        else
          love.graphics.draw(c.sprite,cx + x_offset,cy + y_offset,0,c.size * (tilesize / 24) * (24 / c.sprite:getHeight()))
        end

          --love.graphics.draw(love.graphics.newImage("sprite/" .. c.sprite .. ".png") or love.graphics.newImage("sprite/error.png"),c.x,c.y,0,c.size)

        love.graphics.setColor(1,1,1)
      end
    --love.graphics.print(c.rule[1] or "",c.x,c.y)
    --love.graphics.print(c.meta,c.x+c.size*15,c.y+c.size*15)
  --  love.graphics.print(math.floor(dist(c.x+c.size/2,c.y+c.size/2,love.mouse.getX(),love.mouse.getY())),c.x+c.size/4,c.y+10)
      love.graphics.setColor(1,0,0)
  --love.graphics.print()
      if string.sub(c.name,1,10) == "text_text_" and c.file == nil then
        love.graphics.setColor(1,0,0.5)
        love.graphics.draw(textmeta,c.x + x_offset,c.y + y_offset,0,c.size  * (tilesize / 24))
      end
      if c.blocked then
        love.graphics.setColor(palettecolors[1][1])
        love.graphics.draw(blockerimg,c.x + x_offset,c.y + y_offset,0,c.size  * (tilesize / 24))
      end
     --love.graphics.print(tostring(4),c.x,c.y)
  --  love.graphics.print(tostring(to),300,300)
    --string.pack("j",3)
      if c.name == "clock" then
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
        if c.size > 0.6 then
          love.graphics.print(hour .. ":" .. min,c.x + x_offset,c.y+tilesize/3+1 + y_offset,0,1.3)
        elseif c.size > 0.3 then
          love.graphics.print(hour .. ":" .. min,c.x+4 + x_offset,c.y+tilesize/3+6 + y_offset,0,0.7)
        elseif c.size > 0.1 then
          love.graphics.print(hour .. ":" .. min,c.x+5 + x_offset,c.y+tilesize/3+1 + y_offset,0,0.4)
        end
      elseif c.name == "calendar" then
        love.graphics.setColor(0,0,0)
        local date = os.date("*t",os.time()).day
        love.graphics.draw(love.graphics.newImage("sprite/calendarnumbers/c" .. tostring(date) .. ".png"),c.x  + x_offset,c.y  + y_offset,0,c.size * (tilesize / 24))

      elseif c.num ~= nil and c.lock == nil then
        love.graphics.draw(love.graphics.newImage("sprite/calendarnumbers/c" .. tostring(c.num) .. ".png"),c.x  + x_offset - 3,c.y  + y_offset - 1 ,0,c.size * (tilesize / 24))

      end
   end

   local width, height = love.graphics.getDimensions()
   if wewinning then
     love.graphics.setColor(1,1,1)
    love.graphics.draw(love.graphics.newImage("graphics/you win.png"),width / 2 - 146,height / 2 - 90,0, 2 *math.sin((8 - wintimer) / 4 * math.pi / 2) )
   end
   if theloop then
     love.graphics.setColor(1,1,1)
    love.graphics.draw(love.graphics.newImage("graphics/LOOP.png"),width / 2 - 146,height / 2 - 90,0,2)
   end

   if levelhandle ~= nil then
     love.graphics.setColor(1,1,1)
     love.graphics.print(levelhandle, 10, 10, 0, 2, 2, 0, 0, 0, 0)
   end

   if gamestate == "editor" then
     draweditor()

        if  not hideui and ineditor then
          drawui()
          drawtabs()
        end
      end



           --DBG = love.timer.getFPS()
           --love.graphics.print(DBG,0,300)




        --[[   love.graphics.setColor(1,0.5,0.2)
           local aa = ""
           local files = love.filesystem.getDirectoryItems("sprite")
           for k, file in ipairs(files) do
             aa = aa .. k .. ". " .. file .. "\n"

           end
           love.graphics.print(aa)]] --outputs something like "1. main.lua"

           -- Draw Editor Play button
           if gamestate == "editor" then
             if ineditor then
               local csprite = miscsprites["play"]
               love.graphics.setColor(palettecolors[4][1])
               love.graphics.draw(csprite,width - 80,height - 90,0,2)
             else
               local csprite = miscsprites["flag"]
               love.graphics.setColor(palettecolors[1][1])
               love.graphics.draw(csprite,width - 80,height - 90,0,2)
             end
           end

           if stupid_music_timer > 0 then
             if not mutemusic then
               local csprite = miscsprites["note"]
               love.graphics.setColor(palettecolors[7][5][1] * 0.2, palettecolors[7][5][2] * 0.2, palettecolors[7][5][3] * 0.3)
               love.graphics.rectangle("fill", width - 130 - string.len(musiclist[levelmusic]) * 10 - 5, 51, string.len(musiclist[levelmusic]) * 10 + 109, 134)
               love.graphics.rectangle("fill", width - 180, width - 151, 90, 90)
               love.graphics.setColor(palettecolors[7][5][1] * 1.2, palettecolors[7][5][2] * 1.2, palettecolors[7][5][3] * 1.3)
               love.graphics.draw(csprite,width - 80,95,0,1)
               love.graphics.print(musiclist[levelmusic], width - 130 - string.len(musiclist[levelmusic]) * 10, 100, 0, 2)
             else
               local csprite = miscsprites["dots"]
               love.graphics.setColor(palettecolors[7][5][1] * 0.2, palettecolors[7][5][2] * 0.2, palettecolors[7][5][3] * 0.3)
               love.graphics.rectangle("fill", width - 130 - 5 * 10 - 5, 51, 5 * 10 + 109, 134)
               love.graphics.rectangle("fill", width - 180, width - 151, 90, 90)
               love.graphics.setColor(palettecolors[1][2][1], palettecolors[1][2][2], palettecolors[1][2][3] * 1.1)
               love.graphics.draw(csprite,width - 80,95,0,1)
               love.graphics.print("what?", width - 130 - 5 * 10, 100, 0, 2)
             end
           end

  end
  menu()
  if gamestate == "menu" and menu_state == "main" then
    local width, height = love.graphics.getDimensions()
    local csprite = miscsprites["logo"]
    love.graphics.setColor(1,1,1)
    love.graphics.draw(csprite,width / 2 - 191,155,0,2)
  end

end

delay = {left = 0, up = 0, down = 0, right = 0, space = 0, w = 0, a = 0, s = 0, d = 0, z = 0}
turntimer = 0
delay_timer = 0.15
turnkey = ""

function love.update(delta)

  if not love.window.hasFocus() then
    return
  end

  if stupid_music_timer > 0 then
    stupid_music_timer = stupid_music_timer - delta
  end

  turntimer = turntimer + delta



  doturn = false

    for i, j in ipairs(keys) do
      if love.keyboard.isDown(j) and delay[j] <= 0 then
        if j ~= "z" then
          doturn = true
          turnkey = j
        elseif not wewinning then
          undo()
        end
        delay[j] = delay_timer
        break
      end
    end

    if wewinning then
      doturn = false
      if wintimer > 0 then
        wintimer = wintimer - delta
      else
        if not (menu_state == "editor_test") then

          if #leveltree >= 2 then
            enterlevel(leveltree[#leveltree - 1])
            table.remove(leveltree, #leveltree)
            table.remove(leveltree, #leveltree)
          else
            gotomenuplay()
          end

        else

          dielevel()

        end
      end
    end

  for i, v in pairs(delay) do
    if delay[i] > 0 then
      delay[i] = v - delta
    else
      delay[i] = 0
    end
  end



  if doturn and not (gamestate == "editor" and menu_state ~= "editor_test") then
    if newturn() then
      passturn()
    end
  end

  if gamestate == "editor" and menu_state ~= "editor_test" then
    handletilething()
  end
  if #Objects > 0 then
    for i, c in ipairs(Objects) do
      if c.to_x ~= nil and c.to_y ~= nil then
        if c.frame >= 0.07 then
          c.x = c.tilex * tilesize
          c.y = c.tiley * tilesize
          c.to_x = nil
          c.to_y = nil
          c.frame = 0
        else
          c.x = (c.to_x) * (c.frame / 0.07) + (c.from_x) * (1 - (c.frame / 0.07) )
          c.y = (c.to_y) * (c.frame / 0.07) + (c.from_y) * (1 - (c.frame / 0.07) )
          c.frame = math.min(c.frame + delta, 0.07)
        end
      end
    end
  end

end
function dist(xa,ya,xb,yb)
return math.sqrt((yb-ya)^2+(xb-xa)^2)
end
function love.mousepressed(x, y, button, isTouch)
  local width, height = love.graphics.getDimensions()
  --if x > 1180 and y > 720 and x < 1260 and y < 780 then
  if x > width - 100 and y > height - 100 and x < width - 20 and y < height - 40 then
    if ineditor then
      loadlevel()
    else
      dielevel()
    end
  end


  menu_press()


  if not ineditor then
        for i, j in ipairs(Objects) do
          if j.tilex == math.floor(love.mouse.getX()/ tilesize ) and j.tiley == math.floor(love.mouse.getY()/ tilesize ) then
            turnkey = "No"
            passturn()
          end
        end
  end


end

function love.filedropped(file)
	filename = file:getFilename():gsub("\\", "/")
	ext = filename:match("%.%w+$")

	if ext == ".png" or ext == ".jpg" then
		file:open("r")
		fileData = file:read("data")
		file_img = love.image.newImageData(fileData)
		--file_img = love.graphics.newImage(img)
    _, file_name = filename:match("(/.*/)(.+)(%.)")
    turnkey = "Absolutely Not"
    passturn()
	end
  if ext == ".wav" or ext == ".mp3" or ext == ".ogg" then
		file:open("r")
		fileData = file:read("data")
		--file_img = love.graphics.newImage(img)
    _, file_name = filename:match("(/.*/)(.+)(%.)")
    turnkey = "Nope"
    passturn()
	end
end

function makeobject(x,y,name,dir_,meta_,level_)
    obj = {}
    obj.size = 1
    obj.tilex = x
    obj.tiley = y
    obj.x = x*tilesize
    obj.y = y*tilesize
    obj.frame = 0
    obj.name = name
        obj.type = getspritevalues(obj.name).type
        obj.color = getspritevalues(obj.name).color
    obj.sprite = obj.name

    obj.dir = dir_ or "right"

    obj.id = #Objects + 1
    obj.transformable = true


    obj.active = true

    obj.tiling = nil
    obj.orig_x = x
    obj.orig_y = y
    obj.small = 1

    idtotal = idtotal + 1
    obj.undo_id = idtotal + 0

    obj.levelinside = level_

    dotiling(obj)

    updatesprite(obj)

    table.insert(Objects,obj)
    if afterframeone ~= nil then
      add_undo("create", {the_id = obj.undo_id})
    end

    return obj

end




function contains(table,item)
for index1,val11 in ipairs(table) do
 if(val11 == item)then
 return true
 end

end
 return false

end
function removeunit(unit)
 for i,j in ipairs(Objects) do
  if(j.id > unit.id)then
   j.id = j.id - 1
  end
 end
  table.remove(Objects,unit.id)
end

function destroylevel(type)
  Objects = {}
  the_level_is_gone = true
  if type == "LOOP!!!" then
    theloop = true
  end
end

function parse_text()
  rules = {}
  Parser:init()
  Parser:makeFirstWords()
  Parser:MakeRules()
  Parser:ParseRules()
  rules = {}
  for i,b in ipairs(baserules) do
    local whyyyy = {}
    if b[4] ~= nil then
      for v, w in ipairs(b[4]) do
        table.insert(whyyyy, w)
      end
    end
    table.insert(rules,{b[1],b[2],b[3],whyyyy})
  end
  Parser:AddRules()
  -- oh boy debugging
  --Parser:Debug()
end



--[[
plans

collect: replaces "area clear".
if you make blossom is collect,
you get a blossom added to your inventory,
and if you get any other object,
you also get it added to your inventory.
so you can collect doors or something and it wont add an orb because orbs arent doors

]]


--TODO
--[[

MAIN FEATURES:
1. Make a way to create a map [kinda]
2. Make WIN boot you back to the map [ye]
3. Make a map [Y!!]
4. Seperate play (custom levels) and play (campaign) into two buttons []
!5! 0. Add a puff count [not now]
!6! 58. Make levels [not now2 ]
7. Polish up the mechanics from 1 and 2 as well as level entering

BUGS:
fix multimoves
fix the sound bug with placing level files into levels

SLIGHTLY LESS MAIN FEATURES:
level icons
return to map
make file compatible with levels


funny thingy: make the main menu a level. so the buttons could be special objects, "baaba is you" would be a rule because
its the game name, whatever
]]
