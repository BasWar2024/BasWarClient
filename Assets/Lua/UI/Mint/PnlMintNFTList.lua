

PnlMintNFTList = class("PnlMintNFTList", ggclass.UIBase)

function PnlMintNFTList:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
end

-- self.args = {selectCallback, nftType, seletingNft, otherNfg, thisGridNftId}
function PnlMintNFTList:onAwake()
    self.view = ggclass.PnlMintNFTListView.new(self.pnlTransform)

    self.itemList = {}
    self.scrollView = UIScrollView.new(self.view.scrollView, "MintNftListItems", self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))

    self.commonfilterBox = CommonfilterBox.new(self.view.commonfilterBox)
    self.commonfilterBox:setFilterCB(gg.bind(self.onFilter, self))
end

function PnlMintNFTList:select(data)
    self.args.selectCallback(data)
    self:close()
end

function PnlMintNFTList:onShow()
    self:bindEvent()
    if self.args.nftType then
        self.commonfilterBox:setData({CommonfilterBox.RaceData})
    else
        self.commonfilterBox:setData({CommonfilterBox.RaceData, PnlMintNFTList.QualityData, CommonfilterBox.NFTData})
    end
end

PnlMintNFTList.QualityData = {
    filterType = "FilterQuality",
    info = {
        {
            nameKey = "bag_All",
            filterAttr = nil,
        },
        {
            name = "L",
            filterAttr = {quality = 5,},
        },
        {
            name = "SSR",
            filterAttr = {quality = 4,},
        },
        {
            name = "SR",
            filterAttr = {quality = 3,},
        },
        {
            name = "R",
            filterAttr = {quality = 2,},
        },
        {
            name = "N",
            filterAttr = {quality = 1,},
        },
    }
}

