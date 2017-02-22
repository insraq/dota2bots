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

  "item_ring_of_protection",
  "item_sobi_mask",
  "item_tango",
  "item_tango",

  "item_boots",
  "item_blades_of_attack",
  "item_blades_of_attack",

  "item_belt_of_strength",
  "item_staff_of_wizardry",
  "item_recipe_necronomicon",
  "item_recipe_necronomicon",
  "item_recipe_necronomicon",

  "item_point_booster",
  "item_staff_of_wizardry",
  "item_ogre_axe",
  "item_blade_of_alacrity",

  "item_platemail",
  "item_mystic_staff",
  "item_recipe_shivas_guard",

  "item_shadow_amulet",
  "item_claymore",
  "item_ultimate_orb",
  "item_recipe_silver_edge",

  "item_boots",
  "item_recipe_travel_boots",

  "item_quarterstaff",
  "item_robe",
  "item_sobi_mask",
  "item_quarterstaff",
  "item_robe",
  "item_sobi_mask",
  "item_recipe_orchid",

  "item_broadsword",
  "item_blades_of_attack",
  "item_recipe_lesser_crit",
  "item_recipe_bloodthorn",
};

local abilities = {
  "special_bonus_exp_boost_20",
  "special_bonus_cast_range_150",
  "special_bonus_magic_resistance_15",
  "special_bonus_unique_venomancer",
  "venomancer_poison_nova",
  "venomancer_plague_ward",
  "venomancer_poison_sting",
  "venomancer_venomous_gale",
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