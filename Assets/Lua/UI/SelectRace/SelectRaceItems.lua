RaceAnswerItem = RaceAnswerItem or class("RaceAnswerItem", ggclass.UIBaseItem)

function RaceAnswerItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function RaceAnswerItem:onRelease()

end

function RaceAnswerItem:onInit()

    self.btn = self:Find("Btn")
    self:setOnClick(self.btn, gg.bind(self.onClickBtn, self))
    self.txtBtn = self.btn.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

    -- self.rankBaseInfoItem = RankBaseInfoItem.new(self:Find("RankBaseInfoItem"))
    -- self.rankPersonalInfoItem = RankPersonalInfoItem.new(self:Find("RankPersonalInfoItem"))
    -- self.rankDaoInfoItem = RankDaoInfoItem.new(self:Find("RankDaoInfoItem"))
end

function RaceAnswerItem:onClickBtn()
    self.initData:answer(self.data)
end

function RaceAnswerItem:setData(data)
    self.data = data
    self.txtBtn.text = data.textA
end