
local function moveSelect(trans, targetY, sequence)
    if sequence then
        sequence:Kill()
    end

    sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Append(trans:DOAnchorPosY(targetY, 0.2):SetEase(CS.DG.Tweening.Ease.Linear))
    return sequence
end

------------------------------------------------------------------------------
BattleSoldierItem = BattleSoldierItem or class("BattleSoldierItem", ggclass.UIBaseItem)

function BattleSoldierItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end


function BattleSoldierItem:onInit()
    self.battleCardItem = BattleCardItem.new(self:Find("BattleCardItem"))
    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self), nil, nil, false)
    --self.imgSelect = self:Find("ImgSelect", "Image")
    --self.txtLevel = self:Find("bgCost/TxtLevel", "Text")
    self.canvasGroup = self.transform:GetComponent("CanvasGroup")
    self.animator = self.transform:GetComponent("Animator")
end

function BattleSoldierItem:onBtnItem()
    if self.clickCallback then
        self.clickCallback()
    end
end

-----""
function BattleSoldierItem:addClickCallback(callback)
    self.clickCallback = callback
end

function BattleSoldierItem:setItemGray(isGray)
    EffectUtil.setGray(self.transform, isGray, true)
end

function BattleSoldierItem:setSelect(isSelect)
    --self.imgSelect.gameObject:SetActiveEx(isSelect)
    if isSelect then
        self.animator:SetTrigger("select")

        self.sequence = moveSelect(self.transform, 20, self.sequence)
    else
        self.sequence = moveSelect(self.transform, 0, self.sequence)
    end
end

function BattleSoldierItem:setLevel(level)
    self.txtLevel.text = "Lv." .. level
end

BattleSoldierItem.totalAniTime = 0.5
function BattleSoldierItem:setCardStage(stage)
    if stage == PnlBattle.SKILL_STAGE_HERO_NOT_USE then
        self.canvasGroup.alpha = 1
        self:setActive(true)
    else
        local sequence = CS.DG.Tweening.DOTween.Sequence()
        self.canvasGroup.alpha = 1
        sequence:Append(self.canvasGroup:DOFade(0, BattleSoldierItem.totalAniTime):SetEase(CS.DG.Tweening.Ease.Linear))
        sequence:AppendCallback(function()
            self:setActive(false)
        end)
    end
end

function BattleSoldierItem:setBg(bg)
    -- local battleCardItemBg = self.transform:Find("BattleCardItem"):GetComponent(UNITYENGINE_UI_IMAGE)
    -- local heroSkillIcon = gg.getSpriteAtlasName("Skill_A1_Atlas", heroSkillModel.icon .. "_A1")
    -- gg.setSpriteAsync(self.view.heroSmallIconList[i], heroSkillIcon)
end

function BattleSoldierItem:onRelease()
    if self.sequence then
        self.sequence:Kill()
        self.sequence = nil
    end

    self.battleCardItem:release()
end


-----------------------------------------------------------------------------------------
BattleCardItem = BattleCardItem or class("BattleCardItem", ggclass.UIBaseItem)

function BattleCardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BattleCardItem:onInit()
    self.Bg = self.transform:GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgIcon = self:Find("Mask/Icon", "Image")
end

function BattleCardItem:setIcon(icon)
    gg.setSpriteAsync(self.imgIcon, icon)
end

-----------------------------------------------------------------------------------------------
BattleHeroItem = BattleHeroItem or class("BattleHeroItem", ggclass.UIBaseItem)

function BattleHeroItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BattleHeroItem:onInit()
    self.battleCardItem = BattleCardItem.new(self:Find("BattleCardItem"))
    self.commonHeroItem = CommonHeroItem.new(self:Find("CommonHeroItem"))

    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self), nil, nil, false)
    --self.imgSelect = self:Find("ImgSelect", "Image")
    --self.txtLevel = self:Find("bgCost/TxtLevel", "Text")
    self.canvasGroup = self.transform:GetComponent("CanvasGroup")
    self.animator = self.transform:GetComponent("Animator")
end

function BattleHeroItem:setHeroModel(model)
    local icon = gg.getSpriteAtlasName("Hero_A_Atlas", model.icon .. "_A")
    self.battleCardItem:setIcon(icon)
    self:setQuality(model.quality)
end

