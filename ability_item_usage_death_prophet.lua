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
  "death_prophet_carrion_swarm",
  "death_prophet_silence",
  "death_prophet_spirit_siphon",
  "death_prophet_exorcism",
};

function AbilityUsageThink()

  local npcBot = GetBot();

  local swarm = npcBot:GetAbilityByName(Abilities[1]);
  local silence = npcBot:GetAbilityByName(Abilities[2]);
  local siphon = npcBot:GetAbilityByName(Abilities[3]);
  local ult = npcBot:GetAbilityByName(Abilities[4]);

  if npcBot:IsChanneling() or npcBot:IsUsingAbility() then
    return;
  end

  local battleMayHappen = #npcBot:GetNearbyHeroes(1500, true, BOT_MODE_NONE) >= 3 or
    (
      #npcBot:GetNearbyHeroes(1500, true, BOT_MODE_NONE) >= 2 and
      #npcBot:GetNearbyHeroes(1500, false, BOT_MODE_NONE) >= 2
    );
  local isPushing = (
    #npcBot:GetNearbyTowers(700, true) > 0 or #npcBot:GetNearbyBarracks(700, true) > 0
  ) and #npcBot:GetNearbyHeroes(700, false, BOT_MODE_NONE) >= 2;

  if ult:IsFullyCastable() and (battleMayHappen or isPushing) then
    return npcBot:ActionPush_UseAbility(ult);
  end

  if swarm:IsFullyCastable() and
    npcBot:GetMana() - swarm:GetManaCost() > ult:GetManaCost() and
    swarm:GetLevel() >= 2 then
    local target = Helper.GetHeroWith(npcBot, 'min', 'GetHealth', swarm:GetCastRange(), true);

    if target == nil and
      npcBot:GetMana() > swarm:GetManaCost() + silence:GetManaCost() + siphon:GetManaCost() + ult:GetManaCost() then
      target = npcBot:GetNearbyLaneCreeps(swarm:GetCastRange(), true)[1];
    end

    if target ~= nil then
      return npcBot:ActionPush_UseAbilityOnEntity(swarm, target);
    end
  end

  if silence:IsFullyCastable() then
    local aoe = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), silence:GetCastRange(), 425, 0.0, 100000);
    if aoe.count >= 2 then
      return npcBot:ActionPush_UseAbilityOnLocation(silence, aoe.targetloc);
    end
  end

  if siphon:IsFullyCastable() and swarm:GetLevel() >= 3 and npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
    local target = Helper.GetHeroWith(npcBot, 'min', 'GetHealth', siphon:GetCastRange(), true);
    if target ~= nil then
      npcBot:ActionQueue_MoveToUnit(target);
      return npcBot:ActionPush_UseAbilityOnEntity(siphon, target);
    end
  end

end

function ItemUsageThink()
  ability_item_usage_generic.ItemUsageThink();
end

function BuybackUsageThink()
  ability_item_usage_generic.BuybackUsageThink();
end