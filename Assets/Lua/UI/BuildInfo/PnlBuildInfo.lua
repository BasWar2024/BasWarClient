

PnlBuildInfo = class("PnlBuildInfo", ggclass.UIBase)

function PnlBuildInfo:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onUpdateBuildData", "onRefreshResTxt"}
    self.attrItemList = {}
end

function PnlBuildInfo:onAwake()
    self.view = ggclass.PnlBuildInfoView.new(self.transform)
    self.attrScrollView = UIScrollView.new(self.view.scRectAttr, "CommonAttrItem2", self.attrItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderAttr, self))
end

PnlBuildInfo.TYPE_INFO = 1
PnlBuildInfo.TYPE_UPGRADE = 2

-- args = {buildInfo = , type = }
function PnlBuildInfo:onShow()
    self:bindEvent()
    self:refresh()
end

function PnlBuildInfo:refresh()
    local view = self.view
    self.type = self.args.type or 1
    self.buildInfo = self.args.buildInfo
    self.buildCfg = BuildUtil:getBuildCfgMap()[self.buildInfo.cfgId][self.buildInfo.level]
    self.nextLevelCfg = BuildUtil:getBuildCfgMap()[self.buildInfo.cfgId][self.buildInfo.level+ 1]

    -- gg.setSpriteAsync(view.imgBuild, self.buildCfg.icon)
    view.txtName.text = self.buildCfg.name
    view.txtLevel.text = self.buildInfo.level
    view.txtAlert.transform:SetActiveEx(false)

    self.attrCfgList = BuildUtil:getAttrList(self.buildCfg.showAttr)
    if self.type == PnlBuildInfo.TYPE_INFO then
        self:refreshInfo()
    elseif self.type == PnlBuildInfo.TYPE_UPGRADE then
        self:refreshUpgrade()
    end
end

