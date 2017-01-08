

----------------------------------------------------------------------------------------------------

function Think()

	-- For coach, 0 and 1 are reserved, start from 2
	local startIndex = 2;
	if ( GetTeam() == TEAM_RADIANT )
	then
		print( "selecting radiant" );
		SelectHero( startIndex + 0, "npc_dota_hero_drow_ranger" );
		SelectHero( startIndex + 1, "npc_dota_hero_luna" );
		SelectHero( startIndex + 2, "npc_dota_hero_vengefulspirit" );
		SelectHero( startIndex + 3, "npc_dota_hero_skeleton_king" );
		SelectHero( startIndex + 4, "npc_dota_hero_razor" );
	elseif ( GetTeam() == TEAM_DIRE )
	then
		print( "selecting dire" );
		SelectHero( startIndex + 5, "npc_dota_hero_drow_ranger" );
		SelectHero( startIndex + 6, "npc_dota_hero_earthshaker" );
		SelectHero( startIndex + 7, "npc_dota_hero_juggernaut" );
		SelectHero( startIndex + 8, "npc_dota_hero_mirana" );
		SelectHero( startIndex + 9, "npc_dota_hero_nevermore" );
	end

end

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
			[1] = LANE_BOT,
			[2] = LANE_BOT,
			[3] = LANE_TOP,
			[4] = LANE_BOT,
			[5] = LANE_MID,
		};
	end
end

----------------------------------------------------------------------------------------------------
