-- Client Program

local serverID = 1  -- Set the ID of the master server
local rednetSide = "top"  -- Set the side for the modem
local itemList = {}

-- Function to request item list from the server
local function requestItemList()
    rednet.send(serverID, "REQUEST_ITEM_LIST")
    local id, message = rednet.receive(5)  -- Wait for 5 seconds for a response
    if id == serverID and type(message) == "table" then
        itemList = message
        return true
    else
        print("Failed to retrieve item list.")
        itemList = {}
        return false
    end
end

-- Function to display available items
local function displayItems()
    if next(itemList) == nil then
        print("No items available.")
        return false
    else
        print("Available items:")
        for name, price in pairs(itemList) do
            print("Item: " .. name .. " - Price: " .. price)
        end
        return true
    end
end

-- Function to place an order
local function placeOrder()
    print("Enter your name/alias:")
    local customerName = read()

    print("Enter the name of the item you want to order:")
    local itemName = read()

    if not itemList[itemName] then
        print("Item not found.")
        return
    end

    print("Enter the quantity:")
    local quantity = tonumber(read())
    if not quantity or quantity <= 0 then
        print("Invalid quantity.")
        return
    end

    local order = {
        customer = customerName,
        item = itemName,
        quantity = quantity
    }

    rednet.send(serverID, order)
    print("Order placed: " .. quantity .. " x " .. itemName .. " for " .. customerName)
end

-- Main program loop
local function main()
    rednet.open(rednetSide)
    print("Requesting item list from the server...")

    if requestItemList() and displayItems() then
        placeOrder()
    end

    rednet.close(rednetSide)
end

main()
