---protobuf
--@script gg.codec.protobuf
--@author sundream
--@release 2018/12/25 10:30:00
--@usage
--protobuf
-- -------------
-- |len|message|
-- -------------
-- len2,message
-- message,protobuf,:
-- message MessagePackage {
--     int32 cmd = 1;          // ID
--     bytes args = 2;         // 
--     bool response = 3;      // true=,false=
--     int32 session = 4;      // rpcID,0,,
--     bytes ud = 5;           // ,
-- }
-- args,protobuf(IDmessage)

local pb = require "pb"

local protobuf = setmetatable({},{__index=pb})

function protobuf.new(conf)
    local pbfile = assert(conf.pbfile)
    local idfile = assert(conf.idfile)
    local self = {
        pbfile = pbfile,
        idfile = idfile,
        message_define = {}
    }
    self.MessagePackage = conf.MessagePackage or "MessagePackage"
    setmetatable(self,{__index=protobuf})
    self:reload()
    return self
end

function protobuf:reload()
    protobuf.clear()
    protobuf.loadfile(self.pbfile)
    self.message_define = {}
    local fd = io.open(self.idfile,"rb")
    for line in fd:lines() do
        local message_name,message_id = string.match(line,'([%w_.]+)%s+=%s+(%d+)')
        if message_id and message_name then
            message_id = assert(tonumber(message_id))
            assert(self.message_define[message_name] == nil)
            assert(self.message_define[message_id] == nil)
            self.message_define[message_name] = message_id
            self.message_define[message_id] = message_name
        end
    end
    fd:close()
end

function protobuf:reload()
    xlua:LoadTextAsset(self.pbfile,function (textAsset)
        local bin = textAsset.bytes
        protobuf.load(bin)
        self.message_define = {}
        xlua:LoadTextAsset(self.idfile,function (textAsset)
            local bin = textAsset.bytes
            local lines = string.split(bin,"\n")
            for i,line in ipairs(lines) do
                local message_name,message_id = string.match(line,'([%w_.]+)%s+=%s+(%d+)')
                if message_id and message_name then
                    message_id = assert(tonumber(message_id))
                    assert(self.message_define[message_name] == nil)
                    assert(self.message_define[message_id] == nil)
                    self.message_define[message_name] = message_id
                    self.message_define[message_id] = message_name
                end
            end
        end)
    end)
end

local message_tmp = {}

function protobuf:unpack_message(msg,decrypt)
    local message,err = protobuf.decode(self.MessagePackage,msg)
    assert(err == nil,err)
    local message_id = message.cmd
    if decrypt then
        message_id = decrypt(message_id)
    end
    local cmd = assert(self.message_define[message_id],"unknow message_id:" .. message_id)
    local args_bin = message.args
    local args,err = protobuf.decode(cmd,args_bin)
    assert(err == nil,err)
    if message.response then
        assert(message.session,"session not found")
    end
    return cmd,args,message.response,message.session,message.ud
end

function protobuf:pack_message(cmd,args,response,session,ud,encrypt)
    if response then
        return self:pack_response(cmd,args,session,ud,encrypt)
    else
        return self:pack_request(cmd,args,session,ud,encrypt)
    end
end

function protobuf:pack_request(cmd,args,session,ud,encrypt)
    if session == 0 then
        session = nil
    end
    local message_id = assert(self.message_define[cmd],"unknow cmd: " .. cmd)
    if encrypt then
        message_id = encrypt(message_id)
    end
    message_tmp.cmd = message_id
    message_tmp.session = session
    message_tmp.ud = ud
    message_tmp.response = false
    if args then
        local ok,args_bin = pcall(protobuf.encode,cmd,args)
        if not ok then
            error(string.format("%s: %s",cmd,args_bin))
        end
        message_tmp.args = protobuf.encode(cmd,args)
    end
    return protobuf.encode(self.MessagePackage,message_tmp)
end

function protobuf:pack_response(cmd,args,session,ud,encrypt)
    local message_id = assert(self.message_define[cmd],"unknow cmd: " .. cmd)
    if encrypt then
        message_id = encrypt(message_id)
    end
    message_tmp.cmd = message_id
    message_tmp.session = session
    message_tmp.ud = ud
    message_tmp.response = true
    if args then
        local ok,args_bin = pcall(protobuf.encode,cmd,args)
        if not ok then
            error(string.format("%s: %s",cmd,args_bin))
        end
        message_tmp.args = args_bin
    end
    return protobuf.encode(self.MessagePackage,message_tmp)
end

return protobuf