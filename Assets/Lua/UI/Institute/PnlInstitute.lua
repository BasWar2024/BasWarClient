

PnlInstitute = class("PnlInstitute", ggclass.UIBase)


function PnlInstitute:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)
    self.layer = UILayer.normal
    self.events = {"onItemComposeChange"}
    self.showingType = 0
    self.forceItemList = {}
    self.mineItemList = {}

    self.args = self.args or {}
end

function PnlInstitute:onAwake()
    self.view = ggclass.PnlInstituteView.new(self.transform)
    self.forceScrollView = UIScrollView.new(self.view.scRectForce, "InstituteForceScrollItem", self.forceItemList)
    self.forceScrollView:setRenderHandler(gg.bind(self.onRenderForce, self))
    self.minesScrollView = UIScrollView.new(self.view.scRectMines, "InstituteMineScrollItem", self.mineItemList)
    self.minesScrollView:setRenderHandler(gg.bind(self.onRenderMines, self))
end

--args = {index, openWindow = {name, args}}
function PnlInstitute:onShow()
    self:bindEvent()
    local index = self.args.index or 1
    self:onBtnTop(index, true)

    if self.args.openWindow then
        gg.uiManager:openWindow(self.args.openWindow.name, self.args.openWindow.args)
    end
end

function PnlInstitute:onHide()
    self:releaseEvent()
end

function PnlInstitute:bindEvent()
    local view = self.view
    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    for i = 1, 3 do
        self:setOnClick(view.btnTopList[i], gg.bind(self.onBtnTop, self, i))
    end
end

function PnlInstitute:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
end

function PnlInstitute:onDestroy()
    local view = self.view
    self.forceScrollView:release()
    self.minesScrollView:release()

    for key, value in pairs(self.view.drawItemList) do
        value:release()
    end
end

PnlInstitute.TYPE_MESSAGE = {
    [1] = {name = "layoutForce"},
    [2] = {name = "layoutLandMines"},
    [3] = {name = "layoutDrawings"},
}

function PnlInstitute:onBtnTop(index, isForce)
    local view = self.view
    if self.showingType == index and not isForce then
        return
    end

    self.showingType = index
    for i = 1, 3 do
        if i == index then
            ResMgr:LoadSpriteAsync("button_select_green", function(sprite)
                view.btnTopList[i]:GetComponent("Image").sprite = sprite
            end)
            self.view.typeViewList[i]:SetActiveEx(true)
        else
            ResMgr:LoadSpriteAsync("button_select_gray", function(sprite)
                view.btnTopList[i]:GetComponent("Image").sprite = sprite
            end)
            self.view.typeViewList[i]:SetActiveEx(false)
        end
    end

    if index == 1 then
        self:refreshForce()
    elseif index == 2 then
        self:refreshLandMines()
    elseif index == 3 then
        self:refreshDrawing()
    end
end

function PnlInstitute:refreshForce()
    self.forceDataList = {}
    for key, value in pairs(SoliderUtil:getSoliderCfgMap()) do
        table.insert(self.forceDataList, value)
    end

    table.sort(self.forceDataList, function (a, b)
        return a[0].cfgId < b[0].cfgId
    end)

    self.forceScrollView:setItemCount(math.ceil(#self.forceDataList / 5))
end

function PnlInstitute:onRenderForce(obj, index)
    for i = 1, 5 do
        local idx = (index - 1) * 5 + i
        local item =  InstituteForceItem:getItem(obj.transform:GetChild(i - 1), self.forceItemList)
        item:setData(self.forceDataList[idx])
    end
end

function PnlInstitute:onRenderMines(obj, index)
    for i = 1, 5 do
        local idx = (index - 1) * 5 + i
        local item =  InstituteMineItem:getItem(obj.transform:GetChild(i - 1), self.mineItemList)
        item:setData(self.mineDataList[idx])
    end
end

function PnlInstitute:refreshLandMines()
    self.mineDataList = {}
    for key, value in pairs(MineUtil:getMineCfgMap()) do
        table.insert(self.mineDataList, value)
    end

    table.sort(self.mineDataList, function (a, b)
        return a[0].cfgId < b[0].cfgId
    end)

    self.minesScrollView:setItemCount(math.ceil(#self.mineDataList / 5))
end

function PnlInstitute:refreshDrawing()
    self.drawingDataList = {}
    for key, value in pairs(ItemData.composeItemData) do
        table.insert(self.drawingDataList, value)
    end

    for i = 1, 3 do
        self.view.drawItemList[i]:setData(self.drawingDataList[i])
    end
end

function PnlInstitute:onItemComposeChange()
    if self.showingType == 3 then
        self:refreshDrawing()
    end
end

function PnlInstitute:onBtnClose()
    self:close()
end

return PnlInstitute