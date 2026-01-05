local addon_name = "Lib3DObjectsExamples"
local addon = _G[addon_name]

local l3do = Lib3DObjects
local EM = GetEventManager()

local footsteps = {}
local lastFootstep = nil
local footstepDistance = 200

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
    local footstep = l3do.Texture:New(nil, pX, pY + 5, pZ)
    --local footstep = l3do.Texture3D:New(nil, pX, pY + 5, pZ)
    local index = step % 2 + 1
    local textureCoords = textureMap[index]

    footstep:SetTexture("/art/fx/texture/footprint_ghostcat_01_4x4.dds", textureCoords[1], textureCoords[2], textureCoords[3], textureCoords[4])
    --footstep:SetTexture(nil, textureCoords[1], textureCoords[2], textureCoords[3], textureCoords[4])
    footstep:SetColor(1, 1, 1, 0.5)
    footstep:SetHeight(200)
    footstep:SetDrawDistanceMeters(250)
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
end

function addon.examples.initializeFootsteps()
    createFootstep()

    EM:RegisterForUpdate("Lib3DObjectsExamples_Footsteps", 10, onTick)
end
