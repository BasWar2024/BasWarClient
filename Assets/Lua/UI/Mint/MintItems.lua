MintNftItem = MintNftItem or class("MintNftItem", ggclass.UIBaseItem)

function MintNftItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function MintNftItem:onInit()
    self.bg = self:Find("Bg", UNITYENGINE_UI_IMAGE)
    self.imgIconE = self:Find("Mask/ImgIconE", UNITYENGINE_UI_IMAGE)
    self.imgIconF = self:Find("Mask/ImgIconF", UNITYENGINE_UI_IMAGE)

    self.heroIcon = self:Find("Mask/HeroIcon")
    self.imgHeroIcon = self:Find("Mask/HeroIcon/ImgHeroIcon", UNITYENGINE_UI_IMAGE)
end

function MintNftItem:setQuality(quality)
    -- if quality == 0 then
    --     gg.setSpriteAsync(self.bg, string.format("Item_Bg_Atlas[Item_Bg_%s]", 0))
    --     return
    -- end
    quality = quality or 0
    gg.setSpriteAsync(self.bg, string.format("Item_Bg_Atlas[Item_Bg_%s]", quality))
end

function MintNftItem:setHeroIcon(atlas, icon)
    self.imgIconF.transform:SetActiveEx(false)
    self.imgIconE.transform:SetActiveEx(false)

    if icon then
        self.heroIcon.gameObject:SetActiveEx(true)
        gg.setSpriteAsync(self.imgHeroIcon, string.format("%s[%s_A]", atlas, icon))
    else
        self.heroIcon.gameObject:SetActiveEx(false)
    end
end

function MintNftItem:setIconE(icon)
    self.imgIconF.transform:SetActiveEx(false)
    self.heroIcon.transform:SetActiveEx(false)

    if not icon then
        self.imgIconE.transform:SetActiveEx(false)
        return
    end
    self.imgIconE.transform:SetActiveEx(true)
    gg.setSpriteAsync(self.imgIconE, icon)
end

function MintNftItem:setIconF(icon)
    self.heroIcon.transform:SetActiveEx(false)
    self.imgIconE.transform:SetActiveEx(false)

    if not icon then
        self.imgIconF.transform:SetActiveEx(false)
        return
    end
    self.imgIconF.transform:SetActiveEx(true)
    gg.setSpriteAsync(self.imgIconF, icon)
end

----------------------------------------------------------------------------
MintInfoItem = MintInfoItem or class("MintInfoItem", ggclass.UIBaseItem)

function MintInfoItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function MintInfoItem:onInit()
    self.bg = self:Find("Bg", UNITYENGINE_UI_IMAGE)

    self.mintNftItem = MintNftItem.new(self:Find("MintNftItem"))
    self:setOnClick(self.mintNftItem.gameObject, gg.bind(self.onClickNftItem, self))

    self.txtId = self:Find("TxtId", UNITYENGINE_UI_TEXT)
    self.txtTime = self:Find("TxtTime", UNITYENGINE_UI_TEXT)
end

function MintInfoItem:onRelease()
    self.mintNftItem:release()
end

function MintInfoItem:onClickNftItem()
    local selectCallback = function (data)
        self:setData(data)
    end
    local nftType = nil
    local otherNfg = nil

    local otherData = nil

    local data1 = self.initData.MintInfoItem1.data
    local data2 = self.initData.MintInfoItem2.data

    if self.index == 1 then
        otherData = data2
    else
        otherData = data1
    end
    if otherData then
        nftType = otherData.nftType
        otherNfg = otherData.nft
    end

    local seletingNft = {}
    if data1 then
        seletingNft[data1.nft.id] = true
    end
    if data2 then
        seletingNft[data2.nft.id] = true
    end

    local args = {
        selectCallback = selectCallback,
        nftType = nftType,
        seletingNft = seletingNft,
        otherNfg = otherNfg,
    }

    if self.data and self.data.nft then
        args.thisGridNftId = self.data.nft.id
    end

    gg.uiManager:openWindow("PnlMintNFTList", args)
end

