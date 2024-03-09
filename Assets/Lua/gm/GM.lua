local GM = class("GM")

function GM:ctor()
end

function GM:doCmd(cmdline)
    local split = string.split(cmdline,"%s")
    local cmd = table.remove(split,1)
    local args = split
    local handler
    cmd = cmd:lower()
    for k,v in pairs(GM) do
        if k:lower() == cmd and type(v) == "function" then
            handler = v
        end
    end
    if not handler then
        return false
    end
    local ret = table.pack(xpcall(handler,gg.onerror,self,args))
    local ok = table.remove(ret,1)
    if not ok then
        self:say("")
    end
    self:say(table.dump(ret))
    return true
end

function GM:say(msg)
    local window = gg.uiManager:getWindow("PnlGMTool")  
    if window then
        window:OutPutViewText("Client",msg)     
    end
end

function GM:debugGrid()
    if scene then
        scene:debugGrid()
    end
end

return GM