---json
--@script gg.codec.jsonx
--@author sundream
--@release 2019/6/20 10:30:00
--@usage
--json
--{
--  "cmd" : (),
--  "args" : (),
--  "response" : true--,false--,
--  "session" : rpcID,0,,,
--  "ud" : 
--}

local cjson = require "cjson"
-- []
--cjson.encode_empty_table_as_object(false)

local jsonx = {}

function jsonx.new(conf)
    local self = {}
    return setmetatable(self,{__index=jsonx})
end

function jsonx:reload()
end

function jsonx:pack_message(cmd,args,response,session,ud,encrypt)
    if encrypt then
        cmd = encrypt(cmd)
    end
    return cjson.encode({cmd=cmd,args=args,response=response,session=session,ud=ud})
end

function jsonx:unpack_message(msg,decrypt)
    local message = cjson.decode(msg)
    if decrypt then
        message.cmd = decrypt(message.cmd)
    end
    return message.cmd,message.args,message.response,message.session,message.ud
end

return jsonx