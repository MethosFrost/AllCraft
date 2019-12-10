ACMB = {}

function ACMB.MMSliderDisable()
    if not MasterMerchant then return true end
    return false
end

function ACMB.TTCSliderDisable()
    if not TamrielTradeCentre then return true end
    return false
end

local function CheckboxMenuAdd(settingName)
    local set = settingName

    local setting = AllCraft_Decon.deconSettings
    d(setting.set)
    local functionGet =  function() return setting.set end
    local functionSet = function(value) setting.set = value end
    local x = {}
        x.type = "checkbox"
        x.name = tostring(settingName)
        x.getFunc = functionGet
        x.setFunc = functionSet
    return x
end

function ACLoadMenu()
    local t = getmetatable(AllCraft_Decon.deconSettings).__index
    local setting = AllCraft_Decon.deconSettings
    local menu = {type = "submenu",
    name = "Table Options",
    controls = {}}
    
    for key, value in pairs(t) do
        if key ~= "version" then
            if string.find( key,"Deconstruct_Set_Type_") then
                table.insert (menu.controls, CheckboxMenuAdd(key))
            end
        end
    end
    return menu
end