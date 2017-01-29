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

  local wave = npcBot:GetAbilityByName(Abilities[1]);
  local leak = npcBot:GetAbilityByName(Abilities[2]);
  local mana = npcBot:GetAbilityByName(Abilities[3]);
  local ult = npcBot:GetAbilityByName(Abilities[6]);

  local creeps = npcBot:GetNearbyCreeps(1500, true)
  local enemyHeroes = npcBot:GetNearbyHeroes(600, true, BOT_MODE_NONE)

  local function considerManaLeak()
    if leak:IsFullyCastable() and npcBot:GetMana() - leak:GetManaCost() > mana:GetManaCost() then
      local enemyHero = Helper.GetHeroWith(npcBot, 'min', 'GetHealth', leak:GetCastRange(), true);
      if enemyHero ~= nil then
        return npcBot:Action_UseAbilityOnEntity(leak, enemyHero);
      end
    end
  end

  if npcBot:IsChanneling() then
    if wave:IsChanneling() and (#enemyHeroes >= 2 or npcBot:GetActiveMode() == BOT_MODE_RETREAT) then
      return npcBot:Action_UseAbility(wave);
    end
    return;
  end

  if #enemyHeroes >= 2 or npcBot:GetActiveMode() == BOT_MODE_RETREAT then
    return considerManaLeak();
  end

  if wave:IsFullyCastable() and npcBot:GetMana() > mana:GetManaCost() and npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
    if #creeps >= 3 then
      local neutralCreeps = 0;
      local castTarget = nil;
      for _, creep in pairs(creeps) do
        if (creep ~= nil) then
          if string.find(creep:GetUnitName(), 'neutral') then
            neutralCreeps = neutralCreeps + 1;
          else
            castTarget = creep;
          end
        end
      end
      if castTarget ~= nil and #creeps - neutralCreeps > 0 then
        return npcBot:Action_UseAbilityOnLocation(wave, castTarget:GetLocation());
      end
    end
  end

  considerManaLeak();

  -- if ult:IsFullyCastable() and npcBot:GetMana() - ult:GetManaCost() > waveAndManaCombo then
  --   npcBot:Action_UseAbility(ult);
  -- end
  if mana:IsFullyCastable() then
    local target = Helper.GetHeroWith(npcBot, 'min', 'GetMana', mana:GetCastRange(), false);
    return npcBot:Action_UseAbilityOnEntity(mana, target);
  end

end

function ItemUsageThink()
  ability_item_usage_generic.ItemUsageThink();
end