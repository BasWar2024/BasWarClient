PnlLeagueRank = class("PnlLeagueRank", ggclass.UIBase)
PnlLeagueRank.infomationType = ggclass.UIBase.INFOMATION_HIDE

function PnlLeagueRank:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onUnionRankChange", "onUnionRankJackpot"}

    self.needBlurBG = true

    self.branch = CS.Appconst.branch

    self.chainCfg = cfg.chain
end

function PnlLeagueRank:onAwake()
    self.view = ggclass.PnlLeagueRankView.new(self.pnlTransform)

    self.rankItemList = {}
    self.rankScrollView = UILoopScrollView.new(self.view.rankScrollView, self.rankItemList)
    self.rankScrollView:setRenderHandler(gg.bind(self.onRenderRankItem, self))

    self.leagueRankItem = LeagueRankItem.new(self.view.leagueRankItem)

    self:initLeftButtonView()
end

function PnlLeagueRank:initLeftButtonView()
    local leftButtonView = self.view.leftButtonView
    local func = function(curCfg, go)
        local chainName = constant.getNameByChain(curCfg.alphaChainId)
        if chainName == "NONE" then
            chainName = ""
        end
        chainName = chainName .. " " .. Utils.getText("league_Rank_Title")
        go.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = chainName
    end
    local obj = leftButtonView:Find("BtnRank").gameObject
    self.leftButtonList = {}
    for i, v in pairs(self.chainCfg) do
        if v.isOpen == 1 then
            local go = UnityEngine.GameObject.Instantiate(obj)
            go.transform:SetParent(leftButtonView, false)
            go:SetActiveEx(true)
            func(v, go)
            self.leftButtonList[i] = go
            CS.UIEventHandler.Get(go):SetOnClick(function()
                self:onBtnRank(i)
            end)
        end
    end
end

function PnlLeagueRank:destroyLeftButtonView()
    if self.leftButtonList then
        for k, v in pairs(self.leftButtonList) do
            CS.UIEventHandler.Clear(v)
            UnityEngine.GameObject.Destroy(v)
        end
        self.leftButtonList = nil
    end
end

function PnlLeagueRank:onShow()
    self:bindEvent()
    self.view.txtTime.gameObject:SetActiveEx(false)

    self.view.rankScrollView:SetActiveEx(false)
    self.view.leagueRankItem:SetActiveEx(false)
    self:refreshJackpot()

    UnionData.C2S_Player_QueryStarmapHyJackpot()
    self:refreshAudit()
end

function PnlLeagueRank:refreshAudit()
    local view = self.view
    if IsAuditVersion() then
        view.bgJackpot:SetActiveEx(false)
    end
end

function PnlLeagueRank:refreshJackpot()
    local view = self.view
    if IsAuditVersion() then
        view.bgJackpot:SetActiveEx(false)
        return
    end

    local jackpot = tostring(math.floor(UnionData.jackpot))
    local numChar = {}
    for char in string.gmatch(jackpot, "[%d]") do
        table.insert(numChar, char)
    end
    -- print("aaa", table.dump(numChar))
    local num = #numChar
    for i, v in ipairs(self.view.txtJackpotNum) do
        if num > 0 then
            v.text = numChar[num]
        else
            v.text = 0
        end
        num = num - 1
    end
    self.view.bgJackpot:SetActiveEx(true)
end

function PnlLeagueRank:onUnionRankJackpot()
    self:refreshJackpot()

    local index = 1
    if UnionData.beginGridId then
        local curCfg = gg.galaxyManager:getGalaxyCfg(UnionData.beginGridId)
        if curCfg and curCfg.chainID then
            index = curCfg.chainID
        end
    end
    self:refresh(self:getChainID(index))
    self:sendStarmapMatchRank(index)
end

function PnlLeagueRank:getChainID(index)
    return self.chainCfg[index][constant.CHAIN_BRANCH_KEY[self.branch]]
end

function PnlLeagueRank:sendStarmapMatchRank(index)
    UnionData.C2S_Player_StarmapMatchRank(UnionData.RANK_CORE, self:getChainID(index))
end

function PnlLeagueRank:getChainCfgId(chainId)
    for k, v in pairs(self.chainCfg) do
        for _, key in pairs(constant.CHAIN_BRANCH_KEY) do
            if chainId == v[key] then
                return v.id
            end
        end
    end
end

