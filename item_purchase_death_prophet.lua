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

  "item_vitality_booster",
  "item_energy_booster",
  "item_point_booster",
  "item_sobi_mask",
  "item_ring_of_regen",
  "item_recipe_soul_ring",
  "item_recipe_bloodstone",

  "item_belt_of_strength",
  "item_staff_of_wizardry",
  "item_recipe_necronomicon",
  "item_recipe_necronomicon",
  "item_recipe_necronomicon",

  "item_platemail",
  "item_mystic_staff",
  "item_recipe_shivas_guard",

  "item_vitality_booster",
  "item_reaver",
  "item_recipe_heart",

  "item_boots",
  "item_recipe_travel_boots",

  "item_vitality_booster",
  "item_energy_booster",
  "item_point_booster",
  "item_mystic_staff",

};

local abilities = {
  "special_bonus_spell_amplify_4",
  "special_bonus_unique_death_prophet_2",
  "special_bonus_cooldown_reduction_10",
  "special_bonus_hp_400",
  "death_prophet_exorcism",
  "death_prophet_carrion_swarm",
  "death_prophet_spirit_siphon",
  "death_prophet_silence",
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