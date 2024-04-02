---""sproto""
--@script gg.codec.sproto
--@author sundream
--@release 2018/12/25 10:30:00
--@usage
--""sproto""
-- -------------
-- |header|body|
-- -------------
-- header"",""sproto"",""ID,""ID""
-- body"",""sproto""(""ID""header"")

local core = require "sproto.core"
local sproto = require "etc.proto.sproto.sproto"

local header_tmp = {}

function sproto:queryproto(pname)
    local v = self.__pcache[pname]
    if not v then
        local tag, req, resp = core.protocol(self.__cobj, pname)
        assert(tag, pname .. " not found")
        if tonumber(pname) then
            pname, tag = tag, pname
        end
        v = {
            request = req,
            response = resp,
            name = pname,
            tag = tag,
        }
        self.__pcache[pname] = v
        self.__pcache[tag]  = v
    end
    return v
end

function sproto:unpack_message(msg,decrypt)
    local bin = core.unpack(msg)
    header_tmp.cmd = nil
    header_tmp.session = nil
    header_tmp.ud = nil
    local header,size = core.decode(self.__package,bin,header_tmp)
    local content = bin:sub(size+1)
    local message_id = header.cmd
    local proto,args,response
    if message_id then
        -- request
        if decrypt then
            message_id = decrypt(message_id)
        end
        proto = self:queryproto(message_id)
        if proto.request then
            args = core.decode(proto.request,content)
        end
        response = false
    else
        -- response
        local session = assert(header.session,"session not found")
        local tag = assert(self.__session[session],"Unknown session")
        self.__session[session] = nil
        proto = self:queryproto(tag)
        if proto.response then
            args = core.decode(proto.response,content)
        end
        response = true
    end
    return proto.name,args,response,header.session,header.ud
end

function sproto:pack_message(cmd,args,response,session,ud,encrypt)
    if response then
        return self:pack_response(cmd,args,session,ud,encrypt)
    else
        return self:pack_request(cmd,args,session,ud,encrypt)
    end
end

function sproto:pack_request(cmd,args,session,ud,encrypt)
    if session == 0 then
        session = nil
    end
    local proto = self:queryproto(cmd)
    local message_id = proto.tag
    if session then
        self.__session[session] = message_id
    end
    if encrypt then
        message_id = encrypt(message_id)
    end
    header_tmp.cmd = message_id
    header_tmp.session = session
    header_tmp.ud = ud
    local header = core.encode(self.__package,header_tmp)
    if proto.request and args then
        local content = core.encode(proto.request,args)
        return core.pack(header .. content)
    else
        return core.pack(header)
    end
end

function sproto:pack_response(cmd,args,session,ud,encrypt)
    -- response no need encrypt
    local proto = self:queryproto(cmd)
    header_tmp.cmd = nil
    header_tmp.session = session
    header_tmp.ud = ud
    local header = core.encode(self.__package,header_tmp)
    if proto.response and args then
        local content = core.encode(proto.response,args)
        return core.pack(header .. content)
    else
        return core.pack(header)
    end
end

function sproto.create(filename,binary,packagename)
    packagename = packagename or "package"
    local fp,err = io.open(filename,"rb")
    assert(fp,err)
    local proto_str = fp:read("*a")
    fp:close()
    local obj
    if binary then
        obj = sproto.new(proto_str)
    else
        obj = sproto.parse(proto_str)
    end
    obj.__package = assert(core.querytype(obj.__cobj,packagename),"type package not found")
    return obj
end

function sproto.create_from_str(proto_str,binary,packagename)
    packagename = packagename or "package"
    local obj
    if binary then
        obj = sproto.new(proto_str)
    else
        obj = sproto.parse(proto_str)
    end
    obj.__package = assert(core.querytype(obj.__cobj,packagename),"type package not found")
    return obj
end


return sproto
