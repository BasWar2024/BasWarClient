CommonfilterBox = CommonfilterBox or class("CommonfilterBox", ggclass.UIBaseItem)
function CommonfilterBox:ctor(obj)
    ggclass.UIBaseItem.ctor(self, obj)
end

function CommonfilterBox:onInit()

    self.layoutBtns = self:Find("LayoutBtns").transform

    self.btnFilterList = {}
    for i = 1, self.layoutBtns.childCount, 1 do
        table.insert(self.btnFilterList, self:GetBtnFilter(self.layoutBtns:GetChild(i - 1), i))
    end

    self.itemList = {}
    self.filterScrollView = UIScrollView.new(self:Find("FilterScrollView"), "BtnCommonFilterChoose", self.itemList)
    self.filterScrollView:setRenderHandler(gg.bind(self.onRenderFilterItem, self))

    self.verticalLayoutGroupContent = self.filterScrollView.component.content:GetComponent(typeof(CS.UnityEngine.UI.VerticalLayoutGroup))

    self.filterMap = {}
    self.filterType = nil
end

function CommonfilterBox:GetBtnFilter(obj, index)
    local item = {}
    item.btn = obj.gameObject
    item.text = obj.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self:setOnClick(item.btn, gg.bind(self.onBtnFilter, self, index))

    return item
end

-- local data = {CommonfilterBox.QualityData, }
function CommonfilterBox:setData(data)
    self.btnDataList = data
    self.filterMap = {}
    self.btnMap = {}

    local dataCount = #data
    for index, value in ipairs(self.btnFilterList) do
       if index <= dataCount then
            value.btn:SetActiveEx(true)

            local filterType = data[index].filterType

            self.filterMap[filterType] = data[index].info[1]
            self.btnMap[filterType] = value

            self:refreshFilterText(filterType)
       else
            value.btn:SetActiveEx(false)
       end
    end

    self.filterType = nil
    self.filterScrollView.transform:SetActiveEx(false)

    self:filter()
end

function CommonfilterBox:setFilter(data)
    self.filterMap[self.filterType] = data

    self:refreshFilterText(self.filterType)

    self.filterType = nil
    self.filterScrollView.transform:SetActiveEx(false)

    -- for key, value in pairs(self.itemList) do
    --     value:refreshSelect()
    -- end

    self:filter()
end

function CommonfilterBox:refreshFilterText(filterType)
    local data = self.filterMap[filterType]
    local textSet = self.btnMap[filterType].text

    if data.nameKey then
        textSet.text = Utils.getText(data.nameKey)
    else
        textSet.text = data.name
    end
end

function CommonfilterBox:filter()
    self.filterCB(self.filterMap)
end

function CommonfilterBox:setFilterCB(callBack)
    self.filterCB = callBack
end

local itemH = 61

