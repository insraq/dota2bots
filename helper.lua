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

local cache = {};

function Helper.HasValueChanged(key, value, callback)
  if cache[key] ~= nil and cache[key] ~= value then
    callback(value, cache[key])
  end
  cache[key] = value;
end

local botId = nil;

function Helper.GetFirstBot()
  if botId == nil then
    local players = GetTeamPlayers(GetTeam());
    for _, v in pairs(players) do
      if IsPlayerBot(v) then
        botId = v;
        break;
      end
    end
  end
  return GetTeamMember(GetTeam(), botId);
end

function Helper.WhichLaneToPush()

	local team = TEAM_RADIANT;
	if GetTeam() == TEAM_RADIANT then
		team = TEAM_DIRE;
	end

	if GetTower(team, TOWER_MID_1) ~= nil then
		return LANE_MID;
	end
	if GetTower(team, TOWER_BOT_1) ~= nil then
		return LANE_BOT;
	end
	if GetTower(team, TOWER_TOP_1) ~= nil then
		return LANE_TOP;
	end

	if GetTower(team, TOWER_MID_2) ~= nil then
		return LANE_MID;
	end
	if GetTower(team, TOWER_BOT_2) ~= nil then
		return LANE_BOT;
	end
	if GetTower(team, TOWER_TOP_2) ~= nil then
		return LANE_TOP;
	end

	if GetTower(team, TOWER_MID_3) ~= nil then
		return LANE_MID;
	end
	if GetTower(team, TOWER_BOT_3) ~= nil then
		return LANE_BOT;
	end
	if GetTower(team, TOWER_TOP_3) ~= nil then
		return LANE_TOP;
	end

	return LANE_MID;

end

function Helper.GetPushDesire(npcBot, lane)

   for i = 0,5 do
    local item = npcBot:GetItemInSlot(i);
    if (item) and (string.find(item:GetName(), "item_necronomicon") or item:GetName() == "item_shivas_guard" or item:GetName() == "item_mekansm" or item:GetName() == "item_pipe") then
      if item:IsFullyCastable() and Helper.WhichLaneToPush() == lane then
        local enemyHeroes = npcBot:GetNearbyHeroes(1500, true, BOT_MODE_NONE);
        if enemyHeroes ~= nil and #enemyHeroes > 0 then
          return 0.1;
        end
        if npcBot:GetHealth() / npcBot:GetMaxHealth() < 0.5 then
          return 0.1;
        end
        if GetLaneFrontAmount(GetTeam(), LANE_TOP, false) < 0.3 or GetLaneFrontAmount(GetTeam(), LANE_MID, false) < 0.3 or GetLaneFrontAmount(GetTeam(), LANE_BOT, false) < 0.3 then
          return 0.1;
        end
        if GetUnitToLocationDistance(npcBot, GetLaneFrontLocation(GetTeam(), lane, 0.0)) < 900 then
          return 0.1;
        end
        return Max(GetLaneFrontAmount(GetTeam(), lane, false) - 0.1, 0.1);
      end
    end
  end
  return 0.0;
end

function Helper.PushThink(npcBot, lane)

  return npcBot:Action_MoveToLocation(GetLaneFrontLocation(GetTeam(), lane, 0.0));

end

function Helper.GetOutermostTower(team, lane)

  if lane == LANE_TOP then
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

  if lane == LANE_MID then
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

  if lane == LANE_BOT then
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

function Helper.InspectBotMode(npcBot)
  local MODES = {
    "NONE",
    "LANING",
    "ATTACK",
    "ROAM",
    "RETREAT",
    "SECRET_SHOP",
    "SIDE_SHOP",
    "PUSH_TOWER_TOP",
    "PUSH_TOWER_MID",
    "PUSH_TOWER_BOT",
    "DEFEND_TOWER_TOP",
    "DEFEND_TOWER_MID",
    "DEFEND_TOWER_BOT",
    "ASSEMBLE",
    "TEAM_ROAM",
    "FARM",
    "DEFEND_ALLY",
    "EVASIVE_MANEUVERS",
    "ROSHAN",
    "ITEM",
    "WARD",
  };
  if (npcBot.previousMode ~= nil and npcBot.previousMode ~= npcBot:GetActiveMode()) then
    local message = "Bot Mode Change: " .. MODES[npcBot.previousMode] .. ' => ' .. MODES[npcBot:GetActiveMode()];
    -- Helper.Print(message);
  end
  npcBot.previousMode = npcBot:GetActiveMode()
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