function PnlLeagueRank:setLeftButton(index)
    for k, v in pairs(self.leftButtonList) do
        if index == k then
            v.transform:GetComponent(UNITYENGINE_UI_IMAGE).color = Color.New(1, 1, 1, 1)
        else
            v.transform:GetComponent(UNITYENGINE_UI_IMAGE).color = Color.New(1, 1, 1, 0)
        end
    end
end

function PnlLeagueRank:refresh(chainId)
    local view = self.view
    gg.timer:stopTimer(self.timer)
    self:setLeftButton(self:getChainCfgId(chainId))

    if not UnionData.unionRank[chainId] then
        return
    end

    local cfgId = UnionData.unionRank[chainId].matchCfgId
    local matchCfg = cfg.match[cfgId]

    if not matchCfg then
        -- view.txtTime.gameObject:SetActiveEx(false)
        view.txtRewardTime.gameObject:SetActiveEx(false)
        self.rankScrollView.gameObject:SetActiveEx(false)
        -- view.btnRankReward:SetActiveEx(false)
        self.leagueRankItem:setActive(false)
        -- return
    end

    view.txtTime.gameObject:SetActiveEx(true)

    local lifeTimeEnd = GalaxyData.lifeTimeEnd or 0

    local rewardEndTime = -1
    if lifeTimeEnd > os.time() then
        local daySec = 24 * 60 * 60
        local lessTime = lifeTimeEnd - os.time()
        local hms = gg.time.dhms_time({
            day = 1,
            hour = 1,
            min = 1,
            sec = 1
        }, lessTime)

        if lessTime >= daySec then
            view.txtTime.text = string.format("%sd %sh", hms.day, hms.hour)
        elseif lessTime < 60 then
            view.txtTime.text = string.format("%ss", hms.sec)
        else
            view.txtTime.text = string.format("%sh %sm", hms.hour, hms.min)
        end
    else
        view.txtTime.text = "season end"
        view.txtRewardTime.text = "week reward end"
    end

    self.curChainId = chainId
    view.txtRewardTime.gameObject:SetActiveEx(false)
    self.rankScrollView.gameObject:SetActiveEx(true)
    -- view.btnRankReward:SetActiveEx(true)
    self.leagueRankItem:setActive(true)

    self.rankDataList = UnionData.unionRank[chainId].rankList
    self.rankScrollView:setDataCount(#self.rankDataList)
    self.leagueRankItem:setData(UnionData.unionRank[chainId].selfRank, true, chainId, self:getChainCfgId(chainId))
end

function PnlLeagueRank:onRenderRankItem(obj, index)
    local item = LeagueRankItem:getItem(obj, self.rankItemList)
    item:setData(self.rankDataList[index], false, self.curChainId, self:getChainCfgId(self.curChainId))
end

function PnlLeagueRank:onUnionRankChange(args, chainId)
    self:refresh(chainId)
end

function PnlLeagueRank:onHide()
    self:releaseEvent()
    gg.timer:stopTimer(self.timer)

end

function PnlLeagueRank:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnRankReward):SetOnClick(function()
        self:onBtnRankReward()
    end)
    CS.UIEventHandler.Get(view.btnCoreReward):SetOnClick(function()
        self:onBtnCoreReward()
    end)

    self:setOnClick(view.btnDesc, gg.bind(self.onBtnDesc, self))
end

function PnlLeagueRank:onBtnDesc()
    gg.uiManager:openWindow("PnlDesc", {
        title = Utils.getText("league_Rules_Title"),
        desc = Utils.getText("league_Rules_Txt")
    })
end

function PnlLeagueRank:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnRankReward)
    CS.UIEventHandler.Clear(view.btnCoreReward)

end

function PnlLeagueRank:onDestroy()
    local view = self.view
    self.rankScrollView:release()
    self:destroyLeftButtonView()
    UnionData.unionRank = {}
end

function PnlLeagueRank:onBtnClose()
    self:close()
end

function PnlLeagueRank:onBtnRankReward()
    gg.uiManager:openWindow("PnlLeagueRankReward", nil, function()
        self:close()
    end)
    -- gg.time.strTime2utcTime("2022/7/20 10:11:00")
end

function PnlLeagueRank:onBtnCoreReward()
    gg.uiManager:openWindow("PnlLeagueRankCoreReward")
end

function PnlLeagueRank:onBtnRank(index)
    self:setLeftButton(index)
    local chainId = self:getChainID(index)
    if UnionData.unionRank[chainId] then
        self:refresh(chainId)
    else
        self:sendStarmapMatchRank(index)
    end
end

-------------------------------------------------------------------------------------------------

LeagueRankItem = LeagueRankItem or class("LeagueRankItem", ggclass.UIBaseItem)

function LeagueRankItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function LeagueRankItem:onInit()
    self.imgBg = self:Find("ImgBg", "Image")
    self.txtRank = self:Find("TxtRank", "Text")
    self.txtDao = self:Find("TxtDao", "Text")

    self.imgMe = self:Find("ImgMe", "Image")
    self.imgRank = self:Find("ImgRank", "Image")
    self.imgFlag = self:Find("TxtDao/ImgFlag", "Image")
    self.txtMember = self:Find("TxtMember", "Text")
    self.txtScore = self:Find("TxtScore", "Text")

    self.reward = self:Find("Reward")
    self.notReward = self:Find("NotReward")
    self.mit = self:Find("Reward/Mit")
    self.hy = self:Find("Reward/Hy")

    self.reward2 = self:Find("Reward2").transform

    self.mit2 = self.reward2:Find("Mit")
    self.hy2 = self.reward2:Find("Hy")

    self.txtMit2 = self.mit2:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtHy2 = self.hy2:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.notReward2 = self:Find("NotReward2")
end

function LeagueRankItem:setData(data, isSelf, chainId, chainCfgId)
    if not data then
        self:setActive(false)
        return
    end
    -- print("aaaa", table.dump(data))
    local rank = data.index
    self:setActive(true)
    self.imgMe.transform:SetActiveEx(isSelf)
    self.txtRank.text = rank
    if rank <= 3 and rank > 0 then
        self.txtRank.transform:SetActiveEx(false)
        self.imgBg.transform:SetActiveEx(true)
        gg.setSpriteAsync(self.imgBg, string.format("Rank_Atlas[baseboard_icon_%s]", rank))
        self.imgRank.transform:SetActiveEx(true)
        gg.setSpriteAsync(self.imgRank, string.format("Rank_Atlas[Rank_Icon_%s]", rank))
    else
        self.txtRank.transform:SetActiveEx(true)
        self.imgBg.transform:SetActiveEx(false)
        self.imgRank.transform:SetActiveEx(false)
    end

    self.txtDao.text = data.unionName

    self.txtMember.text = data.memberCount
    self.txtScore.text = data.score

    local flagCfg = cfg.flag[data.unionFlag]
    if not flagCfg then
        flagCfg = cfg.flag[1]
    end
    gg.setSpriteAsync(self.imgFlag, string.format("ContryFlag_Atlas[%s]", flagCfg.icon))

    local reward = {
        gvgPercentage = data.ratio,
        mit = data.mit / 1000,
        hyt = data.hyt / 1000,
    }
    local shareRatio = UnionData.unionRank[chainId].shareRatio / 100


    if IsAuditVersion() then
        reward = nil
    end

    self.reward2:SetActiveEx(false)
    self.mit2:SetActiveEx(false)
    self.hy2:SetActiveEx(false)
    self.notReward2:SetActiveEx(false)

    if reward then
        self.reward:SetActiveEx(true)
        self.notReward:SetActiveEx(false)
        self.mit:SetActiveEx(false)
        self.hy:SetActiveEx(true)

        -- local mitReward = "mit_" .. chainCfgId
        -- local hyReward = "hy_" .. chainCfgId
        -- if reward[mitReward] > 0 then
        --     self.mit:SetActiveEx(true)
        --     self.mit.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.scientificNotationInt(
        --         reward[mitReward] / 1000)
        -- else
        --     self.mit:SetActiveEx(false)
        -- end
        -- if reward[hyReward] > 0 then
        --     self.hy:SetActiveEx(true)
        --     self.hy.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.scientificNotationInt(
        --         reward[hyReward] / 1000)
        -- else
        --     self.hy:SetActiveEx(false)
        -- end
        local gvgPercentage = reward.gvgPercentage / 10000
        self.hy.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.scientificNotationInt(
            UnionData.jackpot * gvgPercentage * shareRatio + reward.hyt)
        self.hy.transform:Find("Text/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("(%.0f%%)",
            gvgPercentage * 100)

        if reward.mit and reward.mit > 0 then
            self.reward2:SetActiveEx(true)
            self.mit2:SetActiveEx(true)
            self.txtMit2.text = Utils.scientificNotation(reward.mit, true)
        else
            self.notReward2:SetActiveEx(true)
        end

    else
        self.reward:SetActiveEx(false)
        self.notReward:SetActiveEx(true)

        self.notReward2:SetActiveEx(true)
    end
end
-------------------------------------------------------------------------------------------------

return PnlLeagueRank
