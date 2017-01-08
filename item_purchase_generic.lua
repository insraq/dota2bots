

local tableItemsToBuy = { 
				"item_flask",
				"item_clarity",
				"item_clarity",
				"item_branches",
				"item_branches",
				"item_boots",
				"item_blades_of_attack",
				"item_blades_of_attack",
				"item_belt_of_strength",
				"item_staff_of_wizardry",
				"item_recipe_necronomicon",
				"item_recipe_necronomicon",
				"item_recipe_necronomicon",
				"item_yasha",
				"item_ultimate_orb",
				"item_manta",
			};


----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()

	local npcBot = GetBot();

	if ( #tableItemsToBuy == 0 ) then
		npcBot:SetNextItemPurchaseValue( 0 );
		return;
	end

	local sNextItem = tableItemsToBuy[1];
	npcBot:SetNextItemPurchaseValue( GetItemCost( sNextItem ) );

	if ( npcBot:GetGold() >= GetItemCost( sNextItem ) ) then
		npcBot:Action_PurchaseItem( sNextItem );
		print(npcBot:GetUnitName() .. " purchased " .. sNextItem)
		table.remove( tableItemsToBuy, 1 );
		npcBot:SetNextItemPurchaseValue( 0 );
	end

end

----------------------------------------------------------------------------------------------------
