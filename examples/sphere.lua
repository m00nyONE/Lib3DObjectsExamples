local addon_name = "Lib3DObjectsExamples"
local addon = _G[addon_name]

local l3do = Lib3DObjects

local function discoLightColor(t)
    t = t / 500 -- Slow down the color cycling
    local r = (math.sin(t) + 1) / 2
    local g = (math.sin(t + 2 * ZO_PI / 3) + 1) / 2
    local b = (math.sin(t + 4 * ZO_PI / 3) + 1) / 2
    return r, g, b
end

function addon.examples.create3DSphereMarker(radius, count)
    radius = radius or 2500
    count = count or 100
    local markers = {}
    local phi = ZO_PI * (3 - zo_sqrt(5)) -- golden angle in radians
    local _, centerX, centerY, centerZ = GetUnitRawWorldPosition("player")
    local rotationPointX, rotationPointY, rotationPointZ = centerX, centerY + (radius * 3), centerZ
    for i = 0, count - 1 do
        local y = 1 - (i / (count - 1)) * 2 -- y goes from 1 to -1
        local radiusAtY = zo_sqrt(1 - y * y) -- radius at y
        local theta = phi * i -- golden angle increment
        local x = zo_cos(theta) * radiusAtY
        local z = zo_sin(theta) * radiusAtY
        local offsetX, offsetY, offsetZ = x * radius, y * radius, z * radius
        local marker = l3do.Marker:New("Lib3DObjects/textures/circle.dds")
        marker:SetPosition(centerX, centerY + radius, centerZ)
        marker:SetPositionOffset(offsetX, offsetY, offsetZ)

        -- rotate the control away from the center point
        local dx, dy, dz = offsetX, offsetY, offsetZ
        local distance = zo_distance3D(0, 0, 0, dx, dy, dz)
        local pitch = -math.asin(dy / distance)
        local yaw = zo_atan2(dx, dz)
        marker:SetRotation(pitch, yaw, 0)

        marker:SetColor(zo_random(), zo_random(), zo_random(), 1)
        --marker:EnableVisualNormalVector()

        marker:AddCallback(function(object, distanceToPlayer, distanceToCamera)
            local r, g, b = discoLightColor(GetGameTimeMilliseconds() + (100 * i))
            object:SetColor(r, g, b, 1)
        end)

        local beginTime = GetGameTimeMilliseconds()
        local startX, startY, startZ = marker:GetPosition()
        local startPitch, startYaw, startRoll = marker:GetRotation()

        marker:AddCallback(function(object, _, _)
            local currentTime = GetGameTimeMilliseconds()
            local elapsed = (currentTime - beginTime) / 1000
            local angle = elapsed * 0.5 -- radians per second

            -- Always rotate from the original position/rotation
            object:SetPosition(startX, startY, startZ)
            object:SetRotation(startPitch, startYaw, startRoll)
            object:RotateAroundPoint(rotationPointX, rotationPointY, rotationPointZ, angle, angle, angle)
        end)
        table.insert(markers, marker)
    end
    local centerPoint = l3do.Point:New(centerX, centerY, centerZ)
    centerPoint:SetLabel("C")
    centerPoint:ShowPosition(true)
    centerPoint:SetColor(1, 1, 1, 1)
    centerPoint:AddCallback(function(object, distanceToPlayer, distanceToCamera)
        local numMarkers = #markers
        local sumX, sumY, sumZ = 0, 0, 0
        for _, marker in ipairs(markers) do
            local posX, posY, posZ = marker:GetFullPosition()
            sumX, sumY, sumZ = sumX + posX, sumY + posY, sumZ + posZ
        end
        object:SetPosition(sumX / numMarkers, sumY / numMarkers, sumZ / numMarkers)
    end)

    local rotationPointMarker = l3do.Point:New(rotationPointX, rotationPointY, rotationPointZ)
    rotationPointMarker:SetLabel("R")
    rotationPointMarker:ShowPosition(true)
    rotationPointMarker:SetColor(1, 1, 1, 1)

    local arrow = l3do.Line:New("Lib3DObjects/textures/arrow.dds", centerX, centerY, centerZ, rotationPointX, rotationPointY, rotationPointZ)
    arrow:SetColor(1, 1, 1, 1)
    arrow:SetLineWidth(50)
    arrow:AddCallback(function(object, distanceToPlayer, distanceToCamera)
        local posX, posY, posZ = centerPoint:GetPosition()
        local rotX, rotY, rotZ = rotationPointMarker:GetPosition()
        object:SetStartPoint(posX, posY, posZ)
        object:SetEndPoint(rotX, rotY, rotZ)
    end)

    return markers
end