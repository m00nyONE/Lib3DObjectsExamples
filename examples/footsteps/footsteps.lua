local addon_name = "Lib3DObjectsExamples"
local addon = _G[addon_name]

local l3do = Lib3DObjects
local EM = GetEventManager()

local footsteps = {}
local lastFootstep = nil
local footstepDistance = 150
local footLength = 60

local maxFootsteps = 2000
local step = 1
local textureMap = {
    [1] = {0, 0.5, 0, 1},
    [2] = {0.5, 1.0, 0, 1},
}

local function createFootstep()
    local _, pX, pY, pZ = GetUnitRawWorldPosition("player")
    if IsUnitInAir("player") then return end
    if IsUnitSwimming("player") then return end

    step = step + 1
    local footstep = l3do.Texture:New(nil, pX, pY + 2, pZ, true) -- with depth buffer
    local index = step % 2 + 1
    local textureCoords = textureMap[index]

    footstep:SetDimensions(footLength, footLength * 2)
    footstep:SetTexture("Lib3DObjectsExamples/examples/footsteps/feet.dds", textureCoords[1], textureCoords[2], textureCoords[3], textureCoords[4])
    --footstep:SetColor(0.6, 0.5, 0.4, 1) -- gray brown
    --footstep:SetColor(1, 0.4, 0.7, 1) -- pink
    footstep:SetColor(1, 0, 1, 1) -- purple
    footstep:SetAlpha(0.8)
    footstep:SetDrawDistanceMeters(250)
    footstep:SetFadeOutDistanceNear(0)
    footstep:RotateToPlayerHeading()
    footstep:RotateToGroundNormal()
    lastFootstep = footstep
    table.insert(footsteps, footstep)
end

local function onTick()
    local _, pX, pY, pZ = GetUnitRawWorldPosition("player")
    local lastX, lastY, lastZ = lastFootstep:GetFullPosition()
    local distance = zo_distance3D(pX, pY, pZ, lastX, lastY, lastZ)
    if distance >= footstepDistance then
        createFootstep()
    end

    if #footsteps > maxFootsteps then
        local oldFootstep = table.remove(footsteps, 1)
        oldFootstep:Destroy()
    end
end

function addon.examples.initializeFootsteps(max)
    maxFootsteps = max or 2000
    createFootstep()

    EM:RegisterForUpdate("Lib3DObjectsExamples_Footsteps", 10, onTick)
end
