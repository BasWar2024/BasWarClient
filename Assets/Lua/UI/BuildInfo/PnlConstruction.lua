PnlConstruction = class("PnlConstruction", ggclass.UIBase)

function PnlConstruction:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {}
end

function PnlConstruction:onAwake()
    self.view = ggclass.PnlConstructionView.new(self.pnlTransform)

end

function PnlConstruction:onShow()
    self:bindEvent()
    self:setLevel()
    self:loadBoxBuildConstruction()
end

function PnlConstruction:onHide()
    self:releaseEvent()

    self:releaseBoxBuildConstruction()
end

function PnlConstruction:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.bgBlack):SetOnClick(function()
        self:close()
    end, "event:/UI_button_click", "se_UI", false)
end

function PnlConstruction:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.bgBlack)

end

function PnlConstruction:onDestroy()
    local view = self.view

end

function PnlConstruction:setLevel()
    self.view.txtUpgradeLevelBefore.text = self.args.level
    self.view.txtUpgradeLevelAfter.text = self.args.level + 1
    self.view.txtConstruction.text = string.format("%s/%s", self.args.totalConstruction, self.args.curConstruction)
    local per = self.args.totalConstruction / self.args.curConstruction
    self.view.slider.fillAmount = per
end

function PnlConstruction:loadBoxBuildConstruction()
    self:releaseBoxBuildConstruction()
    self.boxBuildList = {}
    local buildTable = gg.buildingManager.buildingTable
    local showTable = {}
    for k, v in pairs(buildTable) do
        local buildCfg = v.buildCfg
        if buildCfg.type ~= constant.BUILD_CLUTTER then
            local upCfg = cfg.getCfg("build", buildCfg.cfgId, buildCfg.level + 1, buildCfg.quality)
            local isUnlock = gg.buildingManager:checkUpgradeLock(buildCfg)
            if upCfg and isUnlock and self.args.id ~= v.buildData.id then
                local construction = upCfg.construction - buildCfg.construction
                if construction > 0 then
                    local data = {
                        id = v.buildData.id,
                        icon = buildCfg.icon,
                        level = buildCfg.level,
                        languageNameID = buildCfg.languageNameID,
                        construction = construction,
                        buildData = v.buildData
                    }
                    table.insert(showTable, data)
                end
            end
        end
    end

    for k, value in pairs(gg.buildingManager.buildingCfg) do
        if value.level == 1 and value.quality == 0 and value.construction > 0 and
            gg.buildingManager:checkBuildCountEnought(value.cfgId, value.quality).isCanBuild then
            local data = {
                id = 0,
                type = value.type,
                icon = value.icon,
                level = value.level,
                languageNameID = value.languageNameID,
                construction = value.construction,
                buildData = nil
            }
            table.insert(showTable, data)
        end
    end

    QuickSort.quickSort(showTable, "construction", 1, #showTable)

    for k, buildCfg in pairs(showTable) do
        ResMgr:LoadGameObjectAsync("BoxBuildConstruction", function(go)
            go.transform:SetParent(self.view.content, false)

            local iconName = gg.getSpriteAtlasName("Build_B_Atlas", buildCfg.icon .. "_B")
            gg.setSpriteAsync(go.transform:Find("IconBuild"):GetComponent(UNITYENGINE_UI_IMAGE), iconName)

            go.transform:Find("TxtLv"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("Lv.%s", buildCfg.level)
            go.transform:Find("TxtName"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(buildCfg.languageNameID)
            go.transform:Find("TxtCon"):GetComponent(UNITYENGINE_UI_TEXT).text = "+" .. buildCfg.construction

            if buildCfg.id ~= 0 and buildCfg.buildData then
                go.transform:Find("BtnUp/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
                    "res_UpgradeButton")
                CS.UIEventHandler.Get(go.transform:Find("BtnUp").gameObject):SetOnClick(function()
                    self:onBtnUp(buildCfg.buildData)
                end, "event:/UI_button_click", "se_UI", false)
            else
                go.transform:Find("BtnUp/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
                    "universal_BuildButton")
                CS.UIEventHandler.Get(go.transform:Find("BtnUp").gameObject):SetOnClick(function()
                    self:onBtnBuild(buildCfg.type)
                end, "event:/UI_button_click", "se_UI", false)

            end

            table.insert(self.boxBuildList, go)
            return true
        end, true)

    end
end

function PnlConstruction:releaseBoxBuildConstruction()
    if self.boxBuildList then
        for k, v in pairs(self.boxBuildList) do
            CS.UIEventHandler.Clear(v.transform:Find("BtnUp").gameObject)
            ResMgr:ReleaseAsset(v)
        end
        self.boxBuildList = nil
    end
end

function PnlConstruction:onBtnUp(buildData)
    gg.uiManager:openWindow("PnlBuildInfo", {
        buildInfo = buildData,
        type = ggclass.PnlBuildInfo.TYPE_UPGRADE
    })
    self:close()
end

function PnlConstruction:onBtnBuild(type)
    self:close()
    gg.uiManager:closeWindow("PnlBuildInfo")
    local data = {
        ["type"] = type
    }
    gg.uiManager:openWindow("PnlBuild", data)
end

return PnlConstruction
