#! /usr/bin/luajit
    
function string.split ( str, splt )

    --local splt = "|"
    --local str = "z|a|qtalk|test|org"

    if splt == nil or str == nil then
        return false
    end

    local len = string.len ( str )
    local za = 0
    local index = {}
    local chars = {}
    for k = 1, len do
        table.insert ( chars, string.sub ( str, k, k ) )
        if string.sub ( str, k, k ) == splt then
            za = za + 1
            table.insert ( index, k )
        end
    end
    
    local zb = za + 1
    local rets = {}
    
    for l = 1, zb do
        if l == 1 then
            table.insert ( rets, string.sub ( str, 1, ( index[l] - 1 ) ) )
        end
        if l > 1 and l < zb then
            table.insert ( rets, string.sub ( str, ( index[l-1] + 1 ), ( index[l] - 1 ) ) )
        end
        if l == zb - 1 then
            table.insert ( rets, string.sub ( str, ( index[l] + 1 ), len ) )
        end
    end

    return rets
end

local results = string.split ( "z|a|qtalk|test|org", "|" )
print ( results[1] )
print ( results[2] )
print ( results[3] )
print ( results[4] )
print ( results[5] )