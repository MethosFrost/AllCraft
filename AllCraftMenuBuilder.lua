ACMB = {}

function ACMB.MMSliderDisable()
    if not MasterMerchant then return true end
    return false
end

function ACMB.TTCSliderDisable()
    if not TamrielTradeCentre then return true end
    return false
end

local function pairsByKeys (t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
      i = i + 1
      if a[i] == nil then return nil
      else return a[i], t[a[i]]
      end
    end
    return iter
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
    local setting = AllCraft_Decon.deconSettings
    local menu = {}
    local settingsSM = {type = "submenu",
    name = "Set Deconstruction Options",
    controls = {}}
    for key, value in pairsByKeys(t) do
        if key ~= "version" then
            if string.find( key,"Deconstruct_Set_Type_") and setting.Deconstruct_Set_Items then
                table.insert (settingsSM.controls, CheckboxMenuAdd(key))
            end
        end
    end
    if #settingsSM.controls ~= 0 then menu = settingsSM end
    return menu
end
