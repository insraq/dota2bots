local Helper = require(GetScriptDirectory() .. "/helper");

function GetDesire()
  return Helper.GetPushDesire(GetBot(), LANE_BOT);
end

function OnStart()

  local npcBot = GetBot();
  npcBot:Action_Chat("Pushing Bottom", true);

end

function Think()

  Helper.PushThink(GetBot(), LANE_BOT);

end