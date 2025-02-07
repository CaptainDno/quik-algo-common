local order_manager = {}

function order_manager:init(robot_number, robot_name)
    self.transaction_id = 1000000 * robot_number + 1
    self.client_code = "quik/"..robot_name
end

function order_manager:set_defaults(account, sec_class, sec_code)
    self.default_account = account
    self.default_sec_class = sec_class
    self.default_sec_code = sec_code
end

function order_manager:place_limit_order_default(qty, price)
    self:place_limit_order(self.default_account, self.default_sec_class, self.default_sec_code, qty, price)
end

function order_manager:place_limit_order(account, security_class, security, quantity, price)

    -- Determine operation type
    local operation
    if quantity < 0 then
        operation = "S"
    else
        operation = "B"
    end

    -- Quantity
    quantity = math.abs(quantity)

    local new_transaction = {
        ["TRANS_ID"] = tostring(self.transaction_id),
        ["ACCOUNT"] = account,
        ["CLIENT_CODE"] = self.client_code,
        ["ACTION"] = "NEW_ORDER",
        ["TYPE"] = "L",
        ["CLASSCODE"] = security_class,
        ["SECCODE"] = security,
        ["OPERATION"] = operation,
        ["PRICE"] = tostring(price),
        ["QUANTITY"] = tostring(quantity),
        ["EXECUTION_CONDITION"] = "PUT_IN_QUEUE"
    }

    self.transaction_id = self.transaction_id + 1

    local error_t = sendTransaction(new_transaction)

    if error_t ~= "" then
        message("failed to send order "..error_t, 3)
    else
        message("order sent")
    end
end

-- Designed to be used inside OnOrder callback
-- Calls provided function when order created by this manager is fulfilled
function order_manager:on_fulfillment(order, cb) 
    -- Check if order comes from this order manager
    if order.brokerref == self.client_code then
        -- Check if order is fulfilled
        if order.flags & 0x1 == 0 and order.flags & 0x2 == 0 then
            cb(order)
        end
    end
end

return order_manager;