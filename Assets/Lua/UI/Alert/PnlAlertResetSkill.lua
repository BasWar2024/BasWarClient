PnlAlertResetSkill = class("PnlAlertResetSkill", ggclass.UIBase)

-- args = {
-- txtTitel = ,
-- txtTips = ,
-- txtTipsRed = ,
-- txtYes = , 
-- callbackYes = , 
-- txtNo = , 
-- callbackNo = , 
-- skillCfgId =,
-- skillLevel = ,
-- isDismantleHero = ,
-- isGetSkill = ,
-- itemCfgId = ,
-- itemCount = ,
-- skills = ,
-- type = ,
-- starCoin = 
-- }

function PnlAlertResetSkill:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {}
end

function PnlAlertResetSkill:onAwake()
    self.view = ggclass.PnlAlertResetSkillView.new(self.pnlTransform)

end

function PnlAlertResetSkill:onShow()
    self:bindEvent()
    self.view.res:SetActiveEx(false)
    self.view.skill:SetActiveEx(false)

    local boxResList = self.view.boxResList
    for k, v in pairs(boxResList) do
        v:SetActiveEx(false)
    end

    self.view.txtTitle.text = self.args.txtTitel
    self.view.txtTips.text = self.args.txtTips

    if self.args.txtNo then
        self.view.btnNo:SetActiveEx(true)
        self.view.txtBtnNo.text = self.args.txtNo
    else
        self.view.btnNo:SetActiveEx(false)
    end
    self.view.txtBtnYes.text = self.args.txtYes

    if self.args.isGetSkill then
        self.view.txtTipsRed.gameObject:SetActiveEx(false)
        self.view.txtTips1.gameObject:SetActiveEx(false)
        self:setViewSkill()
        return
    end

    self.view.txtTipsRed.gameObject:SetActiveEx(true)
    self.view.txtTips1.gameObject:SetActiveEx(true)
    if self.args.txtTips1 then
        self.view.txtTips1.text = self.args.txtTips1

    end
    self.view.txtTipsRed.text = self.args.txtTipsRed
    if self.args.isDismantleHero then
        self:setViewSkill()
        return
    end
    self.view.res:SetActiveEx(true)
    if self.args.skillCfgId then
        local skillCfgId = self.args.skillCfgId
        local skillLevel = self.args.skillLevel
        local skillCfg = cfg.getCfg("skill", skillCfgId, skillLevel)

        if skillCfg.forgetRewardShard[1] then
            self:setIcon(skillCfg.forgetRewardShard[1][1], skillCfg.forgetRewardShard[1][2])
        end

        local forgetRewardResources = skillCfg.forgetRewardResources
        for i, v in ipairs(forgetRewardResources) do
            local go = boxResList[i]
            local resId = v[1]
            local count = v[2] / 1000
            gg.setSpriteAsync(go.transform:Find("IconRes"):GetComponent(UNITYENGINE_UI_IMAGE),
                constant.RES_2_CFG_KEY[resId].icon)
            go.transform:Find("TxtCound"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.scientificNotation(count)
            go:SetActiveEx(true)
        end
    else
        if self.args.starCoin then
            local go = boxResList[1]
            local resId = constant.RES_STARCOIN
            local count = self.args.starCoin / 1000
            gg.setSpriteAsync(go.transform:Find("IconRes"):GetComponent(UNITYENGINE_UI_IMAGE),
                constant.RES_2_CFG_KEY[resId].icon)
            go.transform:Find("TxtCound"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.scientificNotation(count)
            go:SetActiveEx(true)

        end
    end

end

function PnlAlertResetSkill:showGetSkill()
    self:setIcon(self.args.itemCfgId, self.args.itemCount)
end

function PnlAlertResetSkill:setIcon(itemCfgId, count)
    local itemCfg = cfg.getCfg("item", itemCfgId)
    UIUtil.setQualityBg(self.view.iconBg, itemCfg.quality)
    local bgName = gg.getSpriteAtlasName("Skill_A1_Atlas", string.format("debris%s_icon", itemCfg.quality))
    gg.setSpriteAsync(self.view.iconSkillBg, bgName)
    local iconName = gg.getSpriteAtlasName("Skill_A1_Atlas", itemCfg.icon .. "_A1")
    gg.setSpriteAsync(self.view.iconSkill, iconName)
    if self.args.type == 1 then
        self.view.txtCound.text = count
    else
        self.view.txtCound.text = string.format("LV.%d", self.args.skillLevel)
    end
end

function PnlAlertResetSkill:onHide()
    self:releaseEvent()
    self:releaseBoxAlertSkillShard()

end

function PnlAlertResetSkill:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnNo):SetOnClick(function()
        self:onBtnNo()
    end)
    CS.UIEventHandler.Get(view.btnYes):SetOnClick(function()
        self:onBtnYes()
    end)

end

function PnlAlertResetSkill:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnNo)
    CS.UIEventHandler.Clear(view.btnYes)

