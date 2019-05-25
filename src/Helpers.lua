local exports = {}

-- Iterate over a table with a specific sorter function.
-- Modified from: https://stackoverflow.com/a/15706820
function exports.spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t[a], t[b]) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return i, t[keys[i]]
        end
    end
end

return exports
