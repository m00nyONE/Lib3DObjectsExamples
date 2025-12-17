local addon_name = "Lib3DObjectsExamples"
local addon = _G[addon_name]

local l3do = Lib3DObjects

function addon.examples.createObjectGroup()
    local _, centerX, centerY, centerZ = GetUnitRawWorldPosition("player")
    local group = l3do.BaseObjectGroup:New()
    -- create groundmarkers around the player that create a star pattern
    local markerCount = 6
    local radius = 500
    for i = 0, markerCount - 1 do
        local angle = (i / markerCount) * (2 * math.pi)
        local offsetX = radius * math.cos(angle)
        local offsetZ = radius * math.sin(angle)
        local marker = l3do.GroundMarker:New(nil, centerX + offsetX, centerY, centerZ + offsetZ)
        marker:SetColor(1, 1, 0, 1)
        group:Add(marker)
    end
    -- connect all corners with lines
    local members = group:GetMembers()
    for i = 0, markerCount - 1 do
        local marker1 = members[i + 1]
        for j = i + 1, markerCount - 1 do
            local marker2 = members[j + 1]
            local x1, y1, z1 = marker1:GetPosition()
            local x2, y2, z2 = marker2:GetPosition()
            local line = l3do.Line:New(nil, x1, y1, z1, x2, y2, z2)
            line:SetColor(0, 0, 1, 1)
            group:Add(line)
        end
    end

    group:EnableVisualReferencePoint()
    group:AddCallback(function(grp, distanceToPlayer, distanceToCamera)
        local _, x, y, z = GetUnitRawWorldPosition("player")
        --grp:SetPosition(x, y, z)
    end)

    return group
end