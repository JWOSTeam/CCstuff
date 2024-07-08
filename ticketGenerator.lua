-- ticketGenerator.lua
local driveSide = "left" -- Adjust according to your setup

local function generateTicket()
    local ticketData = {
        valid = true,
        id = math.random(100000, 999999)
    }

    -- Wait for a disk to be inserted
    print("Insert a floppy disk to write a train ticket.")
    while not disk.isDiskPresent(driveSide) do
        sleep(1)
    end

    local mountPath = disk.getMountPath(driveSide)
    local file = fs.open(mountPath .. "/ticket.txt", "w")
    file.write(textutils.serialize(ticketData))
    file.close()

    disk.eject(driveSide)
    print("Ticket written and ejected.")
end

while true do
    generateTicket()
end