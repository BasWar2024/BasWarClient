BattleResultRewardBox = BattleResultRewardBox or class("BattleResultRewardBox", ggclass.UIBaseItem)

function BattleResultRewardBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

BattleResultRewardBox.TYPE_REWARD_Normal = 0
BattleResultRewardBox.TYPE_REWARD_FIRST = 1
BattleResultRewardBox.TYPE_REWARD_DAILY = 2

BattleResultRewardBox.REWARD_TYPE_2_FLAG = {
    [BattleResultRewardBox.TYPE_REWARD_FIRST] = "Result_Atlas[first_icon]",
    [BattleResultRewardBox.TYPE_REWARD_DAILY] = "Result_Atlas[daily_icon]"

}

function BattleResultRewardBox:onInit()
    self.itemList = {}
    self.isGray = false
    self.scrollView = UIScrollView.new(self:Find("ScrollView"), "BattleResultRewardItem", self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderRewardItem, self))
end

function BattleResultRewardBox:setData(rewardDataList, rewardType)
    self.rewardType = rewardType or BattleResultRewardBox.TYPE_REWARD_Normal

    self.rewardDataList = rewardDataList
    self.scrollView:setItemCount(#self.rewardDataList)
    -- self.imgReceived.transform:SetActiveEx(isFetch)
end

function BattleResultRewardBox:getItemCount()
    return self.scrollView.itemCount
end

function BattleResultRewardBox:onRenderRewardItem(obj, index)
    local item = BattleResultRewardItem:getItem(obj, self.itemList, self)
    local rewardData = self.rewardDataList[index]
    local icon = constant.RES_2_CFG_KEY[rewardData[1]].icon
    item:setData(icon, Utils.getShowRes(rewardData[2]), BattleResultRewardBox.REWARD_TYPE_2_FLAG[self.rewardType])
end

function BattleResultRewardBox:setGray(isGray)
    self.isGray = isGray
    for key, value in pairs(self.itemList) do
        value:setGray(self.isGray)
    end
end

function BattleResultRewardBox:onRelease()
    self.scrollView:release()
end

-- local COLOR_WIN = UnityEngine.Color(0xff/0xff, 0xff/0xff, 0xcb/0xff, 1)
-- local COLOR_LOSE = UnityEngine.Color(0x46/0xff, 0xb2/0xff, 0xfd/0xff, 1)

-- function BattleResultRewardBox:setIsWin(isWin)
--     if isWin then
--         self.txtTitle.color = COLOR_WIN
--         gg.setSpriteAsync(self.imgLine, "Result_Atlas[line02_icon]")
--     else
--         self.txtTitle.color = COLOR_LOSE
--         gg.setSpriteAsync(self.imgLine, "Result_Atlas[line01_icon]")
--     end
-- end

-- function BattleResultRewardBox:onRenderItem(obj, index)
--     local item = BattleResultRewardBoxItem:getItem(obj, self.itemList)
--     item:setData(self.soldiers[index])
-- end

-- function BattleResultRewardBox:onRelease()
--     self.scrollView:release()
-- end

-- -- {SoliderBattleType, }
-- function BattleResultRewardBox:setData(soldiers)
--     self.soldiers = soldiers
--     if #soldiers <= 0 then
--         self.txtAlert.transform:SetActiveEx(true)
--         self.scrollView.transform:SetActiveEx(false)
--         return
--     end

--     self.txtAlert.transform:SetActiveEx(false)
--     self.scrollView.transform:SetActiveEx(true)
--     self.scrollView:setItemCount(#soldiers)
-- end

-------------------------------------------------------

BattleResultRewardItem = BattleResultRewardItem or class("BattleResultRewardItem", ggclass.UIBaseItem)

function BattleResultRewardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BattleResultRewardItem:onInit()
    self.icon = self:Find("icon", UNITYENGINE_UI_IMAGE)
    self.txtReceive = self:Find("txtReceive", UNITYENGINE_UI_TEXT)
    self.imgFlag = self:Find("ImgFlag", UNITYENGINE_UI_IMAGE)
end

function BattleResultRewardItem:setData(icon, count, flag)
    gg.setSpriteAsync(self.icon, icon)
    self.txtReceive.text = count

    if flag then
        gg.setSpriteAsync(self.imgFlag, flag)
    else
        self.imgFlag.transform:SetActiveEx(false)
    end

    self:setGray(self.initData.isGray)
end

function BattleResultRewardItem:setGray(isGray)
    EffectUtil.setGray(self.transform, isGray, true)
end
