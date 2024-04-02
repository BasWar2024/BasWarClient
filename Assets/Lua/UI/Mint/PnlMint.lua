

PnlMint = class("PnlMint", ggclass.UIBase)

function PnlMint:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }

end

function PnlMint:onAwake()
    self.view = ggclass.PnlMintView.new(self.pnlTransform)

    self.MintInfoItem1 = MintInfoItem.new(self.view.transform:Find("Root/LayoutContent/MintInfoItem1"), self)
    self.MintInfoItem2 = MintInfoItem.new(self.view.transform:Find("Root/LayoutContent/MintInfoItem2"), self)
end

function PnlMint:onShow()
    self:bindEvent()

    self.MintInfoItem1:setData(nil)
    self.MintInfoItem1:setIndex(1)
    self.MintInfoItem2:setData(nil)
    self.MintInfoItem2:setIndex(2)
    self.view.bgDesc:SetActiveEx(false)

    self:refreshInfo()
end

PnlMint.QUALITY_2_STAR = {
    [1] = 1,
    [2] = 1,
    [3] = 2,
    [4] = 2,
    [5] = 3,
}

function PnlMint:refreshInfo()
    local view = self.view

    local data1 = self.MintInfoItem1.data
    local data2 = self.MintInfoItem2.data

    if not data1 or not data2 then
        view.txtDesc.transform:SetActiveEx(false)
        view.btnMint:SetActiveEx(false)
        view.layoutReward:SetActiveEx(false)
        return
    end
    view.txtDesc.transform:SetActiveEx(true)
    view.btnMint:SetActiveEx(true)
    view.layoutReward:SetActiveEx(true)

    view.imgWarshipBox:SetActiveEx(false)
    view.imgTowerBox:SetActiveEx(false)
    view.imgHeroBox:SetActiveEx(false)

    local data = data1

    if data1.nft.mintCount < data2.nft.mintCount then
        data = data2
    end

    local subCfg
    local image = nil

    if data.nftType == constant.CHAIN_NFT_KIND_HERO then
        local hero = data.nft
        subCfg = HeroUtil.getHeroCfg(hero.cfgId, hero.level, hero.quality)
        view.txtDesc.text = "Hero Bind Box"

        image =  view.imgHeroBox
        -- view.imgHeroBox:SetActiveEx(true)

    elseif data.nftType == constant.CHAIN_NFT_KIND_SPACESHIP then
        local warship = data.nft
        subCfg = WarshipUtil.getWarshipCfg(warship.cfgId, warship.quality, warship.level)
        view.txtDesc.text = "Warship Bind Box"

        image =  view.imgWarshipBox
        -- view.imgWarshipBox:SetActiveEx(true)

    elseif data.nftType == constant.CHAIN_NFT_KIND_DEFENSIVE then
        local build = data.nft
        subCfg = BuildUtil.getCurBuildCfg(build.cfgId, build.level, build.quality)
        view.txtDesc.text = "Tower Bind Box"

        image =  view.imgTowerBox
        -- view.imgTowerBox:SetActiveEx(true)
    end

    local costCfg = MintUtil.getMintCostCfgMap()[subCfg.mintCfgId][data.nft.mintCount]
    local item = cfg.item[costCfg.itemCfgId]

    view.txtDesc.text = Utils.getText(item.languageNameID)
    
    local starCount = PnlMint.QUALITY_2_STAR[data.nft.quality]
    for i = 1, 3, 1 do
        self.view.stars[i]:SetActiveEx(i <= starCount)
    end
    gg.setSpriteAsync(image, string.format("Item_Atlas[%s]", item.icon))

    view.txtCost1.transform:SetActiveEx(false)
    view.txtCost2.transform:SetActiveEx(false)

    if costCfg.mitCost > 0 then
        view.txtCost1.transform:SetActiveEx(true)
        view.txtCost1.text = Utils.getShowRes(costCfg.mitCost)
        view.txtCost1.transform:SetRectSizeX(view.txtCost1.preferredWidth)
    end

    if costCfg.tesseractCost > 0 then
        view.txtCost2.transform:SetActiveEx(true)
        view.txtCost2.text = Utils.getShowRes(costCfg.tesseractCost)
        view.txtCost2.transform:SetRectSizeX(view.txtCost2.preferredWidth)
    end

    local hms = gg.time.dhms_time({day=false,hour=1,min=1,sec=1}, cfg.global.NFTMintNeedTime.intValue)
    view.txtTime.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)

    for index, value in ipairs(view.txtProbabilityList) do
        value.text = costCfg.countWeight[index][2] / 10 .. "%"
    end
end

function PnlMint:onHide()
    self:releaseEvent()

end

function PnlMint:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnDesc):SetOnClick(function()
        self:onBtnDesc()
    end)
    CS.UIEventHandler.Get(view.btnMint):SetOnClick(function()
        self:onBtnMint()
    end)
end

function PnlMint:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnDesc)
    CS.UIEventHandler.Clear(view.btnMint)

end

function PnlMint:onDestroy()
    local view = self.view
    self.MintInfoItem1:release()
    self.MintInfoItem2:release()
end

function PnlMint:onBtnClose()
    self:close()
end

function PnlMint:onBtnDesc()
    self.view.bgDesc:SetActiveEx(not self.view.bgDesc.gameObject.activeSelf)
end

function PnlMint:onBtnMint()
    if self.MintInfoItem1.data and self.MintInfoItem2.data then
        MintData.C2S_Player_AddMint(self.MintInfoItem1.data.nft.id, self.MintInfoItem2.data.nft.id, self.MintInfoItem1.data.nftType)
        self:close()
    end
end

return PnlMint