end

function PnlAlertResetSkill:onDestroy()
    local view = self.view

end

function PnlAlertResetSkill:onBtnNo()
    if self.args.callbackNo then
        self.args.callbackNo()
    end
    self:close()
end

function PnlAlertResetSkill:onBtnYes()
    if self.args.callbackYes then
        self.args.callbackYes()
    end
    self:close()
end

function PnlAlertResetSkill:setViewSkill()
    local items = {}
    local tesNum = 0
    if self.args.skills then
        for k, v in pairs(self.args.skills) do
            local skillCfgId = v.skillId
            local skillNum = v.num
            local skillLevel = v.level
            local skillCfg = cfg.getCfg("skill", skillCfgId, skillLevel)

            if skillCfg then
                local itemCfgId = skillCfg.forgetRewardShard[1][1]
                local itemCfg = cfg.getCfg("item", itemCfgId)
                local count = itemCfg.resolveItem[1][2] * skillNum
                local num = 0
                if items[itemCfgId] then
                    num = items[itemCfgId].count
                end

                items[itemCfgId] = {
                    itemCfg = itemCfg,
                    count = count + num
                }
                tesNum = tesNum + itemCfg.resolveItem[2][2] * skillNum
            end
        end
    elseif self.args.items then
        for k, v in pairs(self.args.items) do
            local itemCfgId = v.cfgId
            local itemCfg = cfg.getCfg("item", itemCfgId)
            local count = v.num
            local num = 0
            if items[itemCfgId] then
                num = items[itemCfgId].count
            end

            items[itemCfgId] = {
                itemCfg = itemCfg,
                count = count + num
            }

        end

    end

    self:loadBoxAlertSkillShard(items, tesNum)
end

function PnlAlertResetSkill:loadBoxAlertSkillShard(items, tesNum)
    self:releaseBoxAlertSkillShard()
    self.boxAlertSkillShardList = {}
    for k, v in pairs(items) do
        local count = v.count
        local itemCfg = v.itemCfg
        ResMgr:LoadGameObjectAsync("BoxAlertSkillShard", function(go)
            go.transform:SetParent(self.view.content, false)
            UIUtil.setQualityBg(go.transform:GetComponent(UNITYENGINE_UI_IMAGE), itemCfg.quality)
            local bgName = gg.getSpriteAtlasName("Skill_A1_Atlas", string.format("debris%s_icon", itemCfg.quality))
            gg.setSpriteAsync(go.transform:Find("BgSkillChip"):GetComponent(UNITYENGINE_UI_IMAGE), bgName)
            local iconName = gg.getSpriteAtlasName("Skill_A1_Atlas", itemCfg.icon .. "_A1")
            gg.setSpriteAsync(go.transform:Find("BgSkillChip/Mask/IconSkillChip"):GetComponent(UNITYENGINE_UI_IMAGE),
                iconName)
            go.transform:Find("TxtCound"):GetComponent(UNITYENGINE_UI_TEXT).text = count
            table.insert(self.boxAlertSkillShardList, go)
            return true
        end, true)

    end
    if tesNum > 0 then
        self.view.boxRes:SetActiveEx(true)
        self.view.txtCoundRes.text = Utils.scientificNotationInt(tesNum / 1000)
    else
        self.view.boxRes:SetActiveEx(false)
    end
    self.view.skill:SetActiveEx(true)

end

function PnlAlertResetSkill:releaseBoxAlertSkillShard()
    if self.boxAlertSkillShardList then
        for i, v in ipairs(self.boxAlertSkillShardList) do
            ResMgr:ReleaseAsset(v)
        end
        self.boxAlertSkillShardList = nil
    end
end

return PnlAlertResetSkill
