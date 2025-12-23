local addon_name = "Lib3DObjectsExamples"
local addon = _G[addon_name]

local l3do = Lib3DObjects
local WorldSpaceRenderer = l3do.core.WorldSpaceRenderer
local EM = GetEventManager()

local function callback(obj, distanceToPlayer, distanceToCamera)
    local unitTag = obj.unitTag
    local _, x, y, z = GetUnitRawWorldPosition(unitTag)
    obj:SetPosition(x, y + 100, z)
    obj.Control:GetNamedChild("_Name"):SetText(GetUnitDisplayName(unitTag))
    obj.Control:GetNamedChild("_Position"):SetText(string.format("X: %d Z: %d\nY: %d", x, z, y))

    local health, maxHealth, _ = GetUnitPower(unitTag, POWERTYPE_HEALTH)
    local healthPercent = (health / maxHealth) * 100
    local magicka = 0
    local magickaPercent = 0
    local stamina = 0
    local staminaPercent = 0
    if AreUnitsEqual(unitTag, "player") then
        magicka, maxMagicka, _ = GetUnitPower(unitTag, POWERTYPE_MAGICKA)
        magickaPercent = (magicka / maxMagicka) * 100
        stamina, maxStamina, _ = GetUnitPower(unitTag, POWERTYPE_STAMINA)
        staminaPercent = (stamina / maxStamina) * 100
    end

    obj.Control:GetNamedChild("_Stats"):SetText(string.format("|cFF0000%d%%|r\n|c0000FF%d%%|r\n|c00FF00%d%%|r", healthPercent, magickaPercent, staminaPercent))
end

local markers = {}
local function destroyMarkers()
    for _, marker in ipairs(markers) do
        marker:Destroy()
    end
    ZO_ClearTable(markers)
end
local function createMarkers()
    for i = 1, GetGroupSize() do
        local unitTag = GetGroupUnitTagByIndex(i)
        if IsUnitPlayer(unitTag) and IsUnitOnline(unitTag) then
            local unitMarker = l3do.BaseObject:New("l3do_examples_unitesp", nil, WorldSpaceRenderer)
            unitMarker.unitTag = unitTag
            unitMarker:MoveToUnit(unitTag)
            unitMarker:SetDrawDistanceMeters(100)
            unitMarker:SetAutoRotationMode(l3do.AUTOROTATE_CAMERA)
            unitMarker:AddCallback(callback)
        end
    end
end
local function onEvent()
    d("triggered group update event")
    destroyMarkers()
    createMarkers()
end
function addon.examples.unitESP()
    EM:RegisterForEvent(addon_name .. "GroupUpdate", EVENT_GROUP_MEMBER_JOINED, onEvent)
    EM:RegisterForEvent(addon_name .. "GroupUpdate", EVENT_GROUP_MEMBER_LEFT, onEvent)
    EM:RegisterForEvent(addon_name .. "GroupUpdate", EVENT_GROUP_UPDATE, onEvent)
    EM:RegisterForEvent(addon_name .. "GroupUpdate", EVENT_GROUP_MEMBER_CONNECTED_STATUS, onEvent)
    onEvent()
end