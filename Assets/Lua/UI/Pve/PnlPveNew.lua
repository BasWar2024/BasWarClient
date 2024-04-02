PnlPveNew = class("PnlPveNew", ggclass.UIBase)

function PnlPveNew:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    -- self.events = {"onPveBotDataChange" }
    self.events = {"onUpData", "onPveChange", "onRedPointChange", "onFingerUp"}
end

function PnlPveNew:onAwake()
    self.view = ggclass.PnlPveNewView.new(self.pnlTransform)

    self.pveDailyRewardItemList = {}
    self.dailyAllRewardScrollView = UIScrollView.new(self.view.dailyAllRewardScrollView, "PveDailyRewardItem",
        self.pveDailyRewardItemList)
    self.dailyAllRewardScrollView:setRenderHandler(gg.bind(self.onRenderDailyItem, self))
    self.commonResBox = CommonResBox.new(self.view.commonResBox)

    self.firstPveSubRewardBox = BattleResultRewardBox.new(self.view.firstPveSubRewardBox)
    self.dailyPveSubRewardBox = BattleResultRewardBox.new(self.view.dailyPveSubRewardBox)

    self.pveDescLine = PveDescLine.new(self.view.pveDescLine, self)

    self:initPlanets()

    self.redPointBtnMap = {
        [RedPointPveDailyRewardFetch.__name] = self.view.bgDalyLess
    }
end

function PnlPveNew:onShow()
    self:bindEvent()
    self.commonResBox:open()

    self.selectCfg = nil
    self:refreshDaily()
    self:refreshPlanet()
    self:initRedPoint()

    self:hidePlanet2Desc()
    self:refreshMessage()
end

function PnlPveNew:onRedPointChange(_, name, isRed)
    if self.redPointBtnMap[name] then
        RedPointManager:setRedPoint(self.redPointBtnMap[name], isRed)
    end
end

function PnlPveNew:initRedPoint()
    for key, value in pairs(self.redPointBtnMap) do
        RedPointManager:setRedPoint(value, RedPointManager:getIsRed(key))
    end
end

function PnlPveNew:refreshPlanet()
    local chooseId = nil
    if self.selectCfg then
        chooseId = self.selectCfg.cfgId
    else
        chooseId = 1

        if next(BattleData.pvePassMap) then
            for key, value in pairs(BattleData.pvePassMap) do
                if key > chooseId then
                    chooseId = key
                end
            end

            for key, value in pairs(cfg.pve) do
                if value.preCfgId == chooseId then
                    chooseId = value.cfgId
                    break
                end
            end

            -- local nextId = 99999999
            -- for key, value in pairs(cfg.pve) do
            --     if value.cfgId > chooseId and value.cfgId < nextId then
            --         nextId = value.cfgId
            --     end
            -- end
            -- chooseId = nextId
        end
    end

    for key, value in pairs(self.planetMap) do
        value:refresh()

        if value.cfgId == chooseId then
            value:onClickItem()
            self:jump2Planet(value.cfgId)
        end
    end
end

function PnlPveNew:onUpData()
    local view = self.view

    if self.center then
        view.planetSelect.position = self.center.transform.position
    end

    local contentWidth = view.planetContent.rect.width
    local scrollWidth = view.planetScrollView.rect.width
    local bgWidth = view.layoutBg.rect.width
    local viewWidth = view.transform.rect.width

    local ratio = -view.planetContent.anchoredPosition.x / (contentWidth - scrollWidth)

    local x = (bgWidth - viewWidth) * ratio

    x = math.max(x, 0)
    x = math.min(x, bgWidth - viewWidth)

    local pos = view.layoutBg.anchoredPosition
    pos.x = -x

    view.layoutBg.anchoredPosition = pos

    -- print(self.view.planetContent.anchoredPosition)

    if self.isShowDesc then
        self:showPlanet2Desc()
    end
end

