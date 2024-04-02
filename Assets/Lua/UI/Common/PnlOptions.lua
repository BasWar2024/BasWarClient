

PnlOptions = class("PnlOptions", ggclass.UIBase)

PnlOptions.layer = UILayer.information
function PnlOptions:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)
    self.events = { }
end

function PnlOptions:onAwake()
    self.view = ggclass.PnlOptionsView.new(self.pnlTransform)
    self.btnOptions = {}
end

PnlOptions.LEFT = 1
PnlOptions.CENTER = 2
PnlOptions.RIGHT = 3

PnlOptions.TOP = 1
PnlOptions.MIDDLE = 2
PnlOptions.BOTTOM = 3

PnlOptions.BG_DIR_LEFT = 1
PnlOptions.BG_DIR_RIGHT = 2
PnlOptions.BG_DIR_UP = 3
PnlOptions.BG_DIR_DOWN = 4

PnlOptions.BTN_TYPE_BLUE = 1
PnlOptions.BTN_TYPE_YELLOW = 2

--args = {optionList = {{name = ,clickCallback = , color} }, worldPosition = , 
--    offset = ,alignmentX, alignmentY, bgDir}
function PnlOptions:onShow()
    local view = self.view
    view.btnOption:SetActiveEx(false)
    self:bindEvent()
    self.optionList = self.args.optionList
    for index, value in ipairs(self.optionList) do
        if not self.btnOptions[index] then
            local btn = UnityEngine.GameObject.Instantiate(view.btnOption)
            self.btnOptions[index] = btn
            btn.transform:SetParent(view.options, false)
            -- self:setOnClick(btn, gg.bind(self.onBtnOption, self, index))
            CS.UIEventHandler.Get(btn):SetOnClick(gg.bind(self.onBtnOption, self, index))
        end
    end

    local spancing = view.optionsVerticalLayoutGroup.spacing
    local optionCount = #self.optionList
    self.lenth = optionCount * (view.btnOption.transform.rect.height + spancing) - 
        spancing + view.optionsVerticalLayoutGroup.padding.top + view.optionsVerticalLayoutGroup.padding.bottom

    for index, value in ipairs(self.btnOptions) do
        if index > optionCount then
            value:SetActiveEx(false)
        else
            value:SetActiveEx(true)
            -- lenth = lenth + value.transform.rect.height + spancing

            local text = value.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
            local img = value.transform:GetComponent(UNITYENGINE_UI_IMAGE)
            text.text = self.optionList[index].name

            local color = self.optionList[index].color or PnlOptions.BTN_TYPE_BLUE
            if color == PnlOptions.BTN_TYPE_BLUE then
                -- text.color = UnityEngine.Color(0x76/0xff, 0xf7/0xff, 0xff/0xff, 1)
                gg.setSpriteAsync(img, "Button_Atlas[button 01_button_B]")

            elseif color == PnlOptions.BTN_TYPE_YELLOW then
                -- text.color = UnityEngine.Color(0xff/0xff, 0xf5/0xff, 0x4f/0xff, 1)
                gg.setSpriteAsync(img, "Button_Atlas[button 01_button_A]")
            end
        end
    end
    -- lenth = lenth - spancing + view.optionsVerticalLayoutGroup.padding.top + view.optionsVerticalLayoutGroup.padding.bottom
    -- self.lenth = lenth

    self:refreshPosition()
end

