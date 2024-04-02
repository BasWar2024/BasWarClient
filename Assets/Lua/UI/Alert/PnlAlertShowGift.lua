PnlAlertShowGift = class("PnlAlertShowGift", ggclass.UIBase)

function PnlAlertShowGift:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {}
end

function PnlAlertShowGift:onAwake()
    self.view = ggclass.PnlAlertShowGiftView.new(self.pnlTransform)

end

function PnlAlertShowGift:onShow()
    self:bindEvent()

    self:loadShowGiftItem()
end

function PnlAlertShowGift:onHide()
    self:releaseEvent()
    self:releaseShowGiftItem()

end

function PnlAlertShowGift:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnReceive):SetOnClick(function()
        self:onBtnReceive()
    end)
end

function PnlAlertShowGift:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnReceive)

end

function PnlAlertShowGift:onDestroy()
    local view = self.view

end

function PnlAlertShowGift:onBtnReceive()
    self:close()
end

function PnlAlertShowGift:loadShowGiftItem()
    self:releaseShowGiftItem()
    self.showGiftItemList = {}
    local itemCfgId = self.args.cfgId
    local count = self.args.count

    local itemCfg = cfg.item[itemCfgId]
    for k, v in pairs(itemCfg.effect) do
        local effCfg = cfg.itemEffect[v]
        ResMgr:LoadGameObjectAsync("ShowGiftItem", function(go)
            go.transform:SetParent(self.view.content, false)
            self:setData(go, effCfg, count)
            table.insert(self.showGiftItemList, go)
            return true
        end, true)
    end
end

function PnlAlertShowGift:releaseShowGiftItem()
    if self.showGiftItemList then
        for k, v in pairs(self.showGiftItemList) do
            ResMgr:ReleaseAsset(v)
        end
        self.showGiftItemList = nil
    end
end

function PnlAlertShowGift:setData(go, effCfg, count)
    local imgBg = go.transform:GetComponent(UNITYENGINE_UI_IMAGE)
    local icon = go.transform:Find("Mask/Icon"):GetComponent(UNITYENGINE_UI_IMAGE)
    local quailty = 0
    local iconName = ""

    if effCfg.effectType == constant.GIFT_EFFECT_WARSHIP then
        local cfgId = effCfg.value[1]
        quailty = effCfg.value[2]
        local lv = effCfg.value[3]
        local curCfg = cfg.getCfg("warShip", cfgId, lv, quailty)
        iconName = gg.getSpriteAtlasName("Warship_A_Atlas", curCfg.icon .. "_A")

    elseif effCfg.effectType == constant.GIFT_EFFECT_HERO then
        local cfgId = effCfg.value[1]
        quailty = effCfg.value[2]
        local lv = effCfg.value[3]
        local curCfg = cfg.getCfg("hero", cfgId, lv, quailty)
        iconName = gg.getSpriteAtlasName("Hero_A_Atlas", curCfg.icon .. "_A")
    elseif effCfg.effectType == constant.GIFT_EFFECT_CARD then
        local cfgId = effCfg.value[1]
        local num = effCfg.value[2]
        local curCfg = cfg.getCfg("item", cfgId)
        iconName = gg.getSpriteAtlasName("Skill_A1_Atlas", curCfg.icon .. "_A1")
        quailty = curCfg.quailty
        count = count * num
    elseif effCfg.effectType == constant.GIFT_EFFECT_RES then
        local resId = effCfg.value[1]
        local num = effCfg.value[2]
        iconName = constant.RES_2_CFG_KEY[resId].icon
        count = count * num / 1000
    end

    UIUtil.setQualityBg(imgBg, quailty)
    if iconName ~= "" then
        gg.setSpriteAsync(icon, iconName)
    else
        icon.gameObject:SetActiveEx(false)
    end
    go.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("X %.0f", count)
end

return PnlAlertShowGift
