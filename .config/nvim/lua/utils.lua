local M = {}

M.merge = function(t1, t2)
    for k, v in pairs(t2) do
        t1[k] = v
    end
    return t1
end

M._if = function(bool, a, b)
    if bool then
        return a
    else
        return b
    end
end

return M
