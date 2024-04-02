NewPlayerLoginActItem = NewPlayerLoginActItem or class("NewPlayerLoginActItem", ggclass.UIBaseItem)
function NewPlayerLoginActItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function NewPlayerLoginActItem:onInit()
    -- self.imgIcon = self:Find("Bg/ImgIcon", UNITYENGINE_UI_IMAGE)
    -- self.txtCount = self:Find("TxtCount", UNITYENGINE_UI_TEXT)

    self.imgSelect = self:Find("ImgSelect", UNITYENGINE_UI_IMAGE)
    self.imgBg = self:Find("ImgBg", UNITYENGINE_UI_IMAGE)
    self:setOnClick(self.imgBg.gameObject, gg.bind(self.onBtnItem, self))

    self.txtTitle = self:Find("ImgBg/TxtTitle", UNITYENGINE_UI_TEXT)
    self.textGradientTitle = self.txtTitle.transform:GetComponent(typeof(CS.TextGradient))

    self.txtCost = self:Find("ImgBg/TxtCost", UNITYENGINE_UI_TEXT)

    self.btnFetch = self:Find("BtnFetch")
    self:setOnClick(self.btnFetch, gg.bind(self.onBtnFetch, self))

    self.NewPlayerLoginActRewardItem1 = NewPlayerLoginActRewardItem.new(self:Find("ImgBg/NewPlayerLoginActRewardItem1"))
    self.NewPlayerLoginActRewardItem2 = NewPlayerLoginActRewardItem.new(self:Find("ImgBg/NewPlayerLoginActRewardItem2"))
end

NewPlayerLoginActItem.CLOLR_WHITE = UnityEngine.Color32(255, 255, 255, 255)
NewPlayerLoginActItem.CLOLR_YELLOW = UnityEngine.Color32(255, 168, 0, 255)
NewPlayerLoginActItem.CLOLR_BLUE =  UnityEngine.Color32(39, 222, 255, 255)

function NewPlayerLoginActItem:setData(data)
    self.data = data
    self.txtTitle.text = string.format(Utils.getText("activity_DayWhat"), data.day)

    self.loginActivityData = nil
    for key, value in pairs(ActivityData.loginActivityInfo.data) do
        if value.day == self.data.day then
            self.loginActivityData = value
        end
    end

    -- for key, value in pairs(cfg.product) do
    --     if value.productId == data.costProductId then
    --         self.productCfg = value
    --         break
    --     end
    -- end

    if not self.initData.selectingItem and self.data.day == 1 then
        self:onBtnItem()
    end

    self.NewPlayerLoginActRewardItem1:setData(self.data.baseReward, false)
    self.NewPlayerLoginActRewardItem2:setData(self.data.advReward, self.loginActivityData.advStatus == -2)

    if self.loginActivityData.advStatus == 0 or self.loginActivityData.baseStatus == 0 then
        self.btnFetch:SetActiveEx(true)
        EffectUtil.setGray(self.btnFetch, false, true)

    elseif self.loginActivityData.baseStatus == -1 then
        self.btnFetch:SetActiveEx(true)
        EffectUtil.setGray(self.btnFetch, true, true)
    else
        self.btnFetch:SetActiveEx(false)
    end

    -- self.txtCost.text = "$" .. self.productCfg.price
    self.txtCost.text = Utils.getShowRes(data.cost)
    
    if data.specialReward == 1 then
        gg.setSpriteAsync(self.imgBg, "NewPlayerLoginAct_Atlas[box04_icon]")
        self.textGradientTitle:SetColor(NewPlayerLoginActItem.CLOLR_WHITE, NewPlayerLoginActItem.CLOLR_YELLOW)

        if not self.fontYellow then
            self.fontYellowHandle =  ResMgr:LoadFontAsync("button_1_Yellow", function (font)
                self.fontYellow = font
                self.txtCost.font = self.fontYellow
            end)
        else
            self.txtCost.font = self.fontYellow
        end
    else
        gg.setSpriteAsync(self.imgBg, "NewPlayerLoginAct_Atlas[box03_icon]")
        self.textGradientTitle:SetColor(NewPlayerLoginActItem.CLOLR_WHITE, NewPlayerLoginActItem.CLOLR_BLUE)

        if not self.fontBlue then
            self.fontBlueHandle = ResMgr:LoadFontAsync("button_1_Blue", function (font)
                self.fontBlue = font
                self.txtCost.font = self.fontBlue
            end)
        else
            self.txtCost.font = self.fontBlue
        end
    end

    self:refreshSelect()
