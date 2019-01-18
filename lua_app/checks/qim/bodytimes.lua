-- Created by IntelliJ IDEA.
-- User: qitmac000378
-- Date: 17/7/6
-- Time: 下午2:18
-- To change this template use File | Settings | File Templates.
--
local _M = {}

function _M:checkLimtied()

    local _CheckRet = {}
    _CheckRet.httpcode = 200
    _CheckRet.bizcode = 0
    _CheckRet.retmessage = ""

    -- 如果有ckey 解开ckey 查看里面的
    local inCkey = ngx.var.cookie_q_ckey;

    if nil ~= inCkey then
        local decodedCkeyString = ngx.decode_base64(inCkey)
        if nil ~= decodedCkeyString then
            require("utils.string_ex")
            local params = decodedCkeyString:split("&")
            local decodedCkey = {}

            for i = 1, #params do
                local subparam = params[i]
                local kv = subparam:split("=")
                if 2 == #kv then
                    decodedCkey[kv[1]] = kv[2]
                end
            end

            local userid = decodedCkey["u"]

            if nil ~= userid and "" ~= userid then
                local blklist = require('checks.qim.blackuserlist')
                local wrtlist = require('checks.qim.whriteuserlist')

                local arrayUtil = require("utils.array")
                if arrayUtil:array_item_exit(blklist, userid) then
                    _CheckRet.bizcode = -1
                    _CheckRet.retmessage = "request forbidden"
                    return _CheckRet
                end

                if arrayUtil:array_item_exit(wrtlist, userid) then
                    return _CheckRet
                end
            end
        end
    end

    -- 向下继续判定请求频度
    -- 同一个ip get 请求判定 md5(params) post 请求判定 md5(param+body) 在一秒内不能超过2次
    local contentmd5 = ""
    local limitswitch = 2
    local expiretime  = 1
    local request_method = ngx.var.request_method
    if "GET" == request_method then
        local urli = ngx.var.request_uri
        contentmd5 = string.upper(ngx.md5(urli))

    elseif "POST" == request_method then
        local checnstr = ""
        local uri = ngx.var.request_uri
        checnstr = checnstr .. uri;
        ngx.req.read_body()
        local body = ngx.var.request_body
        if nil~=body then
            checnstr = checnstr .. body
        end
        contentmd5 = string.upper(ngx.md5(checnstr))
    end

    local ipkey = ngx.var.remote_addr .. ":" .. contentmd5

    local config = require("checks.qim.qtalkredis")

    local redis = require("resty.redis")
    local red = redis:new()
    red:set_timeout(500)

    local ok, err = red:connect(config.redis.host, config.redis.port)

    if ok then
        ok, err = red:auth(config.redis.passwd)
        red:select(tonumber(config.redis.subpoolforiplimit))
        if ok then
            ok, err = red:get(ipkey)
            if ok then
                local times = tonumber(ok)

                if nil ~= times then
                    if times > limitswitch then
                        _CheckRet.retmessage = "time limited ";
                        _CheckRet.bizcode = -1
                        return _CheckRet
                    else
                        times = times + 1
                        red:set(ipkey, times)
                        red:expire(ipkey, expiretime)
                    end
                else
                    red:set(ipkey, 1)
                    red:expire(ipkey, expiretime)
                end
            else
                red:set(ipkey, 1)
                red:expire(ipkey, expiretime)
            end
        else
            local responce = require("utils.http_responce")
            _CheckRet.retmessage = "redis auth fail " .. err;
            _CheckRet.bizcode = -1
            ngx.log(ngx.ERR, "e " .. "redis auth fail " .. err)
            return _CheckRet
        end
    else
        local responce = require("utils.http_responce")
        _CheckRet.retmessage = "failed to connnect redis:" .. err;
        _CheckRet.bizcode = -1
        ngx.log(ngx.ERR, "e " .. "failed to connnect redis " .. err)
        return _CheckRet
    end

    return _CheckRet
end

return _M