function PnlPveNew:jump2Planet(cfgId)
    local targetPlenet
    for key, value in pairs(self.planetMap) do
        if value.cfgId == cfgId then
            targetPlenet = value
        end
    end
    local width = self.view.planetScrollView.transform.rect.width
    local contentWidth = self.view.planetContent.rect.width
    if targetPlenet.transform.anchoredPosition.x < width / 2 then
        self.view.planetContent.anchoredPosition = Vector2.New(0, 0)
    elseif contentWidth - targetPlenet.transform.anchoredPosition.x < width / 2 then
        self.view.planetContent.anchoredPosition = Vector2.New(-(contentWidth - width), 0)
    else
        self.view.planetContent.anchoredPosition =
            Vector2.New(-targetPlenet.transform.anchoredPosition.x + width / 2, 0)
    end
end

function PnlPveNew:selectPlanet(subCfg, center, pvePlanetInfo)
    print(1111)
    local view = self.view
    self.selectCfg = subCfg
    self.center = center
    self.pvePlanetInfo = pvePlanetInfo

    if not subCfg then
        view.planetSelect:SetActiveEx(false)
        return
    end

    view.planetSelect:SetActiveEx(true)
    view.planetSelect.position = center.transform.position

    local scale = pvePlanetInfo.SelectScale
    view.planetSelect.localScale = CS.UnityEngine.Vector3(scale, scale, 1)

    local anim = view.planetSelectSkeletonAnimation
    anim.Skeleton:SetToSetupPose()
    anim.AnimationState:ClearTracks()
    anim.AnimationState:SetAnimation(0, "click", false)
    anim.AnimationState:AddAnimation(0, "idle", true, 0)

    self:refreshMessage()

    self:showPlanet2Desc()
end

function PnlPveNew:showPlanet2Desc()
    self.isShowDesc = self.selectCfg.playerName and self.selectCfg.playerName ~= ""

    if not self.isShowDesc then
        return
    end

    self.pveDescLine.transform:SetActiveEx(true)
    self.view.layoutPlanetDesc.transform:SetActiveEx(true)

    local centerPos = self.transform:InverseTransformPoint(self.center.transform.position)

    local descTransform = self.view.layoutPlanetDesc.transform
    if centerPos.x < 0 then
        descTransform.pivot = CS.UnityEngine.Vector2(0, 0.8)
        descTransform.anchoredPosition = CS.UnityEngine.Vector2(centerPos.x + 150, 86)

    else
        descTransform.pivot = CS.UnityEngine.Vector2(1, 0.8)
        descTransform.anchoredPosition = CS.UnityEngine.Vector2(centerPos.x - 150, 86)
    end
    self.pveDescLine:setWorldPos(self.center.transform.position, self.view.layoutPlanetDesc.position)
end

function PnlPveNew:hidePlanet2Desc()
    self.isShowDesc = false
    self.pveDescLine.transform:SetActiveEx(false)
    self.view.layoutPlanetDesc.transform:SetActiveEx(false)
end

function PnlPveNew:onFingerUp()
    self:hidePlanet2Desc()
end

function PnlPveNew:refreshMessage()
    local view = self.view
    view.txtProgress.text = string.format("<size=77>%s</size>/%s", BattleData.passCount, PveUtil.getCount())

    if not self.selectCfg then
        return
    end

    local passData = BattleData.pvePassMap[self.selectCfg.cfgId]

    if passData then
        for index, value in ipairs(view.starItemList) do
            value.imgLight:SetActiveEx(passData.star >= index)
        end
    else
        for index, value in ipairs(view.starItemList) do
            value.imgLight:SetActiveEx(false)
        end
    end
    -- dailyRewards

    -- local dailyRewardMap = {}
    -- PveUtil.getStarReward(self.selectCfg.cfgId, true, true, true)

    self.firstPveSubRewardBox:setData(self.selectCfg.passReward, BattleResultRewardBox.TYPE_REWARD_FIRST)
    self.firstPveSubRewardBox:setGray(passData ~= nil)

    self.dailyPveSubRewardBox:setData(PveUtil.getStarReward(self.selectCfg.cfgId, true, true, true),
        BattleResultRewardBox.TYPE_REWARD_DAILY)
    self.dailyPveSubRewardBox:setGray(BattleData.pveDailyRewardMap[self.selectCfg.cfgId])
