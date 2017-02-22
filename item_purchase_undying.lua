-- Include this before require to fix Mac
local dir = GetScriptDirectory();
local function GetScriptDirectory()
  if string.sub(dir, 1, 6) == "/Users" then
    return string.match(dir, '.*/(.+)')
  end
  return dir;
end
-----------------------------------------

local Helper = require(GetScriptDirectory() .. "/helper");

local tableItemsToBuy = {

  "item_stout_shield",
  "item_branches",
  "item_branches",
  "item_tango",
  "item_tango",

  "item_boots",
  "item_energy_booster",

  "item_vitality_booster",
  "item_ring_of_health",

  "item_broadsword",
  "item_chainmail",
  "item_robe",

  "item_ring_of_regen",
  "item_recipe_headdress",
  "item_chainmail",
  "item_recipe_buckler",
  "item_recipe_mekansm",

  "item_platemail",
  "item_mystic_staff",
  "item_recipe_shivas_guard",

  "item_chainmail",
  "item_branches",
  "item_recipe_buckler",
  "item_recipe_crimson_guard",

  "item_vitality_booster",
  "item_reaver",
  "item_recipe_heart",

  "item_recipe_guardian_greaves",

};

local abilities = {
  "special_bonus_gold_income_15",
  "special_bonus_hp_300",
  "special_bonus_unique_undying",
  "special_bonus_unique_undying_2",
  "undying_flesh_golem",
  "undying_decay",
  "undying_tombstone",
  "undying_soul_rip",
}

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()

  local npcBot = GetBot();
  local buildTable = tableItemsToBuy;

  Helper.AbilityUpgrade(npcBot, abilities);
  Helper.PurchaseBootsAndTP(npcBot);
  Helper.PurchaseItems(npcBot, buildTable);

end


----------------------------------------------------------------------------------------------------