AllCraft_Decon = {}
AllCraft_Decon.name = AllCraft_Decon
LSet = LibSets

--{Features to add
--Mass Deconstruct Experiance:
--Hot key overwrite on Gamepad as needed reseting original settings on exit
--Option: Deconstruct Intricate On/Off/Training Order
--Option: Training order is the order you wish to get characters to lvl 50 in craftskill
--Option: Deconstruct Set
--Option: Allow Deconstuct from bank
--Option: MM/TTC Maximum Price for Deconstruct
--Option: Deconstruct Crafted
--Option: Deconstruct Ornate
--Option: Deconstuct Bound
--Option: Ignore Monster (Undaunted) sets
--Option: Maximum Quality to Deconstruct Below Max Extraction
--Option: Maximum Quality to Deconstruct at Max Extraction
--Static: While player has writ quests do not deconstruct


--Selectable settings
AllCraft_Decon.deconSettings = {}

AllCraft_Decon.deconDefaults = {
	DebugOn = false,
	SmartSettings = true,
	ListBeforeDeconstruct = true,
	AccountWide = true,
	PricingOn = true,
	UseBank = true,
	KeepCertMats = true,
	DeconstructBound = false,
	DeconstructSetPiece = false,
	Deconstruct_Set_Type_Crafted = false,
	Deconstruct_Set_Type_Monster = false,
	Deconstruct_Set_Type_Dungeon = true,
	Deconstruct_Set_Type_Trial = false,
	Deconstruct_Set_Type_Arena = true,
	Deconstruct_Set_Type_Overland = true,
	Deconstruct_Set_Type_Cyrodiil = true,
	Deconstruct_Set_Type_Battleground = true,
	Deconstruct_Set_Type_Imperial_City = true,
	Deconstruct_Set_Type_Special = true,
	Deconstruct_Set_Type_Daily_Reward = true,
	DeconstructOrnate = false,
	DeconstructCrafted = false,
	MMMax = 1000,
	TTCMax = 1000,
	DeconstructIntricate = true,
	maxNormBlacksmith	= 3,
	maxMasterBlacksmith = 4,
	maxNormClothier	= 3,
	maxMasterClothier = 4,
	maxNormJewler	= 3,
	maxMasterJewler = 4,
	maxNormWoodworker	= 3,
	maxMasterWoodworker = 4,
	maxNormEnchanting	= 3,
	maxMasterEnchanting = 4,
}

--Management
local function DebugMessage(message)
  if AllCraft_Decon.deconSettings.DebugOn then
    d(message)
  end
end

local function CharacterDeconHere(craftTableType)
	if AllCraft_Decon.deconSettings.SmartSettings then
		if AllCraft_CharacterInfo.ExpertiseLevel(craftTableType) ~= 3 and
		AllCraft_CharacterInfo.CraftingSkillLevel(craftTableType) == 50 then
			return false
		end
	end
	return true
end

local function CharacterRefineHere(craftTableType)
	local EnchantTable = (craftTableType == CRAFTING_TYPE_ENCHANTING)
	if EnchantTable then return false end
	if AllCraft_Decon.deconSettings.SmartSettings then
		if AllCraft_CharacterInfo.ExpertiseLevel(craftTableType) ~= 3 then
			return false
		end
	end
	return true
end

local function DeconstructAllList()

	local itemString = #DeconstructList == 1 and 'item' or 'items'
	d('Auto Deconstruct will destroy:')
	for index, thing in ipairs(DeconstructList) do
		d(' - ' .. thing.itemLink)
	end
	d(#DeconstructList .. ' ' .. itemString)
end

--Refine Check
local function GetRefineItems(bagId)
	local slotIndex = ZO_GetNextBagSlotIndex(bagId)

	while slotIndex do -- Sort through each slot in selected bag.
		if CanItemBeRefined(bagId, slotIndex, GetCraftingInteractionType()) then
			local craftTrainingMats = {[812]=true,[802]=true,[808]=true,[135137]=true}
			local itemLink = GetItemLink(bagId, slotIndex, LINK_STYLE_BRACKETS)
			local backpackCount, bankCount, craftBagCount = GetItemLinkStacks(itemLink)
			local quantity = backpackCount + bankCount + craftBagCount
			local step = GetRequiredSmithingRefinementStackSize() or 1
			quantity = zo_floor(quantity / step) * step -- round quantity to next step down
			if AllCraft_Decon.deconDefaults.KeepCertMats and
			craftTrainingMats[GetItemLinkItemId(itemLink)] then
				quantity = quantity - 10
			end
			if quantity >= GetRequiredSmithingRefinementStackSize() then -- add to refine list
			--**ToBeAdded** keep training quantity unrefined option.
				local x = {}
				x.bagId = bagId
				x.slotIndex = slotIndex
				x.quantity = quantity
				x.itemLink = itemLink
				table.insert(RefineList, x)
			end
		end
		slotIndex = ZO_GetNextBagSlotIndex(bagId, slotIndex)
	end
	--**ToBeAdded** Sort list to total remove duplicates since we are iterating through all bags.
end

--Options Checks
local function GetTTCPrice(itemLink)
	local TTCPrice = nil
	local TTCPrice =  TamrielTradeCentrePrice:GetPriceInfo(itemLink)
	--returns priceDict.Avg, priceDict.Max, priceDict.Min, priceDict.EntryCount, priceDict.AmountCount, priceDict.SuggestedPrice
	DebugMessage("Checking TTC")
	if not TTCPrice == nil then
		local TTCSugestedPrice = nil
		TTCSugestedPrice = TTCPrice.SuggestedPrice
		if  not TTCSugestedPrice == nil then
			if TTCSugestedPrice > AllCraft_Decon.deconSettings.TTCMax then
				DebugMessage("TTC Suggested Price " .. TTCSugestedPrice .. " out of range." )
				return false
			end
		end
	end
	return true
end

local function getMMPrice(itemLink)

	MMPrice = MasterMerchant.GetItemLinePrice(itemLink)
	if MMPrice > AllCraft_Decon.deconSettings.MMMax then
		DebugMessage(itemLink .. MMPrice .. " out of range." )
		return false
	end

	return true

end

local function IsBound(itemLink)
	if(IsItemLinkBound(itemLink)) then
      DebugMessage(itemLink .. "Item is already bound")
      return true
    else
		return false
	end
end

local function IsOrnate(bagId,slotIndex)
	local traitInformation = GetItemTraitInformation(bagId, slotIndex)
	if traitInformation == ITEM_TRAIT_INFORMATION_ORNATE then
	  DebugMessage(' - ornate through GetItemTraitInformation')
	  return true
	end
	local trait = GetItemTrait(bagid, slotIndex)
	if trait == ITEM_TRAIT_TYPE_ARMOR_ORNATE or trait == ITEM_TRAIT_TYPE_WEAPON_ORNATE or trait == ITEM_TRAIT_TYPE_JEWELRY_ORNATE then
	  DebugMessage(' - ornate through GetItemTrait')
	  return true
	end
	return false
end

local function IsIntricate(bagId, slotIndex)
	local traitInformation = GetItemTraitInformation(bagId, slotIndex)
	if traitInformation == ITEM_TRAIT_INFORMATION_INTRICATE then
	  DebugMessage(' - intricate through GetItemTraitInformation')
	  return true
	end
	local trait = GetItemTrait(bagId, slotIndex)
	if trait == ITEM_TRAIT_TYPE_ARMOR_INTRICATE or trait == ITEM_TRAIT_TYPE_WEAPON_INTRICATE or trait == ITEM_TRAIT_TYPE_JEWELRY_INTRICATE then
	  DebugMessage(' - intricate through GetItemTrait')
	  return true
	end
	return false
end

  local function ExternallyProtected( bagId, slotIndex ) -- Credit Mass Deconstructor by: ahmetertem, MaralieRindu because I was too lazy.
	--Item Saver support
	if ItemSaver_IsItemSaved and ItemSaver_IsItemSaved(bagId, slotIndex) then
	  return true
	end

	-- If an item has any FCOIS marks apart from "deconstruct" then it's proteected
	if FCOIsMarked and FCOIsMarked(GetItemInstanceId(bagId, slotIndex), {1,2,3,4,5,6,7,8,10,11,12}) then -- 9 is deconstruct
	  --Old FCOIS version < 1.0
		return true
	elseif FCOIS and FCOIS.IsMarked and FCOIS.IsMarked(bagId, slotIndex, {1,2,3,4,5,6,7,8,10,11,12}, nil)then
	  --New for FCOIS version >= 1.0
	  return true
	end

	--FilterIt support
   if FilterIt and FilterIt.AccountSavedVariables and FilterIt.AccountSavedVariables.FilteredItems then
	  local sUniqueId = Id64ToString(GetItemUniqueId(bagId, slotIndex))
	  if FilterIt.AccountSavedVariables.FilteredItems[sUniqueId] then
		  return FilterIt.AccountSavedVariables.FilteredItems[sUniqueId] ~= FILTERIT_VENDOR
	  end
   end

	  return false
end

--Deconstruct Check
AllCraft_Decon.HasWrits = {}
local function ShouldDecon(bagId, slotIndex, itemLink, craftTableType)

	--Process options
	if ExternallyProtected ( bagId, slotIndex ) then return false end

	--Option is Intricate(Yes, no, Under 50)
	if IsIntricate(bagId, slotIndex) then
		if not AllCraft_Decon.deconSettings.DeconstructIntricate or
		AllCraft_Decon.deconSettings.SmartSettings and
		AllCraft_CharacterInfo.CraftingSkillLevel(craftTableType) == 50	then
			return false
		end
	end

	--Option is Crafted(Yes, No, InWritCrafting)
	if IsItemLinkCrafted(itemLink) then
		if not AllCraft_Decon.deconSettings.DeconstructCrafted or
		AllCraft_Decon.deconSettings.SmartSettings and
		AllCraft_Decon.HasWrits then
			return false
		end
	end

	--Option: Deconstruct Ornate
	if IsOrnate(bagId,slotIndex) and not AllCraft_Decon.deconSettings.DeconstructOrnate then return false end

	--Option: Bound(yes, no)
	if IsBound(itemLink) and not AllCraft_Decon.deconSettings.DeconstructBound then return false end

	--Option: Set
	IsSet,SetName,SetID = LSet.IsSetByItemLink(itemLink)
	if IsSet then
		if not AllCraft_Decon.deconSettings.DeconstructSetPiece then return false end
		
		if LSet.IsCraftedSet(SetID) and not AllCraft_Decon.deconSettings.DeconstructSetCrafted then return false end
		if LSet.IsMonsterSet(SetID) and not AllCraft_Decon.deconSettings.DeconstructSetMonster then return false end
		if LSet.IsDungeonSet(SetID) and not AllCraft_Decon.deconSettings.DeconstructSetDungeon then return false end
		if LSet.IsTrialSet(SetID) and not AllCraft_Decon.deconSettings.DecondtructSetTrial then return false end
		if LSet.IsArenaSet(SetID) and not AllCraft_Decon.deconSettings.DecondtructSetArena then return false end
		if LSet.IsOverlandSet(SetID) and not AllCraft_Decon.deconSettings.DeconstructSetOverland then return false end
		if LSet.IsCyrodiilSet(SetID) and not AllCraft_Decon.deconSettings.DeconstructSetCyrodiil then return false end
		if LSet.IsBattlegroundSet(SetID) and not AllCraft_Decon.deconSettings.DeconstructSetBattleground then return false end
		if LSet.IsImperialCitySet(SetID) and not AllCraft_Decon.deconSettings.DeconstructSetImperialCity then return false end
		if LSet.IsSpecialSet(SetID) and not AllCraft_Decon.deconSettings.DeconstructSetSpecial then return false end
		if LSet.IsDailyRandomDungeonAndImperialCityRewardSet(SetID) and not AllCraft_Decon.deconSettings.DeconstructSetDailyReward then return false end

	end

	--Option: Above Master Merchant Maximum Allowed
	if MasterMerchant and AllCraft_Decon.deconSettings.PricingOn then
		if not getMMPrice(itemLink) then return false end
	end

	--Option: Above Tamriel Trade Centre Maximum Allowed
	if TamrielTradeCentre and AllCraft_Decon.deconSettings.PricingOn then
		if not GetTTCPrice(itemLink) then return false end
	end

	local icon, stack, sellPrice, meetsUsageRequirement, locked, equipType, itemStyleId, quality = GetItemInfo(bagId, slotIndex)
	if quality > CurrentUserDeconstructLevel then return false end

	DebugMessage(itemLink .. " added to list")


	return true
end

local function SelectDeconItems(bagId, craftTableType)
	local slotIndex = ZO_GetNextBagSlotIndex(bagId)

    while slotIndex do
		if CanItemBeDeconstructed(bagId, slotIndex, GetCraftingInteractionType()) and
			not IsItemPlayerLocked(bagId, slotIndex) then
			local itemLink = GetItemLink(bagId, slotIndex, LINK_STYLE_BRACKETS)
			if ShouldDecon(bagId, slotIndex, itemLink, craftTableType) then
				local x = {}
				x.bagId = bagId
				x.slotIndex = slotIndex
				x.itemLink = itemLink
				table.insert(DeconstructList, x)
			end
		end
		slotIndex = ZO_GetNextBagSlotIndex(bagId, slotIndex)
    end

    DebugMessage("Deconstruct queue length: " .. #DeconstructList)
end

local function GetBagItems(craftTableType)
	local readyDecon = {}
	if not SelectDeconItems(BAG_BACKPACK, craftTableType) then readyDecon = false end

	if AllCraft_Decon.deconSettings.UseBank then
		if not SelectDeconItems(BAG_BANK, craftTableType) then readyDecon = false end
		if IsESOPlusSubscriber() then
			if not SelectDeconItems(BAG_SUBSCRIBER_BANK, craftTableType) then
				readyDecon = false
			end
		end
	end
end

--Setup Keys
local function RefineKey()
	local function createList()
	local readyRefine = {}
		if not GetRefineItems(BAG_BACKPACK) then readyRefine = false end
		if HasCraftBagAccess() then
			if not GetRefineItems(BAG_VIRTUAL) then readyRefine = false end
		end

		if AllCraft_Decon.deconSettings.UseBank then
			if not GetRefineItems(BAG_BANK) then readyRefine = false end
			if IsESOPlusSubscriber() then
				if not GetRefineItems(BAG_SUBSCRIBER_BANK) then
					readyRefine = false
				end
			end
		end
		--**ToBeAdded** check for array add failures.
	end
	createList()
	if #RefineList ~= 0 then
	AllCraft.InCraftingState = "refine"
		PrepareDeconstructMessage()
		for index, thing in ipairs(RefineList) do
			AddItemToDeconstructMessage(thing.bagId, thing.slotIndex, thing.quantity)
			table.remove(RefineList, index)
		end
		SendDeconstructMessage()
	end
end
AllCraft_Decon.RefineKey = RefineKey

function DeconstructKey()
	PrepareDeconstructMessage()
	for index, thing in ipairs(DeconstructList) do
		AddItemToDeconstructMessage(thing.bagId, thing.slotIndex)
	end
	SendDeconstructMessage()
end

local function KeyStrip(craftTableType)
	local KeybindStripDescriptor = {alignment = KEYBIND_STRIP_ALIGN_LEFT}
	local AddDeconOption = {
		name = GetString(SI_BINDING_NAME_ALLCRAFT_DECON_AUTO_DECONSTRUCT),
		keybind = "ALLCRAFT_DECON_AUTO_DECONSTRUCT",
		callback = function() DeconstructKey() end,
		}
	local AddRefineOption = {
		name = GetString(SI_BINDING_NAME_ALLCRAFT_DECON_AUTO_REFINE),
		keybind = "ALLCRAFT_DECON_AUTO_REFINE",
		callback = function() RefineKey() end,
		}

	if CharacterDeconHere(craftTableType) then
		table.insert( KeybindStripDescriptor, AddDeconOption )
	end

	if CharacterRefineHere(craftTableType) then
		table.insert( KeybindStripDescriptor, AddRefineOption )
	end

	return KeybindStripDescriptor
end

--Deconstruct Interaction
local function CraftTableInteract(eventCode,craftTableType)
	--Ignore non-deconstruction type tables
	if craftTableType == CRAFTING_TYPE_ALCHEMY
	or craftTableType == CRAFTING_TYPE_PROVISIONING
	or craftTableType == CRAFTING_TYPE_INVALID 	then
		DebugMessage("Current table does not support deconstruction")
		return false
	end

	local TableNorm = {}
	local TableMaster = {}

	TableNorm[1] = AllCraft_Decon.deconSettings.maxNormBlacksmith
	TableMaster[1] = AllCraft_Decon.deconSettings.maxMasterBlacksmith
	TableNorm[2] = AllCraft_Decon.deconSettings.maxNormClothier
	TableMaster[2] = AllCraft_Decon.deconSettings.maxMasterClothier
	TableNorm[7] = AllCraft_Decon.deconSettings.maxNormJewler
	TableMaster[7] = AllCraft_Decon.deconSettings.maxMasterJewler
	TableNorm[6] = AllCraft_Decon.deconSettings.maxNormWoodworker
	TableMaster[6] = AllCraft_Decon.deconSettings.maxMasterWoodworker
	TableNorm[3] = AllCraft_Decon.deconSettings.maxNormEnchanting
	TableMaster[3] = AllCraft_Decon.deconSettings.maxMasterEnchanting

	if AllCraft_CharacterInfo.ExpertiseLevel(craftTableType) == 3 then
		CurrentUserDeconstructLevel = TableMaster[craftTableType]
	else
		CurrentUserDeconstructLevel = TableNorm[craftTableType]
	end
	if not AllCraft_Decon.deconSettings.SmartSettings or
	AllCraft_Decon.deconSettings.SmartSettings and
	CharacterDeconHere(craftTableType) then
		GetBagItems(craftTableType)
		if AllCraft_Decon.deconSettings.ListBeforeDeconstruct then DeconstructAllList()	end
	end

	KeybindStripDescriptor = KeyStrip(craftTableType)

	if KeybindStripDescriptor ~= nil then
	KEYBIND_STRIP:AddKeybindButtonGroup(KeybindStripDescriptor)
	KEYBIND_STRIP:UpdateKeybindButtonGroup(KeybindStripDescriptor)
	end
end
AllCraft_Decon.CraftTableInteract = CraftTableInteract

local function CraftTableLeave()

	KEYBIND_STRIP:RemoveKeybindButtonGroup(KeybindStripDescriptor)
end
AllCraft_Decon.CraftTableLeave = CraftTableLeave

--Initialize
local function DeconInitialize()

	RefineList = {}
	CurrentUserDeconstructLevel = {}
	DeconstructList = {}

	-- make a label for keybinding
	ZO_CreateStringId("SI_BINDING_NAME_ALLCRAFT_DECON_AUTO_DECONSTRUCT", "Auto Deconstruct")
	ZO_CreateStringId("SI_BINDING_NAME_ALLCRAFT_DECON_AUTO_REFINE", "Auto Refine")

end
AllCraft_Decon.DeconInitialize = DeconInitialize