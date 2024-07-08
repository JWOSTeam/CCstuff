-- ticket_generator.lua
local diskSide = "right"  -- Adjust based on where your disk drive is located
local ticketIDFile = "ticket_id.txt"

local function generateUniqueID()
    return tostring(math.random(1000000, 9999999))
end

local function writeIDToDisk(id)
    local mountPath = disk.getMountPath(diskSide)
    if mountPath then
        local file = fs.open(fs.combine(mountPath, ticketIDFile), "w")
        file.write(id)
        file.close()
        print("Ticket ID written to disk: " .. id)
    else
        print("No disk present on " .. diskSide)
    end
end

local function main()
    if not disk.isPresent(diskSide) then
        print("Please insert a disk.")
        return
    end

    local ticketID = generateUniqueID()
    writeIDToDisk(ticketID)
    disk.eject(diskSide)
    print("Disk ejected. Ticket ID: " .. ticketID)
end

main()
