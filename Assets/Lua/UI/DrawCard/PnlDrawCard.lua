PnlDrawCard = class("PnlDrawCard", ggclass.UIBase)

function PnlDrawCard:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onShowViewResult", "onSetTopRes", "onUpData"}

    self.btnCloseIsBack = false
end

function PnlDrawCard:onAwake()
    self.view = ggclass.PnlDrawCardView.new(self.pnlTransform)

    self.drawCardResultBox = DrawCardResultBox.new(self.view.drawCardResultBox)

    local iconName = {"Icon_5100002_C", "Icon_5400002_C", "Icon_5300001_C", "Icon_5200001_C", "Icon_5200002_C",
                      "Icon_5400001_C"}

    for i = 1, 6, 1 do
        local path = "ViewDrawCard/ViewShowCard/BoxCardPoolCard" .. i .. "/Mask/Image"
        local img = self.view.transform:Find(path):GetComponent(UNITYENGINE_UI_IMAGE)
        gg.setSpriteAsync(img, iconName[i])
    end
end

function PnlDrawCard:onShow()
    self:bindEvent()
    self:onSetTopRes()
    self.cardPoolCfg = cfg["cardPool"]
    self:showViewDrawCard()
    self.view.layoutVideo:SetActiveEx(false)
end

function PnlDrawCard:onSetTopRes()
    self.view.txtStarCoin.text = Utils.scientificNotationInt(ResData.getStarCoin() / 1000)
    self.view.txtHy.text = Utils.scientificNotationInt(ResData.getTesseract() / 1000)
    local blueTicketNum = 0
    local yellowTicketNum = 0

    for k, v in pairs(ItemData.itemBagData) do
        if v.cfgId == constant.ITEM_CARDTICKET then
            blueTicketNum = blueTicketNum + v.num
        elseif v.cfgId == constant.ITEM_SUPERCARDTICKET then
            yellowTicketNum = yellowTicketNum + v.num
        end
    end
    self.view.txtBlueTicket.text = blueTicketNum
    self.view.txtYellowTicket.text = yellowTicketNum
end

function PnlDrawCard:onHide()
    self:releaseEvent()

    self:releaseBtnCardPool()
    self:releaseBoxCard()

    self.curCardPoolId = nil
end

function PnlDrawCard:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnAddHy):SetOnClick(function()
        self:onBtnAddHy()
    end)
    CS.UIEventHandler.Get(view.btnAddBlueTicket):SetOnClick(function()
        self:onBtnAddBlueTicket()
    end)
    CS.UIEventHandler.Get(view.btnAddYellowTicket):SetOnClick(function()
        self:onBtnAddYellowTicket()
    end)
    CS.UIEventHandler.Get(view.btn1Time):SetOnClick(function()
        self:onBtn1Time(1)
    end, "event:/UI_button_click", "se_UI", false)
    CS.UIEventHandler.Get(view.btn10Time):SetOnClick(function()
        self:onBtn1Time(10)
    end, "event:/UI_button_click", "se_UI", false)
    CS.UIEventHandler.Get(view.btn100Time):SetOnClick(function()
        self:onBtn1Time(100)
    end, "event:/UI_button_click", "se_UI", false)
    CS.UIEventHandler.Get(view.btnMissage):SetOnClick(function()
        self:onBtnMissage()
    end)
    CS.UIEventHandler.Get(view.btnAgain):SetOnClick(function()
        self:onBtnAgain()
    end, "event:/UI_button_click", "se_UI", false)
    CS.UIEventHandler.Get(view.btnSkip):SetOnClick(function()
        self:onBtnSkip()
    end, "event:/UI_button_click", "se_UI", false)

    self:setOnClick(self.view.btnMessage, gg.bind(self.onBtnMessage, self))
end

function PnlDrawCard:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnAddHy)
    CS.UIEventHandler.Clear(view.btnAddBlueTicket)
    CS.UIEventHandler.Clear(view.btnAddYellowTicket)
    CS.UIEventHandler.Clear(view.btn1Time)
    CS.UIEventHandler.Clear(view.btn10Time)
    CS.UIEventHandler.Clear(view.btn100Time)
    CS.UIEventHandler.Clear(view.btnMissage)
    CS.UIEventHandler.Clear(view.btnAgain)
    CS.UIEventHandler.Clear(view.btnSkip)
