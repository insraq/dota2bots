-- Include this before require to fix Mac
local dir = GetScriptDirectory();
local function GetScriptDirectory()
  if string.sub(dir, 1, 6) == "/Users" then
    return string.match(dir, '.*/(.+)');
  end
  return dir;
end
-----------------------------------------

local Helper = require(GetScriptDirectory() .. "/helper");
require(GetScriptDirectory().."/ability_item_usage_generic");

local Abilities = {
  "venomancer_venomous_gale",
  "venomancer_poison_sting",
  "venomancer_plague_ward",
  "venomancer_poison_nova",
};

function AbilityUsageThink()

  local npcBot = GetBot();

  local gale = npcBot:GetAbilityByName(Abilities[1]);
  local ward = npcBot:GetAbilityByName(Abilities[3]);
  local nova = npcBot:GetAbilityByName(Abilities[4]);

  if npcBot:IsChanneling() or npcBot:IsUsingAbility() then
    return;
  end

  if gale:IsFullyCastable() and
    npcBot:GetMana() - gale:GetManaCost() > nova:GetManaCost() and
    npcBot:GetActiveMode() == BOT_MODE_ATTACK then
    local target = Helper.GetHeroWith(npcBot, 'min', 'GetHealth', gale:GetCastRange(), true);
    if target ~= nil then
      return npcBot:ActionPush_UseAbilityOnLocation(gale, target:GetLocation());
    end
  end

  if ward:IsFullyCastable() and
    (#npcBot:GetNearbyHeroes(1500, true, BOT_MODE_NONE) > 0 or
      #npcBot:GetNearbyTowers(1500, true) > 0 or
      #npcBot:GetNearbyBarracks(1500, true) > 0 or
      #npcBot:GetNearbyLaneCreeps(1500, true) > 2 or
      npcBot:GetManaRegen() > 4 or
      npcBot:GetActiveMode() == BOT_MODE_ATTACK or
      npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT or
      npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
      npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
      npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY
    ) and
    npcBot:GetMana() - ward:GetManaCost() > nova:GetManaCost() and
    ward:GetLevel() >= 2 then
    local target = npcBot:GetNearbyHeroes(ward:GetCastRange(), true, BOT_MODE_NONE)[1];
    if target ~= nil then
      return npcBot:ActionPush_UseAbilityOnLocation(ward, target:GetLocation());
    else
      return npcBot:ActionPush_UseAbilityOnLocation(ward, npcBot:GetLocation() + Helper.RandomForwardVector(ward:GetCastRange()));
    end
  end

  local enemyHeroes = npcBot:GetNearbyHeroes(575, true, BOT_MODE_NONE);
  if #enemyHeroes >= 3 or (#enemyHeroes >= 2 and npcBot:GetActiveMode() == BOT_MODE_ATTACK) then
    return npcBot:ActionPush_UseAbility(nova);
  end

end

function ItemUsageThink()
  ability_item_usage_generic.ItemUsageThink();
end

function BuybackUsageThink()
  ability_item_usage_generic.BuybackUsageThink();
end