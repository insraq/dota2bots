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
    npcBot:SetNextItemPurchaseValue( 0 );
    return;
  end

  local sNextItem = buildTable[1];
  npcBot:SetNextItemPurchaseValue( GetItemCost( sNextItem ) );

  if ( npcBot:GetGold() >= GetItemCost( sNextItem ) ) then

    local function PurchaseItem(who)
      who:ActionImmediate_PurchaseItem( sNextItem );
      print(npcBot:GetUnitName() .. " purchased " .. sNextItem)
      table.remove(buildTable, 1);
      npcBot:SetNextItemPurchaseValue(0);
    end

    if (IsItemPurchasedFromSecretShop(sNextItem)) then
      if npcBot:DistanceFromSecretShop() < 300 then
        PurchaseItem(npcBot);
      elseif GetCourier(0):DistanceFromSecretShop() < 300 then
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

  local team = TEAM_RADIANT;
  if GetTeam() == TEAM_RADIANT then
    team = TEAM_DIRE;
  end

  if npcBot:GetAssignedLane() == LANE_MID and
    (GetTower(team, TOWER_MID_1) ~= nil or
    GetTower(team, TOWER_MID_2) ~= nil) then
    return LANE_MID;
  end

  if npcBot:GetAssignedLane() == LANE_BOT and
    (GetTower(team, TOWER_BOT_1) ~= nil or
    GetTower(team, TOWER_BOT_2) ~= nil) then
    return LANE_BOT;
  end

  if npcBot:GetAssignedLane() == LANE_TOP and
    (GetTower(team, TOWER_TOP_1) ~= nil or
    GetTower(team, TOWER_TOP_2) ~= nil) then
    return LANE_TOP;
  end

  return Helper.TeamPushLane();

end

function Helper.GetPushDesire(npcBot, lane)

   for i = 0,5 do
    local item = npcBot:GetItemInSlot(i);
    if (item) and (string.find(item:GetName(), "item_necronomicon") or item:GetName() == "item_mekansm") then
      if Helper.SeparatePushLane(npcBot) == lane then
        local enemyHeroes = npcBot:GetNearbyHeroes(1500, true, BOT_MODE_NONE);
        if enemyHeroes ~= nil and #enemyHeroes > 0 then
          return 0.1;
        end
        if npcBot:GetHealth() < 500 then
          return 0.25;
        end
        if GetLaneFrontAmount(GetTeam(), LANE_TOP, false) < 0.3 or GetLaneFrontAmount(GetTeam(), LANE_MID, false) < 0.3 or GetLaneFrontAmount(GetTeam(), LANE_BOT, false) < 0.3 then
          return 0.25;
        end
        if GetUnitToLocationDistance(npcBot, GetLaneFrontLocation(GetTeam(), lane, 0.0)) < 500 then
          return Clamp(GetLaneFrontAmount(GetTeam(), lane, false) + 0.25, 0.25, 0.5);
        end
        return Clamp(GetLaneFrontAmount(GetTeam(), lane, false) + 0.25, 0.25, 0.9);
      end
    end
  end
  return 0.1;
end

function Helper.PushThink(npcBot, lane)
  if npcBot:IsChanneling() or npcBot:IsUsingAbility() then
    return;
  end
  npcBot:ActionPush_MoveToLocation(
    GetLaneFrontLocation(GetTeam(), lane, 0) - Helper.RandomForwardVector(npcBot:GetAttackRange() * 0.8)
  );
  local creeps = npcBot:GetNearbyLaneCreeps(npcBot:GetAttackRange(), true);
  if #creeps > 0 then
    npcBot:ActionPush_AttackUnit(creeps[1], false)
  end
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