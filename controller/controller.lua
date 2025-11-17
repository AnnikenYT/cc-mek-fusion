-- Protocol Definition: annikentogo.frc - Fusion Reactor Controller
-- A fusion reactor unit can include:
-- - Peripherals
--  - Fusion Reactor (FUSION_REACTOR)
--   - (in) BURNRATE [value|auto] - Set the burn rate to value (0-98)
--  - Fuel Input (FUEL_INPUT)
-- - Networked Computers
--  - Fusion Reactor Controller (this computer)
--   - (out) ADVERTISE [component1,component2,...] [hostname] - Broadcast presence on the network
--  - Fusion Reactor Viewport
--   - (in) STATE [statistic] [value] - Update the viewport with the current statistic value
-- - Redstone
--  - Blast Doors (BLASTDOOR)
--   - (in) ACTIVATE - Open the blast doors
--   - (in) DEACTIVATE - Close the blast doors
--  - Laser Activators (LASER)
--   - (in) TRIGGER - Trigger the laser to fire for 5 Ticks
--   - (in) ACTIVATE - Activate the laser (keep firing)
--   - (in) DEACTIVATE - Deactivate the laser (stop firing)
--
-- Note that every controller that recieves a command executes it.
--
-- Parts of a message:
-- [Target Component] [Command] [Parameters...]
-- Example:
-- LASER ACTIVATE
-- BLASTDOOR OPEN
-- FUSION_REACTOR SET
--
-- Acknowledgements:
-- ACK [Target Component] [Command]
-- Example:
-- ACK LASER ACTIVATE
-- NACK [Target Component] [Command] [Reason]
-- Example:
-- NACK BLASTDOOR OPEN Obstruction Detected
-- End Protocol Definition

local proto = "annikentogo.frc"

-- Logging
local logFile = fs.open("fusion-controller.log", "a")

CCLogger = require "CCLogger"
local logger = CCLogger.new(
    logFile,
    term.current(),
    "debug",
    "debug",
    true
)

-- Initialize RedNet
peripheral.find("modem", rednet.open)

local config = require "config"

-- Set the computer's hostname
os.setComputerLabel(config.settings.hostname or "fusion-controller")
rednet.host(proto, os.getComputerLabel())
logger:i("Fusion Controller started with hostname: " .. os.getComputerLabel())

-- Find connected components
local components = {
    "FUSION_REACTOR",
    "FUEL_INPUT",
    "BLASTDOOR",
    "LASER"
}

-- Advertise service
logger:i("Advertised Fusion Controller service on the network.")

-- Main loop to receive and process messages
logger:i("Entering main message processing loop.")
repeat
    local id, message = rednet.receive(proto, 1) -- wait up to 1 second
    if id then
        logger:d("Received message from ID " .. id .. ": " .. message)
        -- Process the message (this is a placeholder for actual processing logic)
        rednet.send(id, "ACK " .. message, proto)
        logger:d("Sent ACK for message: " .. message)
    else
        rednet.broadcast("ADVERTISE" .. " " .. table.concat(components, ",") .. " " .. os.getComputerLabel(), proto)
    end
until false
-- End of fusion-controller.lua