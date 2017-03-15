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
  "keeper_of_the_light_illuminate",
  "keeper_of_the_light_mana_leak",
  "keeper_of_the_light_chakra_magic",
  "keeper_of_the_light_recall",
  "keeper_of_the_light_blinding_light",
  "keeper_of_the_light_spirit_form",
  "keeper_of_the_light_illuminate_end",
  "keeper_of_the_light_spirit_form_illuminate",
  "keeper_of_the_light_spirit_form_illuminate_end",
};

function AbilityUsageThink()

  local npcBot = GetBot();

  local wave = npcBot:GetAbilityInSlot(0);
  local leak = npcBot:GetAbilityByName(Abilities[2]);
  local mana = npcBot:GetAbilityByName(Abilities[3]);
  local ult = npcBot:GetAbilityByName(Abilities[6]);

  local creeps = npcBot:GetNearbyLaneCreeps(1500, true);
  local enemyHeroes = npcBot:GetNearbyHeroes(600, true, BOT_MODE_NONE);

  local function considerManaLeak()
    if leak:IsFullyCastable() and npcBot:GetMana() - leak:GetManaCost() > mana:GetManaCost() then
      local enemyHero = Helper.GetHeroWith(npcBot, 'min', 'GetHealth', leak:GetCastRange(), true);
      if enemyHero ~= nil then
        return npcBot:ActionPush_UseAbilityOnEntity(leak, enemyHero);
      end
    end
  end

  if npcBot:IsChanneling() or (npcBot:IsUsingAbility() and (not wave:IsInAbilityPhase())) then
    return;
  end

  if mana:IsFullyCastable() then
    local target = Helper.GetHeroWith(npcBot, 'min', 'GetMana', mana:GetCastRange(), false);
    return npcBot:ActionPush_UseAbilityOnEntity(mana, target);
  end

  if #enemyHeroes >= 2 or npcBot:GetActiveMode() == BOT_MODE_RETREAT then
    return considerManaLeak();
  end

  if wave:IsFullyCastable() and
    npcBot:GetMana() - wave:GetManaCost() > mana:GetManaCost() and
    npcBot:GetActiveMode() ~= BOT_MODE_RETREAT and
    #creeps >= 3 then
    return npcBot:ActionPush_UseAbilityOnLocation(wave, creeps[1]:GetLocation());
  end

  considerManaLeak();

  -- if ult:IsFullyCastable() and npcBot:GetMana() - ult:GetManaCost() > waveAndManaCombo then
  --   npcBot:ActionPush_UseAbility(ult);
  -- end
end

function ItemUsageThink()
  ability_item_usage_generic.ItemUsageThink();
end

function BuybackUsageThink()
  ability_item_usage_generic.BuybackUsageThink();
end