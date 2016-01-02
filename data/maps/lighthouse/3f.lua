-- Lighthouse 3F script
-- Version 0.1.1

local map = ...
--local rpf_builder = require("maps/lib/rotating_platform_builder")

function statue_eye_3:on_activated()
  map:open_doors("locked_door_3")
end

function map:on_started()
  --local rpf1 = rpf_builder:create("rpf1")
end
