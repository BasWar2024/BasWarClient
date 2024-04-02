PnlMyPlanet = class("PnlMyPlanet", ggclass.UIBase)

function PnlMyPlanet:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {}
    self.resPlanetCfg = cfg["resPlanet"]

end

function PnlMyPlanet:onAwake()
    self.view = ggclass.PnlMyPlanetView.new(self.pnlTransform)

end

function PnlMyPlanet:onShow()
    self:bindEvent()

    self:loadResPlanet()

    self:swichType("nft")

    gg.event:dispatchEvent("onShowPlayerInformation", false)

end

function PnlMyPlanet:onHide()
    self:releaseEvent()

    gg.event:dispatchEvent("onShowPlayerInformation", true)

    self:unLoadBoxPlanet()
end

function PnlMyPlanet:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnNft):SetOnClick(function()
        self:onBtnNft()
    end)
    CS.UIEventHandler.Get(view.btnConfusion):SetOnClick(function()
        self:onBtnConfusion()
    end)
end

function PnlMyPlanet:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnNft)
    CS.UIEventHandler.Clear(view.btnConfusion)

end

function PnlMyPlanet:onDestroy()
    local view = self.view

end

function PnlMyPlanet:onBtnClose()
    self:close()
end

function PnlMyPlanet:onBtnPosition(temp)
    -- gg.resPlanetManager:onMove2ResPlanet(self.resPlanetCfg[temp])
end

function PnlMyPlanet:onBtnRename(temp)
    local args = {
        type = 1,
        index = temp
    }
    gg.uiManager:openWindow("PnlRename", args)
end

function PnlMyPlanet:onBtnNft()
    self:swichType("nft")
end

function PnlMyPlanet:onBtnConfusion()
    self:swichType("confusion")
end

function PnlMyPlanet:swichType(temp)
    local view = self.view
    if temp == "nft" then
        view.nftPlanet:SetActive(true)
        view.confusionPlanet:SetActive(false)
        gg.setSpriteAsync(view.btnNft.transform:GetComponent(UNITYENGINE_UI_IMAGE), "button_select_green")

        gg.setSpriteAsync(view.btnConfusion.transform:GetComponent(UNITYENGINE_UI_IMAGE), "button_select_gray")

    else
        view.nftPlanet:SetActive(false)
        view.confusionPlanet:SetActive(true)

        gg.setSpriteAsync(view.btnConfusion.transform:GetComponent(UNITYENGINE_UI_IMAGE), "button_select_green")

        gg.setSpriteAsync(view.btnNft.transform:GetComponent(UNITYENGINE_UI_IMAGE), "button_select_gray")
    end
end

function PnlMyPlanet:loadResPlanet()
    self:unLoadBoxPlanet()

    self.boxPlanet = {}
    local nftIndex = 1
    local confusionIndex = 1
    local index = 1
    local nextPosY = -180

    for k, v in pairs(ResPlanetData.myResPlanetData) do
        local myCfg = self.resPlanetCfg[v.index]
        local cfgId = myCfg.cfgId
        local args = 0
        if cfgId == 1 then
            args = confusionIndex
            confusionIndex = confusionIndex + 1
        elseif cfgId == 2 then
            args = nftIndex
            nftIndex = nftIndex + 1
        end
        local key = index
        index = index + 1
        ResMgr:LoadGameObjectAsync("BoxMyPlanet", function(go)
            local y = nextPosY * (args - 1)
            if cfgId == 1 then
                go.transform:SetParent(self.view.confusionPlanetContent, false)
                go.transform:Find("BtnRename").gameObject:SetActive(false)
            elseif cfgId == 2 then
                go.transform:SetParent(self.view.nftPlanetContent, false)
                go.transform:Find("BtnRename").gameObject:SetActive(true)

            end

            go.transform.anchoredPosition = Vector2.New(0, y)

            local txtName = v.planetName
            local txtPosition = "aaaaa"

            go.transform:Find("TxtName"):GetComponent(UNITYENGINE_UI_TEXT).text = txtName
            go.transform:Find("TxtPosition"):GetComponent(UNITYENGINE_UI_TEXT).text = txtPosition

            local txtRes1 = go.transform:Find("TxtRes1"):GetComponent(UNITYENGINE_UI_TEXT)
            local iconRes1 = go.transform:Find("IconRes1"):GetComponent(UNITYENGINE_UI_IMAGE)
            local txtRes2 = go.transform:Find("TxtRes2"):GetComponent(UNITYENGINE_UI_TEXT)
            local iconRes2 = go.transform:Find("IconRes2"):GetComponent(UNITYENGINE_UI_IMAGE)

            if v.currencies[1] then
                gg.setSpriteAsync(iconRes1, constant.RES_2_CFG_KEY[v.currencies[1].resCfgId].icon)

                txtRes1.text = v.currencies[1].count
                txtRes1.gameObject:SetActive(true)
                iconRes1.gameObject:SetActive(true)
            else
                txtRes1.gameObject:SetActive(false)
                iconRes1.gameObject:SetActive(false)
            end

            if v.currencies[2] then
                gg.setSpriteAsync(iconRes2, constant.RES_2_CFG_KEY[v.currencies[2].resCfgId].icon)

                txtRes2.text = v.currencies[2].count
                txtRes2.gameObject:SetActive(true)
                iconRes2.gameObject:SetActive(true)
            else
                txtRes2.gameObject:SetActive(false)
                iconRes2.gameObject:SetActive(false)
            end
            CS.UIEventHandler.Get(go.transform:Find("BtnPosition").gameObject):SetOnClick(function()
                self:onBtnPosition(v.index)
            end)
            CS.UIEventHandler.Get(go.transform:Find("BtnRename").gameObject):SetOnClick(function()
                self:onBtnRename(v.index)
            end)

            self.boxPlanet[key] = go
            return true
        end, true)
    end
    local confusionViewHigh = nextPosY * (confusionIndex - 1) - 10
    self.view.confusionPlanetContent.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(0,
        -confusionViewHigh)

    local nftViewHigh = nextPosY * (nftIndex - 1) - 10
    self.view.nftPlanetContent.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(0, -nftViewHigh)
end

function PnlMyPlanet:unLoadBoxPlanet()
    if self.boxPlanet then
        for k, v in pairs(self.boxPlanet) do
            CS.UIEventHandler.Clear(v.transform:Find("BtnPosition").gameObject)
            CS.UIEventHandler.Clear(v.transform:Find("BtnRename").gameObject)

            ResMgr:ReleaseAsset(v)
        end
        self.boxPlanet = {}
    end
end

return PnlMyPlanet