end

function PnlDrawCard:onDestroy()
    local view = self.view
    self.drawCardResultBox:release()
end

function PnlDrawCard:onBtnMessage()

    -- print("ttttttttttttttttttttttt")

    gg.uiManager:openWindow("PnlCardpoolMessage")
end

function PnlDrawCard:onBtnClose()
    if self.btnCloseIsBack then
        self.btnCloseIsBack = false
        self:showViewDrawCard()
    else
        self:close()
    end
end

function PnlDrawCard:onBtnAddHy()
    gg.uiManager:openWindow("PnlShop")
end

function PnlDrawCard:onBtnAddBlueTicket()

end

function PnlDrawCard:onBtnAddYellowTicket()

end

function PnlDrawCard:onBtn1Time(num)
    local maxCount = cfg.global.HQBagMax.intValue
    if Utils.getwarshipCount() > maxCount then
        gg.uiManager:showTip("warship count max")
        return
    end

    if Utils.getHeroCount() > maxCount then
        gg.uiManager:showTip("hero count max")
        return
    end

    if Utils.getNftBuildCount() > maxCount then
        gg.uiManager:showTip("nft tower count max")
        return
    end

    self.drawNum = num
    DrawCardData.C2S_Player_Draw_Card(self.curCardPoolId, num)
end

function PnlDrawCard:onBtnMissage()
    gg.uiManager:openWindow("PnlDrawCardInfo")
end

function PnlDrawCard:onBtnAgain()
    if self.drawNum then
        DrawCardData.C2S_Player_Draw_Card(self.curCardPoolId, self.drawNum)
    end
end

function PnlDrawCard:onBtnSkip()
    self:stopVideo()
end

function PnlDrawCard:onBtnCardPool(cfgId)
    self:setCardPool(cfgId)
end

function PnlDrawCard:showViewDrawCard()
    self.view.txtTitle.text = Utils.getText("pool_Title")
    self.view.bg1:SetActiveEx(true)
    self.view.bg2:SetActiveEx(false)
    self.view.viewDrawCard:SetActiveEx(true)
    self.view.viewResult:SetActiveEx(false)
    if not self.curCardPoolId then
        self:loadBtnCardPool()
    else
        self:setCardPool(self.curCardPoolId)
    end
end

function PnlDrawCard:loadBtnCardPool()
    self:releaseBtnCardPool()
    self.btnCardPoolList = {}
    self.cardPoolIconName = {}
    for k, v in ipairs(self.cardPoolCfg) do
        local isPassAuditVersion = not IsAuditVersion() or (v.cfgId == 1 or v.cfgId == 3)

        if v.available == 1 and isPassAuditVersion then
            ResMgr:LoadGameObjectAsync("BtnCardPool", function(go)
                go.transform:SetParent(self.view.boxLeftButton, false)
                local iconName = gg.getSpriteAtlasName("DrawCard_Atlas", v.icon)
                gg.setSpriteAsync(go.transform:GetComponent(UNITYENGINE_UI_IMAGE), iconName, function(image, sprite)
                    image.sprite = sprite
                    image:SetNativeSize()
                end)

                CS.UIEventHandler.Get(go):SetOnClick(function()
                    self:onBtnCardPool(v.cfgId)
                end)
                self.btnCardPoolList[v.cfgId] = go
                self.cardPoolIconName[v.cfgId] = v.icon
                if v.cfgId == 1 then
                    self:setCardPool(1)
                end
                return true
            end, true)
        end
    end
end

function PnlDrawCard:releaseBtnCardPool()
    if self.btnCardPoolList then
        for k, v in pairs(self.btnCardPoolList) do
            CS.UIEventHandler.Clear(v)
            ResMgr:ReleaseAsset(v)
        end
        self.btnCardPoolList = nil
    end
end

