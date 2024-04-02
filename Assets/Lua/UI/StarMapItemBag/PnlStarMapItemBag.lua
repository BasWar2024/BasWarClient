

PnlStarMapItemBag = class("PnlStarMapItemBag", ggclass.UIBase)

function PnlStarMapItemBag:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onUpdateUnionData" }
end

function PnlStarMapItemBag:onAwake()
    self.view = ggclass.PnlStarMapItemBagView.new(self.pnlTransform)



    self.StarMapItemBagItemList = {}
    self.scrollView = UIScrollView.new(self.view.scrollView, "StarMapItemBagItems", self.StarMapItemBagItemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))


end

function PnlStarMapItemBag:onShow()
    self:bindEvent()
    UnionData.C2S_Player_QueryUnionBuilds()
end

function PnlStarMapItemBag:refresh()
    self.buildDataList = {}

    for key, value in pairs(UnionData.unionData.builds) do
        table.insert(self.buildDataList, value)
    end

    local itemCount = math.ceil(#self.buildDataList / 5)
    self.scrollView:setItemCount(itemCount)
end

function PnlStarMapItemBag:onRenderItem(obj, index)
    for i = 1, 5 do
        local idx = (index - 1) * 5 + i
        local item = StarMapItemBagItem:getItem(obj.transform:GetChild(i - 1), self.StarMapItemBagItemList, self)
        item:setData(self.buildDataList[idx])
    end
end

function PnlStarMapItemBag:onUpdateUnionData()
    print("onUpdateUnionData =============")
    gg.printData(UnionData.unionData.builds)
    self:refresh()
end

function PnlStarMapItemBag:onHide()
    self:releaseEvent()
end

function PnlStarMapItemBag:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnDestroy):SetOnClick(function()
        self:onBtnDestroy()
    end)
    CS.UIEventHandler.Get(view.btnUse):SetOnClick(function()
        self:onBtnUse()
    end)
end

function PnlStarMapItemBag:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnDestroy)
    CS.UIEventHandler.Clear(view.btnUse)

end

function PnlStarMapItemBag:onDestroy()
    local view = self.view

end

function PnlStarMapItemBag:onBtnClose()
    self:close()
end

function PnlStarMapItemBag:onBtnDestroy()

end

function PnlStarMapItemBag:onBtnUse()

end

----------------------------------------------------------------

StarMapItemBagItem = StarMapItemBagItem or class("StarMapItemBagItem", ggclass.UIBaseItem)

function StarMapItemBagItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function StarMapItemBagItem:onInit()
    self.commonBagItem = CommonBagItem.new(self:Find("CommonBagItem"))

    self.txtCount = self:Find("TxtCount", UNITYENGINE_UI_TEXT)

    self:setOnClick(self.gameObject, gg.bind(self.onCkicItem, self))


    -- self.icon = self:Find("Icon", UNITYENGINE_UI_IMAGE)
    -- self.txtProgress = self:Find("TxtProgress", UNITYENGINE_UI_TEXT)
    -- -- self.imgLight = self:Find("ImgPoint/ImgLight")
    -- self.spineRewardFetch = self:Find("SpineRewardFetch")
    -- self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self))
end

function StarMapItemBagItem:setData(data)
    gg.printData(data)
    self.data = data
    if not data or data.count <= 0 then
        self:close()
        return
    end
    self:open()

    local buildCfg = BuildUtil.getCurBuildCfg(data.cfgId, data.level, 0)
    self.buildCfg = buildCfg

    self.commonBagItem:setQuality(buildCfg.quality)
    self.commonBagItem:setIcon(string.format("Icon_E_Atlas[%s_E]", buildCfg.icon))
    self.commonBagItem:setLevel(data.level)

    self.txtCount.text = "count:" .. data.count
end

function StarMapItemBagItem:onCkicItem()
    if gg.sceneManager.showingScene == constant.SCENE_PLANET then
        local baseOwner = gg.buildingManager.baseOwner
        gg.buildingManager:loadBuilding(self.buildCfg, nil, self.data.cfgId, baseOwner)
        self.initData:close()
    end
end

function StarMapItemBagItem:onRelease()
    self.commonBagItem:release()
end

----------------------------------------------------------------

return PnlStarMapItemBag