-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0


--[[ doc.lua begin ]]
local addon = {
    name = "Lib3DObjectsExamples",
    version = "dev",
    author = "@m00nyONE",

    examples = {},
}
local addon_name = addon.name
local addon_author = addon.author
local addon_version = addon.version
_G[addon_name] = addon

local EM = GetEventManager()


--[[ doc.lua end ]]
local function initialize()

    -- helper objects
    --local _ = addon.examples.createAxis(300)

    --local _ = addon.examples.createObjectGroup()
    --local _ = addon.examples.createGroundMarkerArray(50)
    --local _ = addon.examples.createReactiveGroundMarkerArray(50)
    --local _ = addon.examples.createReactiveGroundMarkerConcentricArray(6, 6, 200, 200)
    --local _ = addon.examples.createUnitMarkerArray(20)
    --local _ = addon.examples.createSingleReactiveFloatingMarker()
    --local _ = addon.examples.createReactiveFloatingMarkerArray(20)
    --local _ = addon.examples.createSingleLine()
    --local _ = addon.examples.createLineSphere(10)
    --local _ = addon.examples.createKubeOutOfLines(200)
    --local _ = addon.examples.createPointingArrowLine()
    --local _ = addon.examples.create3DSphereMarker(500, 150)
    --local _ = addon.examples.createCloudOfIcons(2000)
    --local _ = addon.examples.unitMarkerPriorities()
    --local _ =  addon.examples.unitESP()

end

EM:RegisterForEvent(addon_name, EVENT_ADD_ON_LOADED, function(_, name)
    if name ~= addon_name then return end

    EM:UnregisterForEvent(addon_name, EVENT_ADD_ON_LOADED)
    initialize()
end)
