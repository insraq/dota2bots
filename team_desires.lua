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

----------------------------------------------------------------------------------------------------

-- function UpdatePushLaneDesires()

-- 	-- { Top Middle Bottom }

-- end

----------------------------------------------------------------------------------------------------

-- function UpdateDefendLaneDesires()
-- 	-- { Top Middle Bottom }
-- 	return { 0.5, 0.5, 0.5};

-- end

----------------------------------------------------------------------------------------------------

-- function UpdateFarmLaneDesires()
-- 	{ Top Middle Bottom }
-- 	if (DotaTime() <= 60 * 5) then
-- 		return { 0, 0, 0 };
-- 	end

-- 	return { 0.5, 0.5, 0.5 }

-- end

----------------------------------------------------------------------------------------------------

-- function UpdateRoamDesire()
  -- { Desire Unit }
  -- return { 0.5, GetTeamMember( TEAM_RADIANT, 1 ) };

-- end

----------------------------------------------------------------------------------------------------

-- function UpdateRoshanDesire()

-- 	return 0;

-- end

----------------------------------------------------------------------------------------------------
