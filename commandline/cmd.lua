-- Protocol Definition: annikentogo.frc - Fusion Reactor Controller
-- A fusion reactor unit can include:
-- - Peripherals
--  - Fusion Reactor (FUSION_REACTOR)
--   - (in) BURNRATE [value|auto] - Set the burn rate to value (0-98)
--  - Fuel Input (FUEL_INPUT)
-- - Networked Computers
--  - Fusion Reactor Controller
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

-- Simple Command Line Interface for Fusion Reactor Controller


-- Initialize RedNet
local proto = "annikentogo.frc"

peripheral.find("modem", rednet.open)

-- Wait for first ADVERTISE
local function waitForAdvertise()
    print("Waiting for Fusion Reactor Controller ADVERTISE...")
    while true do
        local senderId, message, protocol = rednet.receive(proto)
        if type(message) == "table" and message[1] == "ADVERTISE" then
            print("Received ADVERTISE from " .. (message[3] or "unknown hostname") .. " (ID: " .. senderId .. ")")
            return senderId
        end
    end
end

local controllerId = waitForAdvertise()

-- Command Loop
print("Enter commands to send to the Fusion Reactor Controller.")
while true do
    write("> ")
    local input = read()
    if input == "exit" then
        print("Exiting command line.")
        break
    end
    local commandParts = {}
    for part in string.gmatch(input, "%S+") do
        table.insert(commandParts, part)
    end
    if #commandParts > 0 then
        rednet.send(controllerId, commandParts, proto)
        print("Sent command: " .. input)
        -- Wait for ACK/NACK
        local senderId, response = rednet.receive(proto, 5) -- wait up to
        if senderId then
            if type(response) == "table" and (response[1] == "ACK" or response[1] == "NACK") then
                print("Received " .. response[1] .. " for command: " .. table.concat(response, " ", 2))
            else
                print("Received unexpected response.")
            end
        else
            print("No response received within timeout period.")
        end
    end
end