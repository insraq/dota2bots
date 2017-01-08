

----------------------------------------------------------------------------------------------------

_G._savedEnv = getfenv()
module( "ability_item_usage_generic", package.seeall )

----------------------------------------------------------------------------------------------------

function AbilityUsageThink()

	--print( "Generic.AbilityUsageThink" );

end

----------------------------------------------------------------------------------------------------

function ItemUsageThink()

    local npcBot = GetBot();
	
    for i = 0,5 do
        local item = npcBot:GetItemInSlot(i);

		if (item) and item:GetName() == "item_arcane_boots" then
            if (item:IsFullyCastable()) then
                print(npcBot:GetUnitName() .. " used " .. item:GetName())
                npcBot:Action_UseAbility(item);
            end
		end

        if (item) and item:GetName() == "item_necronomicon" then
            if (item:IsFullyCastable()) then
                print(npcBot:GetUnitName() .. " used " .. item:GetName())
                npcBot:Action_UseAbility(item);
            end
        end

        if (item) and item:GetName() == "item_manta" then
            if (item:IsFullyCastable()) then
                print(npcBot:GetUnitName() .. " used " .. item:GetName())
                npcBot:Action_UseAbility(item);
            end
        end

        if (item) and item:GetName() == "item_flask" then
            if (npcBot:GetHealth() <= 200) then
                print(npcBot:GetUnitName() .. " used " .. item:GetName())
                npcBot:Action_UseAbilityOnEntity(item, npcBot);
            end
        end

        if (item) and item:GetName() == "item_clarity" then
            if (npcBot:GetMana() <= 200) then
                print(npcBot:GetUnitName() .. " used " .. item:GetName())
                npcBot:Action_UseAbilityOnEntity(item, npcBot);
            end
        end
    end

end

----------------------------------------------------------------------------------------------------


for k,v in pairs( ability_item_usage_generic ) do	_G._savedEnv[k] = v end
