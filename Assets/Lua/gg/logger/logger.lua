--- ""
--@script gg.logger.logger
--@author sundream
--@release 2018/12/25 10:30:00

local cjson = require "cjson"

logger = logger or {}

--- ""(msg"","")
--@param[type=string] msg ""
function logger.write(msg)
    print(msg)
end

--- "","":debug
--@param[type=string] fmt ""
--@param ... ""
--@usage
--  logger.debug("name=%s,age=%s","lgl",28)
--  logger.debug("hello,world")
function logger.debug(fmt,...)
    logger.logf(logger.DEBUG,fmt,...)
end

--- "","":trace,trace""
--@param[type=string] fmt ""
--@param ... ""
--@usage
--  logger.debug("name=%s,age=%s","lgl",28)
--  logger.debug("hello,world")
function logger.trace(fmt,...)
    logger.logf(logger.TRACE,fmt,...)
end

--- "","":info
--@param[type=string] fmt ""
--@param ... ""
--@usage
--  logger.info("name=%s,age=%s","lgl",28)
--  logger.info("hello,world")
function logger.info(fmt,...)
    logger.logf(logger.INFO,fmt,...)
end

--- "","":warn
--@param[type=string] fmt ""
--@param ... ""
--@usage
--  logger.warn("name=%s,age=%s","lgl",28)
--  logger.warn("hello,world")
function logger.warn(filename,fmt,...)
    logger.logf(logger.WARN,filename,fmt,...)
end

--- "","":error
--@param[type=string] fmt ""
--@param ... ""
--@usage
--  logger.error("name=%s,age=%s","lgl",28)
--  logger.error("hello,world")
function logger.error(fmt,...)
    logger.logf(logger.ERROR,fmt,...)
end

--- "","":fatal
--@param[type=string] fmt ""
--@param ... ""
--@usage
--  logger.fatal("name=%s,age=%s","lgl",28)
--  logger.fatal("hello,world")
function logger.fatal(fmt,...)
    logger.logf(logger.FATAL,fmt,...)
end

function logger.format(fmt,...)
    local msg
    if select("#",...) == 0 then
        msg = fmt
    else
        local args = table.pack(...)
        local len = math.max(#args,args.n or 0)
        for i = 1, len do
            local typ = type(args[i])
            if typ == "table" then
                local ok,str = pcall(cjson.encode,args[i])
                if ok then
                    args[i] = str
                else
                    args[i] = gg.tostring(args[i])
                end
            elseif typ ~= "number" then
                args[i] = tostring(args[i])
            end
        end
        msg = string.format(fmt,table.unpack(args))
    end
    return msg
end

--- "","",""
--@param[type=string] loglevel ""(debug<trace<info<warn<error<fatal)
--@param[type=string] fmt ""
--@param ... ""(""table""json"")
--@usage
--  logger.logf("info","name=%s,age=%s","lgl",28)
--  logger.logf("debug","hello,world") "" logger.debug("hello,world")
function logger.logf(loglevel,fmt,...)
    local loglevel_name
    loglevel,loglevel_name = logger.check_loglevel(loglevel)
    if logger.loglevel > loglevel then
        return
    end
    assert(fmt)
    if loglevel == logger.TRACE then
        local info = debug.getinfo(2,"Sl")
        fmt = info.short_src .. ":" .. info.currentline .. " " .. fmt
    end
    local msg = logger.format(fmt,...)
    msg = string.format("[%s] %s\n",loglevel_name,msg)
    if loglevel >= logger.WARN then
        UnityEngine.Debug.LogError(msg)
        local pos = string.find(msg,"\n")
        local tag = msg:sub(1,pos-1)
        local now = os.time()
        msg = string.format("[%s] %s",os.date("%Y-%m-%d %H:%M:%S",now),msg)
        -- TODO: report bug
    else
        logger.write(msg)
    end
    return msg
end

--- "",""debug"","":"",""
--@param ... ""
--@usage
--  logger.print("hello")
--  logger.print(string.format("key1=%s,key2=%s",1,2))
function logger.print(...)
    if logger.loglevel > logger.TRACE then
        return
    end
    local info = debug.getinfo(2,"Sl")
    local trace = info.short_src .. ":" .. info.currentline
    print(trace,...)
end

--- "",""debug"","":"",""
--@param fmt ""
--@param ... ""
--@usage
--  logger.printf("key1=%s,key2=%s",1,2)
function logger.printf(fmt,...)
    if logger.loglevel > logger.TRACE then
        return
    end
    local info = debug.getinfo(2,"Sl")
    local trace = info.short_src .. ":" .. info.currentline
    local msg = logger.format(fmt,...)
    print(trace,msg)
end

--- ""
--@param[type=string] loglevel ""
--@usage
--  logger.setloglevel("info")  -- ""info"",""debug
function logger.setloglevel(loglevel)
    loglevel = logger.check_loglevel(loglevel)
    logger.loglevel = loglevel
end

function logger.check_loglevel(loglevel)
    if type(loglevel) == "string" then
        loglevel = logger.NAME_LEVEL[loglevel]
    end
    local name = logger.LEVEL_NAME[loglevel]
    return loglevel,name
end

logger.DEBUG = 1
logger.TRACE = 2
logger.INFO = 3
logger.WARN = 4
logger.ERROR = 5
logger.FATAL = 6
logger.NAME_LEVEL = {
    debug = logger.DEBUG,
    trace = logger.TRACE,
    info = logger.INFO,
    warn = logger.WARN,
    ["error"] = logger.ERROR,
    fatal = logger.FATAL,
}
logger.LEVEL_NAME = {
    [logger.DEBUG] = "debug",
    [logger.TRACE] = "trace",
    [logger.INFO] = "info",
    [logger.WARN] = "warn",
    [logger.ERROR] = "error",
    [logger.FATAL] = "fatal",
}


--- ""
function logger.init()
    logger.setloglevel(gg.config.loglevel)
end

return logger