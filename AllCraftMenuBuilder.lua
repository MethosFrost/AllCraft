ACMB = {}
AllCraft_Decon = {}
AllCraft_Decon.name = AllCraft_Decon
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
	Deconstruct_Set_Items = false,
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


function ACMB.MMSliderDisable()
    if not MasterMerchant then return true end
    return false
end

function ACMB.TTCSliderDisable()
    if not TamrielTradeCentre then return true end
    return false
end

local function ReadableName(name)
    if string.find( name,"Deconstruct_Set_Type_") then 
        name = string.gsub(name,"Deconstruct_Set_Type_","Deconstruct_Set_Type:_")
    end
        name = string.gsub( name,"_"," ")
        return name
end

local function CheckboxMenuAdd(settingName)
    local set = settingName
    local setting = AllCraft_Decon.deconSettings
    local s = {}
        s.type = "checkbox"
        s.name = ReadableName(settingName)
        s.getFunc = function() return setting[set] end
        s.setFunc = function(value) setting[set] = value end
    return s
end

function ACLoadMenu()
    local t = getmetatable(AllCraft_Decon.deconSettings).__index
    --local sort_func = function(a, b) return a.bName < b.bName end
    --t = table.sort(t, function (k1, k2) return k1.str < k2.str end)
    local setting = AllCraft_Decon.deconSettings
    local menu = {}
    local settingsSM = {type = "submenu",
    name = "Set Deconstruction Options",
    controls = {}}
    d(menu)
    for key, value in pairs(t) do
        if key ~= "version" then
            if string.find( key,"Deconstruct_Set_Type_") and setting.Deconstruct_Set_Items then
                table.insert (settingsSM.controls, CheckboxMenuAdd(key))
            end
        end
    end
    if #settingsSM.controls ~= 0 then menu = settingsSM end
    if #menu == 0 then
        return menu
    else
        return nil
    end

end