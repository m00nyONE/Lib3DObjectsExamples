local addon_name = "Lib3DObjectsExamples"
local addon = _G[addon_name]

local l3do = Lib3DObjects

local LCI = LibCustomIcons

function addon.examples.unitMarkerPriorities()
    if not LCI then d("LibCustomIcons is required for this example.") return end

    local unitTag = "player"
    local offsetY = 300


    -- Low priority marker (default)
    local texturePath, left, right, top, bottom = LCI.GetStatic("@seadotarley")
    local lowPriorityMarker = l3do.UnitMarker:New(nil, unitTag, offsetY, l3do.PRIORITY_LOW)
    lowPriorityMarker:SetTexture(texturePath, left, right, top, bottom)
    lowPriorityMarker:SetScale(0.75)
    lowPriorityMarker:SetAlpha(0.9)

    -- mechanic priority marker
    local mechanicPriorityMarker = l3do.UnitMarkerMechanic:New(nil, unitTag, offsetY, 5, 0, function()
        d("Mechanic priority marker expired.")
    end)
    mechanicPriorityMarker:SetTexture("Lib3DObjects/textures/circle.dds")
    mechanicPriorityMarker:SetColor(0, 1, 0)
    --mechanicPriorityMarker:RunAnimation()
    mechanicPriorityMarker:SetScale(0.75)
    mechanicPriorityMarker:SetAlpha(0.9)

    -- this marker will always render - no matter what
    local playerNameMarker = l3do.UnitMarker:New(nil, unitTag, 0, l3do.PRIORITY_IGNORE)
    playerNameMarker:SetScale(0.5)
    playerNameMarker:SetAlpha(0.8)
    playerNameMarker:SetColor(0, 0, 0, 0)
    local function updateStats(object, _, _)
        local health, maxHealth, _ = GetUnitPower(unitTag, POWERTYPE_HEALTH)
        local healthPercent = (health / maxHealth) * 100

        local magicka, maxMagicka, _ = GetUnitPower(unitTag, POWERTYPE_MAGICKA)
        local magickaPercent = (magicka / maxMagicka) * 100

        local stamina, maxStamina, _ = GetUnitPower(unitTag, POWERTYPE_STAMINA)
        local staminaPercent = (stamina / maxStamina) * 100
        local str = string.format("%s\n|cFF0000%3d|r |c0000FF%3d|r |c00FF00%3d|r", GetUnitDisplayName("player"), healthPercent, magickaPercent, staminaPercent)
        object:SetText(str)
    end
    playerNameMarker:AddCallback(updateStats)
end