-- ""
local offSetBg = 7
function PnlOptions:refreshPosition()
    local view = self.view
    local lenth = self.lenth
    local width = self.view.options.rect.width

    local alignmentX = self.args.alignmentX or PnlOptions.RIGHT
    local alignmentY = self.args.alignmentY or PnlOptions.TOP
    local offset = self.args.offset or UnityEngine.Vector2(0, 0)
    local worldPos = self.args.worldPosition or UnityEngine.Vector3(0, 0, 0)

    -- local localPos = gg.uiManager.uiRoot.uiCamera:WorldToScreenPoint(worldPos)
    local localPos = view.transform:InverseTransformPoint(worldPos)
    local x = localPos.x
    local y = localPos.y
    if alignmentX == PnlOptions.LEFT then
        x = x + offset.x - width
    elseif alignmentX == PnlOptions.CENTER then
        x = x + offset.x - width / 2
    elseif alignmentX == PnlOptions.RIGHT then
        x = x + offset.x
    end

    if alignmentY == PnlOptions.TOP then
        y = y + offset.y
    elseif alignmentY == PnlOptions.MIDDLE then
        y = y + offset.y - lenth / 2
    elseif alignmentY == PnlOptions.BOTTOM then
        y = y + offset.y - lenth
    end

    if x + width > UnityEngine.Screen.width / 2 then
        x = UnityEngine.Screen.width / 2 - width
    elseif x < -UnityEngine.Screen.width / 2 then
        x = -UnityEngine.Screen.width / 2
    end

    if y + lenth > UnityEngine.Screen.height / 2 then
        y = UnityEngine.Screen.height / 2 - lenth
    elseif y < -UnityEngine.Screen.height / 2 then
        y = -UnityEngine.Screen.height / 2
    end

    -- x = math.min(math.max(x, 0), UnityEngine.Screen.width - width)
    -- y = math.min(math.max(y, 0), UnityEngine.Screen.height - lenth)
    self.view.options.transform.localPosition = UnityEngine.Vector3(x, y, 0)
    local bgDir = self.args.bgDir or PnlOptions.BG_DIR_LEFT

    if bgDir == PnlOptions.BG_DIR_LEFT then
        view.bgOptions.transform.anchorMax = UnityEngine.Vector2(0, 0)
        view.bgOptions.transform.anchorMin = UnityEngine.Vector2(0, 0)
        view.bgOptions.transform.pivot = UnityEngine.Vector2(0, 0)

        view.bgOptions.transform.rotation = UnityEngine.Quaternion.Euler(0, 0, -90)
        view.bgOptions.transform.localScale = UnityEngine.Vector3(-1, 1, 1)

        view.bgOptions.transform.sizeDelta = Vector2.New(lenth, width)
        view.bgOptions.transform.anchoredPosition = UnityEngine.Vector2(view.options.transform.anchoredPosition.x - offSetBg,
            view.options.transform.anchoredPosition.y)
    elseif bgDir == PnlOptions.BG_DIR_RIGHT then
        view.bgOptions.transform.anchorMax = UnityEngine.Vector2(0, 0)
        view.bgOptions.transform.anchorMin = UnityEngine.Vector2(0, 0)
        view.bgOptions.transform.pivot = UnityEngine.Vector2(0, 1)

        view.bgOptions.transform.rotation = UnityEngine.Quaternion.Euler(0, 0, -90)
        view.bgOptions.transform.localScale = UnityEngine.Vector3(-1, -1, 1)

        view.bgOptions.transform.sizeDelta = Vector2.New(lenth, width)
        view.bgOptions.transform.anchoredPosition = UnityEngine.Vector2(view.options.transform.anchoredPosition.x + offSetBg,
            view.options.transform.anchoredPosition.y)
    elseif bgDir == PnlOptions.BG_DIR_UP then

        view.bgOptions.transform.anchorMax = UnityEngine.Vector2(0, 0)
        view.bgOptions.transform.anchorMin = UnityEngine.Vector2(0, 0)
        view.bgOptions.transform.pivot = UnityEngine.Vector2(0, 0)

        view.bgOptions.transform.rotation = UnityEngine.Quaternion.Euler(0, 0, 0)
        view.bgOptions.transform.localScale = UnityEngine.Vector3(1, 1, 1)

        view.bgOptions.transform.sizeDelta = Vector2.New(width, lenth)
        view.bgOptions.transform.anchoredPosition = UnityEngine.Vector2(view.options.transform.anchoredPosition.x,
            view.options.transform.anchoredPosition.y - offSetBg)
    
    elseif bgDir == PnlOptions.BG_DIR_DOWN then

        view.bgOptions.transform.anchorMax = UnityEngine.Vector2(0, 0)
        view.bgOptions.transform.anchorMin = UnityEngine.Vector2(0, 0)
        view.bgOptions.transform.pivot = UnityEngine.Vector2(0, 1)

        view.bgOptions.transform.rotation = UnityEngine.Quaternion.Euler(0, 0, 0)
        view.bgOptions.transform.localScale = UnityEngine.Vector3(1, -1, 1)

        view.bgOptions.transform.sizeDelta = Vector2.New(width, lenth)
        view.bgOptions.transform.anchoredPosition = UnityEngine.Vector2(view.options.transform.anchoredPosition.x,
            view.options.transform.anchoredPosition.y + offSetBg)
    end

    self:refreshBgOptionsInside()
end

