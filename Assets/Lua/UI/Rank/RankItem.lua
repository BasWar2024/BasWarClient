RankBaseInfoItem = RankBaseInfoItem or class("RankBaseInfoItem", ggclass.UIBaseItem)

function RankBaseInfoItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function RankBaseInfoItem:onInit()
    self.imgBg = self:Find("", "Image")

    self.imgRank = self:Find("ImgRank", "Image")
    self.txtRank = self:Find("TxtRank", "Text")

    self.imgRankChange = self:Find("ImgRankChange", "Image")
    self.imgSame = self:Find("ImgSame", "Image")
    self.txtRankChange = self:Find("TxtRankChange", "Text")

    self.imgBgReward = self:Find("ImgBgReward", "Image")
    self.imgReward = self:Find("ImgBgReward/ImgReward", "Image")
    self.txtReward = self:Find("ImgBgReward/TxtReward", "Text")
end

function RankBaseInfoItem:SetMessage(rank, rankChange, rewardCount)
    if rank <= 3 then
        self.imgRank.gameObject:SetActiveEx(true)
        self.txtRank.gameObject:SetActiveEx(false)
        gg.setSpriteAsync(self.imgRank, string.format("Rank_Atlas[Rank_Icon_%s]", rank))

        gg.setSpriteAsync(self.imgBg, string.format("Rank_Atlas[RankItem_Bg_%s]", rank))
    else
        self.imgRank.gameObject:SetActiveEx(false)
        self.txtRank.gameObject:SetActiveEx(true)
        self.txtRank.text = rank
        gg.setSpriteAsync(self.imgBg, "Rank_Atlas[RankItem_Bg_4]")
    end

    --gg.setSpriteAsync(self.imgRank, "Rank_Atlas[]")
    

    self.txtRankChange.text = math.abs(rankChange)
    self.imgRankChange.gameObject:SetActiveEx(false)
    self.imgSame.gameObject:SetActiveEx(false)

    if rankChange > 0 then
        self.imgRankChange.gameObject:SetActiveEx(true)
        gg.setSpriteAsync(self.imgRankChange, "Rank_Atlas[up_icon]")
        self.txtRankChange.color = UnityEngine.Color(0xd8/0xff, 0xbb/0xff, 0x2c/0xff, 1)

    elseif rankChange < 0 then
        self.imgRankChange.gameObject:SetActiveEx(true)
        gg.setSpriteAsync(self.imgRankChange, "Rank_Atlas[down_icon]")
        self.txtRankChange.color = UnityEngine.Color(0xd7/0xff, 0x2a/0xff, 0x30/0xff, 1)
    else
        self.imgSame.gameObject:SetActiveEx(true)
        self.txtRankChange.color = UnityEngine.Color(0x9b/0xff, 0x9d/0xff, 0xa2/0xff, 1)
    end

    self.txtReward.text = rewardCount
end

---------------------------------------------------------------
RankDaoInfoItem = RankDaoInfoItem or class("RankDaoInfoItem", ggclass.UIBaseItem)
function RankDaoInfoItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function RankDaoInfoItem:onInit()
    self.imgHead = self:Find("ImgHead", "Image")
    self.txtName = self:Find("TxtName", "Text")
    self.txtMember = self:Find("TxtMember", "Text")
    self.imgValue = self:Find("ImgValue", "Image")
    self.txtValue = self:Find("TxtValue", "Text")
end

function RankDaoInfoItem:SetMessage(headIcon, name, value, member, memberMax)
    gg.setSpriteAsync(self.imgHead, Utils.getHeadIcon(headIcon))
    self.txtName.text = name
    self.txtMember.text = member .. "/" .. memberMax
    self.txtValue.text = value
end
---------------------------------------------------------------
RankPersonalInfoItem = RankPersonalInfoItem or class("RankPersonalInfoItem", ggclass.UIBaseItem)
function RankPersonalInfoItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function RankPersonalInfoItem:onInit()
    self.imgHead = self:Find("ImgHead", "Image")
    self.txtName = self:Find("TxtName", "Text")
    self.imgValue = self:Find("ImgValue", "Image")
    self.txtValue = self:Find("TxtValue", "Text")
end

function RankPersonalInfoItem:SetMessage(headIcon, name, value, rankType)
    gg.setSpriteAsync(self.imgHead, Utils.getHeadIcon(headIcon))
    self.txtName.text = name
    gg.setSpriteAsync(self.imgValue, constant.RANK_TYPE_2_VALUE_MESSAGE[rankType].icon)
    self.txtValue.text = value
end
---------------------------------------------------------------
RankItem = RankItem or class("RankItem", ggclass.UIBaseItem)

function RankItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function RankItem:onRelease()
    self.rankBaseInfoItem:release()
    self.rankPersonalInfoItem:release()
    self.rankDaoInfoItem:release()
end

function RankItem:onInit()
    self.rankBaseInfoItem = RankBaseInfoItem.new(self:Find("RankBaseInfoItem"))
    self.rankPersonalInfoItem = RankPersonalInfoItem.new(self:Find("RankPersonalInfoItem"))
    self.rankDaoInfoItem = RankDaoInfoItem.new(self:Find("RankDaoInfoItem"))
end

function RankItem:setData(data, type)
    self.data = data
    if not data then
        return
    end
    self.rankBaseInfoItem:SetMessage(data.index, data.upDown, data.award)

    if type == constant.RANK_TYPE_BADGE or type == constant.RANK_TYPE_COST_MIT then
        self.rankPersonalInfoItem:SetMessage(data.headIcon, data.name, data.value, type)
        self.rankPersonalInfoItem:open()
        self.rankDaoInfoItem:close()
    else
        self.rankPersonalInfoItem:close()
        self.rankDaoInfoItem:open()
        self.rankPersonalInfoItem:SetMessage(data.headIcon, data.name, data.value, 1, 2)
    end
end
