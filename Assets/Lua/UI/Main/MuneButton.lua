MuneButton = MuneButton or class("MuneButton", ggclass.UIBaseItem)

function MuneButton:ctor(obj)
    UIBaseItem.ctor(self, obj)

    self.events = {"onRedPointChange", "onUpdateBuildData"}
    self:open()
end

function MuneButton:onInit()
    self.btnMenu = self:Find("BtnMenu")
    self.btnMail = self:Find("BtnMail")
    self.btnSetting = self:Find("BtnSetting")
    self.btnHq = self:Find("Bg/BtnHq")
    self.btnDao = self:Find("Bg/BtnDao")
    self.btnShop = self:Find("Bg/BtnShop")
    self.btnPVE = self:Find("Bg/BtnPVE")
    self.btnMatch = self:Find("Bg/BtnMatch")
    self.btnCard = self:Find("Bg/BtnCard")

    self.imgBtnMatchBottom = self.btnMatch.transform:Find("Image")
    self.textBtnMatchBottom = self.btnMatch.transform:Find("Image/Text")


    self.redPointBtnMap = {
        [RedPointMail.__name] = self.btnMail,
        [RedPointUnion.__name] = self.btnDao,
        [RedPointDrawCard.__name] = self.btnCard,
        [RedPointMainMenu.__name] = self.btnMenu,
        [RedPointHeadquarters.__name] = self.btnHq,
        [RedPointItemBag.__name] = self.btnShop,
        [RedPointPve.__name] = self.btnPVE
    }

    self:initRedPoint()
    self.menuBg = self:Find("Bg")
    self.menuBg:SetActiveEx(false)

    self:setOnClick(self.btnMenu, gg.bind(self.onBtnMenu, self))
    self:setOnClick(self.btnMail, gg.bind(self.onBtnMail, self))
    self:setOnClick(self.btnSetting, gg.bind(self.onBtnSetting, self))
    self:setOnClick(self.btnHq, gg.bind(self.onBtnHq, self))
    self:setOnClick(self.btnDao, gg.bind(self.onBtnDao, self))
    self:setOnClick(self.btnShop, gg.bind(self.onBtnShop, self))
    self:setOnClick(self.btnPVE, gg.bind(self.onBtnPVE, self))
    self:setOnClick(self.btnMatch, gg.bind(self.onBtnMatch, self))
    self:setOnClick(self.btnCard, gg.bind(self.onBtnCard, self))

    self:refreshPvpStage()
end

function MuneButton:initRedPoint()
    for key, value in pairs(self.redPointBtnMap) do
        RedPointManager:setRedPoint(value, RedPointManager:getIsRed(key))
    end
end

function MuneButton:onRedPointChange(_, name, isRed)
    if self.redPointBtnMap[name] then
        RedPointManager:setRedPoint(self.redPointBtnMap[name], isRed)
    end
end

function MuneButton:onUpdateBuildData()
    self:refreshPvpStage()
end


function MuneButton:onBtnMenu()
    local bool = self.menuBg.activeSelf
    self.menuBg:SetActiveEx(not bool)
end

function MuneButton:onBtnMail()
    gg.uiManager:openWindow("PnlMail")
    gg.buildingManager:cancelBuildOrMove()

end

function MuneButton:onBtnSetting()
    gg.uiManager:openWindow("PnlSetting")
    gg.buildingManager:cancelBuildOrMove()

end

function MuneButton:onBtnHq()
    gg.uiManager:openWindow("PnlHeadquarters")
end

function MuneButton:onBtnDao()
    gg.uiManager:openWindow("PnlUnion")
    gg.buildingManager:cancelBuildOrMove()
end

function MuneButton:onBtnShop()
    -- print("onBtnShop")
    -- gg.uiManager:showTip("currently unavailable")
    local args = {
        bagBelong = PnlItemBagNew.BAGBELONG_ME
    }
    gg.uiManager:openWindow("PnlItemBagNew", args)
    gg.buildingManager:cancelBuildOrMove()
end

function MuneButton:onBtnPVE()
    gg.uiManager:openWindow("PnlPveNew")
    gg.buildingManager:cancelBuildOrMove()
end

function MuneButton:onBtnMatch()
    local baseLevel = gg.buildingManager:getBaseLevel()

    if baseLevel < cfg.global.PvpUnlockLevel.intValue then
        -- gg.uiManager:showTip("function open after base above level 3")
        gg.uiManager:showTip(Utils.getText("pvp_UnlockTips"))
    else
        gg.uiManager:openWindow("PnlPvp")
        gg.buildingManager:cancelBuildOrMove()
    end
end

function MuneButton:refreshPvpStage()
    local baseLevel = gg.buildingManager:getBaseLevel()
    if baseLevel < cfg.global.PvpUnlockLevel.intValue then
        -- self.view.matchSpine.color = CS.UnityEngine.Color(0.4, 0.4, 0.4, 1)

        EffectUtil.setGray(self.imgBtnMatchBottom, true, true)
    else
        -- self.view.matchSpine.color = CS.UnityEngine.Color(1, 1, 1, 1)
        EffectUtil.setGray(self.imgBtnMatchBottom, false, true)
    end
end

function MuneButton:onBtnCard()
    gg.uiManager:openWindow("PnlDrawCard")
end

function MuneButton:onRelease()
    for k, v in pairs(self.redPointBtnMap) do
        RedPointManager:releaseRedPoint(v)
    end
    self.redPointBtnMap = nil
    self.menuBg = nil
    self.btnMenu = nil
    self.btnMail = nil
    self.btnSetting = nil
    self.btnHq = nil
    self.btnDao = nil
    self.btnShop = nil
    self.btnPVE = nil
    self.btnMatch = nil
    self.btnCard = nil
end