local midOffset = 15
function PnlOptions:refreshBgOptionsInside()
    local view = self.view
    -- local offset = self.args.offset or UnityEngine.Vector2(0, 0)

    local bgDir = self.args.bgDir or PnlOptions.BG_DIR_LEFT
    local alignmentX = self.args.alignmentX or PnlOptions.RIGHT
    local alignmentY = self.args.alignmentY or PnlOptions.TOP
    local offset = self.args.offset or UnityEngine.Vector2(0, 0)
    local worldPos = self.args.worldPosition or UnityEngine.Vector3(0, 0, 0)

    local pos = view.bgOptions.transform:InverseTransformPoint(worldPos)

    -- pos.x = pos.x + offset.x
    -- pos.y = pos.y + offset.y

    local bgOptionMidPos = UnityEngine.Vector3(pos.x, view.bgOptionMid.transform.localPosition.y, view.bgOptionMid.transform.localPosition.z)

    if bgDir == PnlOptions.BG_DIR_LEFT or bgDir == PnlOptions.BG_DIR_RIGHT then
        -- pos.x = pos.x + offset.y
        -- bgOptionMidPos = UnityEngine.Vector3(pos.x, view.bgOptionMid.transform.localPosition.y, view.bgOptionMid.transform.localPosition.z)

        if alignmentY == PnlOptions.TOP then
            bgOptionMidPos.x = bgOptionMidPos.x + midOffset
        elseif alignmentY == PnlOptions.BOTTOM then
            bgOptionMidPos.x = bgOptionMidPos.x - midOffset
            view.bgOptionMid.transform.localPosition = UnityEngine.Vector3(pos.x - midOffset, view.bgOptionMid.transform.localPosition.y, view.bgOptionMid.transform.localPosition.z)
        end
    elseif bgDir == PnlOptions.BG_DIR_UP or bgDir == PnlOptions.BG_DIR_DOWN then
        -- pos.x = pos.x + offset.x
        -- bgOptionMidPos = UnityEngine.Vector3(pos.x, view.bgOptionMid.transform.localPosition.y, view.bgOptionMid.transform.localPosition.z)
        if alignmentX == PnlOptions.LEFT then
            bgOptionMidPos.x = bgOptionMidPos.x - midOffset
        elseif alignmentX == PnlOptions.RIGHT then
            bgOptionMidPos.x = bgOptionMidPos.x + midOffset
        end
    end

    view.bgOptionMid.transform.localPosition = bgOptionMidPos
    Utils.setMultipleBgSize(view.bgOptions, view.bgOptionLeft, view.bgOptionMid, view.bgOptionRight)

    -- local optionMidWidth = view.bgOptionMid.transform.rect.width
    -- local rightWidth = view.bgOptions.transform.rect.width / 2 - view.bgOptionMid.transform.anchoredPosition.x - optionMidWidth / 2
    -- local leftWidth = view.bgOptions.transform.rect.width - rightWidth - optionMidWidth
    -- view.bgOptionLeft.transform:SetRectSizeX(leftWidth)
    -- view.bgOptionRight.transform:SetRectSizeX(rightWidth)
end

-- function PnlOptions:refreshBgOptionsInside()
--     local view = self.view
--     -- local offset = self.args.offset or UnityEngine.Vector2(0, 0)
--     -- local worldPos = self.args.worldPosition or UnityEngine.Vector3(0, 0, 0)

--     local alignmentX = self.args.alignmentX or PnlOptions.RIGHT
--     local alignmentY = self.args.alignmentY or PnlOptions.TOP
--     local offset = self.args.offset or UnityEngine.Vector2(0, 0)
--     local worldPos = self.args.worldPosition or UnityEngine.Vector3(0, 0, 0)

--     local pos = view.bgOptions.transform:InverseTransformPoint(worldPos)

--     -- if alignmentY == PnlOptions.TOP then
--     --     view.bgOptionMid.transform.localPosition = UnityEngine.Vector3(pos.x + 20, view.bgOptionMid.transform.localPosition.y, view.bgOptionMid.transform.localPosition.z)
--     -- else
--     --     view.bgOptionMid.transform.localPosition = UnityEngine.Vector3(pos.x, view.bgOptionMid.transform.localPosition.y, view.bgOptionMid.transform.localPosition.z)
--     -- end

--     view.bgOptionMid.transform.localPosition = UnityEngine.Vector3(pos.x, view.bgOptionMid.transform.localPosition.y, view.bgOptionMid.transform.localPosition.z)

--     -- Utils.setMultipleBgSize(view.bgOptions, view.bgOptionLeft, view.bgOptionMid, view.bgOptionRight)

--     -- local optionMidWidth = view.bgOptionMid.transform.rect.width
--     -- local rightWidth = view.bgOptions.transform.rect.width / 2 - view.bgOptionMid.transform.anchoredPosition.x - optionMidWidth / 2
--     -- local leftWidth = view.bgOptions.transform.rect.width - rightWidth - optionMidWidth
--     -- view.bgOptionLeft.transform:SetRectSizeX(leftWidth)
--     -- view.bgOptionRight.transform:SetRectSizeX(rightWidth)
-- end

function PnlOptions:onHide()
    self:releaseEvent()
end

function PnlOptions:bindEvent()
    local view = self.view
    self:setOnClick(view.btnClose, gg.bind(self.close, self))
end

function PnlOptions:releaseEvent()
    local view = self.view
    -- CS.UIEventHandler.Clear(view.btnOption)
end

function PnlOptions:onDestroy()
    local view = self.view
    for key, value in pairs(self.btnOptions) do
        CS.UIEventHandler.Clear(value)
    end
end

function PnlOptions:onBtnOption(index)
    -- print(index)
    if self.optionList[index] and self.optionList[index].clickCallback then
        self.optionList[index].clickCallback()
    end
    self:close()
end

---guide
function PnlOptions:getGuideRectTransform(guideCfg)
    local index = tonumber(guideCfg.viewFuncName)
    if self.btnOptions[index] then
        return self.btnOptions[index]
    end
end

function PnlOptions:triggerGuideClick(guideCfg)
    local index = tonumber(guideCfg.viewFuncName)

    if self.btnOptions[index] then
        self:onBtnOption(index)
    end
end

return PnlOptions