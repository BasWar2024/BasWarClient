

PnlUnionArmy = class("PnlUnionArmy", ggclass.UIBase)

function PnlUnionArmy:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onUnionArmyChange" }
end

function PnlUnionArmy:onAwake()
    self.view = ggclass.PnlUnionArmyView.new(self.pnlTransform)

    local view = self.view

    self.armyItemList = {}
    self.armyScrollView = UILoopScrollView.new(view.armyScrollView, self.armyItemList)
    self.armyScrollView:setRenderHandler(gg.bind(self.onRenderArmy, self))
end

-- args = {planetId = self.curPlanetCfgId, type = }
function PnlUnionArmy:onShow()
    self:bindEvent()

    self.type = self.args.type or constant.UNION_TYPE_ARMY_UNION
    self:onBtnLandPoint(3)
    
    UnionData.clearUnionArmy()

    if self.type == constant.UNION_TYPE_ARMY_UNION then
        UnionData.C2S_Player_StartEditUnionArmys()
    end
    self:refresh()
end

function PnlUnionArmy:onUnionArmyChange()
    self:refresh()
end

function PnlUnionArmy:refresh()
    local count = #UnionData.unionArmyList
    -- self.view.txtCount.text = count .. " / " .. cfg.global.UnionArmyTeamsLimit.intValue

    self.view.txtCount.text = string.format("<color=#18cbff><size=36>%s</size></color>/%s", count, cfg.global.UnionArmyTeamsLimit.intValue)
    self.armyScrollView:setDataCount(count)

    self.view.txtContribution.text = count * cfg.global.perFleetMakeContribute.intValue
end

function PnlUnionArmy:onHide()
    self:releaseEvent()
end

function PnlUnionArmy:onRenderArmy(obj, index)
    local item = UnionArmyItem:getItem(obj, self.armyItemList, self)
    item:setData(UnionData.unionArmyList[index], index)
end

function PnlUnionArmy:bindEvent()
    local view = self.view

    --for i = 1, 4, 1 do
        --self:setOnClick(view.btnLandPointList[i].gameObject, gg.bind(self.onBtnLandPoint, self, i))
    --end

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)

    CS.UIEventHandler.Get(view.btnAtk):SetOnClick(function()
        self:onBtnAtk()
    end)
    CS.UIEventHandler.Get(view.btnAdd):SetOnClick(function()
        self:onBtnAdd()
    end)
    CS.UIEventHandler.Get(view.btnQuickAdd):SetOnClick(function()
        self:onBtnQuickAdd()
    end)
end

function PnlUnionArmy:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnAtk)
    CS.UIEventHandler.Clear(view.btnAdd)
    CS.UIEventHandler.Clear(view.btnQuickAdd)
end

function PnlUnionArmy:onDestroy()
    local view = self.view
    self.armyScrollView:release()
end

function PnlUnionArmy:close()
    -- UnionData.clearUnionArmy()
    ggclass.UIBase.close(self)
end

function PnlUnionArmy:onBtnClose()
    self:close()
end

function PnlUnionArmy:onBtnLandPoint(index)
    self.signPosId = index

    for key, value in pairs(self.view.btnLandPointList) do
        if key == index then
            value.layoutSelect:SetActiveEx(true)
            value.layoutUnselect:SetActiveEx(false)
        else
            value.layoutSelect:SetActiveEx(false)
            value.layoutUnselect:SetActiveEx(true)
        end
    end
end

function PnlUnionArmy:onBtnAtk()
    local armys = UnionUtil.getUnionBattleArmys()

    if self.type == constant.UNION_TYPE_ARMY_UNION then
        BattleData.StartUnionBattle(BattleData.ARMY_TYPE_UNION, self.args.planetId, armys, self.signPosId, CS.Appconst.BattleVersion, UnionUtil.getUnionBattleOperate(self.signPosId))
    else
        BattleData.StartUnionBattle(BattleData.ARMY_TYPE_SELF, self.args.planetId, armys, self.signPosId, CS.Appconst.BattleVersion, UnionUtil.getUnionBattleOperate(self.signPosId))
    end

    UnionData.clearUnionArmy()
end

function PnlUnionArmy:onBtnAdd()
    UnionUtil.startEdit(nil, self.type)
end

function PnlUnionArmy:onBtnQuickAdd()

end

return PnlUnionArmy