local Helper = require(GetScriptDirectory() .. "/helper");

local tableItemsToBuy = {

	"item_flask",
	"item_circlet",
	"item_mantle",

	"item_boots",
	"item_blades_of_attack",
	"item_blades_of_attack",

	"item_recipe_null_talisman",

	"item_belt_of_strength",
	"item_staff_of_wizardry",
	"item_recipe_necronomicon",
	"item_recipe_necronomicon",
	"item_recipe_necronomicon",

	"item_staff_of_wizardry",
	"item_recipe_dagon",

	"item_shadow_amulet",
	"item_cloak",

	"item_platemail",
	"item_mystic_staff",
	"item_recipe_shivas_guard",

	"item_recipe_dagon",
	"item_recipe_dagon",
	"item_recipe_dagon",
	"item_recipe_dagon",

};

local tableItemsToBuySupport = {
	"item_courier",
	"item_flask",
	"item_branches",
	"item_branches",

	"item_boots",
	"item_blades_of_attack",
	"item_blades_of_attack",

	"item_flying_courier",

	"item_ring_of_regen",
	"item_recipe_headdress",
	"item_chainmail",
	"item_recipe_buckler",
	"item_recipe_mekansm",

	"item_belt_of_strength",
	"item_staff_of_wizardry",
	"item_recipe_necronomicon",
	"item_recipe_necronomicon",
	"item_recipe_necronomicon",

	"item_ring_of_health",
	"item_cloak",
	"item_ring_of_regen",

	"item_ring_of_regen",
	"item_branches",
	"item_recipe_headdress",
	"item_recipe_pipe",

	"item_circlet",
	"item_mantle",
	"item_recipe_null_talisman",

	"item_staff_of_wizardry",
	"item_recipe_dagon",

	"item_recipe_dagon",
	"item_recipe_dagon",
	"item_recipe_dagon",
	"item_recipe_dagon",
};

local abilities = {
	"special_bonus_strength_6",
	"special_bonus_respawn_reduction_25",
	"special_bonus_armor_7",
	"special_bonus_unique_keeper_of_the_light",
	"keeper_of_the_light_chakra_magic",
	"keeper_of_the_light_illuminate",
  "keeper_of_the_light_mana_leak",
  "keeper_of_the_light_spirit_form",
}

local SupportPlayerID = nil;

----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()

	local npcBot = GetBot();
	local buildTable = tableItemsToBuy;

	Helper.AbilityUpgrade(npcBot, abilities);
	Helper.PurchaseTP(npcBot);

	-- Assign the first bot as support
	if SupportPlayerID == nil then
		local players = GetTeamPlayers(GetTeam());
		for _, v in pairs(players) do
			if IsPlayerBot(v) then
				SupportPlayerID = v;
				break;
			end
		end
	end

	if SupportPlayerID == npcBot:GetPlayerID() then
		buildTable = tableItemsToBuySupport;
	end

	if ( #buildTable == 0 ) then
		npcBot:SetNextItemPurchaseValue( 0 );
	  return;
	end

	local sNextItem = buildTable[1];
	npcBot:SetNextItemPurchaseValue( GetItemCost( sNextItem ) );

	if ( npcBot:GetGold() >= GetItemCost( sNextItem ) ) then

		local function PurchaseItem()
			npcBot:Action_PurchaseItem( sNextItem );
			print(npcBot:GetUnitName() .. " purchased " .. sNextItem)
			table.remove( buildTable, 1 );
			npcBot:SetNextItemPurchaseValue( 0 );
		end

		if (IsItemPurchasedFromSecretShop(sNextItem)) then

			if npcBot:DistanceFromSecretShop() < 300 then
				PurchaseItem();
			else
				local secretShop = Helper.Locations.RadiantShop;
				if (GetTeam() == TEAM_DIRE) then
					secretShop = Helper.Locations.DireShop;
				end
				npcBot:Action_MoveToLocation(secretShop);
			end

		else
			PurchaseItem();
		end
	end



end


----------------------------------------------------------------------------------------------------