function PnlBuildInfo:refreshInfo()
    local view = self.view
    local buildCfg = self.buildCfg
    view.LayoutInfo.transform:SetActiveEx(true)
    view.layoutUpgrade.transform:SetActiveEx(false)
    view.txtDesc.text = buildCfg.desc
    view.txtTitle.text = buildCfg.name
    view.imgEnoughtUpgrade.transform:SetActiveEx(false)
    view.txtAlertUnlock.transform:SetActiveEx(self.buildCfg.cfgId == 1001001 
        and BuildUtil:getBuildCfgMap()[self.buildCfg.cfgId][self.buildCfg.level + 1] ~= nil)

    if buildCfg.pledgeId and buildCfg.pledgeId > 0 then
        local pledgeData = BuildData.pledgeData[buildCfg.pledgeId]
        self.pledgeData = pledgeData
        if pledgeData and pledgeData.mit > 0 then
            view.txtAlert.transform:SetActiveEx(true)
            view.txtAlert.text = "Production is increasing......"
        elseif buildCfg.cfgId == 1101001 then
            view.txtAlert.transform:SetActiveEx(true)
            view.txtAlert.text = "Not working: MIT pledge require!"
        end
    end
    self.attrScrollView:setItemCount(#self.attrCfgList)
end

function PnlBuildInfo:refreshUpgrade()
    local view = self.view
    local buildCfg = self.buildCfg
    view.LayoutInfo.transform:SetActiveEx(false)
    view.layoutUpgrade.transform:SetActiveEx(true)
    view.txtTitle.text = string.format("up to level %s", buildCfg.level + 1)
    view.layoutPledge:SetActiveEx(self.buildCfg.pledgeId ~= nil and self.buildCfg.pledgeId > 0)
    view.commonUpgradeBox:setMessage(buildCfg, self.buildInfo.lessTickEnd)
    view.imgEnoughtUpgrade.transform:SetActiveEx(Utils:checkIsEnoughtLevelUpRes(buildCfg))

    local attrCfgList = {}
    if self.nextLevelCfg then
        for key, value in pairs(self.attrCfgList) do
            if Utils:GetAttrByCfg(value, self.buildCfg) ~= Utils:GetAttrByCfg(value, self.nextLevelCfg) then
                table.insert(attrCfgList, value)
            end
        end
    end
    self.attrCfgList = attrCfgList
    self.attrScrollView:setItemCount(#self.attrCfgList)

    if self.buildCfg.UnlockTechnology and next(self.buildCfg.UnlockTechnology) then
        view.LayoutUnlockTechnology:SetActiveEx(true)

        for index, value in ipairs(view.buildInfoTechnoItemList) do
            local techid = self.buildCfg.UnlockTechnology[1][index]
            if techid then
                value:setActive(true)
                -- local technologyCfg = cfg.Technology[techid]
                value:setData(cfg.Technology[techid])
            else
                value:setActive(false)
            end
        end
    else
        view.LayoutUnlockTechnology:SetActiveEx(false)
    end
end

function PnlBuildInfo:onUpdateBuildData(args, data)
    if data.id == self.buildInfo.id then
        self:setArgs({buildInfo = data, type = self.type})
        self:refresh()
    end
end

function PnlBuildInfo:onRefreshResTxt()
    local view = self.view
    if self.type == self.TYPE_UPGRADE then
        --self:refreshUpgrade()
        view.imgEnoughtUpgrade.transform:SetActiveEx(Utils:checkIsEnoughtLevelUpRes(self.buildCfg))
    end
end

function PnlBuildInfo:onHide()
    self:releaseEvent()
end

function PnlBuildInfo:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:close()
    end)

    view.commonUpgradeBox:setInstantCallback(gg.bind(self.onBtnInstant, self))
    view.commonUpgradeBox:setUpgradeCallback(gg.bind(self.onBtnUpgrade, self, 0))

    self:setOnClick(view.btnPledge, gg.bind(self.onBtnPledge, self))
    self:setOnClick(view.btnTakeOut, gg.bind(self.onBtnTakeOut, self))
end

function PnlBuildInfo:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
end

function PnlBuildInfo:onDestroy()
    local view = self.view
    self.attrScrollView:release()
    view.commonUpgradeBox:release()
end

function PnlBuildInfo:onBtnUpgrade(upgradeType)
    if gg.buildingManager:checkResources(self.buildCfg) and gg.buildingManager:chenckWorkers() then
        BuildData.C2S_Player_BuildLevelUp(self.buildInfo.id, upgradeType)
    else
        gg.uiManager:showTip("Insufficient resources")
    end
end

function PnlBuildInfo:onBtnInstant()
    if self.buildInfo.lessTickEnd > os.time() then
        BuildData.C2S_Player_SpeedUp_BuildLevelUp(self.buildInfo.id)
    else
        self:onBtnUpgrade(1)
    end
end

function PnlBuildInfo:onBtnPledge()
    print("onBtnPledge")
    gg.uiManager:openWindow("PnlPledgeSet", {pledgeId = self.buildCfg.pledgeId})
end

function PnlBuildInfo:onBtnTakeOut()
    print("onBtnTakeOut")
    BuildData.C2S_Player_PledgeCancel(self.buildCfg.pledgeId)
end

function PnlBuildInfo:onRenderAttr(obj, index)
    local item = CommonAttrItem2:getItem(obj, self.attrItemList)
    item:setAddAttrActive(self.type == self.TYPE_UPGRADE)
    if self.type == self.TYPE_INFO then
        item:setColorType(CommonAttrItem2.TYPE_BROWN)
        if self.buildCfg.pledgeId and self.buildCfg.pledgeId > 0 then
            if constant.RES_2_CFG_KEY[self.buildCfg.pledgeId].perMakeKey == self.attrCfgList[index].cfgKey and 
                self.pledgeData and self.pledgeData.mit then
                local pledgeCfg = cfg.pledge[self.buildCfg.pledgeId]
                local rate = load(pledgeCfg.expression)()(self.pledgeData.mit)
                local attr = Utils:GetAttrByCfg(self.attrCfgList[index], self.buildCfg)
                local curAttr = attr * rate
                if attr ~= curAttr then
                    item:setAddAttrActive(true)
                    item:setData2(index, self.attrCfgList, self.buildCfg, curAttr)
                    return
                end
            end
        end
        item:setData2(index, self.attrCfgList, self.buildCfg)
    else
        item:setData(index, self.attrCfgList, self.buildCfg, self.nextLevelCfg)
        item:setColorType(CommonAttrItem2.TYPE_GREEN)
    end
end

return PnlBuildInfo