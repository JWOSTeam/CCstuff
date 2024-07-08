-- ticket_validator.lua
local diskSide = "right"  -- Adjust based on where your disk drive is located
local gateSide = "left"   -- Adjust based on where your redstone-controlled gate is located
local ticketIDFile = "ticket_id.txt"
local databaseFile = "ticket_database.txt"

local function readIDFromDisk()
    local mountPath = disk.getMountPath(diskSide)
    if mountPath then
        local file = fs.open(fs.combine(mountPath, ticketIDFile), "r")
        local id = file.readAll()
        file.close()
        return id
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
    sleep(3)  -- Adjust the duration the gate stays open
    redstone.setOutput(gateSide, false)
end

local function main()
    if not disk.isPresent(diskSide) then
        print("Please insert a disk.")
        return
    end

    local ticketID = readIDFromDisk()
    if ticketID then
        if isIDUsed(ticketID) then
            print("Ticket ID already used.")
            disk.eject(diskSide)
        else
            print("Ticket ID is valid.")
            addIDToDatabase(ticketID)
            openGate()
            disk.eject(diskSide)
        end
    else
        print("Failed to read ticket ID from disk.")
    end
end

main()