function BattleHeroItem:setSoldierModel(model)
    if model then
        self.commonHeroItem:setActive(true)
        self.commonHeroItem:setIcon("Soldier_A_Atlas", model.icon)
        self.commonHeroItem:setQuality(0)
    else
        self.commonHeroItem:setActive(false)
    end
end

function BattleHeroItem:onBtnItem()
    if self.clickCallback then
        self.clickCallback()
    end
end

-----""
function BattleHeroItem:addClickCallback(callback)
    self.clickCallback = callback
end

function BattleHeroItem:setItemGray(isGray)
    EffectUtil.setGray(self.transform, isGray, true)
end

function BattleHeroItem:setSelect(isSelect)
    --self.imgSelect.gameObject:SetActiveEx(isSelect)
    if isSelect then
        self.animator:SetTrigger("select")
        self.sequence = moveSelect(self.transform, 20, self.sequence)
    else
        self.sequence = moveSelect(self.transform, 0, self.sequence)
    end
end

function BattleHeroItem:setLevel(level)
    self.txtLevel.text = "Lv." .. level
end

BattleHeroItem.totalAniTime = 0.5
function BattleHeroItem:setCardStage(stage)
    if stage == PnlBattle.SKILL_STAGE_HERO_NOT_USE then
        self.canvasGroup.alpha = 1
        self:setActive(true)
    else
        local sequence = CS.DG.Tweening.DOTween.Sequence()
        self.canvasGroup.alpha = 1
        sequence:Append(self.canvasGroup:DOFade(0, BattleHeroItem.totalAniTime):SetEase(CS.DG.Tweening.Ease.Linear))
        sequence:AppendCallback(function()
            self:setActive(false)
        end)
    end
end

BattleHeroItem.FrameQuality = {"longframe_icon_A", "longframe_icon_B", "longframe_icon_C", "longframe_icon_D", "longframe_icon_E"}
function BattleHeroItem:setQuality(quality)
    local frame = BattleHeroItem.FrameQuality[quality]
    local battleCardItemBg = self.transform:Find("BattleCardItem/BG"):GetComponent(UNITYENGINE_UI_IMAGE)

    local frameIcon = gg.getSpriteAtlasName("Battle_Atlas", frame)

    gg.setSpriteAsync(battleCardItemBg, frameIcon)

end

function BattleHeroItem:onRelease()
    if self.sequence then
        self.sequence:Kill()
        self.sequence = nil
    end

    self.battleCardItem:release()
end

-----------------------------------------------------------------------------------------------
BattleHeroSkillItem = BattleHeroSkillItem or class("BattleHeroSkillItem", ggclass.UIBaseItem)
BattleHeroSkillItem.FrameQuality = {"longframe_icon_A", "longframe_icon_B", "longframe_icon_C", "longframe_icon_D", "longframe_icon_E"}
function BattleHeroSkillItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BattleHeroSkillItem:onInit()
    self.icon = self:Find("Mask/Icon", "Image")
    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self), nil, nil, false)
    self:setOnLongPress(self.gameObject, gg.bind(self.onLongPressBtnItem, self), nil, nil, false)

    -- self.transform.anchoredPosition = CS.UnityEngine.Vector2(0, 50)

    --self.txtCost = self:Find("bgCost/TxtCost", "Text")
    --self.imgSelect = self:Find("ImgSelect", "Image")
    self.animator = self.transform:GetComponent("Animator")
end

function BattleHeroSkillItem:onBtnItem()
    if self.clickCallback then
        self.clickCallback()
    end
end

function BattleHeroSkillItem:setQuality(quality, heroData)
    local frame = BattleHeroSkillItem.FrameQuality[quality]
    local bg = self.transform:Find("Bg"):GetComponent(UNITYENGINE_UI_IMAGE)

    local bgIcon = gg.getSpriteAtlasName("Battle_Atlas", frame)
    gg.setSpriteAsync(bg, bgIcon)
end

function BattleHeroSkillItem:onRelease()
    if self.sequence then
        self.sequence:Kill()
        self.sequence = nil
    end
end

function BattleHeroSkillItem:onLongPressBtnItem()
    if self.longPressCallback then
        self.longPressCallback()
    end
end

-----""
function BattleHeroSkillItem:addClickCallback(callback)
    self.clickCallback = callback
end

function BattleHeroSkillItem:addLongPressCallback(callback)
    self.longPressCallback = callback
