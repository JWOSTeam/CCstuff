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

local function isDiskEmpty()
    local mountPath = disk.getMountPath(diskSide)
    if mountPath then
        local files = fs.list(mountPath)
        if #files == 0 then
            return true
        else
            return false
        end
    end
    return false
end

local function main()
    while true do
        term.clear()
        term.setCursorPos(1, 1)
        print("Please insert a disk to receive your ticket.")

        -- Wait until a disk is inserted
        os.pullEvent("disk")

        if isDiskEmpty() then
            local ticketID = generateUniqueID()
            writeIDToDisk(ticketID)
            disk.eject(diskSide)
            print("Disk ejected. Ticket ID: " .. ticketID)
        else
            print("This ticket has already has data on it! Please get a new one if it has been used already.")
            disk.eject(diskSide)
        end

        -- Wait until the disk is removed before restarting
        while disk.isPresent(diskSide) do
            sleep(1)  -- Check every second
        end

        sleep(3)  -- Short delay before restarting the loop
    end
end

main()
