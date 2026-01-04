local addon_name = "Lib3DObjectsExamples"
local addon = _G[addon_name]

local l3do = Lib3DObjects

function addon.examples.createSingleGroundMarker()
    local _, x, y, z = GetUnitRawWorldPosition("player")
    local marker = l3do.GroundMarker:New(nil, x, y, z)
    marker:SetColor(1, 1, 1, 1)

    if l3do.RotationHelper then
        local rotationHelper = l3do.RotationHelper:New(marker)
    end

    return marker
end

function addon.examples.createGroundMarkerArray(count)
    local markers = {}
    local radius = 1000
    local angleStep = (2 * math.pi) / count
    local _, centerX, centerY, centerZ = GetUnitRawWorldPosition("player")

    for i = 0, count - 1 do
        local angle = i * angleStep
        local offsetX = radius * math.cos(angle)
        local offsetY = 0
        local offsetZ = radius * math.sin(angle)

        local marker = l3do.GroundMarker:New(nil, centerX + offsetX, centerY + offsetY, centerZ + offsetZ)
        marker:SetColor(math.random(), math.random(), math.random(), 1)
        --marker:EnableVisualNormalVector()
        table.insert(markers, marker)
    end

    return markers
end

