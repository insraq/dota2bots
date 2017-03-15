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

  "item_circlet",
  "item_tango",
  "item_tango",
  "item_mantle",

  "item_boots",
  "item_blades_of_attack",
  "item_blades_of_attack",

  "item_recipe_null_talisman",

  "item_point_booster",
  "item_staff_of_wizardry",
  "item_ogre_axe",
  "item_blade_of_alacrity",

  "item_belt_of_strength",
  "item_staff_of_wizardry",
  "item_recipe_necronomicon",
  "item_recipe_necronomicon",
  "item_recipe_necronomicon",

  "item_staff_of_wizardry",
  "item_recipe_dagon",

  "item_recipe_dagon",
  "item_recipe_dagon",
  "item_recipe_dagon",
  "item_recipe_dagon",

  "item_platemail",
  "item_mystic_staff",
  "item_recipe_shivas_guard",

  "item_boots",
  "item_recipe_travel_boots",

  "item_vitality_booster",
  "item_reaver",
  "item_recipe_heart"
};

local abilities = {
  "special_bonus_strength_6",
  "special_bonus_respawn_reduction_25",
  "special_bonus_armor_7",
  "special_bonus_unique_keeper_of_the_light",
  "keeper_of_the_light_chakra_magic",
  "keeper_of_the_light_illuminate",
  "keeper_of_the_light_mana_leak",
  "keeper_of_the_light_spirit_form",
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