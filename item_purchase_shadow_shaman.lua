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

  "item_courier",
  "item_tango",
  "item_tango",

  "item_boots",
  "item_energy_booster",

  "item_flying_courier",

  "item_point_booster",
  "item_staff_of_wizardry",
  "item_ogre_axe",
  "item_blade_of_alacrity",

  "item_belt_of_strength",
  "item_staff_of_wizardry",
  "item_recipe_necronomicon",
  "item_recipe_necronomicon",
  "item_recipe_necronomicon",

  "item_ring_of_health",
  "item_cloak",
  "item_ring_of_regen",

  "item_ring_of_regen",
  "item_branches",
  "item_recipe_headdress",
  "item_recipe_pipe",

  "item_boots",
  "item_recipe_travel_boots",

  "item_void_stone",
  "item_ultimate_orb",
  "item_mystic_staff",
};

local abilities = {
  "special_bonus_hp_150",
  "special_bonus_cast_range_100",
  "special_bonus_respawn_reduction_30",
  "special_bonus_unique_shadow_shaman_2",
  "shadow_shaman_mass_serpent_ward",
  "shadow_shaman_ether_shock",
  "shadow_shaman_voodoo",
  "shadow_shaman_shackles",
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