function PnlDrawCard:setCardPool(cfgId)
    self.curCardPoolId = cfgId
    for k, v in pairs(self.btnCardPoolList) do
        if k ~= cfgId then
            local iconName = gg.getSpriteAtlasName("DrawCard_Atlas", self.cardPoolIconName[k])
            gg.setSpriteAsync(v.transform:GetComponent(UNITYENGINE_UI_IMAGE), iconName, function(image, sprite)
                image.sprite = sprite
                image:SetNativeSize()
            end)
        end
    end
    local iconName = gg.getSpriteAtlasName("DrawCard_Atlas", self.cardPoolIconName[cfgId] .. "_B")
    gg.setSpriteAsync(self.btnCardPoolList[cfgId].transform:GetComponent(UNITYENGINE_UI_IMAGE), iconName,
        function(image, sprite)
            image.sprite = sprite
            image:SetNativeSize()
        end)

    local curPoorCfg = cfg.getCfg("cardPool", cfgId)
    if curPoorCfg.minimumCount > 0 then
        self.view.bgBlue:SetActiveEx(true)
        local num = curPoorCfg.minimumCount - DrawCardData.cardPoolData[cfgId].count
        self.view.txtLimit.text = "/" .. curPoorCfg.minimumCount
        self.view.txtNum.text = num
    else
        self.view.bgBlue:SetActiveEx(false)
    end

    -- self.view.txtTips.text = string.format(Utils.getText("pool_OpenText"), num)

    if curPoorCfg.costItem[1] then
        local curCfg = cfg.getCfg("item", curPoorCfg.costItem[1])
        local iconName = gg.getSpriteAtlasName("ResIcon_200_Atlas", curCfg.icon)
        gg.setSpriteAsync(self.view.btn1Time.transform:Find("BgBlack/Icon"):GetComponent(UNITYENGINE_UI_IMAGE), iconName)
        gg.setSpriteAsync(self.view.btn10Time.transform:Find("BgBlack/Icon"):GetComponent(UNITYENGINE_UI_IMAGE),
            iconName)
        gg.setSpriteAsync(self.view.btn100Time.transform:Find("BgBlack/Icon"):GetComponent(UNITYENGINE_UI_IMAGE),
            iconName)

        self.view.btn1Time.transform:Find("BgBlack/TxtCost"):GetComponent(UNITYENGINE_UI_TEXT).text =
            Utils.scientificNotation(curPoorCfg.costItem[2])
        self.view.btn10Time.transform:Find("BgBlack/TxtCost"):GetComponent(UNITYENGINE_UI_TEXT).text =
            Utils.scientificNotation(curPoorCfg.costItemInMuilt[2])
        -- self.view.btn100Time.transform:Find("BgBlack/TxtCost"):GetComponent(UNITYENGINE_UI_TEXT).text =
        --     Utils.scientificNotation(curPoorCfg.costItem[2] * 10)
    elseif curPoorCfg.costRes[1] then
        local iconName = constant.RES_2_CFG_KEY[curPoorCfg.costRes[1]].icon
        gg.setSpriteAsync(self.view.btn1Time.transform:Find("BgBlack/Icon"):GetComponent(UNITYENGINE_UI_IMAGE), iconName)
        gg.setSpriteAsync(self.view.btn10Time.transform:Find("BgBlack/Icon"):GetComponent(UNITYENGINE_UI_IMAGE),
            iconName)
        gg.setSpriteAsync(self.view.btn100Time.transform:Find("BgBlack/Icon"):GetComponent(UNITYENGINE_UI_IMAGE),
            iconName)
        local cost = curPoorCfg.costRes[2]
        local costResInMuilt = curPoorCfg.costResInMuilt[2] * 10
        local discount = DrawCardData.discount
        if curPoorCfg.costRes[1] == constant.RES_TESSERACT and discount < 1 then
            cost = cost * discount
            costResInMuilt = costResInMuilt * discount
            self.view.ImgOff.gameObject:SetActiveEx(true)
            -- self.view.btn1Time.transform:Find("Discount").gameObject:SetActiveEx(true)
            -- self.view.btn10Time.transform:Find("Discount").gameObject:SetActiveEx(true)
            -- self.view.btn1Time.transform:Find("Discount/Text1").gameObject:SetActiveEx(true)
            -- self.view.btn10Time.transform:Find("Discount/Text1").gameObject:SetActiveEx(true)

            -- self.view.btn1Time.transform:Find("Discount/TxtDisCount"):GetComponent(UNITYENGINE_UI_TEXT).text =
            --     string.format("%.0f%%", (1 - discount) * 100)
            -- self.view.btn10Time.transform:Find("Discount/TxtDisCount"):GetComponent(UNITYENGINE_UI_TEXT).text =
            --     string.format("%.0f%%", (1 - discount) * 100)
        else
            self.view.ImgOff.gameObject:SetActiveEx(false)

            -- self.view.btn1Time.transform:Find("Discount").gameObject:SetActiveEx(false)
            -- self.view.btn10Time.transform:Find("Discount").gameObject:SetActiveEx(true)
            -- self.view.btn10Time.transform:Find("Discount/TxtDisCount"):GetComponent(UNITYENGINE_UI_TEXT).text = "5%"

        end
        local curTime = Utils.getServerSec()
        local lastTime = DrawCardData.cardPoolData[cfgId].drawTime
        local free = 1
        local imgBtn1Time = self.view.btn1Time.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)
        if curPoorCfg.freeTime ~= 0 and curTime - lastTime >= curPoorCfg.freeTime then
            free = 0
            -- self.view.btn1Time.transform:Find("Discount").gameObject:SetActiveEx(true)
            -- self.view.btn1Time.transform:Find("Discount/Text1").gameObject:SetActiveEx(false)
            -- self.view.btn1Time.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)

            self.view.btn1Time.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = "FREE"
            gg.setSpriteAsync(imgBtn1Time, "Button_Atlas[btn_icon_C]")
        else
            self.view.btn1Time.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
                "pool_OneTimeBtn")
            gg.setSpriteAsync(imgBtn1Time, "Button_Atlas[btn_icon_B]")
        end

        self.view.btn1Time.transform:Find("BgBlack/TxtCost"):GetComponent(UNITYENGINE_UI_TEXT).text =
            Utils.scientificNotation(cost / 1000 * free)
        self.view.btn10Time.transform:Find("BgBlack/TxtCost"):GetComponent(UNITYENGINE_UI_TEXT).text =
            Utils.scientificNotation(costResInMuilt / 1000)
        self.view.btn100Time.transform:Find("BgBlack/TxtCost"):GetComponent(UNITYENGINE_UI_TEXT).text =
            Utils.scientificNotation(cost / 1000 * 100)

    end
