

----------------------------------------------------------------------------------------------------

local MyBots={
  "npc_dota_hero_keeper_of_the_light",
  "npc_dota_hero_keeper_of_the_light",
  "npc_dota_hero_keeper_of_the_light",
  "npc_dota_hero_keeper_of_the_light",
  "npc_dota_hero_keeper_of_the_light"
};

function Think()
  local IDs = GetTeamPlayers(GetTeam());
  for i,id in pairs(IDs) do
    if IsPlayerBot(id) then
      SelectHero(id,MyBots[i]);
    end
  end

end

----------------------------------------------------------------------------------------------------

function UpdateLaneAssignments()
  if ( GetTeam() == TEAM_RADIANT ) then
    return {
      [1] = LANE_MID,
      [2] = LANE_TOP,
      [3] = LANE_TOP,
      [4] = LANE_BOT,
      [5] = LANE_BOT,
    };
  elseif ( GetTeam() == TEAM_DIRE ) then
    return {
      [1] = LANE_MID,
      [2] = LANE_TOP,
      [3] = LANE_TOP,
      [4] = LANE_BOT,
      [5] = LANE_BOT,
    };
  end
end

----------------------------------------------------------------------------------------------------