function CommonfilterBox:onBtnFilter(index)
    local filterData = self.btnDataList[index]
    local filterType = filterData.filterType

    if self.filterType == filterType then
        self.filterScrollView.transform:SetActiveEx(false)
        self.filterType = nil
        return
    end

    self.filterType = filterType
    self.filterScrollView.transform:SetActiveEx(true)

    local btn = self.btnFilterList[index].btn
    local pos = btn.transform.position

    self.filterScrollView.transform.position = pos
    self.filterData = self.btnDataList[index].info
    self.filterScrollView:setItemCount(#self.filterData)

    local spancing = self.verticalLayoutGroupContent.spacing
    local h = (spancing + itemH) * #self.filterData - spancing + 8
    self.filterScrollView.transform:SetRectSizeY(h)
end

function CommonfilterBox:onRenderFilterItem(obj, index)
    local item = BtnCommonFilterChoose:getItem(obj, self.itemList, self)
    item:setData(self.filterData[index])
end

function CommonfilterBox:onRelease()
    self.filterScrollView:release()
end

CommonfilterBox.FilterTypeQuality = "CommonfilterBoxFilterTypeQuality"
CommonfilterBox.QualityData = {
    filterType = CommonfilterBox.FilterTypeQuality,
    info = {
        {
            nameKey = "bag_All",
            filterAttr = nil,
        },
        {
            name = "L",
            filterAttr = {quality = 5,},
        },
        {
            name = "SSR",
            filterAttr = {quality = 4,},
        },
        {
            name = "SR",
            filterAttr = {quality = 3,},
        },
        {
            name = "R",
            filterAttr = {quality = 2,},
        },
        {
            name = "N",
            filterAttr = {quality = 1,},
        },
    }
}

CommonfilterBox.FilterTypeRace = "CommonfilterBoxFilterTypeRace"
CommonfilterBox.RaceData = {
    filterType = CommonfilterBox.FilterTypeRace,
    info = {
        {
            nameKey = "bag_All",
            filterAttr = nil,
        },
        {
            nameKey = constant.RACE_MESSAGE[constant.RACE_HUMAN].languageKey,
            filterAttr = {race = constant.RACE_HUMAN},
        },
        {
            nameKey = constant.RACE_MESSAGE[constant.RACE_CENTRA].languageKey,
            filterAttr = {race = constant.RACE_CENTRA},
        },
        {
            nameKey = constant.RACE_MESSAGE[constant.RACE_SCOURGE].languageKey,
            filterAttr = {race = constant.RACE_SCOURGE},
        },
        {
            nameKey = constant.RACE_MESSAGE[constant.RACE_ENDARI].languageKey,
            filterAttr = {race = constant.RACE_ENDARI},
        },
        {
            nameKey = constant.RACE_MESSAGE[constant.RACE_TALUS].languageKey,
            filterAttr = {race = constant.RACE_TALUS},
        },
    },
}

CommonfilterBox.FilterTypeNft = "CommonfilterBoxFilterTypeNft"
CommonfilterBox.NFTData = {
    filterType = CommonfilterBox.FilterTypeNft,
    info = {
        {
            nameKey = "bag_All",
            filterNft = {
                [constant.CHAIN_NFT_KIND_SPACESHIP] = true, 
                [constant.CHAIN_NFT_KIND_HERO] = true, 
                [constant.CHAIN_NFT_KIND_DEFENSIVE] = true, 
            },
        },

        {
            nameKey = "bag_Warship",
            filterNft = {
                [constant.CHAIN_NFT_KIND_SPACESHIP] = true, 
            },
        },
    
        {
            nameKey = "bag_Hero",
            filterNft = {
                [constant.CHAIN_NFT_KIND_HERO] = true, 
            },
        },
    
        {
            nameKey = "bag_Tower",
            filterNft = {
                [constant.CHAIN_NFT_KIND_DEFENSIVE] = true, 
            },
        },
    

    },
}

----------------------------------------------------

BtnCommonFilterChoose = BtnCommonFilterChoose or class("BtnCommonFilterChoose", ggclass.UIBaseItem)

function BtnCommonFilterChoose:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BtnCommonFilterChoose:onInit()
    self.image = self.transform:GetComponent(UNITYENGINE_UI_IMAGE)
    self.text = self:Find("Text", UNITYENGINE_UI_TEXT)
    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
end

function BtnCommonFilterChoose:setData(data)
    self.data = data
    if data.nameKey then
        self.text.text = Utils.getText(data.nameKey)
    else
        self.text.text = data.name
    end

    self:refreshSelect()
end

function BtnCommonFilterChoose:onClickItem()
    self.initData:setFilter(self.data)
end

BtnCommonFilterChoose.colorTxtSelect = CS.UnityEngine.Color(0xeb/0xff, 0xf2/0xff, 0xff/0xff, 1)
BtnCommonFilterChoose.colorTxtUnSelect = CS.UnityEngine.Color(0x81/0xff, 0x82/0xff, 0x83/0xff, 1)

function BtnCommonFilterChoose:refreshSelect()
    if self.initData.filterMap[self.initData.filterType] == self.data then
        self.text.color = BtnCommonFilterChoose.colorTxtSelect
        self.image.color = CS.UnityEngine.Color(1, 1, 1, 1)
    else
        self.text.color = BtnCommonFilterChoose.colorTxtUnSelect
        self.image.color = CS.UnityEngine.Color(1, 1, 1, 0)
    end
end