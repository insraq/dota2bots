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
  "undying_decay",
  "undying_tombstone",
  "undying_soul_rip",
  "undying_flesh_golem",
};

function AbilityUsageThink()

  local npcBot = GetBot();

  local decay = npcBot:GetAbilityByName(Abilities[1]);
  local tombstone = npcBot:GetAbilityByName(Abilities[2]);
  local heal = npcBot:GetAbilityByName(Abilities[3]);
  local ult = npcBot:GetAbilityByName(Abilities[4]);

  if npcBot:IsChanneling() or npcBot:IsUsingAbility() then
    return;
  end

  local battleMayHappen = #npcBot:GetNearbyHeroes(1500, true, BOT_MODE_NONE) >= 3 or
    (
      #npcBot:GetNearbyHeroes(1500, true, BOT_MODE_NONE) >= 2 and
      #npcBot:GetNearbyHeroes(1500, false, BOT_MODE_NONE) >= 2
    );

  if tombstone:IsFullyCastable() and battleMayHappen then
    return npcBot:ActionPush_UseAbilityOnLocation(tombstone, npcBot:GetLocation());
  end

  if ult:IsFullyCastable() and battleMayHappen then
    return npcBot:ActionPush_UseAbility(ult);
  end

  if decay:IsFullyCastable() and
    npcBot:GetMana() - decay:GetManaCost() > ult:GetManaCost() + tombstone:GetManaCost() then
    local aoe = npcBot:FindAoELocation(
        true, true, npcBot:GetLocation(), decay:GetCastRange(), 325, decay:GetCastPoint(), 100000);
    if aoe.count >= 2 or (aoe.count >= 1 and npcBot:GetActiveMode() == BOT_MODE_ATTACK) then
      return npcBot:ActionPush_UseAbilityOnLocation(decay, aoe.targetloc);
    end
  end

  if heal:IsFullyCastable() and
    npcBot:GetMana() - heal:GetManaCost() > ult:GetManaCost() + tombstone:GetManaCost() + 3 * decay:GetManaCost() then

    local enemy = Helper.GetHeroWith(npcBot, 'min', 'GetHealth', heal:GetCastRange(), true);
    local friend = Helper.GetHeroWith(npcBot, 'min', 'GetHealth', heal:GetCastRange(), false);

    local target = enemy or friend;
    if enemy ~= nil and friend ~= nil then
      target = enemy:GetHealth() < friend:GetHealth() and enemy or friend;
    end

    if target ~= nil then
      return npcBot:ActionPush_UseAbilityOnEntity(heal, target);
    end
  end

end

function ItemUsageThink()
  ability_item_usage_generic.ItemUsageThink();
end

function BuybackUsageThink()
  ability_item_usage_generic.BuybackUsageThink();
end