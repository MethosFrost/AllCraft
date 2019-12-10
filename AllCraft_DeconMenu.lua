AllCraft_DeconMenu = {}
AllCraft_DeconMenu.name = AllCraft_DeconMenu

-- verify declaration
if AllCraft_Decon == nil then AllCraft_Decon = {} end

function AllCraftDeconMenu()
	local menu = LibStub("LibAddonMenu-2.0")
	local set = AllCraft_Decon.deconSettings

	  -- the panel for the addons menu
  local panel = {
    type = "panel",
    name = "AllCraft: Deconstructor",
    displayName = "AllCraft: Deconstructor",
    author = "Methos_Frost",
    version = AllCraft.version,
  }

  -- this addons entries in the addon menu
  local options = {
	{
		type = "checkbox",
		name = "Account Wide Settings",
		warning = "Will need to reload the UI.",
		getFunc = function() return set.AccountWide end,
		setFunc = function(value) set.AccountWide = value end,
		disabled = true,
	},
	{
		type = "button",
		name = "Reload UI",
		func = function() ReloadUI() end
	},
    {
      type = "checkbox",
      name = "Debug mode",
      getFunc = function() return set.DebugOn end,
	  setFunc = function(value) set.DebugOn = value end,
	},
    {
		type = "checkbox",
		name = "Use Pricing option",
		getFunc = function() return set.PricingOn end,
		setFunc = function(value) set.PricingOn = value end,
	},
	{
	type = "slider",
	name = "Master Merchant Sales Price Cap",
	tooltip = "Maximum Master Merchant Price before reject destruction",
	min = 0,
	max = 10000,
	getFunc = function() return set.MMMax end,
	setFunc = function(value) set.MMMax = value end,
	disabled = ACMB.MMSliderDisable,
	clampInput = false,
	inputLocation = "below",
	},
	{
	type = "slider",
	name = "Tamriel Trade Centre Sales Price Cap",
	tooltip = "Maximum Tamriel Trade Centre Price before reject destruction",
	min = 0,
	max = 10000,
	getFunc = function() return set.TTCMax end,
	setFunc = function(value) set.TTCMax = value end,
	disabled = ACMB.TTCSliderDisable,
	clampInput = false,
	inputLocation = "below",
	},
	{
		type = "checkbox",
		name = "Smart Mode",
		getFunc = function() return set.SmartSettings end,
		setFunc = function(value) set.SmartSettings = value end,
	  },
    {
      type = "checkbox",
      name = "List Before Deconstruct",
      getFunc = function() return set.ListBeforeDeconstruct end,
      setFunc = function(value) set.ListBeforeDeconstruct = value end,
    },
	{
        type = "header",
        name = "Refine options",
        width = "full",	--or "half" (optional)
    },
	{
		type = "checkbox",
		name = "Keep Certification Materials",
		getFunc = function() return set.KeepCertMats end,
		setFunc = function(value) set.KeepCertMats = value end,
	  },
	{
        type = "header",
        name = "Deconstructions options",
        width = "full",	--or "half" (optional)
    },
    {
      type = "checkbox",
      name = "Deconstruct items in bank",
      getFunc = function() return set.UseBank end,
      setFunc = function(value) set.UseBank = value end,
    },
    {
      type = "checkbox",
      name = "Deconstruct bound items",
      getFunc = function() return set.DeconstructBound end,
      setFunc = function(value) set.DeconstructBound = value end,
    },
    {
      type = "checkbox",
      name = "Deconstruct set pieces",
      getFunc = function() return set.DeconstructSetPiece end,
      setFunc = function(value) set.DeconstructSetPiece = value end,
    },
    {
      type = "checkbox",
      name = "Deconstruct ornate items",
      getFunc = function() return set.DeconstructOrnate end,
      setFunc = function(value) set.DeconstructOrnate = value end,
    },
    {
    	type = "checkbox",
    	name = "Deconstruct crafted items",
    	getFunc = function() return set.DeconstructCrafted end,
    	setFunc = function(value) set.DeconstructCrafted = value end,
    },
	{
        type = "submenu",
        name = "Table Options",
        controls = {
			{
			  type = "checkbox",
			  name = "Deconstruct Intricate",
			  getFunc = function() return set.DeconstructIntricate end,
			  setFunc = function(value) set.DeconstructIntricate = value end,
			},
			{
			type = "header",
			name = "Blacksmithing table options",
			},
			{
			type = "slider",
			name = "Max item quality to deconstruct for non-craftmaster",
			tooltip = "Maximum quality at which items will be destroyed for non-craftmasters.  (1 = white,5  = legendary)",
			min = 1,
			max = 5,
			getFunc = function() return set.maxNormBlacksmith end,
			setFunc = function(value) set.maxNormBlacksmith = value end,
			},
			{
			type = "slider",
			name = "Max item quality to deconstruct for craftmaster",
			tooltip = "Max quality at which items will be destroyed for craftmasters.  (1 = white,5  = legendary)",
			min = 1,
			max = 5,
			getFunc = function() return set.maxMasterBlacksmith end,
			setFunc = function(value) set.maxMasterBlacksmith = value end,
			},
			{
			type = "header",
			name = "Clothing table options",
			},
			{
			type = "slider",
			name = "Max item quality to deconstruct for non-craftmaster",
			tooltip = "Maximum quality at which items will be destroyed for non-craftmasters.  (1 = white,5  = legendary)",
			min = 1,
			max = 5,
			getFunc = function() return set.maxNormClothier end,
			setFunc = function(value) set.maxNormClothier = value end,
			},
			{
			type = "slider",
			name = "Max item quality to deconstruct for craftmaster",
			tooltip = "Max quality at which items will be destroyed for craftmasters.  (1 = white,5  = legendary)",
			min = 1,
			max = 5,
			getFunc = function() return set.maxMasterClothier end,
			setFunc = function(value) set.maxMasterClothier = value end,
			},
			{
			type = "header",
			name = "Jewlery table options",
			},
			{
			type = "slider",
			name = "Max item quality to deconstruct for non-craftmaster",
			tooltip = "Maximum quality at which items will be destroyed for non-craftmasters.  (1 = white,5  = legendary)",
			min = 1,
			max = 5,
			getFunc = function() return set.maxNormJewler end,
			setFunc = function(value) set.maxNormJewler = value end,
			},
			{
			type = "slider",
			name = "Max item quality to deconstruct for craftmaster",
			tooltip = "Max quality at which items will be destroyed for craftmasters.  (1 = white,5  = legendary)",
			min = 1,
			max = 5,
			getFunc = function() return set.maxMasterJewler end,
			setFunc = function(value) set.maxMasterJewler = value end,
			},
			{
			type = "header",
			name = "Woodworking table options",
			},
			{
			type = "slider",
			name = "Max item quality to deconstruct for non-craftmaster",
			tooltip = "Maximum quality at which items will be destroyed for non-craftmasters.  (1 = white,5  = legendary)",
			min = 1,
			max = 5,
			getFunc = function() return set.maxNormWoodworker end,
			setFunc = function(value) set.maxNormWoodworker = value end,
			},
			{
			type = "slider",
			name = "Max item quality to deconstruct for craftmaster",
			tooltip = "Max quality at which items will be destroyed for craftmasters.  (1 = white,5  = legendary)",
			min = 1,
			max = 5,
			getFunc = function() return set.maxMasterWoodworker end,
			setFunc = function(value) set.maxMasterWoodworker = value end,
			},
			{
			type = "header",
			name = "Enchanting table options",
			},
			{
			type = "slider",
			name = "Max item quality to deconstruct for non-craftmaster",
			tooltip = "Maximum quality at which items will be destroyed for non-craftmasters.  (1 = white,5  = legendary)",
			min = 1,
			max = 5,
			getFunc = function() return set.maxNormEnchanting end,
			setFunc = function(value) set.maxNormEnchanting = value end,
			},
			{
			type = "slider",
			name = "Max item quality to deconstruct for craftmaster",
			tooltip = "Maximum quality at which items will be destroyed for craftmasters.  (1 = white,5  = legendary)",
			min = 1,
			max = 5,
			getFunc = function() return set.maxNormEnchanting end,
			setFunc = function(value) set.maxNormEnchanting = value end,
			},
		}
	}
}
table.insert(options, ACLoadMenu())

  menu:RegisterAddonPanel("AllCraftDeconstructor", panel)
  menu:RegisterOptionControls("AllCraftDeconstructor", options)
end
