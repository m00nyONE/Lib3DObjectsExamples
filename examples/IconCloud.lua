local addon_name = "Lib3DObjectsExamples"
local addon = _G[addon_name]

local l3do = Lib3DObjects
local LCI = LibCustomIcons

function addon.examples.createCloudOfIcons(radius)
    if not LCI then
        d("LibCustomIcons is required for this example.")
        return nil
    end

    local icons = {}
    radius = radius or 2000
    local iconList = {}

    local allStatic = LCI.GetAllStatic() -- maps @name to iconData
    local numStatic = LCI.GetStaticCount()


    for _, iconData in pairs(allStatic) do
        table.insert(iconList, iconData)
    end

    local _, centerX, centerY, centerZ = GetUnitRawWorldPosition("player")
    for i = 0, numStatic - 1 do
        local angle1 = math.acos(1 - 2 * (i + 0.5) / numStatic)
        local angle2 = math.pi * (1 + 5^0.5) * (i + 0.5)

        local offsetX = radius * math.sin(angle1) * math.cos(angle2)
        local offsetY = radius * math.sin(angle1) * math.sin(angle2)
        local offsetZ = radius * math.cos(angle1)

        local icon = l3do.FloatingMarker:New(iconList[i], centerX + offsetX, centerY + offsetY, centerZ + offsetZ)
        icon:SetScale(0.5)
        table.insert(icons, icon)
    end


    return icons
end