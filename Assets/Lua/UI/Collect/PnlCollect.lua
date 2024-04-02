PnlCollect = class("PnlCollect", ggclass.UIBase)

function PnlCollect:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {}

    self.resPlanetCfg = cfg["resPlanet"]
end

function PnlCollect:onAwake()
    self.view = ggclass.PnlCollectView.new(self.pnlTransform)

end

function PnlCollect:onShow()
    self:bindEvent()
    self:loadBoxCollect()
    gg.event:dispatchEvent("onShowPlayerInformation", false)

end

function PnlCollect:onHide()
    self:releaseEvent()
    gg.event:dispatchEvent("onShowPlayerInformation", true)

end

function PnlCollect:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)

    gg.event:addListener("onRefreshBoxCollect", self)
end

function PnlCollect:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    gg.event:removeListener("onRefreshBoxCollect", self)

end

function PnlCollect:onDestroy()
    local view = self.view

end

function PnlCollect:onBtnClose()
    self:close()
end

function PnlCollect:onBtnPosition(temp)
    --gg.resPlanetManager:onMove2ResPlanet(self.resPlanetCfg[temp])
end

function PnlCollect:onBtnDelete(temp)
    -- GalaxyData.C2S_Player_RemoveResPlanetFromMyFavorites(temp)
end

function PnlCollect:onBtnRemake(temp)
    local args = {
        type = 2,
        index = temp
    }
    gg.uiManager:openWindow("PnlRename", args)
end

function PnlCollect:onRefreshBoxCollect()
    self:loadBoxCollect()
    gg.uiManager:closeWindow("PnlRename")
end

function PnlCollect:loadBoxCollect()
    self:unLoadBoxCollect()
    self.boxCollect = {}

    local index = 1
    local nextPosY = -180

    for k, v in pairs(ResPlanetData.favoriteResPlanetData) do
        local args = index
        index = index + 1
        ResMgr:LoadGameObjectAsync("BoxCollect", function(go)
            local y = nextPosY * (args - 1)

            go.transform:SetParent(self.view.content, false)
            go.transform.anchoredPosition = Vector2.New(0, y)

            local txtName = v.planetName
            local txtPosition = "aaaaa"
            if v.remark then
                txtName = v.remark
            end
            go.transform:Find("TxtName"):GetComponent(UNITYENGINE_UI_TEXT).text = txtName
            go.transform:Find("TxtPosition"):GetComponent(UNITYENGINE_UI_TEXT).text = txtPosition

            CS.UIEventHandler.Get(go.transform:Find("BtnPosition").gameObject):SetOnClick(function()
                self:onBtnPosition(v.index)
            end)
            CS.UIEventHandler.Get(go.transform:Find("BtnDelete").gameObject):SetOnClick(function()
                self:onBtnDelete(v.index)
            end)
            CS.UIEventHandler.Get(go.transform:Find("BtnRemark").gameObject):SetOnClick(function()
                self:onBtnRemake(v.index)
            end)
            self.boxCollect[args] = go
            return true
        end, true)
    end

    local height = nextPosY * (index - 1) - 10
    self.view.content.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(0, -height)
end

function PnlCollect:unLoadBoxCollect()
    if self.boxCollect then
        for k, v in pairs(self.boxCollect) do
            CS.UIEventHandler.Clear(v.transform:Find("BtnPosition").gameObject)
            CS.UIEventHandler.Clear(v.transform:Find("BtnDelete").gameObject)
            CS.UIEventHandler.Clear(v.transform:Find("BtnRemark").gameObject)

            ResMgr:ReleaseAsset(v)
        end
        self.boxCollect = {}
    end
end

return PnlCollect