function PnlMintNFTList:onFilter(filterMap)
    local nftMap = {
        [constant.CHAIN_NFT_KIND_SPACESHIP] = WarShipData.warShipData,
        [constant.CHAIN_NFT_KIND_HERO] = HeroData.heroDataMap,
        [constant.CHAIN_NFT_KIND_DEFENSIVE] = BuildData.buildData,
    }

    self.dataList = {}
    local thisGridNft = nil

    for nftType, value in pairs(nftMap) do

        local isNotFilterNft = true
        local nftfilterData = filterMap[CommonfilterBox.FilterTypeNft]
        if nftfilterData then
            isNotFilterNft = nftfilterData.filterNft[nftType]
        end

        if isNotFilterNft then
            if self.args.nftType == nil or nftType == self.args.nftType then
                for _, nft in pairs(value) do

                    if nft.id == self.args.thisGridNftId then
                        thisGridNft = {nftType = nftType, nft = nft}
                    end

                    if nft.chain > 0 and nft.chain ~= 63023 and nft.ref == 0 and (not self.args.otherNfg or self.args.otherNfg.quality == nft.quality) then
                        local nftCfg
                        if nftType == constant.CHAIN_NFT_KIND_SPACESHIP then
                            nftCfg = WarshipUtil.getWarshipCfg(nft.cfgId, nft.quality, nft.level)
                        elseif nftType == constant.CHAIN_NFT_KIND_HERO then
                            nftCfg = HeroUtil.getHeroCfg(nft.cfgId, nft.level, nft.quality)
                        elseif nftType == constant.CHAIN_NFT_KIND_DEFENSIVE then
                            nftCfg = BuildUtil.getBuildCfgMap()[nft.cfgId][nft.quality][nft.level]
                        end
    
                        local isFilter = false
                        for _, filterData in pairs(filterMap) do
                            if filterData.filterAttr then
                                for attrKey, attr in pairs(filterData.filterAttr) do
                                    if nftCfg[attrKey] ~= attr then
                                        isFilter = true
                                        break
                                    end
                                end
                            end
                        end
        
                        if not isFilter then
                            -- table.insert(self.dataList, {nftType = nftType, nft = nft})
                            local isUsed = self.args.seletingNft[nft.id]
                            for _, mintData in pairs(MintData.mintList) do
                                if mintData.nftId1 == nft.id or mintData.nftId2 == nft.id then
                                    isUsed = true
                                end
                            end
                            if not isUsed then
                                table.insert(self.dataList, {nftType = nftType, nft = nft})
                            end
                        end
                    end
                end
            end
        end
    end

    table.sort(self.dataList, function (a, b)

        if a.nft.quality ~= b.nft.quality then
            return a.nft.quality > b.nft.quality
        end

        return a.nftType < b.nftType
    end)

    if thisGridNft then
        table.insert(self.dataList, 1, thisGridNft)
    end

    local itemCount = math.ceil(#self.dataList / 5)
    self.scrollView:setItemCount(itemCount)

    local number = 0
    local nFTMintMaxTime = cfg.global.NFTMintMaxTime.intValue

    for key, value in pairs(self.dataList) do
        if value.nft.mintCount < nFTMintMaxTime then
            number = number + 1
        end
    end
    self.view.txtNumber.text = string.format("<color=#ffae00>%s</color>[<color=#ffae00>%s</color>/%s]", "Numbers:", number, #self.dataList)
end

function PnlMintNFTList:onRenderItem(obj, index)
    for i = 1, 5, 1 do
        local idx = (index - 1) * 5 + i
        local item = MintNftListItem:getItem(obj.transform:GetChild(i - 1), self.itemList, self)
        item:setData(self.dataList[idx])
    end
end

function PnlMintNFTList:onHide()
    self:releaseEvent()

end

function PnlMintNFTList:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlMintNFTList:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlMintNFTList:onDestroy()
    local view = self.view
    self.scrollView:release()
    self.commonfilterBox:release()
end

function PnlMintNFTList:onBtnClose()
    self:close()
end

----------------------------------------------------------

MintNftListItem = MintNftListItem or class("MintNftListItem", ggclass.UIBaseItem)

function MintNftListItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function MintNftListItem:onInit()
    self.layoutItem = self:Find("LayoutItem").transform
    self.mintNftItem = MintNftItem.new(self:Find("LayoutItem/MintNftItem"))
    self.slider = self:Find("LayoutItem/Slider", UNITYENGINE_UI_SLIDER)
    self.txtSlider = self.slider.transform:Find("TxtSlider"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgFull = self:Find("LayoutItem/ImgFull", UNITYENGINE_UI_IMAGE)

    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))

    self.layoutRemove = self:Find("LayoutRemove")
    self:setOnClick(self.layoutRemove, gg.bind(self.onClickRemove, self))
end

function MintNftListItem:onRelease()
    self.mintNftItem:release()
end

function MintNftListItem:setData(data)
    self.data = data
    if not  self.data then
        self:setActive(false)
        return
    end
    self:setActive(true)

    self.isSelect = self.initData.args.seletingNft[self.data.nft.id]
    if self.isSelect then
        self.layoutRemove:SetActiveEx(true)
        self.layoutItem:SetActiveEx(false)
        -- self.mintNftItem.transform.localScale = Vector3(1.05, 1.05, 1.05)
    else
        self.layoutRemove:SetActiveEx(false)
        self.layoutItem:SetActiveEx(true)
        -- self.mintNftItem.transform.localScale = Vector3(1, 1, 1)
    end

    self.slider.value = data.nft.mintCount / cfg.global.NFTMintMaxTime.intValue
    self.txtSlider.text = data.nft.mintCount .. "/" .. cfg.global.NFTMintMaxTime.intValue

    self.imgFull.transform:SetActiveEx(data.nft.mintCount >= cfg.global.NFTMintMaxTime.intValue)

    self.mintNftItem:setQuality(data.nft.quality)

    if data.nftType == constant.CHAIN_NFT_KIND_HERO then
        local hero = data.nft
        local heroCfg = HeroUtil.getHeroCfg(hero.cfgId, hero.level, hero.quality)
        self.mintNftItem:setHeroIcon("Hero_A_Atlas", heroCfg.icon)

    elseif data.nftType == constant.CHAIN_NFT_KIND_SPACESHIP then
        local warship = data.nft
        local warshipCfg = WarshipUtil.getWarshipCfg(warship.cfgId, warship.quality, warship.level)
        self.mintNftItem:setIconE(string.format("Warship_A_Atlas[%s_A]", warshipCfg.icon))

    elseif data.nftType == constant.CHAIN_NFT_KIND_DEFENSIVE then
        local build = data.nft
        local buildCfg = BuildUtil.getCurBuildCfg(build.cfgId, build.level, build.quality)
        self.mintNftItem:setIconF(string.format("Build_B_Atlas[%s]", buildCfg.icon .. "_B"))
    end
end

function MintNftListItem:onClickItem()
    if self.isSelect then
        return
    end

    if self.data.nft.mintCount < cfg.global.NFTMintMaxTime.intValue then
        self.initData:select(self.data)
    end
end

function MintNftListItem:onClickRemove()
    self.initData:select(nil)
end

return PnlMintNFTList