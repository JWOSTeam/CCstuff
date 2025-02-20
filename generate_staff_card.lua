-- generate_staff_card.lua
local diskSide = "bottom"  -- Adjust based on where your disk drive is located
local ticketIDFile = "ticket_id.txt"

local function writeStaffIDToDisk()
    local mountPath = disk.getMountPath(diskSide)
    if mountPath then
        local file = fs.open(fs.combine(mountPath, ticketIDFile), "w")
        file.write("420")
        file.close()
        disk.setLabel(diskSide, "Lifetime Subway Pass")
        print("Ticket ID 420 written to disk.")
    else
        print("No disk present on " .. diskSide)
    end
end

local function main()
    term.clear()
    term.setCursorPos(1, 1)
    print("Please insert a disk to receive the lifetime pass.")

    -- Wait until a disk is inserted
    os.pullEvent("disk")

    writeStaffIDToDisk()
    disk.eject(diskSide)
    print("Disk ejected with ticket ID 420.")

    -- Wait until the disk is removed before ending the program
    while disk.isPresent(diskSide) do
        sleep(1)  -- Check every second
    end
end

main()
