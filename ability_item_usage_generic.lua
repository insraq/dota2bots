_G._savedEnv = getfenv()
module("ability_item_usage_generic", package.seeall)

-- Include this before require to fix Mac
local dir = GetScriptDirectory();
local function GetScriptDirectory()
  if string.sub(dir, 1, 6) == "/Users" then
    return string.match(dir, '.*/(.+)')
  end
  return dir;
end
-----------------------------------------

local Helper = require(GetScriptDirectory() .. "/helper");

local function considerGlyph(tower)
  if tower ~= nil then return end
  local recentValues = Helper.GetLastValues('Health:' .. tower:GetUnitName(), tower:GetHealth());
  if recentValues[5][1] - recentValues[1][1] > tower:GetHealth() * 0.5 and
    GetGlyphCooldown() == 0 then
      GetBot():ActionImmediate_Glyph();
  end
end

function ItemUsageThink()

  local npcBot = GetBot();

  considerGlyph(Helper.GetOutermostTower(GetTeam(), LANE_TOP));
  considerGlyph(Helper.GetOutermostTower(GetTeam(), LANE_MID));
  considerGlyph(Helper.GetOutermostTower(GetTeam(), LANE_BOT));

  if npcBot:IsChanneling() or npcBot:IsUsingAbility() then
    return;
  end

  local teammates = npcBot:GetNearbyHeroes(900, false, BOT_MODE_NONE);
  local enemies = npcBot:GetNearbyHeroes(900, true, BOT_MODE_NONE);

  for i = 0,5 do
    local item = npcBot:GetItemInSlot(i);

    if (item) and string.find(item:GetName(), "item_necronomicon") and item:IsFullyCastable() and #enemies >= 1 then
      npcBot:ActionPush_UseAbility(item);
    end

    if (item) and string.find(item:GetName(), "item_dagon") and item:IsFullyCastable() and #enemies >= 1 then
      local weakestEnemy = Helper.GetHeroWith(npcBot, 'min', 'GetHealth', item:GetCastRange(), true);
      if (weakestEnemy ~= nil) then
        npcBot:ActionPush_UseAbilityOnEntity(item, weakestEnemy);
      end
    end

    if (item) and (item:GetName() == "item_tpscroll" or item:GetName() == "item_travel_boots") and item:IsFullyCastable() then

      local target = nil;

      local enemy = Helper.GetEnemyLastSeenInfo(5.0);

      if npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then
        target = Helper.GetOutermostTower(GetTeam(), LANE_BOT):GetLocation();
      elseif npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID then
        target = Helper.GetOutermostTower(GetTeam(), LANE_MID):GetLocation();
      elseif npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then
        target = Helper.GetOutermostTower(GetTeam(), LANE_TOP):GetLocation();
      elseif npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT and item:GetName() == "item_travel_boots" and #enemy[LANE_BOT] < 3 then
        target = GetLaneFrontLocation(GetTeam(), LANE_BOT, 0.0);
      elseif npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID and item:GetName() == "item_travel_boots" and #enemy[LANE_MID] < 3 then
        target = GetLaneFrontLocation(GetTeam(), LANE_MID, 0.0);
      elseif npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP and item:GetName() == "item_travel_boots" and #enemy[LANE_TOP] < 3 then
        target = GetLaneFrontLocation(GetTeam(), LANE_TOP, 0.0);
      end

      if target ~= nil and #teammates < 2 and
        GetUnitToLocationDistance(npcBot, target) > 5000 and
        Helper.IsForward(npcBot:GetLocation(), target) then
        local offset = Vector(-500, -500);
        if (GetTeam() == TEAM_DIRE) then
          offset = Vector(500, 500)
        end
        npcBot:ActionPush_UseAbilityOnLocation(item, target + offset);
      end

    end

    if (item) and (
        item:GetName() == "item_mekansm" or
        item:GetName() == "item_pipe" or
        item:GetName() == "item_guardian_greaves" or
        item:GetName() == "item_crimson_guard"
      ) and item:IsFullyCastable() and teammates ~= nil and #teammates >=2 then
      if npcBot:GetHealth() <= 400 then
        npcBot:ActionPush_UseAbility(item);
      end
      for _, hero in pairs(teammates) do
        if (hero:GetHealth() <= 400) then
          npcBot:ActionPush_UseAbility(item);
        end
      end
    end

    if (item) and item:GetName() == "item_phase_boots" and item:IsFullyCastable() then
      npcBot:ActionPush_UseAbility(item);
    end

    if (item) and item:GetName() == "item_arcane_boots" and item:IsFullyCastable() then
      npcBot:ActionPush_UseAbility(item);
    end

    if (item) and item:GetName() == "item_shivas_guard" and item:IsFullyCastable() and #enemies >= 2 then
      npcBot:ActionPush_UseAbility(item);
    end

    if (item) and (item:GetName() == "item_invis_sword" or item:GetName() == "item_silver_edge") and
      item:IsFullyCastable() and
      npcBot:GetActiveMode() == BOT_MODE_RETREAT and
      npcBot:DistanceFromFountain() > 1500 then
      npcBot:ActionPush_UseAbility(item);
    end

    if (item) and
      (item:GetName() == "item_orchid" or item:GetName() == "item_recipe_bloodthorn") and
      item:IsFullyCastable() then
      local weakestEnemy = Helper.GetHeroWith(npcBot, 'min', 'GetHealth', item:GetCastRange(), true);
      if (weakestEnemy ~= nil) then
        npcBot:ActionPush_UseAbilityOnEntity(item, weakestEnemy);
      end
    end

    if (item) and
      item:GetName() == "item_sheepstick" and
      item:IsFullyCastable() then
      local target = Helper.GetHeroWith(npcBot, 'max', 'GetRawOffensivePower', item:GetCastRange(), true);
      if target ~= nil then
        npcBot:ActionPush_UseAbilityOnEntity(item, target);
      end
    end

    if (item) and
      item:GetName() == "item_blade_mail" and
      npcBot:WasRecentlyDamagedByAnyHero(2.0) and
      item:IsFullyCastable() then
      npcBot:ActionPush_UseAbility(item);
    end

    if (item) and
      npcBot:GetHealth() < npcBot:GetMaxHealth() - 200 and
      (not npcBot:HasModifier("modifier_tango_heal")) and
      item:GetName() == "item_tango" then
      local trees = npcBot:GetNearbyTrees(300);
      if (#trees > 0) then
        npcBot:Action_UseAbilityOnTree(item, trees[1]);
      end
    end

    if (item) and item:GetName() == "item_courier" and item:IsFullyCastable() then
      npcBot:ActionPush_UseAbility(item);
    end

    if (item) and item:GetName() == "item_flask" and item:IsFullyCastable() and npcBot:GetHealth() <= 200 then
      npcBot:ActionPush_UseAbilityOnEntity(item, npcBot);
    end

    if (item) and item:GetName() == "item_clarity" and item:IsFullyCastable() and npcBot:GetMana() <= 200 then
      npcBot:ActionPush_UseAbilityOnEntity(item, npcBot);
    end
  end

end

function BuybackUsageThink()
  local npcBot = GetBot();
  if npcBot:HasBuyback() then
    print(npcBot:GetUnitName());
  end
  if npcBot:IsAlive() or (not npcBot:HasBuyback()) then
    return;
  end
  if GetLaneFrontAmount(GetTeam(), LANE_TOP, false) < 0.2 or
    GetLaneFrontAmount(GetTeam(), LANE_MID, false) < 0.2 or
    GetLaneFrontAmount(GetTeam(), LANE_BOT, false) < 0.2 then
    npcBot:ActionImmediate_Buyback();
  end
end

function CourierUsageThink()
  local npcBot = GetBot();

  if not IsCourierAvailable() then
    return
  end

  if GetCourierState(GetCourier(GetNumCouriers() -1)) ~= COURIER_STATE_IDLE
  and  GetCourierState(GetCourier(GetNumCouriers() -1)) ~= COURIER_STATE_AT_BASE then
    return
  end

  if GetCourierState(GetCourier(GetNumCouriers() -1)) == COURIER_STATE_IDLE
    and GetCourier(GetNumCouriers() -1):DistanceFromFountain() > 200 then
    npcBot:ActionImmediate_Courier(GetCourier(GetNumCouriers() -1), COURIER_ACTION_RETURN);
    return
  end

  local limit = math.min(DotaTime(), 1000);

  if npcBot:IsAlive() and (npcBot:GetStashValue() >= limit or npcBot:GetCourierValue() >= limit) then
    npcBot:ActionImmediate_Courier(GetCourier(GetNumCouriers() -1), COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS);
    return
  end
end


for k,v in pairs(ability_item_usage_generic) do _G._savedEnv[k] = v end