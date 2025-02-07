local rsi_condition = {}

function rsi_condition:init(overbought_threshold, oversold_threshold, epsilon)
    self.overbought_threshold = overbought_threshold
    self.oversold_threshold = oversold_threshold
    self.epsilon = epsilon
end

-- Returns -1 if security is oversold, 1 if overbought and 0 in other case
function rsi_condition:test(rsi)
    if self.overbought_threshold - rsi <= self.epsilon then
        return 1
    elseif rsi - self.oversold_threshold <= self.epsilon then
        return -1
    else
        return 0
    end
end

return rsi_condition