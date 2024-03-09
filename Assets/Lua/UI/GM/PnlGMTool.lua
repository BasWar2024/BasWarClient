

PnlGMTool = class("PnlGMTool", ggclass.UIBase)



function PnlGMTool:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.popup
    self.events = { }

    
end

function PnlGMTool:onAwake()
    self.view = ggclass.PnlGMToolView.new(self.transform)

    self.areaText=""
end

function PnlGMTool:onShow()
    self:bindEvent()
end

function PnlGMTool:onHide()
    self:releaseEvent()

end

function PnlGMTool:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnAddRes):SetOnClick(function()
        self:onBtnAddRes()
    end)
    CS.UIEventHandler.Get(view.btnSend):SetOnClick(function()
        self:onBtnSend()
    end)
    CS.UIEventHandler.Get(view.btnClean):SetOnClick(function()
        self:onBtnClean()
    end)
    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnAdjust):SetOnClick(function()
        self:onBtnAdjust()
    end)
end

function PnlGMTool:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnAddRes)
    CS.UIEventHandler.Clear(view.btnSend)
    CS.UIEventHandler.Clear(view.btnClean)
    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnAdjust)
end

function PnlGMTool:onDestroy()
    local view = self.view

end

function PnlGMTool:onBtnAddRes()
    local args=self.view.inputField:GetComponent("Text").text
    local msg1 = "addRes 102 "..args
    local msg2 = "addRes 103 "..args
    local msg3 = "addRes 104 "..args
    local msg4 = "addRes 105 "..args
    local msg5 = "addRes 106 "..args

    local msg = {msg1, msg2, msg3, msg4, msg5}

    for i=1, 5 do
        self:gmOrder(msg[i])
    end
    
end

function PnlGMTool:onBtnSend()   
    local args=self.view.inputField:GetComponent("Text").text
    print(args)
    self:gmOrder(args)
end

function PnlGMTool:gmOrder(args)
    self:OutPutViewText("Client",args)
    --,
    local ret = gg.gm:doCmd(args)
    if not ret then
        gg.client.gameServer:send("C2S_Msg_GM",{
            cmd = args
        })
    end
end

function PnlGMTool:onBtnClean()
    self.areaText=""
    self.view.outPutText:GetComponent("Text").text=self.areaText
end

function PnlGMTool:onBtnClose()
    self.destroyTime = 1
    self:close()
end

function PnlGMTool:onBtnAdjust()
    local fontSize = self.view.inputField:GetComponent("Text").fontSize
    fontSize = tonumber(fontSize)
    fontSize = fontSize - 1
    if fontSize < 1 then
        fontSize = 15
    end
    self.view.inputField:GetComponent("Text").fontSize = fontSize
end

function PnlGMTool:receiveInfo(args)  
    self:OutPutViewText("Server",args)
end

function PnlGMTool:OutPutViewText(type,args)
    local date=os.date("%Y-%m-%d %H:%M:%S",now)
    self.areaText=self.areaText.."\n ".."["..date.."] [ "..type.." ] "..args
    self.view.outPutText:GetComponent("Text").text = self.areaText
end

return PnlGMTool