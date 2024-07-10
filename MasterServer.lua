-- Master Server Program

local itemDatabaseFile = "items.txt"
local ordersFile = "orders.txt"
local rednetActive = false
local rednetSide = "right"

-- Function to load items from file
local function loadItems()
    if not fs.exists(itemDatabaseFile) then
        return {}
    end

    local file = fs.open(itemDatabaseFile, "r")
    local items = textutils.unserialize(file.readAll())
    file.close()
    return items
end

-- Function to save items to file
local function saveItems(items)
    local file = fs.open(itemDatabaseFile, "w")
    file.write(textutils.serialize(items))
    file.close()
end

-- Function to load orders from file
local function loadOrders()
    if not fs.exists(ordersFile) then
        return {}
    end

    local file = fs.open(ordersFile, "r")
    local orders = textutils.unserialize(file.readAll())
    file.close()
    return orders
end

-- Function to save orders to file
local function saveOrders(orders)
    local file = fs.open(ordersFile, "w")
    file.write(textutils.serialize(orders))
    file.close()
end

-- Function to toggle Rednet connection
local function toggleRednet()
    if rednetActive then
        rednet.close(rednetSide)
        rednetActive = false
        print("Rednet connection stopped.")
    else
        rednet.open(rednetSide)
        rednetActive = true
        print("Rednet connection started.")
    end
end

-- Function to add an item
local function addItem(name, price)
    local items = loadItems()
    items[name] = price
    saveItems(items)
    print("Item added: " .. name .. " - " .. price)
end

-- Function to remove an item
local function removeItem(name)
    local items = loadItems()
    if items[name] then
        items[name] = nil
        saveItems(items)
        print("Item removed: " .. name)
    else
        print("Item not found: " .. name)
    end
end

-- Function to check orders
local function checkOrders()
    local orders = loadOrders()
    if #orders == 0 then
        print("No orders found.")
    else
        for i, order in ipairs(orders) do
            print("Order #" .. i .. ":")
            print("Customer: " .. order.customer)
            print("Item: " .. order.item)
            print("Quantity: " .. order.quantity)
        end
    end
end

-- Function to check stock
local function checkStock()
    local items = loadItems()
    if next(items) == nil then
        print("No items in stock.")
    else
        for name, price in pairs(items) do
            print("Item: " .. name .. " - Price: " .. price)
        end
    end
end

-- Function to handle incoming orders and requests
local function handleOrders()
    while rednetActive do
        local id, message = rednet.receive(1)  -- Use a timeout to periodically check rednetActive
        if message == "REQUEST_ITEM_LIST" then
            local items = loadItems()
            rednet.send(id, items)
        elseif type(message) == "table" then
            local orders = loadOrders()
            table.insert(orders, message)
            saveOrders(orders)
            print("Order received from " .. message.customer)
        end
    end
end

-- Main program loop
local function main()
    while true do
        print("Commands: toggle, add, remove, check, stock, exit")
        local command = read()

        if command == "toggle" then
            toggleRednet()
        elseif command == "add" then
            print("Enter item name:")
            local name = read()
            print("Enter item price:")
            local price = tonumber(read())
            addItem(name, price)
        elseif command == "remove" then
            print("Enter item name to remove:")
            local name = read()
            removeItem(name)
        elseif command == "check" then
            checkOrders()
        elseif command == "stock" then
            checkStock()
        elseif command == "exit" then
            if rednetActive then
                toggleRednet()
            end
            break
        else
            print("Unknown command. Please try again.")
        end

        if rednetActive then
            handleOrders()
        end
    end
end

main()
