-- ticket_validator.lua
local diskSide = "right"  -- Adjust based on where your disk drive is located
local gateSide = "left"   -- Adjust based on where your redstone-controlled gate is located
local ticketIDFile = "ticket_id.txt"
local databaseFile = "ticket_database.txt"

local function readIDFromDisk()
    local mountPath = disk.getMountPath(diskSide)
    if mountPath then
        local filePath = fs.combine(mountPath, ticketIDFile)
        if fs.exists(filePath) then
            local file = fs.open(filePath, "r")
            local id = file.readAll()
            file.close()
            return id
        else
            return nil
        end
    end
    return nil
end

local function isIDUsed(id)
    if fs.exists(databaseFile) then
        local file = fs.open(databaseFile, "r")
        local line = file.readLine()
        while line do
            if line == id then
                file.close()
                return true
            end
            line = file.readLine()
        end
        file.close()
    end
    return false
end

local function addIDToDatabase(id)
    local file = fs.open(databaseFile, "a")
    file.writeLine(id)
    file.close()
end

local function openGate()
    redstone.setOutput(gateSide, true)
    sleep(10)  -- Gate open duration in seconds
    redstone.setOutput(gateSide, false)
end

local function main()
    while true do
        term.clear()
        term.setCursorPos(1, 1)
        print("Please insert your ticket.")

        -- Wait until a disk is inserted
        os.pullEvent("disk")

        local ticketID = readIDFromDisk()
        if ticketID then
            if ticketID == "420" then
                print("Staff card accepted. Access granted.")
                openGate()
                disk.eject(diskSide)
            elseif isIDUsed(ticketID) then
                print("This ticket has already been used.")
                disk.eject(diskSide)
            else
                print("Ticket accepted. Opening gate.")
                addIDToDatabase(ticketID)
                openGate()
                disk.setLabel(diskSide, "Used Subway Ticket")
                disk.eject(diskSide)
            end
        else
            print("Failed to read ticket. Please ensure you are using a new, stamped ticket.")
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
