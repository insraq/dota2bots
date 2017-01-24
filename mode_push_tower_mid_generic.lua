local Helper = require(GetScriptDirectory() .. "/helper");

function GetDesire()
  return Helper.GetPushDesire(GetBot(), LANE_MID);
end

function OnStart()

  local npcBot = GetBot();
  npcBot:Action_Chat("Pushing Middle", true);

end

function Think()
  Helper.PushThink(GetBot(), LANE_MID);
end