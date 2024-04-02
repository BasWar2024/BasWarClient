---------------------------------------------------------------------------------------------------
-- ""LayoutBtns"",""1""
CommonBtnsBox = CommonBtnsBox or class("CommonBtnsBox", ggclass.UIBaseItem)
function CommonBtnsBox:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
    self.redPointMap = {}
end

CommonBtnsBox.events = {"onRedPointChange"}

function CommonBtnsBox:onInit()
    self.btnList = {}
    self.layoutBtns = self:Find("LayoutBtns").transform
    self.btn = self.layoutBtns:GetChild(0).gameObject
    self.btnList[1] = self.btn
    for i = 1, self.layoutBtns.childCount do
        self.btnList[i] = self:getBtnItem(i, self.layoutBtns:GetChild(i - 1))
    end
end

function CommonBtnsBox:onOpen(...)
    self:initRedPoint()
end
-- ""
-- dataList = {{name = , callback = , redPointName, activityCfgId}}
function CommonBtnsBox:setBtnDataList(dataList, clickIndex)
    self.dataList = dataList
    self.redPointMap = {}

    for index, value in ipairs(self.dataList) do
        value.index = index
        if not self.btnList[index] then
            self.btnList[index] = self:getBtnItem(index)
        end
        local btn = self.btnList[index]
        btn.transform:SetActiveEx(true)
        self:onSetBtnData(btn, value)

        if value.redPointName then
            self.redPointMap[value.redPointName] = btn
        end

        self:checkActivity(value)
    end

    local dataCount = #self.dataList
    local btnCount = #self.btnList

    if dataCount < btnCount then
        for i = dataCount + 1, btnCount do
            self.btnList[i].transform:SetActiveEx(false)
        end
    end

    if clickIndex and clickIndex <= #dataList then
        self:onBtn(clickIndex)
    else
        self:setBtnStageWithoutNotify(0)
    end
end

function CommonBtnsBox:checkActivity(btnData)
    if not btnData.activityCfgId then
        return
    end
    self.btnList[btnData.index].transform:SetActiveEx(ActivityUtil.checkActivityOpen(btnData.activityCfgId))
end

-- redPoint
function CommonBtnsBox:initRedPoint()
    for key, value in pairs(self.btnList) do
        RedPointManager:setRedPoint(value.gameObject, false)
    end

    for key, value in pairs(self.redPointMap) do
        RedPointManager:setRedPoint(value.gameObject, RedPointManager:getIsRed(key))
    end
end

function CommonBtnsBox:onRedPointChange(_, name, isRed)
    self:setRedPoint(name, isRed)
end
--

function CommonBtnsBox:getBtnItem(index, btn)
    btn = btn or UnityEngine.GameObject.Instantiate(self.btn)
    local item = {}
    item.transform = btn.transform
    item.transform:SetParent(self.layoutBtns, false)
    item.gameObject = btn.gameObject
    self:onGetBtnItem(item)
    self:setOnClick(item.gameObject, gg.bind(self.onBtn, self, index))
    return item
end

function CommonBtnsBox:onBtn(index)
    local result = nil
    if self.dataList[index] and self.dataList[index].callback then
        result = self.dataList[index].callback()
    end

    if result ~= false then
        self:setBtnStageWithoutNotify(index)
    end
end

function CommonBtnsBox:setBtnStageWithoutNotify(index)
    for i, value in ipairs(self.btnList) do
        self:onSetBtnStageWithoutNotify(value, i == index, i)
    end
end

function CommonBtnsBox:setRedPoint(redPoint, isRed)
    if self.redPointMap[redPoint] then
        RedPointManager:setRedPoint(self.redPointMap[redPoint].gameObject, isRed)
    end
end

function CommonBtnsBox:releaseRedPoint()
    for key, value in pairs(self.btnList) do
        RedPointManager:releaseRedPoint(value.gameObject)
    end
end

function CommonBtnsBox:onRelease()
    self:releaseRedPoint()
end

-- override
function CommonBtnsBox:onGetBtnItem(item)
end

function CommonBtnsBox:onSetBtnData(item, data)
end

function CommonBtnsBox:onSetBtnStageWithoutNotify(item, isSelect, index)
end

---------------------------------------------------------------------------------------------------

BottomOptionalBtnsBox = BottomOptionalBtnsBox or class("BottomOptionalBtnsBox", ggclass.CommonBtnsBox)
function BottomOptionalBtnsBox:ctor(obj, initData)
    ggclass.CommonBtnsBox.ctor(self, obj, initData)
end

function BottomOptionalBtnsBox:onGetBtnItem(item)
    item.image = item.transform:GetComponent(UNITYENGINE_UI_IMAGE)
    item.text = item.transform:Find("Text"):GetComponent(typeof(CS.TextYouYU))
    item.imgArrow = item.transform:Find("ImgArrow"):GetComponent(UNITYENGINE_UI_IMAGE)
