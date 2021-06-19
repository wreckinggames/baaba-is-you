function getspritevalues(n)
  for i,j in ipairs(objectValues)do
   if(j.name == n)then
     return j
   end
  end
  return {sprite = n,name = n, color = {1,1}, rotate = nil}
end
objectValues = {
  {
    name = "baaba",
    sprite = "baaba",
    color = {1,2},
    rotate = 4
  },
  {
    name = "text_baaba",
    sprite = "text_baaba",
    color = {4,4},
    type = 0
  },
  {
    name = "stone",
    sprite = "stone",
    color = {2,3}
  },
  {
    name = "text_stone",
    sprite = "text_stone",
    color = {2,3},
    type = 0
  },
  {
    name = "tiles",
    sprite = "tiles",
    color = {1,3},
  },
  {
    name = "text_tiles",
    sprite = "text_tiles",
    color = {1,3},
    type = 0
  },
  {
    name = "text_you",
    sprite = "text_you",
    color = {4,4},
    type = 2
  },
  {
    name = "text_is",
    sprite = "text_is",
    color = {1,2},
    type = 1
  },
  {
    name = "text_meta",
    sprite = "text_meta",
    color = {4,4},
    type = 2
  },
  {
    name = "text_text",
    sprite = "text_text",
    color = {4,4},
    type = 0
  },
  {
    name = "text_open",
    sprite = "text_open",
    color = {3,1},
    type = 2
  },
  {
    name = "text_push",
    sprite = "text_push",
    color = {2,3},
    type = 2
  },
  {
    name = "text_all",
    sprite = "text_all",
    color = {1,2},
    type = 0
  },
  {
    name = "text_weak",
    sprite = "text_weak",
    color = {5,2},
    type = 2
  },
  {
    name = "text_move",
    sprite = "text_move",
    color = {5,1},
    type = 2
  },
  {
    name = "text_red",
    sprite = "text_red",
    color = {1,1},
    type = 2
  },
  {
    name = "text_stop",
    sprite = "text_stop",
    color = {6,1},
    type = 2
  },
  {
    name = "text_this",
    sprite = "text_this",
    color = {1,2},
    type = 0
  },
  {
    name = "text_shut",
    sprite = "text_shut",
    color = {1,1},
    type = 2
  },
  {
    name = "keeke",
    sprite = "keeke",
    color = {1,1},
  },
  {
    name = "flag",
    sprite = "flag",
    color = {3,1},
  },
  {
    name = "wall",
    sprite = "wall",
    color = {7,5},
  },
  {
    name = "text_keeke",
    sprite = "text_keeke",
    color = {1,1},
    type = 0
  },
  {
    name = "text_flag",
    sprite = "text_flag",
    color = {3,1},
    type = 0
  },
  {
    name = "text_wall",
    sprite = "text_wall",
    color = {7,5},
    type = 0
  },
  {
    name = "text_sink",
    sprite = "text_sink",
    color = {6,3},
    type = 2
  },
  {
    name = "text_whater",
    sprite = "text_whater",
    color = {6,1},
    type = 0
  },
  {
    name = "whater",
    sprite = "whater",
    color = {6,1}
  },
  {
    name = "text_lavaaa",
    sprite = "text_lavaaa",
    color = {2,1},
    type = 0
  },
  {
    name = "lavaaa",
    sprite = "lavaaa",
    color = {2,1}
  },
  {
    name = "text_hot",
    sprite = "text_hot",
    color = {2,1},
    type = 2
  },
  {
    name = "text_melt",
    sprite = "text_melt",
    color = {6,1},
    type = 2
  },
  {
    name = "text_fofofo",
    sprite = "text_fofofo",
    color = {5,1},
    type = 0
  },
  {
    name = "fofofo",
    sprite = "fofofo",
    color = {5,1}
  },
  {
    name = "text_key",
    sprite = "text_key",
    color = {3,1},
    type = 0
  },
  {
    name = "key",
    sprite = "key",
    color = {3,1}
  },
  {
    name = "text_door",
    sprite = "text_door",
    color = {1,1},
    type = 0
  },
  {
    name = "door",
    sprite = "door",
    color = {1,1}
  },
  {
    name = "text_group",
    sprite = "text_group",
    color = {5,1},
    type = 0
  },
  {
    name = "clock",
    sprite = "clock",
    color = {7,4}
  },
  {
    name = "text_clock",
    sprite = "text_clock",
    color = {7,4},
    type = 0
  },
  {
    name = "text_have",
    sprite = "text_have",
    color = {1,2},
    type = 1
  },
  {
    name = "text_win",
    sprite = "text_win",
    color = {3,1},
    type = 2
  },
  {
    name = "text_defeat",
    sprite = "text_defeat",
    color = {3,4},
    type = 2
  },
  {
    name = "text_clipboard",
    sprite = "text_clipboard",
    color = {1,2},
    type = 0
  },
  {
    name = "text_orange",
    sprite = "text_orange",
    color = {2,1},
    type = 2
  },
  {
    name = "skulll",
    sprite = "skulll",
    color = {3,4}
  },
  {
    name = "text_skulll",
    sprite = "text_skulll",
    color = {3,4},
    type = 0
  },
  {
    name = "text_leevel",
    sprite = "text_leevel",
    color = {4,4},
    typr = 0
  },
  {
    name = "leevel",
    sprite = "leevel",
    color = {1,2}
  },
  {
    name = "text_a",
    sprite = "text_a",
    color = {1,2},
    type = 5
  },
  {
    name = "text_b",
    sprite = "text_b",
    color = {1,2},
    type = 5
  },
  {
    name = "text_tele",
    sprite = "text_tele",
    color = {6,5},
    type = 2
  },
  {
    name = "text_icy",
    sprite = "text_icy",
    color = {6,5},
    type = 0
  },
  {
    name = "icy",
    sprite = "icy",
    color = {6,5}
  },
  {
    name = "text_up",
    sprite = "text_up",
    color = {6,5},
    type = 0
  },
}
