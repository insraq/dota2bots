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
  "shadow_shaman_ether_shock",
  "shadow_shaman_voodoo",
  "shadow_shaman_shackles",
  "shadow_shaman_mass_serpent_ward",
};

function AbilityUsageThink()

  local npcBot = GetBot();

  local shock = npcBot:GetAbilityByName(Abilities[1]);
  local hex = npcBot:GetAbilityByName(Abilities[2]);
  local shackles = npcBot:GetAbilityByName(Abilities[3]);
  local ult = npcBot:GetAbilityByName(Abilities[4]);

  if npcBot:IsChanneling() or npcBot:IsUsingAbility() then
    return;
  end

  local ultTarget = nil;

  local enemyHeroes = npcBot:GetNearbyHeroes(ult:GetCastRange(), true, BOT_MODE_NONE);
  if #enemyHeroes >= 2 then
    ultTarget = enemyHeroes[1]:GetLocation();
  end

  local towers = npcBot:GetNearbyTowers(ult:GetCastRange(), true);
  if #towers > 0 then
    ultTarget = towers[1]:GetLocation();
  end

  local barracks = npcBot:GetNearbyBarracks(ult:GetCastRange(), true);
  if #barracks > 0 then
    ultTarget = barracks[1]:GetLocation();
  end

  if ultTarget ~= nil and ult:IsFullyCastable() then
    return npcBot:ActionPush_UseAbilityOnLocation(ult, ultTarget);
  end

  if shock:IsFullyCastable() and
    npcBot:GetMana() - shock:GetManaCost() > ult:GetManaCost() and
    shock:GetLevel() >= 2 then
    local target = Helper.GetHeroWith(npcBot, 'min', 'GetHealth', shock:GetCastRange(), true);

    if target == nil and
      npcBot:GetMana() > shock:GetManaCost() + hex:GetManaCost() + shackles:GetManaCost() + ult:GetManaCost() then
      target = npcBot:GetNearbyLaneCreeps(shock:GetCastRange(), true)[1];
    end

    if target ~= nil then
      return npcBot:ActionPush_UseAbilityOnEntity(shock, target);
    end
  end

  if hex:IsFullyCastable() and
    npcBot:GetMana() - hex:GetManaCost() > ult:GetManaCost() + shock:GetManaCost() then
    local target = Helper.GetHeroWith(npcBot, 'max', 'GetRawOffensivePower', hex:GetCastRange(), true);
    if target ~= nil then
      return npcBot:ActionPush_UseAbilityOnEntity(hex, target);
    end
  end

  if shackles:IsFullyCastable() and
    #npcBot:GetNearbyHeroes(ult:GetCastRange(), false, BOT_MODE_NONE) >= 2 and
    npcBot:GetMana() - shackles:GetManaCost() > ult:GetManaCost() + shock:GetManaCost() then
    local target = Helper.GetHeroWith(npcBot, 'min', 'GetHealth', shackles:GetCastRange(), true);
    if target ~= nil then
      return npcBot:ActionPush_UseAbilityOnEntity(shackles, target);
    end
  end

end

function ItemUsageThink()
  ability_item_usage_generic.ItemUsageThink();
end

function BuybackUsageThink()
  ability_item_usage_generic.BuybackUsageThink();
end