end

function PnlPveNew:onPveChange()
    self:refreshMessage()
    self:refreshDaily()
end

function PnlPveNew:initPlanets()
    local view = self.view

    self.planetMap = {}
    for i = 1, view.layoutPlanets.childCount, 1 do
        local item = PvePlanetItem.new(view.layoutPlanets:GetChild(i - 1), self)
        self.planetMap[item.cfgId] = item
    end
end

function PnlPveNew:checkIsCanFetchDaily()
    local isCanFetch, rewardMap = PveUtil.checkIsCanFetchDaily()

    self.rewardMap = rewardMap

    return isCanFetch
end

function PnlPveNew:refreshDaily()
    local view = self.view

    gg.timer:stopTimer(self.dailyFetchTimer)
    local lessTickEnd = BattleData.pveResetTickEnd
    self:refreshDailyLess()
    if lessTickEnd > Utils.getServerSec() then
        view.txtDailyLess.gameObject:SetActiveEx(true)
        self.dailyFetchTimer = gg.timer:startLoopTimer(0, 0.3, -1, function()
            local time = lessTickEnd - Utils.getServerSec()
            if time <= 0 then
                gg.timer:stopTimer(self.dailyFetchTimer)
                view.txtDailyLess.gameObject:SetActiveEx(false)
                self:refreshDailyLess()
                return
            end

            local hms = gg.time.dhms_time({
                day = false,
                hour = 1,
                min = 1,
                sec = 1
            }, time)
            view.txtDailyLess.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)
        end)
    else
        view.txtDailyLess.gameObject:SetActiveEx(false)
    end

    self.nextDayRewardMap = {}
    -- BattleData.pveDayPassMap = {[1] = {cfgId = 1, stars = {1, 3}}}

    -- for key, dayPass in pairs(BattleData.pveDayPassMap) do
    --     if dayPass.stars[#dayPass.stars] == 3 then
    --         local rewardList = PveUtil.getStarReward(dayPass.cfgId, true, true, true)
    --         for _, reward in pairs(rewardList) do
    --             self.nextDayRewardMap[reward[1]] = self.nextDayRewardMap[reward[1]] or {resId = reward[1], count = 0}
    --             self.nextDayRewardMap[reward[1]].count = self.nextDayRewardMap[reward[1]].count + reward[2]
    --         end
    --     end
    -- end

    for key, dayPass in pairs(BattleData.pvePassMap) do
        if dayPass.star == 3 then
            local rewardList = PveUtil.getStarReward(dayPass.cfgId, true, true, true)
            for _, reward in pairs(rewardList) do
                self.nextDayRewardMap[reward[1]] = self.nextDayRewardMap[reward[1]] or {
                    resId = reward[1],
                    count = 0
                }
                self.nextDayRewardMap[reward[1]].count = self.nextDayRewardMap[reward[1]].count + reward[2]
            end
        end
    end

    self.nextDayRewardList = {}
    for key, value in pairs(self.nextDayRewardMap) do
        if value.count > 0 then
            table.insert(self.nextDayRewardList, value)
        end
    end

    local dataCount = #self.nextDayRewardList

    if dataCount > 0 then
        view.bgDailyReward:SetActiveEx(true)
        self.dailyAllRewardScrollView:setItemCount(#self.nextDayRewardList)
    else
        view.bgDailyReward:SetActiveEx(false)
    end
end

function PnlPveNew:refreshDailyLess()
    if self:checkIsCanFetchDaily() then
        EffectUtil.setGray(self.view.bgDalyLess, false, true)
    else
        EffectUtil.setGray(self.view.bgDalyLess, true, true)
    end
end

function PnlPveNew:onRenderDailyItem(obj, index)
    local item = PveDailyRewardItem:getItem(obj, self.pveDailyRewardItemList, self)
    local data = self.nextDayRewardList[index]
    local icon = constant.RES_2_CFG_KEY[data.resId].icon
    item:setData(icon, data.count)
end

function PnlPveNew:onHide()
    self:releaseEvent()
end

function PnlPveNew:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnRank):SetOnClick(function()
        self:onBtnRank()
    end)
    CS.UIEventHandler.Get(view.btnRule):SetOnClick(function()
        self:onBtnRule()
    end)
    CS.UIEventHandler.Get(view.btnScout):SetOnClick(function()
        self:onBtnScout()
    end)
    CS.UIEventHandler.Get(view.btnFight):SetOnClick(function()
        self:onBtnFight()
    end)
    CS.UIEventHandler.Get(view.btnInfo):SetOnClick(function()
        self:onBtnInfo()
    end)

    self:setOnClick(view.bgDalyLess, gg.bind(self.fetchDailyReward, self))
end

function PnlPveNew:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnRank)
    CS.UIEventHandler.Clear(view.btnRule)
    CS.UIEventHandler.Clear(view.btnScout)
    CS.UIEventHandler.Clear(view.btnFight)
    CS.UIEventHandler.Clear(view.btnInfo)

    gg.timer:stopTimer(self.dailyFetchTimer)
    self.commonResBox:close()
