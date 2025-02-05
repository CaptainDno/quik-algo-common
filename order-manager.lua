local order_manager = {}

function order_manager:init(robot_number, robot_name)
    self.transaction_id = 1000000 * robot_number + 1
    self.client_code = "quik/"..robot_name
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

return order_manager;