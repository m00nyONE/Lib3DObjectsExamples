local addon_name = "Lib3DObjectsExamples"
local addon = _G[addon_name]

local l3do = Lib3DObjects

local scaleToFourAnimation = l3do.animations.CreateSingleScaleAnimation(500, 4)
local scaleToOneAnimation = l3do.animations.CreateSingleScaleAnimation(500, 1)
local function onMouseEnterCallback(self, distanceToPlayer, distanceToCamera)
    self:AddCallback(scaleToFourAnimation())
    self.TextControl:SetHidden(false)
end
local function onMouseLeaveCallback(self, distanceToPlayer, distanceToCamera)
    self:AddCallback(scaleToOneAnimation())
    self.TextControl:SetHidden(true)
end
local function updateDistanceText(self, distanceToPlayer, distanceToCamera)
    self:SetText(string.format("%.1fm", distanceToPlayer / 100))
end
local onMouseOver = l3do.animations.CreateMouseOverTrigger(100, onMouseEnterCallback, onMouseLeaveCallback)

function addon.examples.createSingleReactiveFloatingMarker()
    local _, pX, pY, pZ = GetUnitRawWorldPosition("player")
    local marker = l3do.FloatingMarker:New(nil, pX, pY, pZ, 0)
    marker:SetDrawDistanceMeters(200)
    marker:SetColor(0, 0, 1, 1)
    marker:AddCallback(updateDistanceText)
    marker:AddCallback(marker.MoveToCursor)
    return marker
end

function addon.examples.createReactiveFloatingMarkerArray(count)
    local markers = {}
    local radius = 5000
    local angleStep = (2 * math.pi) / count
    local _, centerX, centerY, centerZ = GetUnitRawWorldPosition("player")

    for i = 0, count - 1 do
        local angle = i * angleStep
        local offsetX = radius * math.cos(angle)
        local offsetZ = radius * math.sin(angle)

        local marker = l3do.FloatingMarker:New(nil, centerX + offsetX, centerY, centerZ + offsetZ, 1000)
        marker:SetDrawDistanceMeters(200)
        marker:SetColor(math.random(), math.random(), math.random(), 1)
        marker:AddCallback(onMouseOver())
        marker:AddCallback(updateDistanceText)
        marker.TextControl:SetHidden(true)
        table.insert(markers, marker)
    end

    return markers
end