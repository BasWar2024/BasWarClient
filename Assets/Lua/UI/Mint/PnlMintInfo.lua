

PnlMintInfo = class("PnlMintInfo", ggclass.UIBase)

function PnlMintInfo:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onMintChange", "onStarScoreChange"}
end

function PnlMintInfo:onAwake()
    self.view = ggclass.PnlMintInfoView.new(self.pnlTransform)

    self.itemList = {}
    self.scrollView = UIScrollView.new(self.view.scrollView, "MintingItem", self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
    self.fullViewOptionBtnBox = ViewOptionBtnBox.new(self.view.fullViewOptionBtnBox)
end

function PnlMintInfo:onShow()
    self:bindEvent()

    MintData.C2S_Player_GetMints()

    self.fullViewOptionBtnBox:setBtnDataList({
        [1] = 
        {
            nemeKey = "guild_Mint_Left_Mint",
            -- callback = function ()
            --     MintData.S2C_Player_MintsUpdate({
            --         op_type = 2,
            --         list = {
            --             [1] = {
            --                 nftId1 = MintData.mintList[2].nftId1

            --             }

            --         }
            --     })
            -- end
        },
    }, 1)

    

    self.view.txtDaoScore.text = string.format("<color=#43ABE8>%s</color>:[%s/%s]", Utils.getText("guild_Mint_DaoScors"), 0, cfg.global.NFTMintUnlockLeaguePoint.intValue)
    self.scrollView:setItemCount(0)
    UnionData.C2S_Player_GetStarmapScore()
end

function PnlMintInfo:onMintChange()
    self.dataList = {}

    for key, value in pairs(MintData.mintList) do
        table.insert(self.dataList, value)
    end
    self.scrollView:setItemCount(#self.dataList)
end

function PnlMintInfo:onStarScoreChange()
    self.view.txtDaoScore.text = string.format("<color=#ffae00>%s</color>:[%s/%s]", Utils.getText("guild_Mint_DaoScors"), UnionData.starScore, cfg.global.NFTMintUnlockLeaguePoint.intValue)
end

function PnlMintInfo:onRenderItem(obj, index)
    local item = MintingItem:getItem(obj, self.itemList, self)
    item:setData(self.dataList[index])
end

function PnlMintInfo:onHide()
    self:releaseEvent()

end

function PnlMintInfo:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnMint):SetOnClick(function()
        self:onBtnMint()
    end)

    self:setOnClick(view.btnDesc, gg.bind(self.onBtnDesc, self))
end

function PnlMintInfo:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnMint)

end

function PnlMintInfo:onDestroy()
    local view = self.view
    self.scrollView:release()
end

function PnlMintInfo:onBtnClose()
    self:close()
end

function PnlMintInfo:onBtnMint()
    if UnionData.starScore and UnionData.starScore >= cfg.global.NFTMintUnlockLeaguePoint.intValue then
        gg.uiManager:openWindow("PnlMint")
    else
        gg.uiManager:showTip("not enought league point")
    end

    -- gg.uiManager:openWindow("PnlMint")
end

function PnlMintInfo:onBtnDesc()
    gg.uiManager:openWindow("PnlDesc", {title = Utils.getText("guild_InstructionTitle"), desc = Utils.getText("guild_InstructionTxt")})

end

------------------------------------------

MintingItem = MintingItem or class("MintingItem", ggclass.UIBaseItem)

function MintingItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function MintingItem:onInit()
    self.imgItem = self.transform:GetComponent(UNITYENGINE_UI_IMAGE)

    self.mintNftItem1 = MintNftItem.new(self:Find("MintNftItem1"))
    self.mintNftItem2 = MintNftItem.new(self:Find("MintNftItem2"))

    self.imgWarshipBox = self:Find("ImgWarshipBox", UNITYENGINE_UI_IMAGE)
    self.imgTowerBox = self:Find("ImgTowerBox", UNITYENGINE_UI_IMAGE)
    self.imgHeroBox = self:Find("ImgHeroBox", UNITYENGINE_UI_IMAGE)

    self.layoutStar = self:Find("LayoutStar").transform

    self.stars = {}
    for i = 1, 3, 1 do
        self.stars[i] =  self.layoutStar:GetChild(i - 1)
    end

    self.imgPlus = self:Find("ImgPlus", UNITYENGINE_UI_IMAGE)
    self.txtId1 = self:Find("TxtId1", UNITYENGINE_UI_TEXT)
    self.txtId2 = self:Find("TxtId2", UNITYENGINE_UI_TEXT)

    self.slider = self:Find("Slider", UNITYENGINE_UI_SLIDER)
    self.txtSlider = self.slider.transform:Find("TxtSlider"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnReceive = self:Find("BtnReceive")
    self:setOnClick(self.btnReceive, gg.bind(self.onBtnReceive, self))
end

function MintingItem:setData(data)
    self.data = data

    self.txtId1.text = "NFT ID:#" .. data.nftId1
    self.txtId2.text = "NFT ID:#" .. data.nftId2

    self.imgWarshipBox.transform:SetActiveEx(false)
    self.imgTowerBox.transform:SetActiveEx(false)
    self.imgHeroBox.transform:SetActiveEx(false)

    self.nftMap = {
        [constant.CHAIN_NFT_KIND_HERO] = HeroData.heroDataMap,
        [constant.CHAIN_NFT_KIND_SPACESHIP] = WarShipData.warShipData,
        [constant.CHAIN_NFT_KIND_DEFENSIVE] = BuildData.buildData,
    }

    local nft1 = self.nftMap[data.nftType][data.nftId1]
    local nft2 = self.nftMap[data.nftType][data.nftId2]

    self.mintNftItem1:setQuality(nft1.quality)
    self.mintNftItem2:setQuality(nft2.quality)

    local cfg1
    local cfg2
    local imgIcon

    if data.nftType == constant.CHAIN_NFT_KIND_HERO then
        imgIcon = self.imgHeroBox

        cfg1 = HeroUtil.getHeroCfg(nft1.cfgId, nft1.level, nft1.quality)
        cfg2 = HeroUtil.getHeroCfg(nft2.cfgId, nft2.level, nft2.quality)
        self.mintNftItem1:setHeroIcon("Hero_A_Atlas", cfg1.icon)
        self.mintNftItem2:setHeroIcon("Hero_A_Atlas", cfg2.icon)

    elseif data.nftType == constant.CHAIN_NFT_KIND_SPACESHIP then
        imgIcon = self.imgWarshipBox

        cfg1 = WarshipUtil.getWarshipCfg(nft1.cfgId, nft1.quality, nft1.level)
        cfg2 = WarshipUtil.getWarshipCfg(nft2.cfgId, nft2.quality, nft2.level)
        self.mintNftItem1:setIconE(string.format("Warship_A_Atlas[%s_A]", cfg1.icon))
        self.mintNftItem2:setIconE(string.format("Warship_A_Atlas[%s_A]", cfg2.icon))
    elseif data.nftType == constant.CHAIN_NFT_KIND_DEFENSIVE then
        imgIcon = self.imgTowerBox

        cfg1 = BuildUtil.getCurBuildCfg(nft1.cfgId, nft1.level, nft1.quality)
        cfg2 = BuildUtil.getCurBuildCfg(nft2.cfgId, nft2.level, nft2.quality)

        self.mintNftItem1:setIconF(string.format("Build_B_Atlas[%s]", cfg1.icon .. "_B"))
        self.mintNftItem2:setIconF(string.format("Build_B_Atlas[%s]", cfg2.icon .. "_B"))
    end

    gg.timer:stopTimer(self.timer)
    if data.status == 0 then
        gg.setSpriteAsync(self.imgItem, "MintIcon_Atlas[bule background_icon]")

        self.slider.transform:SetActiveEx(true)
        self.btnReceive:SetActiveEx(false)

        local needTime = cfg.global.NFTMintNeedTime.intValue
        local lessTickEnd = data.startTime + needTime
        self.timer = gg.timer:startLoopTimer(0, 0.3, -1, function ()
            local time = lessTickEnd - Utils.getServerSec()
            local hms = gg.time.dhms_time({day=false,hour=1,min=1,sec=1}, time)
            self.txtSlider.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)
            self.slider.value = time / needTime
        end)
    elseif data.status == 1 then
        gg.setSpriteAsync(self.imgItem, "MintIcon_Atlas[yellowback_icon]")
        self.slider.transform:SetActiveEx(false)
        self.btnReceive:SetActiveEx(true)
    end

    local subCfg = cfg1
    local mintNft = nft1

    if nft1.mintCount > nft2.mintCount then
        subCfg = cfg2
        mintNft = nft2
    end

    local costCfg = MintUtil.getMintCostCfgMap()[subCfg.mintCfgId][mintNft.mintCount]
    local item = cfg.item[costCfg.itemCfgId]
    gg.setSpriteAsync(imgIcon, string.format("Item_Atlas[%s]", item.icon))
    
    for i = 1, 3 do
        self.stars[i]:SetActiveEx(mintNft.quality - 2 >= i)
    end
end

function MintingItem:onBtnReceive()
    for index, value in ipairs(MintData.mintList) do
        if value.nftId1 == self.data.nftId1 then
            MintData.C2S_Player_ReceiveMintItem(index)
            break
        end
    end
end

function MintingItem:onRelease()
    self.mintNftItem1:release()
    self.mintNftItem2:release()
    gg.timer:stopTimer(self.timer)
end

return PnlMintInfo