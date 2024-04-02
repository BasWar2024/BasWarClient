

PnlUnionArmyNew = class("PnlUnionArmyNew", ggclass.UIBase)

function PnlUnionArmyNew:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onUpdateUnionData", "onUpdateUnionNft", "onUnionArmyChange", "OnGuildReserveArmyChange" }
end

function PnlUnionArmyNew:onAwake()
    self.view = ggclass.PnlUnionArmyNewView.new(self.pnlTransform)

    self.itemList = {}
    self.scrollView = UILoopScrollView.new(self.view.scrollView, self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
end

-- args = {planetId = }
function PnlUnionArmyNew:onShow()
    self:bindEvent()
    UnionData.C2S_Player_QueryUnionSoliders()
    UnionData.C2S_Player_QueryUnionNfts()

    self:refresh()
end

function PnlUnionArmyNew:refresh()
    local maxArmyCount = cfg.global.UnionArmyTeamsLimit.intValue

    self.dataList = UnionData.unionArmyList or {}
    local dataCount = #self.dataList

    local showItemCount = dataCount
    if dataCount < maxArmyCount then
        showItemCount = showItemCount + 1
    end
    self.view.txtArmyCount.text = string.format("<color=#FD9D13>%s</color>/%s", dataCount, maxArmyCount)

    self.scrollView:setDataCount(showItemCount)

    self:refreshSoldierCount()
end

function PnlUnionArmyNew:onRenderItem(obj, index)
    local item = UnionArmyNewItem:getItem(obj, self.itemList, self)
    item:setData(self.dataList[index], index)
end

function PnlUnionArmyNew:onUpdateUnionData(_, dataType, subDataType )
    if subDataType == PnlUnion.WAREHOUSE_SOLIDIER then
        
    end
end

function PnlUnionArmyNew:onUpdateUnionNft(_, dataType, subDataType )
    if subDataType == PnlUnion.WAREHOUSE_SOLIDIER then
        
    end
end

function PnlUnionArmyNew:onUnionArmyChange()
    self:refresh()
end

function PnlUnionArmyNew:onHide()
    self:releaseEvent()

end

function PnlUnionArmyNew:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnAddSoldier):SetOnClick(function()
        self:onBtnAddSoldier()
    end)
    CS.UIEventHandler.Get(view.btnFast):SetOnClick(function()
        self:onBtnFast()
    end)
    CS.UIEventHandler.Get(view.btnAttack):SetOnClick(function()
        self:onBtnAttack()
    end)
end

function PnlUnionArmyNew:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnAddSoldier)
    CS.UIEventHandler.Clear(view.btnFast)
    CS.UIEventHandler.Clear(view.btnAttack)

end

function PnlUnionArmyNew:onDestroy()
    local view = self.view

end

function PnlUnionArmyNew:onBtnClose()
    self:close()
end

function PnlUnionArmyNew:onBtnAddSoldier()
    local costCfg = cfg.global.GuildReserveArmyCostRes

    local costRes = costCfg.tableValue[1][1]
    local costPer = costCfg.tableValue[1][2]
    local buyMaxCount = cfg.global.GuildReserveArmyLimt.intValue - UnionData.armyData.guildReserveCount

    local args = {
        minCount = 1,
        maxCount = buyMaxCount,
        startCount = 1,
        resId = costRes,
        title = "buy army",
        title2 = "",
    }

    args.yesCallback = function (count)
        UnionData.C2S_Player_AddGuildReserveCount(count)
    end

    args.changeCallback = function (count)
        return count * costPer
    end

    gg.uiManager:openWindow("PnlBuyCount", args)
end

function PnlUnionArmyNew:OnGuildReserveArmyChange()
    self:refreshSoldierCount()
end

function PnlUnionArmyNew:refreshSoldierCount()
    self.view.txtSoldierCount.text = UnionData.armyData.guildReserveCount .. string.format("[<color=#Fd9d13>-%s</color>]", UnionArmyUtil.getSpaceUsed())
end

function PnlUnionArmyNew:onBtnFast()
    gg.uiManager:openWindow("PnlAutoSelectArmy")
end

function PnlUnionArmyNew:onBtnAttack()
    local armys = UnionArmyUtil.getUnionBattleArmys()
    self.signPosId = 3
    BattleData.StartUnionBattle(BattleData.ARMY_TYPE_UNION, self.args.planetId, armys, self.signPosId, CS.Appconst.BattleVersion, UnionUtil.getUnionBattleOperate(self.signPosId))
    UnionData.clearUnionArmy()

    self:close()
end

return PnlUnionArmyNew