end

function NewPlayerLoginActItem:onBtnFetch()
    -- self.loginActivityData.advStatus = 0
    -- self.loginActivityData.baseStatus = 0

    if self.loginActivityData.advStatus == 0 or self.loginActivityData.baseStatus == 0 then
        ActivityData.C2S_Player_GetLoginActReward(self.data.day)

        local rewardList = {}
        if self.loginActivityData.baseStatus == 0 then
            self:getRewardList(self.data.baseReward, rewardList)
        end
        if self.loginActivityData.advStatus == 0 then
            self:getRewardList(self.data.advReward, rewardList)
        end

        gg.uiManager:openWindow("PnlTaskReward", {reward = rewardList})
    end
end

function NewPlayerLoginActItem:getRewardList(loginActivityReward, rewardList)
    rewardList = rewardList or {}

    for key, value in pairs(loginActivityReward) do
        table.insert(rewardList, {
            rewardType = constant.ACTIVITY_REWARD_ITEM,
            cfgId = value[1],
            count = value[2],
        })

        -- local subRewardList = ShopUtil.parseItemEffect(value[1])
        -- for _, v in pairs(subRewardList) do
        --     v.count = v.count * value[2]
        --     table.insert(rewardList, v)
        -- end
    end
end

function NewPlayerLoginActItem:onBtnItem()
    self.initData:selectItem(self)
end

function NewPlayerLoginActItem:refreshSelect()
    self.imgSelect.transform:SetActiveEx(self.initData.selectingItem == self)
end

function NewPlayerLoginActItem:onRelease()
    if self.fontYellowHandle then
        ResMgr:ReleaseAssetAsyncOperationHandle(self.fontYellowHandle)
    end
    
    if self.fontBlueHandle then
        ResMgr:ReleaseAssetAsyncOperationHandle(self.fontBlueHandle)
    end

    self.NewPlayerLoginActRewardItem1:release()
    self.NewPlayerLoginActRewardItem2:release()
end

--------------------------------------------------------

NewPlayerLoginActRewardItem = NewPlayerLoginActRewardItem or class("NewPlayerLoginActRewardItem", ggclass.UIBaseItem)
function NewPlayerLoginActRewardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function NewPlayerLoginActRewardItem:onInit()
    self.txtCount = self:Find("TxtCount", UNITYENGINE_UI_TEXT)
    self.imgLock = self:Find("ImgLock", UNITYENGINE_UI_IMAGE)

    self.activityRewardItem = ActivityRewardItem.new(self:Find("ActivityRewardItem"))

    self:setOnClick(self.activityRewardItem.gameObject, gg.bind(self.onClickReward, self))
end

function NewPlayerLoginActRewardItem:setData(data, isLock)
    local rewardItem = data[1]
    self.rewardItem = rewardItem

    -- local rewardList = ShopUtil.parseItemEffect(rewardItem[1])
    -- local reward = rewardList[1]
    -- self.activityRewardItem:setData(reward)
    -- local icon, count, name, quality = ShopUtil.parseReward(reward)
    -- if reward.rewardType == constant.ACTIVITY_REWARD_RES then
    --     self.txtCount.text = "X" .. Utils.getShowRes(reward.count * rewardItem[2])
    -- else
    --     self.txtCount.text = "X" .. count * rewardItem[2]
    -- end

    -- print("eweeeeeeeeeeeeeeeeeeee")
    -- print(rewardItem[1])

    self.activityRewardItem:setItemCfgId(rewardItem[1])
    self.txtCount.text = "X" .. rewardItem[2]

    self.imgLock.transform:SetActiveEx(isLock)
    EffectUtil.setGray(self.transform, isLock, true)
end

function NewPlayerLoginActRewardItem:onRelease()
    self.activityRewardItem:release()
end

function NewPlayerLoginActRewardItem:onClickReward()
    gg.uiManager:openWindow("PnlItemInfoSmall", {itemCfgId = self.rewardItem[1], count = self.rewardItem[2]})
end