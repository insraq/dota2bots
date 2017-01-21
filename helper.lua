local inspect = require(GetScriptDirectory() .. "/inspect");

local Helper = {};

Helper.Locations = {
  RadiantShop = Vector(-4739,1263),
  DireShop = Vector(4559,-1554),
  BotShop = Vector(7253,-4128),
  TopShop = Vector(-7236,4444),
}

function Helper.Print(val)
  print(inspect(val))
end

function Helper.AbilityUpgrade(npcBot, abilities)

  if npcBot:GetAbilityPoints() == 0 or DotaTime() < 0 or #abilities == 0 then
    return;
  end

  for i, ability in pairs(abilities) do

    local handle = npcBot:GetAbilityByName(ability);

    if handle ~= nil then
      if handle:GetLevel() == handle:GetMaxLevel() then
        table.remove(abilities, i);
      elseif handle:CanAbilityBeUpgraded() then
        npcBot:Action_LevelAbility(ability);
      end
    end

  end
end

function Helper.PurchaseTP(npcBot)

  if npcBot:GetGold() < GetItemCost("item_tpscroll") * 2 then
    return;
  end

  for i = 0, 14 do
    local item = npcBot:GetItemInSlot(i);
    if (item) and item:GetName() == "item_tpscroll" then
      return;
    end
  end
  npcBot:Action_PurchaseItem("item_tpscroll");
  npcBot:Action_PurchaseItem("item_tpscroll");
end

function Helper.GetOutermostTower(team, lane)

  if lane == 'TOP' then
    if GetTower(team, TOWER_TOP_1) ~= nil then
      return GetTower(team, TOWER_TOP_1);
    end
    if GetTower(team, TOWER_TOP_2) ~= nil then
      return GetTower(team, TOWER_TOP_2);
    end
    if GetTower(team, TOWER_TOP_3) ~= nil then
      return GetTower(team, TOWER_TOP_3);
    end
    return nil;
  end

  if lane == 'MID' then
    if GetTower(team, TOWER_MID_1) ~= nil then
      return GetTower(team, TOWER_MID_1);
    end
    if GetTower(team, TOWER_MID_2) ~= nil then
      return GetTower(team, TOWER_MID_2);
    end
    if GetTower(team, TOWER_MID_3) ~= nil then
      return GetTower(team, TOWER_MID_3);
    end
    if GetTower(team, TOWER_BASE_1) ~= nil then
      return GetTower(team, TOWER_BASE_1);
    end
    if GetTower(team, TOWER_BASE_2) ~= nil then
      return GetTower(team, TOWER_BASE_2);
    end
    return nil;
  end

  if lane == 'BOT' then
    if GetTower(team, TOWER_BOT_1) ~= nil then
      return GetTower(team, TOWER_BOT_1);
    end
    if GetTower(team, TOWER_BOT_2) ~= nil then
      return GetTower(team, TOWER_BOT_2);
    end
    if GetTower(team, TOWER_BOT_3) ~= nil then
      return GetTower(team, TOWER_BOT_3);
    end
    return nil;
  end

  return nil;

end

function Helper.GetHeroWith(npcBot, comparison, attr, radius, enemy)

  local heroes = npcBot:GetNearbyHeroes(radius, enemy, BOT_MODE_NONE);
  local hero = npcBot;
  local value = npcBot[attr](npcBot);

  if enemy then
    hero = nil;
    value = 10000;
  end

  if comparison == 'max' then
    value = 0;
  end

  if heroes == nil or #heroes == 0 then
    return hero, value;
  end

  for _, h in pairs(heroes) do

    if h ~= nil and h:IsAlive() then

      local valueToCompare = h[attr](h);
      local success = valueToCompare < value;

      if comparison == 'max' then
        success = valueToCompare > value;
      end

      if success then
        value = valueToCompare;
        hero = h;
      end

    end
  end

  return hero, value;

end

return Helper;