end

function PnlPveNew:onDestroy()
    local view = self.view
    self.dailyAllRewardScrollView:release()
    self.commonResBox:release()
    self.pveDescLine:release()
end

function PnlPveNew:onBtnClose()
    self:close()
end

function PnlPveNew:fetchDailyReward()
    if not next(BattleData.pveDayPassMap) and not next(BattleData.pvePassMap) then
        gg.uiManager:showTip(Utils.getText("pve_NoReward"))
    else
        if self:checkIsCanFetchDaily() then
            self.rewardMap = {}
            for key, value in pairs(BattleData.pvePassMap) do
                if not BattleData.pveDailyRewardMap[value.cfgId] then
                    PveUtil.addStarReward(PveUtil.getStarReward(value.cfgId, value.star >= 1, value.star >= 2,
                        value.star >= 3), self.rewardMap)
                end
            end

            local args = {
                rewards = {}
            }
            for _, value in pairs(self.rewardMap) do
                if value[2] > 0 then
                    table.insert(args.rewards, {
                        rewardType = PnlReward.TYPE_RES,
                        resId = value[1],
                        count = value[2]
                    })
                end
            end

            BattleData.C2S_Player_PVERecvDailyRewards()
            gg.uiManager:openWindow("PnlReward", args)
        else
            gg.uiManager:showTip(Utils.getText("pve_AlreadyReceive"))
        end
    end
end

function PnlPveNew:onBtnRank()

end

function PnlPveNew:onBtnRule()
    gg.uiManager:openWindow("PnlRule", {
        title = Utils.getText("pve_Rules_Title"),
        content = Utils.getText("pve_Rules")
    })
end

function PnlPveNew:onBtnScout()
    if self.selectCfg then
        BattleData.setPvpScoutReturnOpenWindow({
            name = "PnlPveNew"
            -- type = PnlMatch.TYPE_MATCH
        })

        gg.uiManager:openWindow("PnlLoading", nil, function()
            BattleData.C2S_Player_PVEScoutFoundation(self.selectCfg.cfgId)
            self:close()
        end)
    end
end

function PnlPveNew:onBtnFight()
    if self.selectCfg then
        gg.uiManager:openWindow("PnlPersonalQuickSelectArmy", {
            fightCB = function(armys)
                BattleData.startPvp(BattleData.BATTLE_TYPE_PVE, self.selectCfg.cfgId, armys[1].armyId, self)
            end
        })
    end
end

function PnlPveNew:onBtnInfo()
    gg.uiManager:openWindow("PnlBattleReport")
end

return PnlPveNew
