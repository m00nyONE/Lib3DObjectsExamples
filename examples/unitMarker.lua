local addon_name = "Lib3DObjectsExamples"
local addon = _G[addon_name]

local l3do = Lib3DObjects

local AUTOROTATE_PLAYER = l3do.AUTOROTATE_PLAYER

function addon.examples.createSingleUnitMarker()
    local marker = l3do.UnitMarker:New(nil, "player", nil)
    marker.Control:SetColor(0,1,0,1)

    return marker
end

function addon.examples.createUnitMarkerArray(count)
    local markers = {}
    local radius = 1000
    local angleStep = (2 * math.pi) / count

    for i = 0, count - 1 do
        local angle = i * angleStep
        local offsetX = radius * math.cos(angle)
        local offsetZ = radius * math.sin(angle)

        local marker = l3do.UnitMarker:New(nil, "player", nil)
        marker:SetColor(math.random(), math.random(), math.random(), 1)
        marker:SetPositionOffsetX(offsetX)
        marker:SetPositionOffsetZ(offsetZ)
        marker:SetAutoRotationMode(AUTOROTATE_PLAYER)
        table.insert(markers, marker)
    end

    return markers
end