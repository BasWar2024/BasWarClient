PnlBuild = class("PnlBuild", ggclass.UIBase)

PnlBuild.closeType = ggclass.UIBase.CLOSE_TYPE_BG

PnlBuild.infomationType = ggclass.UIBase.INFOMATION_RES
PnlBuild.needFitSafeArea = true

function PnlBuild:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onRefreshResTxt"}
    self.needBlurBG = true
    -- self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_DOWN_2_UP
end

function PnlBuild:onAwake()
    self.view = ggclass.PnlBuildView.new(self.pnlTransform)

    self.buildItemList = {}
    self.buildScrollView = UIScrollView.new(self.view.buildScrollView, "CardModle", self.buildItemList, false, true)
    self.buildScrollView:setRenderHandler(gg.bind(self.onRenderBuildItem, self))

    self.redPointMap = {
        [ggclass.RedPointBuildEconomic.__name] = true,
        [ggclass.RedPointBuildDevelopment.__name] = true,
        [ggclass.RedPointBuildDefense.__name] = true
    }
    self.view.bottomOptionalBtnsBox:setBtnDataList({{
        nameKey = "build_Economy",
        callback = gg.bind(self.onBtnOptions, self, PnlBuild.TYPE_ECONOMY),
        redPointName = RedPointBuildEconomic.__name
    }, {
        nameKey = "build_Development",
        callback = gg.bind(self.onBtnOptions, self, PnlBuild.TYPE_DEVELOPMENT),
        redPointName = RedPointBuildDevelopment.__name
    }, {
        nameKey = "build_Defense",
        callback = gg.bind(self.onBtnOptions, self, PnlBuild.TYPE_DEFENSE),
        redPointName = RedPointBuildDefense.__name
    } -- {name = "not open", callback = gg.bind(self.onBtnOptions, self, PnlBuild.TYPE_NOTOPEN)},
    })
end

-- args = {type = }
function PnlBuild:onShow()
    self:bindEvent()

    local type = 1
    if self.args then
        type = self.args.type or 1
    end

    self.view.bottomOptionalBtnsBox:open()
    self.view.bottomOptionalBtnsBox:onBtn(type)
end

PnlBuild.TYPE_ECONOMY = 1
PnlBuild.TYPE_DEVELOPMENT = 2
PnlBuild.TYPE_DEFENSE = 3
PnlBuild.TYPE_NOTOPEN = 100

function PnlBuild:onBtnOptions(type)

    if type == PnlBuild.TYPE_NOTOPEN then
        return false
    end

    self.dataList = nil
    if type == PnlBuild.TYPE_ECONOMY then
        self.dataList = gg.buildingManager.buildingTableOfEconomic
    elseif type == PnlBuild.TYPE_DEVELOPMENT then
        self.dataList = gg.buildingManager.buildingTableOfDevelopment
    elseif type == PnlBuild.TYPE_DEFENSE then
        self.dataList = gg.buildingManager.buildingTableOfDefense
    end

    self.checkBuildResultMap = {}
    for key, value in pairs(self.dataList) do
        self.checkBuildResultMap[value.cfgId] = gg.buildingManager:checkBuildCountEnought(value.cfgId, value.quality)
    end

    table.sort(self.dataList, function(a, b)
        -- if not self.checkBuildResultMap[a.cfgId] then
        --     self.checkBuildResultMap[a.cfgId] = gg.buildingManager:checkBuildCountEnought(a.cfgId, a.quality)
        -- end

        if not self.checkBuildResultMap[b.cfgId] then
            self.checkBuildResultMap[b.cfgId] = gg.buildingManager:checkBuildCountEnought(b.cfgId, a.quality)
        end
        local isCanBuildA = self.checkBuildResultMap[a.cfgId].isCanBuild
        local isCanBuildB = self.checkBuildResultMap[b.cfgId].isCanBuild
        if isCanBuildA ~= isCanBuildB then
            return isCanBuildA
        end
        return a.cfgId < b.cfgId
    end)

    self.buildScrollView:setContentAnchoredPosition(0)
    self.buildScrollView:setItemCount(#self.dataList)
end

function PnlBuild:onRenderBuildItem(obj, index)
    local item = BuildingCardModel:getItem(obj, self.buildItemList, self)
    local data = self.dataList[index]
    item:setData(data, self.checkBuildResultMap[data.cfgId])
end

function PnlBuild:onHide()
    self:releaseEvent()
    -- gg.event:dispatchEvent("onReturnSpineAni", 1)
    self.view.bottomOptionalBtnsBox:close()

end

function PnlBuild:bindEvent()
    local view = self.view

end

function PnlBuild:releaseEvent()
    local view = self.view
end

function PnlBuild:onDestroy()
    local view = self.view
    self.buildScrollView:release()
    self.view.bottomOptionalBtnsBox:release()
end

function PnlBuild:onRefreshResTxt()
    for key, value in pairs(self.buildItemList) do
        value:refreshRes()
    end
end

-- override
function PnlBuild:getGuideRectTransform(guideCfg)
    if guideCfg.gameObjectName == "BuildTypeEconomy" then
        return self.view.bottomOptionalBtnsBox.btnList[1].gameObject

    elseif guideCfg.gameObjectName == "BuildTypeDevelopment" then
        return self.view.bottomOptionalBtnsBox.btnList[2].gameObject

    elseif guideCfg.gameObjectName == "BuildTypeDefense" then
        return self.view.bottomOptionalBtnsBox.btnList[3].gameObject

    elseif guideCfg.gameObjectName == "Building" then
        for key, value in pairs(self.buildItemList) do
            if value.data.cfgId == guideCfg.otherArgs[1] then
                return value.gameObject
            end
        end
    end
    return ggclass.UIBase.getGuideRectTransform(self, guideCfg)
end

-- override
function PnlBuild:triggerGuideClick(guideCfg)
    if guideCfg.gameObjectName == "BuildTypeEconomy" then
        self.view.bottomOptionalBtnsBox:onBtn(1)

    elseif guideCfg.gameObjectName == "BuildTypeDevelopment" then
        self.view.bottomOptionalBtnsBox:onBtn(2)

    elseif guideCfg.gameObjectName == "BuildTypeDefense" then
        self.view.bottomOptionalBtnsBox:onBtn(3)

    elseif guideCfg.gameObjectName == "Building" then
        for key, value in pairs(self.buildItemList) do
            if value.data.cfgId == guideCfg.otherArgs[1] then
                local pos = nil
                if guideCfg.eventArgs then
                    pos = guideCfg.eventArgs[1]
                end
                return value:onClickItem(pos, true)
            end
        end
    else
        ggclass.UIBase.triggerGuideClick(self, guideCfg)
    end
end

return PnlBuild
