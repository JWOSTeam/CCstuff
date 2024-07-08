-- disk_wipe.lua
local diskSide = "right"  -- Adjust based on where your disk drive is located

local function wipeDisk()
    local mountPath = disk.getMountPath(diskSide)
    if mountPath then
        local files = fs.list(mountPath)
        for _, file in ipairs(files) do
            fs.delete(fs.combine(mountPath, file))
        end
        print("Disk wiped successfully.")
    else
        print("No disk present on " .. diskSide)
    end
end

local function getConfirmation()
    while true do
        term.clear()
        term.setCursorPos(1, 1)
        print("All data on this disk will be wiped! Only use it on ticket disks that need clearing!")
        print("Really wipe disk? (Y/N)")
        local event, key = os.pullEvent("key")
        if key == keys.y then
            return true
        elseif key == keys.n then
            return false
        end
    end
end

local function main()
    if not disk.isPresent(diskSide) then
        print("Please insert a disk.")
        return
    end

    if getConfirmation() then
        wipeDisk()
    else
        print("Disk wipe cancelled.")
    end
end

main()