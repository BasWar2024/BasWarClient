PnlPvpRank = class("PnlPvpRank", ggclass.UIBase)

function PnlPvpRank:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onRankChange"}
end

function PnlPvpRank:onAwake()
    self.view = ggclass.PnlPvpRankView.new(self.pnlTransform)
    local view = self.view

    self.rankItemList = {}
    self.rankScrollView = UILoopScrollView.new(view.rankScrollView, self.rankItemList)
    self.rankScrollView:setRenderHandler(gg.bind(self.onRenderRank, self))

    self.pvpStageBox = PvpStageBox.new(view.pvpStageBox)

    self.pvpRankItem = PvpRankItem.new(view.pvpRankItem)
    PlayerData.C2S_Player_QueryPlayerInfo()

end

function PnlPvpRank:onShow()
    self:bindEvent()
    RankData.C2S_Player_Rank_Info(RankData.RANK_TYPE_PVP)
    self:refresh()
end

function PnlPvpRank:refresh()
    local view = self.view
    gg.setSpriteAsync(view.imgHead, Utils.getHeadIcon(PlayerData.myInfo.headIcon))
    view.txtName.text = PlayerData.getName()
    view.txtDao.text = ""

    local pvpRankData = RankData.rankMap[RankData.RANK_TYPE_PVP]

    if not pvpRankData then
        return
    end

    self.rankDataList = pvpRankData.dataList
    self.rankScrollView:setDataCount(#self.rankDataList)

    self.pvpStageBox:setBlade(pvpRankData.selfRank.value)
    view.txtScore.text = pvpRankData.selfRank.value

    self.pvpRankItem:setData(pvpRankData.selfRank, true)

    if pvpRankData.selfRank.index <= 3 and pvpRankData.selfRank.index > 0 then
        view.txtRank.transform:SetActiveEx(false)
        view.imgRank.transform:SetActiveEx(true)

        gg.setSpriteAsync(view.imgRank, string.format("Rank_Atlas[Rank_Icon_%s]", pvpRankData.selfRank.index))
    else
        view.txtRank.transform:SetActiveEx(true)
        view.imgRank.transform:SetActiveEx(false)
        view.txtRank.text = pvpRankData.selfRank.index
    end
end

function PnlPvpRank:onHide()
    self:releaseEvent()

end

function PnlPvpRank:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlPvpRank:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
end

function PnlPvpRank:onDestroy()
    local view = self.view
    self.rankScrollView:release()
    self.pvpStageBox:release()
    self.pvpRankItem:release()
end

function PnlPvpRank:onRenderRank(obj, index)
    local item = PvpRankItem:getItem(obj, self.rankItemList, self)
    item:setData(self.rankDataList[index])

    -- item:setData(self.dataList[index], self.selectType)
end

function PnlPvpRank:onBtnClose()
    self:close()
end

function PnlPvpRank:onRankChange(event, rankType, version)
    if rankType == RankData.RANK_TYPE_PVP then
        self:refresh()
    end
end
-------------------------------------------------------------
PvpRankItem = PvpRankItem or class("PvpRankItem", ggclass.UIBaseItem)
function PvpRankItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PvpRankItem:onInit()
    self.bg = self:Find("Bg", "Image")
    self.imgRank = self:Find("ImgRank", "Image")
    self.imgSelfRankIcon = self:Find("ImgSelfRankIcon", "Image")
    self.txtRank = self:Find("TxtRank", "Text")
    self.imgHead = self:Find("MaskHead/ImgHead", "Image")
    self.txtName = self:Find("TxtName", "Text")
    self.imgStage = self:Find("ImgStage", "Image")
    self.txtValue = self:Find("TxtValue", "Text")
end

function PvpRankItem:setData(data, isSelf)
    self.data = data

    if isSelf then
        self.txtRank.gameObject:SetActiveEx(true)
        self.imgRank.gameObject:SetActiveEx(false)
        self.imgSelfRankIcon.gameObject:SetActiveEx(true)
        self.bg.gameObject:SetActiveEx(false)
        if data.index == 0 then
            self.txtRank.text = Utils.getText("pvp_History_NotListed")
        else
            self.txtRank.text = data.index
        end
    else
        self.imgSelfRankIcon.gameObject:SetActiveEx(false)
        if data.index <= 3 and data.index > 0 then
            self.txtRank.gameObject:SetActiveEx(false)
            self.imgRank.gameObject:SetActiveEx(true)
            gg.setSpriteAsync(self.imgRank, string.format("Rank_Atlas[Rank_Icon_%s]", data.index))
            self.bg:SetActiveEx(true)
            gg.setSpriteAsync(self.bg, string.format("Rank_Atlas[baseboard_icon_%s]", data.index))
        else
            self.txtRank.gameObject:SetActiveEx(true)
            self.imgRank.gameObject:SetActiveEx(false)

            if data.index == 0 then
                self.txtRank.text = Utils.getText("pvp_History_NotListed")
            else
                self.txtRank.text = data.index
            end

            self.bg:SetActiveEx(false)
        end
    end

    gg.setSpriteAsync(self.imgHead, Utils.getHeadIcon(data.headIcon))

    self.txtName.text = data.name
    self.txtValue.text = data.value

    local stageCfg, nextStageCfg = PvpUtil.bladge2StageCfg(data.value)
    gg.setSpriteAsync(self.imgStage, string.format("PvpStage_Atlas[dan_icon_%s]", stageCfg.stage))
end
----------------------------------------------------------------
return PnlPvpRank