end

function PnlDrawCard:onUpData()
    if not self.isPlaying and self.view.videoPlayer.isPlaying then
        self.isPlaying = true
    end
    if self.isPlaying and not self.view.videoPlayer.isPlaying then
        self:stopVideo()
    end
end

function PnlDrawCard:onShowViewResult(args, cardData)
    self.view.videoPlayer:Stop()
    self.view.layoutVideo:SetActiveEx(true)
    self.view.videoPlayer:Play()

    self.cardData = cardData
end

function PnlDrawCard:stopVideo()
    self.isPlaying = false
    self.view.videoPlayer:Stop()
    self.view.layoutVideo:SetActiveEx(false)
    if self.cardData then
        self:showViewResult(self.cardData)
    end
end

local animTime = 0.3
local animInterval = 0.2

function PnlDrawCard:showViewResult(cardData)
    self.view.txtTitle.text = Utils.getText("pool_Result_Title")
    self.btnCloseIsBack = true

    self.view.bg1:SetActiveEx(false)
    self.view.bg2:SetActiveEx(true)
    self.view.viewDrawCard:SetActiveEx(false)
    self.view.viewResult:SetActiveEx(true)

    -- local curPoorCfg = cfg.getCfg("cardPool", self.curCardPoolId)
    self.drawCardResultBox:setData(cardData, self.curCardPoolId, self.drawNum)

    -- if curPoorCfg.costItem[1] then
    --     local curCfg = cfg.getCfg("item", curPoorCfg.costItem[1])
    --     local iconName = gg.getSpriteAtlasName("ResIcon_200_Atlas", curCfg.icon)
    --     gg.setSpriteAsync(self.view.btnAgain.transform:Find("BgBlack/IconRes"):GetComponent(UNITYENGINE_UI_IMAGE),
    --         iconName)

    --     self.view.txtRes.text = curPoorCfg.costItem[2] * self.drawNum
    -- elseif curPoorCfg.costRes[1] then
    --     local iconName = constant.RES_2_CFG_KEY[curPoorCfg.costRes[1]].icon
    --     gg.setSpriteAsync(self.view.btnAgain.transform:Find("BgBlack/IconRes"):GetComponent(UNITYENGINE_UI_IMAGE),
    --         iconName)
    --     local discount = 1
    --     if curPoorCfg.costRes[1] == constant.RES_TESSERACT then
    --         discount = DrawCardData.discount
    --     end
    --     local cost = curPoorCfg.costRes[2] / 1000 * self.drawNum * discount
    --     self.view.txtRes.text = Utils.scientificNotation(cost)
    -- end

    -- self:releaseBoxCard()
    -- self.boxCardList = {}
    -- local index = 0
    -- for k, v in pairs(cardData) do
    --     index = index + 1
    --     ResMgr:LoadGameObjectAsync("BoxCard", function(go)
    --         go.transform:SetParent(self.view.content, false)

    --         local root = go.transform:Find("Root")
    --         local canvasGroup = root:GetComponent(typeof(UnityEngine.CanvasGroup))
    --         canvasGroup.alpha = 0
    --         root.anchoredPosition = UnityEngine.Vector2(0, -100)

    --         local sequence = CS.DG.Tweening.DOTween.Sequence()
    --         sequence:AppendInterval((go.transform:GetSiblingIndex()) * animInterval)
    --         sequence:Append(canvasGroup:DOFade(1, animTime))
    --         sequence:Join(root:DOAnchorPosY(0, animTime))

    --         local curCfg = cfg.getCfg("item", v)
    --         local quality = curCfg.quality

    --         -- if quality >= 4 then
    --         --     root:Find("BgLight").gameObject:SetActiveEx(true)
    --         --     local lightName = gg.getSpriteAtlasName("DrawCard_Atlas",
    --         --         string.format("backlight%s_icon", (quality - 3)))
    --         --     gg.setSpriteAsync(root:Find("BgLight"):GetComponent(UNITYENGINE_UI_IMAGE), lightName)
    --         -- else
    --         --     root:Find("BgLight").gameObject:SetActiveEx(false)
    --         -- end

    --         local bgName = gg.getSpriteAtlasName("Item_Bg_Atlas", string.format("longframe_icon_%s", quality))
    --         gg.setSpriteAsync(root:Find("IconBg"):GetComponent(UNITYENGINE_UI_IMAGE), bgName)

    --         -- local qualityName = gg.getSpriteAtlasName("DrawCard_Atlas", string.format("title%s_icon", quality))
    --         -- gg.setSpriteAsync(root:Find("IconBg/IconQuality"):GetComponent(UNITYENGINE_UI_IMAGE), qualityName)

    --         local type = curCfg.itemType
    --         local atlasName
    --         local suffix = "_N"
    --         if type == constant.ITEM_ITEMTYPE_SKILL_PIECES then
    --             atlasName = "Skill_A2_Atlas"
    --             suffix = "_A2"
    --             root:Find("IconBg/Mask/IconTop").gameObject:SetActiveEx(false)
    --             root:Find("IconBg/Mask/IconSkill"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(
    --                 165, 245)
    --         elseif type == constant.ITEM_ITEMTYPE_HERO then
    --             atlasName = "Hero_A_Atlas"
    --             suffix = "_A"
    --             root:Find("IconBg/Mask/IconTop").gameObject:SetActiveEx(true)
    --             root:Find("IconBg/Mask/IconSkill"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(
    --                 245, 245)
    --         end
    --         local skillName = gg.getSpriteAtlasName(atlasName, curCfg.icon .. suffix)
    --         gg.setSpriteAsync(root:Find("IconBg/Mask/IconSkill"):GetComponent(UNITYENGINE_UI_IMAGE), skillName)

    --         table.insert(self.boxCardList, go)

    --         return true
    --     end, true)
    -- end

    -- self.view.btnAgain:SetActiveEx(false)

    -- local delay = index * animInterval + 0.2
    -- gg.timer:startTimer(delay, function()
    --     self.view.btnAgain:SetActiveEx(true)
    -- end)

    -- if index <= 5 then
    --     self.view.scrollView.localPosition = Vector3(0, -170, 0)
    -- else
    --     self.view.scrollView.localPosition = Vector3(0, 17, 0)
    -- end

    -- self.cardData = nil
end

function PnlDrawCard:releaseBoxCard()
    if self.boxCardList then
        for k, v in pairs(self.boxCardList) do
            ResMgr:ReleaseAsset(v)
        end
        self.boxCardList = nil
    end
end

return PnlDrawCard
