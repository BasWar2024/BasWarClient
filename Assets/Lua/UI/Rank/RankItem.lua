RankItem = RankItem or class("RankItem", ggclass.UIBaseItem)

function RankItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function RankItem:onInit()
    self.imgRank = self:Find("ImgRank", "Image")
    self.tmpRank = self:Find("TmpRank", "TextMeshProUGUI")

    self.imgUp = self:Find("ImgUp", "Image")
    self.tmpUp = self:Find("ImgUp/TmpUp", "TextMeshProUGUI")

    self.imgSame = self:Find("ImgSame", "Image")
    self.iconHead = self:Find("IconHead", "Image")
    self.tmpName = self:Find("TmpName", "TextMeshProUGUI")
    self.imgScore = self:Find("ImgScore", "Image")
    self.tmpScore = self:Find("ImgScore/TmpScore", "TextMeshProUGUI")
    self.tmpMembers = self:Find("TmpMem/TmpMembers")
    self.imgReward = self:Find("ImgReward", "Image")
    self.tmpReward = self:Find("ImgReward/TmpReward", "TextMeshProUGUI")
end

function RankItem:setData(index)
    if index > 0 and index <= 3 then
        self.imgRank.gameObject:SetActiveEx(true)
        self.tmpRank.gameObject:SetActiveEx(false)
        ResMgr:LoadSpriteAsync("RankIcon" .. index, function(sprite)
            self.imgRank.sprite = sprite
        end)
    else
        self.imgRank.gameObject:SetActiveEx(false)
        self.tmpRank.gameObject:SetActiveEx(true)
        self.tmpRank.text = index
    end

    -- self.data = data
    -- if not data then
    --     self.txtItem.transform:SetActiveEx(true)
    --     self.txtItem.text = ""
    --     self.sliderLife.gameObject:SetActiveEx(false)
    --     return
    -- end

    -- local itemCfg = cfg.get("etc.cfg.item")[data.cfgId]
    -- self.cfg = itemCfg

    -- self.sliderLife.value = data.curLife / data.life
    -- self.sliderLife.gameObject:SetActiveEx(true)
    -- self.txtItem.transform:SetActiveEx(false)

    -- ResMgr:LoadSpriteAsync(itemCfg.icon, function(sprite)
    --     self.imgItem.sprite = sprite
    -- end)
end

-- function RankItem:onBtnItem()
--     self.initData:chooseRankItem(self.data, self.cfg)
-- end

-- function RankItem:onRelease()
--     CS.UIEventHandler.Clear(self.gameObject)
-- end