end

function BattleHeroSkillItem:setCost(cost)
    self.txtCost.text = cost
end

function BattleHeroSkillItem:setSelect(isSelect)
    -- self.imgSelect.gameObject:SetActiveEx(isSelect)
    -- if isSelect then
    --     self.animator:SetTrigger("select")
    -- end
    --self.imgSelect.gameObject:SetActiveEx(isSelect)
    -- if isSelect then
    --     self.animator:SetTrigger("select")
    --     self.sequence = moveSelect(self.transform, 20, self.sequence)
    -- else
    --     self.sequence = moveSelect(self.transform, 0, self.sequence)
    -- end
end

function BattleHeroSkillItem:setItemGray(isGray)
    EffectUtil.setGray(self.transform, isGray, true)
end

function BattleHeroSkillItem:setCardStage(stage)
    self:setActive(true)
    if stage == PnlBattle.SKILL_STAGE_HERO_NOT_USE then
        -- self.transform.localEulerAngles = Vector3(0, 0, -5)
        self.animator:SetTrigger("wait")
    else
        -- local sequence = CS.DG.Tweening.DOTween.Sequence()
        -- sequence:AppendInterval(BattleHeroItem.totalAniTime)
        -- sequence:Append(self.transform:DOLocalRotate(Vector3(0, 0, 0), 0.25):SetEase(CS.DG.Tweening.Ease.Linear))
        self.animator:SetTrigger("appear")
        -- sequence:Join(self.transform:DOPunchScale(CS.UnityEngine.Vector3(1.2, 1.2, 1.2), 0.5):SetEase(CS.DG.Tweening.Ease.InSine))
    end
end

function BattleHeroSkillItem:setIcon(icon)
    gg.setSpriteAsync(self.icon, icon)
end

-----------------------------------------------------------------------------------------------
BattleSkillItem = BattleSkillItem or class("BattleSkillItem", ggclass.UIBaseItem)
BattleSkillItem.BgQuality = {"Item_Bg_1", "Item_Bg_2", "Item_Bg_3", "Item_Bg_4", "Item_Bg_5"}

function BattleSkillItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BattleSkillItem:onRelease()
    if self.sequence then
        self.sequence:Kill()
        self.sequence = nil
    end
end

function BattleSkillItem:onInit()
    self.icon = self:Find("Icon", "Image")
    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self), nil, nil, false)
    self:setOnLongPress(self.gameObject, gg.bind(self.onLongPressBtnItem, self), nil, nil, false)

    self.txtCost = self:Find("bgCost/TxtCost", "Text")
    self.imgSelect = self:Find("Choose", "Image")
    self.imgSelect.gameObject:SetActiveEx(false)

    self.animator = self.transform:GetComponent("Animator")
end

function BattleSkillItem:setQuality(quality)
    local bg = self.transform:Find("Bg"):GetComponent(UNITYENGINE_UI_IMAGE)

    local bgIcon = gg.getSpriteAtlasName("Item_Bg_Atlas", BattleSkillItem.BgQuality[quality])

    gg.setSpriteAsync(bg, bgIcon)
end

function BattleSkillItem:onBtnItem()
    if self.clickCallback then
        self.clickCallback()
    end
end

function BattleSkillItem:onLongPressBtnItem()
    if self.longPressCallback then
        self.longPressCallback()
    end
end

-----""
function BattleSkillItem:addClickCallback(callback)
    self.clickCallback = callback
end

function BattleSkillItem:addLongPressCallback(callback)
    self.longPressCallback = callback
end

function BattleSkillItem:setCost(cost)
    self.txtCost.text = cost
end

function BattleSkillItem:setSelect(isSelect)
    self.imgSelect.gameObject:SetActiveEx(isSelect)

    -- if isSelect then
    --     self.animator:SetTrigger("select")
    -- end
    --self.imgSelect.gameObject:SetActiveEx(isSelect)
    -- if isSelect then
    --     self.animator:SetTrigger("select")
    --     self.sequence = moveSelect(self.transform, 20, self.sequence)
    -- else
    --     self.sequence = moveSelect(self.transform, 0, self.sequence)
    -- end
end

function BattleSkillItem:setIcon(icon)
    gg.setSpriteAsync(self.icon, icon)
end

-----------------------------------------------------------------------------------------------