-- Include this before require to fix Mac
local dir = GetScriptDirectory();
local function GetScriptDirectory()
  if string.sub(dir, 1, 6) == "/Users" then
    return string.match(dir, '.*/(.+)')
  end
  return dir;
end
-----------------------------------------

local inspect = require(GetScriptDirectory() .. "/inspect");

local Helper = {};

Helper.Locations = {
  RadiantShop = Vector(-4739,1263),
  DireShop = Vector(4559,-1554),
  BotShop = Vector(7253,-4128),
  TopShop = Vector(-7236,4444),
}

function Helper.PP(val)
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
        npcBot:ActionImmediate_LevelAbility(ability);
      end
    end

  end
end

function Helper.PurchaseBootsAndTP(npcBot)

  local hasTravelBoots = false;
  local tpScroll = nil;
  local otherBoots = nil;

  for i = 0, 14 do
    local item = npcBot:GetItemInSlot(i);
    if (item) and item:GetName() == "item_travel_boots" then
      hasTravelBoots = true;
    end
    if (item) and item:GetName() == "item_tpscroll" then
      tpScroll = item;
    end
    if (item) and (item:GetName() == "item_phase_boots" or item:GetName() == "item_arcane_boots") then
      otherBoots = item;
    end
  end

  if hasTravelBoots then
    if tpScroll ~= nil then
      npcBot:ActionImmediate_SellItem(tpScroll);
    end
    if otherBoots ~= nil then
      npcBot:ActionImmediate_SellItem(otherBoots);
    end
  else
    Helper.PurchaseTP(npcBot);
  end

end