end

-- data = {nameKey = , callback = }
function BottomOptionalBtnsBox:onSetBtnData(item, data)
    -- item.text.text = data.name

    item.text:SetLanguageKey(data.nameKey)
end

function BottomOptionalBtnsBox:onSetBtnStageWithoutNotify(item, isSelect)
    if isSelect then
        gg.setSpriteAsync(item.image, "BuildShop_Atlas[Btn_Option_Select]")
        item.text.color = UnityEngine.Color(0xff / 0xff, 0xff / 0xff, 0xff / 0xff, 1)
        item.imgArrow.gameObject:SetActiveEx(true)
    else
        gg.setSpriteAsync(item.image, "BuildShop_Atlas[Btn_Option_Unselect]")
        item.text.color = UnityEngine.Color(0x18 / 0xff, 0x9f / 0xff, 0xe2 / 0xff, 1)
        item.imgArrow.gameObject:SetActiveEx(false)
    end
end
---------------------------------------------------------------------------------------------------
OptionalTopBtnsBox = OptionalTopBtnsBox or class("OptionalTopBtnsBox", ggclass.CommonBtnsBox)
function OptionalTopBtnsBox:ctor(obj, initData)
    ggclass.CommonBtnsBox.ctor(self, obj, initData)
end

function OptionalTopBtnsBox:onGetBtnItem(item)
    item.txtBtn = item.transform:Find("TxtBtn"):GetComponent(UNITYENGINE_UI_TEXT)
    item.imgSelect = item.transform:Find("ImgSelect"):GetComponent(UNITYENGINE_UI_IMAGE)
    item.txtSelect = item.transform:Find("ImgSelect/TxtSelect"):GetComponent(UNITYENGINE_UI_TEXT)
end

function OptionalTopBtnsBox:onSetBtnData(item, data)
    if data.name then
        item.txtBtn.text = data.name
        item.txtSelect.text = data.name
    elseif data.nameKey then
        item.txtBtn.text = Utils.getText(data.nameKey)
        item.txtSelect.text = Utils.getText(data.nameKey)
    end
end

function OptionalTopBtnsBox:onSetBtnStageWithoutNotify(item, isSelect)
    item.txtBtn.transform:SetActiveEx(not isSelect)
    item.imgSelect.transform:SetActiveEx(isSelect)
end

---------------------------------------------------------------
-- "" FullViewOptionBtnBox LeftBtnViewBgBtnsBox
ViewOptionBtnBox = ViewOptionBtnBox or class("ViewOptionBtnBox", ggclass.CommonBtnsBox)
function ViewOptionBtnBox:ctor(obj, initData)
    ggclass.CommonBtnsBox.ctor(self, obj, initData)
end

function ViewOptionBtnBox:onGetBtnItem(item)
    item.txtBtn = item.transform:Find("TxtBtn"):GetComponent(UNITYENGINE_UI_TEXT_YPU_YU)
    item.imgSelect = item.transform:Find("ImgSelect"):GetComponent(UNITYENGINE_UI_IMAGE)
    item.txtSelect = item.transform:Find("ImgSelect/TxtSelect"):GetComponent(UNITYENGINE_UI_TEXT_YPU_YU)
    item.icon = item.transform:Find("Icon"):GetComponent(UNITYENGINE_UI_IMAGE)
end

-- dataList = {{name = , nemeKey, callback = , icon, iconSelect}}
function ViewOptionBtnBox:onSetBtnData(item, data)
    if data.name then
        item.txtBtn.text = data.name
        item.txtSelect.text = data.name
    elseif data.nemeKey then
        item.txtBtn:SetLanguageKey(data.nemeKey)
        item.txtSelect:SetLanguageKey(data.nemeKey)
    end
end

function ViewOptionBtnBox:onSetBtnStageWithoutNotify(item, isSelect, index)
    item.txtBtn.transform:SetActiveEx(not isSelect)
    item.imgSelect.transform:SetActiveEx(isSelect)
    local data = self.dataList[index]

    if data and data.icon and data.iconSelect then
        if isSelect then
            gg.setSpriteAsync(item.icon, data.iconSelect)
        else
            gg.setSpriteAsync(item.icon, data.icon)
        end
    else
        item.icon.transform:SetActiveEx(false)
    end
end
------------------------------------------------------------------------------
LeftBtnViewBgBtnsBox = LeftBtnViewBgBtnsBox or class("LeftBtnViewBgBtnsBox", ggclass.ViewOptionBtnBox)
function LeftBtnViewBgBtnsBox:ctor(obj, initData)
    ggclass.ViewOptionBtnBox.ctor(self, obj, initData)
end