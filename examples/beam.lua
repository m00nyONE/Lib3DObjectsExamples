local addon_name = "Lib3DObjectsExamples"
local addon = _G[addon_name]

local l3do = Lib3DObjects

function addon.examples.createSingleBeam()
    local _, x, y, z = GetUnitRawWorldPosition("player")
    local beam1 = l3do.Beam:New(x + 200, y, z)
    local beam2 = l3do.Beam:New(x - 200, y, z, true)
    beam1:SetColor(1, 0, 0, 1)
    beam2:SetColor(0, 1, 0, 1)
    beam2:AddCallback(function(obj, distanceToPlayer, distanceToCamera)

    end)

    return beam1, beam2
end
