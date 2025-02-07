local strategy = {
    ["name"] = "fixed-offset"
}

-- Close position with limit order using fixed offset. 
-- Profit is limited by offset

function strategy:init(account, sec_class, sec_code, order_manager, offset)
    self.order_manager = order_manager
    self.offset = offset

    self.account = account
    self.sec_class = sec_class
    self.sec_code = sec_code

end

function strategy:use(order)
    local price = order.price
    local qty

    local is_buy = order.flags & 0x4 == 0

    -- If position was opened with buy order, close it with limit sell at (price + offset). 
    -- Otherwise, close with limit buy order at (price - offset)
    if is_buy then
        price = price + self.offset
        qty = -order.qty
    else
        price = price - self.offset
        qty = order.qty
    end

    -- Place order
    self.order_manager:place_limit_order(self.account, self.sec_class, self.sec_code, qty, price)
end

return strategy