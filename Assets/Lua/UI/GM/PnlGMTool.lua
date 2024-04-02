PnlGMTool = class("PnlGMTool", ggclass.UIBase)
PnlGMTool.closeType = ggclass.UIBase.CLOSE_TYPE_NONE

function PnlGMTool:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.popup
    self.events = {}
    self.destroyTime = 0

end

function PnlGMTool:onAwake()
    self.view = ggclass.PnlGMToolView.new(self.transform)

    self.areaText = ""
end

function PnlGMTool:onShow()
    self:bindEvent()

    self.view.buttonList:SetActiveEx(false)

end

function PnlGMTool:onHide()
    self:releaseEvent()

end

function PnlGMTool:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnAddRes):SetOnClick(function()
        self:onBtnAddRes()
    end)
    CS.UIEventHandler.Get(view.btnCostRes):SetOnClick(function()
        self:onBtnCostRes()
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
    CS.UIEventHandler.Get(view.btnOpenList):SetOnClick(function()
        self:onBtnOpenList()
    end)
    CS.UIEventHandler.Get(view.btnGenerateNft):SetOnClick(function()
        self.view.txtInput.text = "oneKeyGenerateNfts 97 5"
    end)
    CS.UIEventHandler.Get(view.btnFullItem):SetOnClick(function()
        self:gmOrder("fullItem")
    end)
    CS.UIEventHandler.Get(view.btnUnionSolider):SetOnClick(function()
        self:gmOrder("genUnionSolider")
    end)
    CS.UIEventHandler.Get(view.btnTemp):SetOnClick(function()
        -- local args = {
        --     bagBelong = PnlGridItemBag.BAGBELONG_MYPLANET
        -- }
        -- gg.uiManager:openWindow("PnlGridItemBag", args)
        local order = {
            productId = "gb.tesseract.499",
            orderId = "123456"
        }
        gg.event:dispatchEvent("onPurchaseClicked", order)
    end)

    self:setOnClick(view.btnEnterEdit, gg.bind(self.onBtnEnterEdit, self))
end

function PnlGMTool:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnAddRes)
    CS.UIEventHandler.Clear(view.btnCostRes)
    CS.UIEventHandler.Clear(view.btnSend)
    CS.UIEventHandler.Clear(view.btnClean)
    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnAdjust)
    CS.UIEventHandler.Clear(view.btnOpenList)
    CS.UIEventHandler.Clear(view.btnGenerateNft)
    CS.UIEventHandler.Clear(view.btnFullItem)
    CS.UIEventHandler.Clear(view.btnUnionSolider)
    CS.UIEventHandler.Clear(view.btnTemp)

end

function PnlGMTool:onDestroy()
    local view = self.view

end

function PnlGMTool:onBtnAddRes()
    local args = self.view.inputField:GetComponent(UNITYENGINE_UI_TEXT).text
    local msg1 = "addRes 101 " .. args
    local msg2 = "addRes 102 " .. args
    local msg3 = "addRes 103 " .. args
    local msg4 = "addRes 104 " .. args
    local msg5 = "addRes 105 " .. args
    local msg6 = "addRes 106 " .. args
    local msg7 = "addRes 107 " .. args

    local msg = {msg1, msg2, msg3, msg4, msg5, msg6, msg7}

    for i = 1, #msg do
        self:gmOrder(msg[i])
    end
end

function PnlGMTool:onBtnCostRes()
    local args = self.view.inputField:GetComponent(UNITYENGINE_UI_TEXT).text
    local msg1 = "costRes 101 " .. args
    local msg2 = "costRes 102 " .. args
    local msg3 = "costRes 103 " .. args
    local msg4 = "costRes 104 " .. args
    local msg5 = "costRes 105 " .. args
    local msg6 = "costRes 106 " .. args
    local msg7 = "costRes 107 " .. args

    local msg = {msg1, msg2, msg3, msg4, msg5, msg6, msg7}

    for i = 1, #msg do
        self:gmOrder(msg[i])
    end

end

function PnlGMTool:onBtnOpenList()
    local bool = self.view.buttonList.activeSelf
    self.view.buttonList:SetActiveEx(not bool)
end

function PnlGMTool:onBtnSend()
    local args = self.view.inputField:GetComponent(UNITYENGINE_UI_TEXT).text
    print(args)
    self:gmOrder(args)
end

function PnlGMTool:gmOrder(args)
    self:OutPutViewText("Client", args)
    -- "",""
    local ret = gg.gm:doCmd(args)
    if not ret then
        gg.client.gameServer:send("C2S_Msg_GM", {
            cmd = args
        })
    end
end

function PnlGMTool:onBtnClean()
    self.areaText = ""
    self.view.outPutText:GetComponent(UNITYENGINE_UI_TEXT).text = self.areaText
end

function PnlGMTool:onBtnClose()
    self:close()
end

function PnlGMTool:onBtnAdjust()
    local fontSize = self.view.inputField:GetComponent(UNITYENGINE_UI_TEXT).fontSize
    fontSize = tonumber(fontSize)
    fontSize = fontSize - 1
    if fontSize < 1 then
        fontSize = 15
    end
    self.view.inputField:GetComponent(UNITYENGINE_UI_TEXT).fontSize = fontSize
end

function PnlGMTool:receiveInfo(args)
    self:OutPutViewText("Server", args)
end

function PnlGMTool:OutPutViewText(type, args)
    local date = os.date("%Y-%m-%d %H:%M:%S", now)
    self.areaText = self.areaText .. "\n " .. "[" .. date .. "] [ " .. type .. " ] " .. args
    self.view.outPutText:GetComponent(UNITYENGINE_UI_TEXT).text = self.areaText
end

function PnlGMTool:onBtnEnterEdit()
    EditData.changeEditMode()
    self:close()
end

return PnlGMTool
