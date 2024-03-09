CommonAttrItem = CommonAttrItem or class("CommonAttrItem", ggclass.UIBaseItem)

function CommonAttrItem:ctor(obj)
    UIBaseItem.ctor(self, obj)
end

function CommonAttrItem:onInit()
    self.imgAttr = self.transform:Find("ImgAttr"):GetComponent("Image")
    self.txtName = self.transform:Find("TxtName"):GetComponent("Text")
    self.txtAttr = self.transform:Find("TxtAttr"):GetComponent("Text")
    self.txtAttrAdd = self.transform:Find("TxtAttrAdd"):GetComponent("Text")
end

-- prefab name: CommonAttrItem
-- index2Attr = {cfg.attribute[1], }

function CommonAttrItem.getAttr(attrCfg, config)
    return Utils:GetAttrByCfg(attrCfg, config)
end

function CommonAttrItem:setData(index, index2Attr, curCfg, addCfg)
    local attrCfg = index2Attr[index]
    local attr = self.getAttr(attrCfg, curCfg)
    local addAttr = self.getAttr(attrCfg, addCfg)

    if attrCfg.isPercent == 1 then
        attr = attr / 100 .. "%"
        if addAttr and addAttr - attr > 0 then
            addAttr = (addAttr - attr) / 100 .. "%"
        end
    end

    if addAttr and addAttr - attr > 0 then
        self:setInfo(attrCfg.icon, attrCfg.name, attr, "+" .. addAttr - attr)
    else
        self:setInfo(attrCfg.icon, attrCfg.name, attr)
    end
end

function CommonAttrItem:setInfo(icon, name, attr, addAttr)
    if icon then
        gg.setSpriteAsync(self.imgAttr, icon)
    end
    attr = attr or ""
    addAttr = addAttr or ""
    self.txtName.text = name
    self.txtAttr.text = attr
    self.txtAttrAdd.text = addAttr
end

function CommonAttrItem:setAddAttrActive(isShow)
    self.txtAttrAdd.transform:SetActiveEx(isShow)
end
--------------------------------------------------------------
CommonAttrItem2 = CommonAttrItem2 or class("CommonAttrItem2", ggclass.CommonAttrItem)
function CommonAttrItem2:ctor(obj)
    ggclass.CommonAttrItem.ctor(self, obj)
    self.colorType = CommonAttrItem2.TYPE_GREEN
    self.iconUpgrade = self.transform:Find("IconUpgrade"):GetComponent("Image")
    self.txtAttrAdd2 = self.transform:Find("TxtAttrAdd2"):GetComponent("Text")
    self.txtAttrAdd2.transform:SetActiveEx(false)
end

function CommonAttrItem2:setData(index, index2Attr, curCfg, addCfg)
    self.txtAttrAdd2.transform:SetActiveEx(false)
    self.txtAttrAdd.transform:SetActiveEx(true)
    self.txtAttr.transform:SetActiveEx(true)

    local attrCfg = index2Attr[index]
    local attr = self.getAttr(attrCfg, curCfg)
    local addAttr = self.getAttr(attrCfg, addCfg)
    if attrCfg.isPercent == 1 then
        attr = attr / 100 .. "%"
        if addAttr and addAttr ~= attr then
            addAttr = addAttr / 100 .. "%"
        end
    end
    self:setInfo(attrCfg.icon, attrCfg.name, attr, addAttr)
end

function CommonAttrItem2:setData2(index, index2Attr, curCfg, addAttr)
    local attrCfg = index2Attr[index]
    local attr = self.getAttr(attrCfg, curCfg)
    self.txtName.text = attrCfg.name
    if not addAttr then
        self.txtAttrAdd.transform:SetActiveEx(false)
        self.txtAttr.transform:SetActiveEx(false)
        self.txtAttrAdd2.transform:SetActiveEx(true)
        self.txtAttrAdd2.text = attr
    else
        self.txtAttrAdd.transform:SetActiveEx(true)
        self.txtAttr.transform:SetActiveEx(true)
        self.txtAttrAdd2.transform:SetActiveEx(false)
        self.txtAttr.text = attr
        self.txtAttrAdd.text = addAttr
    end
    gg.setSpriteAsync(self.imgAttr, attrCfg.icon)
end

CommonAttrItem2.TYPE_GREEN = 1
CommonAttrItem2.TYPE_BROWN = 2
function CommonAttrItem2:setColorType(type)
    if type == self.colorType then
        return
    end
    self.colorType = type
    if type == CommonAttrItem2.TYPE_GREEN then
        gg.setSpriteAsync(self.iconUpgrade, "Addition_icon_A")
        self.txtAttrAdd.color = UnityEngine.Color(0x66/0xff, 0xff/0xff, 0x66/0xff, 1)
    elseif type == CommonAttrItem2.TYPE_BROWN then
        gg.setSpriteAsync(self.iconUpgrade, "Addition_icon_B")
        self.txtAttrAdd.color = UnityEngine.Color(0x3c/0xff, 0x01/0xff, 0x01/0xff, 1)
    end