function Helper.PurchaseItems(npcBot, buildTable)
  if ( #buildTable == 0 ) then
    npcBot:SetNextItemPurchaseValue(0);
    return;
  end

  local sNextItem = buildTable[1];
  npcBot:SetNextItemPurchaseValue(GetItemCost(sNextItem));

  local function PurchaseItem(who)
    who:ActionImmediate_PurchaseItem( sNextItem );
    print(npcBot:GetUnitName() .. " purchased " .. sNextItem)
    table.remove(buildTable, 1);
  end

  if (npcBot:GetGold() >= GetItemCost(sNextItem)) then
    if (IsItemPurchasedFromSecretShop(sNextItem)) then
      if GetCourier(0):DistanceFromSecretShop() < 300 then
        PurchaseItem(GetCourier(0));
        npcBot:ActionImmediate_Courier(GetCourier(0), COURIER_ACTION_TRANSFER_ITEMS);
      elseif IsCourierAvailable() then
        npcBot:ActionImmediate_Courier(GetCourier(0), COURIER_ACTION_SECRET_SHOP);
      end
    else
      PurchaseItem(npcBot);
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
  npcBot:ActionImmediate_PurchaseItem("item_tpscroll");
  npcBot:ActionImmediate_PurchaseItem("item_tpscroll");
end

local cache = {};

function Helper.HasValueChanged(key, value, callback)
  if cache[key] ~= nil and cache[key] ~= value then
    callback(value, cache[key])
  end
  cache[key] = value;
end

local last = "";
function Helper.ChatIfChanged(text)
  if (last == text) then
    return;
  end
  last = text;
  GetBot():ActionImmediate_Chat(text, true);
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
  return GetTeamMember(botId);
end

function Helper.GetEnemyLastSeenInfo(maxTime)
  local IDs = GetTeamPlayers(GetOpposingTeam());
  local result = {
    [LANE_TOP] = {},
    [LANE_MID] = {},
    [LANE_BOT] = {},
  };
  for _,id in pairs(IDs) do
    local info = GetHeroLastSeenInfo(id);
    if IsHeroAlive(id) and info.time <= maxTime then
      local lane = LANE_TOP;
      if GetAmountAlongLane(LANE_MID, info.location).distance < GetAmountAlongLane(lane, info.location).distance then
        lane = LANE_MID;
      end
      if GetAmountAlongLane(LANE_BOT, info.location).distance < GetAmountAlongLane(lane, info.location).distance then
        lane = LANE_BOT;
      end
      local laneInfo = GetAmountAlongLane(lane, info.location);
      info.laneFrontDistance = laneInfo.distance;
      info.laneFrontAmount = laneInfo.amount;
      table.insert(result[lane], info);
    end
  end
  return result;
end

function Helper.TeamPushLane()

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

  if GetTower(team, TOWER_MID_3) ~= nil or
    GetBarracks(team, BARRACKS_MID_MELEE) ~= nil or
    GetBarracks(team, BARRACKS_MID_RANGED) ~= nil then
    return LANE_MID;
  end
  if GetTower(team, TOWER_BOT_3) ~= nil or 
    GetBarracks(team, BARRACKS_BOT_MELEE) ~= nil or
    GetBarracks(team, BARRACKS_BOT_RANGED) ~= nil then
    return LANE_BOT;
  end
  if GetTower(team, TOWER_TOP_3) ~= nil or
    GetBarracks(team, BARRACKS_TOP_MELEE) ~= nil or
    GetBarracks(team, BARRACKS_TOP_RANGED) ~= nil then
    return LANE_TOP;
  end

  return LANE_MID;

end

function Helper.SeparatePushLane(npcBot)

  -- local team = TEAM_RADIANT;
  -- if GetTeam() == TEAM_RADIANT then
  --   team = TEAM_DIRE;
  -- end

  -- if npcBot:GetAssignedLane() == LANE_MID and
  --   (GetTower(team, TOWER_MID_1) ~= nil or
  --   GetTower(team, TOWER_MID_2) ~= nil) then
  --   return LANE_MID;
  -- end

  -- if npcBot:GetAssignedLane() == LANE_BOT and
  --   (GetTower(team, TOWER_BOT_1) ~= nil or
  --   GetTower(team, TOWER_BOT_2) ~= nil) then
  --   return LANE_BOT;
  -- end

  -- if npcBot:GetAssignedLane() == LANE_TOP and
  --   (GetTower(team, TOWER_TOP_1) ~= nil or
  --   GetTower(team, TOWER_TOP_2) ~= nil) then
  --   return LANE_TOP;
  -- end

  return Helper.TeamPushLane();

end

function Helper.TeamAlive()
  local radiantAlive = 0;
  local direAlive = 0;

  local IDs = GetTeamPlayers(TEAM_RADIANT);
  for _,id in pairs(IDs) do
    if IsHeroAlive(id) then
      radiantAlive = radiantAlive + 1;
    end
  end

  IDs = GetTeamPlayers(TEAM_DIRE);
  for _,id in pairs(IDs) do
    if IsHeroAlive(id) then
      direAlive = direAlive + 1;
    end
  end

  if GetTeam() == TEAM_RADIANT then
    return radiantAlive, direAlive;
  end

  return direAlive, radiantAlive;

end

function Helper.GetPushDesire(npcBot, lane)

  if DotaTime() < 60 * 10 then
    return 0.1;
  end

  if Helper.SeparatePushLane(npcBot) == lane then

    if #npcBot:GetNearbyHeroes(900, true, BOT_MODE_NONE) > 0 then
      return 0.1;
    end

    if npcBot:GetHealth() < 400 or
      GetLaneFrontAmount(GetTeam(), LANE_TOP, false) < 0.2 or
      GetLaneFrontAmount(GetTeam(), LANE_MID, false) < 0.2 or
      GetLaneFrontAmount(GetTeam(), LANE_BOT, false) < 0.2 then
      return 0.25;
    end

    local max = math.max(GetDefendLaneDesire(LANE_TOP), 0.7)
    max = math.max(GetDefendLaneDesire(LANE_MID), max)
    max = math.max(GetDefendLaneDesire(LANE_BOT), max)

    return Clamp(GetLaneFrontAmount(GetTeam(), lane, false), 0.25, max - 0.01);

  end

  return 0.1;
end

function Helper.PushThink(npcBot, lane)

  if npcBot:IsChanneling() or npcBot:IsUsingAbility() then
    return;
  end

  local offset = -1600;
  local team, enemyTeam = Helper.TeamAlive();

  if (lane == LANE_TOP) then
    otherLanes = {LANE_MID, LANE_BOT};
  end
  if (lane == LANE_MID) then
    otherLanes = {LANE_TOP, LANE_BOT};
  end
  if (lane == LANE_BOT) then
    otherLanes = {LANE_MID, LANE_TOP};
  end

  local enemy = Helper.GetEnemyLastSeenInfo(5.0);

  if Helper.WeAreStronger(npcBot, 1600) and 
    #npcBot:GetNearbyHeroes(1600, false, BOT_MODE_NONE) >= #enemy[lane] and
    #npcBot:GetNearbyHeroes(1600, false, BOT_MODE_NONE) >= enemyTeam - #enemy[otherLanes[1]] - #enemy[otherLanes[2]] then
    -- Helper.ChatIfChanged("Stronger, moving to lane front");
    offset = 0;
  elseif Helper.WeAreStronger(npcBot, 1600) and
    #npcBot:GetNearbyHeroes(1600, false, BOT_MODE_NONE) >= #enemy[lane] then
    -- Helper.ChatIfChanged("Might be stronger, moving behind the lane front");
    offset = -500;
  else
    -- Helper.ChatIfChanged("Weaker, wait for teammates");
  end

  npcBot:ActionPush_MoveToLocation(
    GetLaneFrontLocation(GetTeam(), lane, offset) - Helper.RandomForwardVector(npcBot:GetAttackRange() * 0.8)
  );
  local creeps = npcBot:GetNearbyLaneCreeps(npcBot:GetAttackRange(), true);
  if #creeps > 0 then
    npcBot:ActionPush_AttackUnit(creeps[1], false)
  end
end

function Helper.WeAreStronger(npcBot, radius)

  local mates = npcBot:GetNearbyHeroes(radius, false, BOT_MODE_NONE);
  local enemies = npcBot:GetNearbyHeroes(radius, true, BOT_MODE_NONE);

  local ourPower = 0;
  local enemyPower = 0;

  for _, h in pairs(mates) do
    ourPower = ourPower + h:GetOffensivePower();
  end

  for _, h in pairs(enemies) do
    enemyPower = enemyPower + h:GetRawOffensivePower();
  end

  return #mates > #enemies and ourPower > enemyPower;

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
  end

  return GetAncient(team);

end

function Helper.RandomForwardVector(length)
  local offset = RandomVector(length);
  if GetTeam() == TEAM_RADIANT then
    offset.x = offset.x > 0 and offset.x or -offset.x;
    offset.y = offset.y > 0 and offset.y or -offset.y;
  end
  if GetTeam() == TEAM_DIRE then
    offset.x = offset.x < 0 and offset.x or -offset.x;
    offset.y = offset.y < 0 and offset.y or -offset.y;
  end
  return offset;
end

function Helper.IsForward(from, to)
  if GetTeam() == TEAM_RADIANT then
    return to.x - from.x > 0 or to.y - from.y > 0;
  end
  return to.x - from.x < 0 or to.y - from.y < 0;
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