MintInfoItem.QUALITY_2_COLOR = {
    [1] = {
        bg = "MintIcon_Atlas[Mint_Info_Bg_3]",
        text1 = UnityEngine.Color(0x3a/0xff, 0xc0/0xff, 0xff/0xff, 1),
        text2 = UnityEngine.Color(0xfb/0xff, 0xf3/0xff, 0xff/0xff, 0.5),
    },
    [2] = {
        bg = "MintIcon_Atlas[Mint_Info_Bg_3]",
        text1 = UnityEngine.Color(0x3a/0xff, 0xc0/0xff, 0xff/0xff, 1),
        text2 = UnityEngine.Color(0xfb/0xff, 0xf3/0xff, 0xff/0xff, 0.5),
    },
    [3] = {
        bg = "MintIcon_Atlas[Mint_Info_Bg_4]",
        text1 = UnityEngine.Color(0x3a/0xff, 0xc0/0xff, 0xff/0xff, 1),
        text2 = UnityEngine.Color(0xfb/0xff, 0xf3/0xff, 0xff/0xff, 0.5),
    },

    [4] = {
        bg = "MintIcon_Atlas[Mint_Info_Bg_4]",
        text1 = UnityEngine.Color(0xd2/0xff, 0xb2/0xff, 0xff/0xff, 1),
        text2 = UnityEngine.Color(0xf8/0xff, 0xf3/0xff, 0xff/0xff, 0.5),
    },

    [5] = {
        bg = "MintIcon_Atlas[Mint_Info_Bg_5]",
        text1 = UnityEngine.Color(0xff/0xff, 0x8b/0xff, 0x90/0xff, 1),
        text2 = UnityEngine.Color(0xfe/0xff, 0x4a/0xff, 0x1c/0xff, 0.5),
    },
}

function MintInfoItem:setQuality(quality)
    local setQuality = quality
    if quality == 0 then
        setQuality = 1
    end

    self.mintNftItem:setQuality(quality)
    gg.setSpriteAsync(self.bg, MintInfoItem.QUALITY_2_COLOR[setQuality].bg)
    self.txtId.color = MintInfoItem.QUALITY_2_COLOR[setQuality].text1
    self.txtTime.transform:GetComponent("Outline").effectColor = MintInfoItem.QUALITY_2_COLOR[setQuality].text2
end

function MintInfoItem:setIndex(index)
    self.index = index
end

function MintInfoItem:setData(data)
    self.data = data
    if not data then
        self:setQuality(0)
        self.mintNftItem:setHeroIcon()
        -- self.mintNftItem:setQuality(0)
        self.txtId.transform:SetActiveEx(false)
        self.txtTime.transform:SetActiveEx(false)
        self.initData:refreshInfo()
        return
    end

    self.txtId.transform:SetActiveEx(true)
    self.txtTime.transform:SetActiveEx(true)

    self.txtId.text = "NFT ID:#" .. data.nft.id
    self.txtTime.text = Utils.getText("guild_Mint_MintTimes") .. data.nft.mintCount .. "/" .. cfg.global.NFTMintMaxTime.intValue
    self:setQuality(data.nft.quality)

    if data.nftType == constant.CHAIN_NFT_KIND_HERO then
        local hero = data.nft
        local heroCfg = HeroUtil.getHeroCfg(hero.cfgId, hero.level, hero.quality)
        self.mintNftItem:setHeroIcon("Hero_A_Atlas", heroCfg.icon)

    elseif data.nftType == constant.CHAIN_NFT_KIND_SPACESHIP then
        local warship = data.nft
        local warshipCfg = WarshipUtil.getWarshipCfg(warship.cfgId, warship.quality, warship.level)
        self.mintNftItem:setIconE(string.format("Warship_A_Atlas[%s_A]", warshipCfg.icon))
        -- Atlas_icon_K
        
    elseif data.nftType == constant.CHAIN_NFT_KIND_DEFENSIVE then
        local build = data.nft
        local buildCfg = BuildUtil.getCurBuildCfg(build.cfgId, build.level, build.quality)
        self.mintNftItem:setIconF(string.format("Build_B_Atlas[%s]", buildCfg.icon .. "_B"))
    end

    self.initData:refreshInfo()
end