end

function CommonAttrItem2:setAddAttrActive(isShow)
    self.txtAttrAdd.transform:SetActiveEx(isShow)
    self.iconUpgrade.transform:SetActiveEx(isShow)
end

--------------------------------------------------------------
CommonUpgradeBox = CommonUpgradeBox or class("CommonUpgradeBox", ggclass.UIBaseItem)
function CommonUpgradeBox:ctor(obj)
    ggclass.UIBaseItem.ctor(self, obj)
end

function CommonUpgradeBox:onInit()
    self.partList = {}
    for i = 1, 2 do
        self.partList[i] = {}
        local part = self.transform:Find("Part" .. i)
        self.partList[i].part = part
        self.partList[i].btn = part:Find("Btn").gameObject
        self:setOnClick(self.partList[i].btn, gg.bind(self.onBtn, self, i))
        
        self.partList[i].txtCost = part:Find("CostItem/Text"):GetComponent("Text")
        -- self.partList[i].costMap[0] = layoutCost.transform:GetChild(0):Find("Text"):GetComponent("Text")

        local layoutCost = part:Find("LayoutCost")
        self.partList[i].layoutCost = layoutCost
        self.partList[i].costMap = {}
        self.partList[i].costMap[constant.RES_STARCOIN] = layoutCost.transform:GetChild(0):Find("Text"):GetComponent("Text")
        self.partList[i].costMap[constant.RES_CARBOXYL] = layoutCost.transform:GetChild(1):Find("Text"):GetComponent("Text")
        self.partList[i].costMap[constant.RES_GAS] = layoutCost.transform:GetChild(2):Find("Text"):GetComponent("Text")
        self.partList[i].costMap[constant.RES_ICE] = layoutCost.transform:GetChild(3):Find("Text"):GetComponent("Text")
        self.partList[i].costMap[constant.RES_TITANIUM] = layoutCost.transform:GetChild(4):Find("Text"):GetComponent("Text")
    end
    self.txtCostInstant = self.partList[1].part.transform:Find("CostItem/Text"):GetComponent("Text")
end

function CommonUpgradeBox:onBtn(index)
    if not self.isUpgradeing then
        if not Utils:checkIsEnoughtLevelUpRes(self.curCfg, true) then
            return
        end
    end

    if index == 1 then
        if self.mitCost > ResData:getMit() then
            gg.uiManager:showTip("not enought MIT")
            return
        end

        if self.instantCB then
            self.instantCB()
        end
    elseif index == 2 then
        if self.upgradeCB then
            self.upgradeCB()
        end
    end
end

function CommonUpgradeBox:onRelease()
    gg.timer:stopTimer(self.upgradeTimer)
end

----
function CommonUpgradeBox:setMessage(curCfg, lessTickEnd)
    self.curCfg = curCfg
    gg.timer:stopTimer(self.upgradeTimer)
    self.isUpgradeing = lessTickEnd - os.time() > 0
    if lessTickEnd - os.time() <= 0 then
        for i = 1, 2 do
            local part = self.partList[i]
            part.part.transform:SetActiveEx(true)
            part.layoutCost:SetActiveEx(true)
            for key, value in pairs(part.costMap) do
                local cost = 0
                if constant.RES_2_CFG_KEY[key] then
                    cost = curCfg[constant.RES_2_CFG_KEY[key].levelUpKey]
                end
                value.text = cost
            end
        end
        self.mitCost = math.ceil(curCfg.levelUpNeedTick / 60) * cfg.global.SpeedUpPerMinute.intValue
        self.partList[1].txtCost.text = self.mitCost
        local hms = gg.time.dhms_time({day=false,hour=1,min=1,sec=1}, curCfg.levelUpNeedTick)
        self.partList[2].txtCost.text = string.format("%sh%sm%ss", hms.hour, hms.min, hms.sec)

    else
        self.partList[1].layoutCost.transform:SetActiveEx(false)
        self.partList[2].part.transform:SetActiveEx(false)

        self.upgradeTimer = gg.timer:startLoopTimer(0, 0.3, 99999999, function()
            local time = lessTickEnd - os.time()
            self.mitCost = math.ceil(time / 60) * cfg.global.SpeedUpPerMinute.intValue
            self.partList[1].txtCost.text = self.mitCost
        end)
    end
end

function CommonUpgradeBox:setInstantCallback(callback)
    self.instantCB = callback
end

function CommonUpgradeBox:setUpgradeCallback(callback)
    self.upgradeCB = callback
end
