

PnlWarPlayerInfo = class("PnlWarPlayerInfo", ggclass.UIBase)

function PnlWarPlayerInfo:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onLoadBoxWarPlayerInfo" }

    self.damageToPerConquest = cfg.global.DamageToPerConquest.intValue
end

function PnlWarPlayerInfo:onAwake()
    self.view = ggclass.PnlWarPlayerInfoView.new(self.pnlTransform)

end

function PnlWarPlayerInfo:onShow()
    self:bindEvent()
    self.view.scrollViewMy:SetActiveEx(false)
    self.view.totalDamageBg:SetActiveEx(false)
    UnionData.C2S_Player_QueryStarmapCampaignPlyStatistics(self.args.campaignId)

end

function PnlWarPlayerInfo:onHide()
    self:releaseEvent()
    self:releaseBoxWarPlayerInfo()
end

function PnlWarPlayerInfo:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlWarPlayerInfo:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlWarPlayerInfo:onDestroy()
    local view = self.view

end

function PnlWarPlayerInfo:onBtnClose()
    self:close()
end

function PnlWarPlayerInfo:onLoadBoxWarPlayerInfo(args, data)
    self:releaseBoxWarPlayerInfo()
    if self.args.campaignId ~= data.campaignId then
        return
    end
    self.boxWarPlayerInfoList = {}
    local maxLoseHp = self.args.maxLoseHp
    local allDamgae = 0
    local allContribution = 0
    for k, v in pairs(data.reports) do
        local con = v.atkHp / self.damageToPerConquest
        allDamgae = allDamgae +  v.atkHp
        allContribution = allContribution + con

        ResMgr:LoadGameObjectAsync("BoxWarPlayerInfo", function(go)
            go.transform:SetParent(self.view.content, false)
            go.transform:Find("TxtName"):GetComponent(UNITYENGINE_UI_TEXT).text = v.playerName
            go.transform:Find("TxtAtkTimes"):GetComponent(UNITYENGINE_UI_TEXT).text = v.atkCnt
            local pencent = v.atkHp / maxLoseHp
            if pencent > 1 then
                pencent = 1
            end
            local pen = math.floor(v.atkHp / self.args.maxHp * 100)
            go.transform:Find("HpBg/TxtHp"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("%s(%s%%)", v.atkHp, pen)
            go.transform:Find("HpBg/ImgHp"):GetComponent(UNITYENGINE_UI_IMAGE).fillAmount = pencent
            go.transform:Find("TxtContribution"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.scientificNotation(con, true)
            table.insert(self.boxWarPlayerInfoList, go)
            return true
        end, true)
    end

    self.view.scrollViewMy:SetActiveEx(true)
    self.view.totalDamageBg:SetActiveEx(true)
    local hpPencent = allDamgae / self.args.maxHp
    self.view.imgHp.fillAmount = hpPencent
    self.view.txtHp.text = allDamgae
    self.view.txtCon.text = Utils.scientificNotation(allContribution, true)
end

function PnlWarPlayerInfo:releaseBoxWarPlayerInfo()
    if self.boxWarPlayerInfoList then
        for k, v in pairs(self.boxWarPlayerInfoList) do
            ResMgr:ReleaseAsset(v)
        end
        self.boxWarPlayerInfoList = nil
    end
end

return PnlWarPlayerInfo