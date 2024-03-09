local GM = ggclass.GM

--- : 
---@usage
---: clientEcho 
---: clientEcho hello
function GM:clientEcho(args)
    local ok,args = gg.checkargs(args,"string")
    if not ok then
        return self:say(": clientEcho ")
    end
    local msg = args[1]
    return msg
end

--- : 
---@usage
---: openWindow 
---: openWindow TestWindow
function GM:openWindow(args)
    local ok,args = gg.checkargs(args,"string")
    if not ok then
        return self:say(": openWindow ")
    end
    local windowName = args[1]
    gg.uiManager:openWindow(windowName)
end

--- : 
---@usage
---: closeWindow 
---: closeWindow TestWindow
function GM:closeWindow(args)
    local ok,args = gg.checkargs(args,"string")
    if not ok then
        return self:say(": closeWindow ")
    end
    local windowName = args[1]
    gg.uiManager:closeWindow(windowName)
end

--- : 
---@usage
---: testDisconnect
---: testDisconnect
function GM:testDisconnect(args)
    if gg.client.gameServer then
        gg.client.gameServer:close()
    end
end

function GM:testRandom(args)
    local random = require "random"
    local r = random(0)	-- random generator with seed 0
    local r2 = random(0)

    for i=1,10 do
        local x = r()
        assert(x == r2())
        print(x)
    end

    for i=1,10 do
        local x = r(2)
        assert(x == r2(2))
        print(x)
    end

    for i=1,10 do
        local x = r(0,3)
        assert(x == r2(0,3))
        print(x)
    end
end

function GM:exec(args)
    local ok,args = gg.checkargs(args,"string")
    if not ok then
        return self:say(": exec ")
    end
    local text = args[1]
    load(text)()
end

return GM