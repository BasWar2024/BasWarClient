

PnlBattleDrawCard = class("PnlBattleDrawCard", ggclass.UIBase)
PnlBattleDrawCard.closeType = ggclass.UIBase.CLOSE_TYPE_NONE
function PnlBattleDrawCard:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)
    self.layer = UILayer.normal
    self.events = { }
    self.needBlurBG = true
end

function PnlBattleDrawCard:onAwake()
    self.view = ggclass.PnlBattleDrawCardView.new(self.pnlTransform)
    self.defCardList = {}

    for i = 1, self.view.layoutDefCards.childCount, 1 do
        self.defCardList[i] = CardItem.new(self.view.layoutDefCards:GetChild(i - 1))
        self.defCardList[i]:showCardBack(true)
    end

    self.atkCardList = {}
    for i = 1, self.view.layoutAtkCards.childCount, 1 do
        self.atkCardList[i] = CardItem.new(self.view.layoutAtkCards:GetChild(i - 1))
        self.atkCardList[i]:setClickCallback(gg.bind(self.onBtnAtkItem, self, i))
    end
end

function PnlBattleDrawCard:onBtnAtkItem(index)
    self.view.layoutAtkCards:SetActiveEx(false)
    self.selectAtkCardCfgId = self.randomCardList[index]
    self:setStep(PnlBattleDrawCard.STEP_SHOW_DEF_CARD)
end

--args = {defCardList = }
function PnlBattleDrawCard:onShow()
    self:bindEvent()
    self.selectAtkCardCfgId = nil

    self.view.layoutAtkCards.gameObject:SetActiveEx(false)
    self.view.layoutDefCards.gameObject:SetActiveEx(false)

    if self.args and next(self.args.defCardList) then
        self:initDefCard(self.args.defCardList)
    end
    self:setStep(PnlBattleDrawCard.STEP_DRAW_ATK_CARD)
end

function PnlBattleDrawCard:drawAtkCard()
    if not next(CardData.useGrpIdx) then
        self:setStep(PnlBattleDrawCard.STEP_SHOW_DEF_CARD)
        return
    end
    self.view.layoutAtkCards.gameObject:SetActiveEx(true)
    local cardGroup = CardData.attaCardGroupsMap[CardData.useGrpIdx[constant.CARD_GROUP_TYPE_ATK]]
    local randomCardList = {}
    local cardIds = gg.copy(cardGroup.group.cardIds)
    for i = 1, 3 do
        table.insert(randomCardList, PnlBattleDrawCard:randomCard(cardIds))
    end

    self.randomCardList = randomCardList
    for index, value in ipairs(self.atkCardList) do
        value:setData(self.randomCardList[index])
    end
end

PnlBattleDrawCard.STEP_DRAW_ATK_CARD = 1
PnlBattleDrawCard.STEP_SHOW_DEF_CARD = 2
PnlBattleDrawCard.STEP_FINISH = 3

function PnlBattleDrawCard:setStep(step)

    if step == PnlBattleDrawCard.STEP_FINISH then
        gg.battleManager:setAtkCard(self.selectAtkCardCfgId)
        self:close()
    elseif step == PnlBattleDrawCard.STEP_DRAW_ATK_CARD then
        self:drawAtkCard()

    elseif step == PnlBattleDrawCard.STEP_SHOW_DEF_CARD then
        self:showDefCard()
    end
end

function PnlBattleDrawCard:showDefCard()
    if self.args and next(self.args.defCardList) then
        self.view.layoutDefCards:SetActiveEx(true)
        gg.timer:startTimer(1, function ()
            self.defCardList[self.randomCardPos]:showCardBack(false)
            gg.timer:startTimer(2, function ()
                self:setStep(PnlBattleDrawCard.STEP_FINISH)
            end)
        end)
    else
        self:setStep(PnlBattleDrawCard.STEP_FINISH)
    end
end

function PnlBattleDrawCard:initDefCard(cardList)
    if not cardList or not next(cardList) then
        self.view.layoutDefCards:SetActiveEx(false)
        self.isShowDef = false
        return
    end

    self.isShowDef = true

    local randomCardPos = math.random(1, 3)
    self.randomCardPos = randomCardPos
    self.defCardList[randomCardPos]:setData(cardList[1])

    local settingIndex = 2
    for key, value in pairs(self.defCardList) do
        if key ~= randomCardPos then
            value:setData(cardList[settingIndex])
            settingIndex = settingIndex + 1
        end
        value:showCardBack(true)
    end
end

function PnlBattleDrawCard:randomCard(cardIds)
    local cardCount = #cardIds
    local randomIndex = math.random(1, cardCount)
    local cfgId = cardIds[randomIndex]
    table.remove(cardIds, randomIndex)
    return cfgId
end

function PnlBattleDrawCard:onHide()
    self:releaseEvent()
end

function PnlBattleDrawCard:bindEvent()
    local view = self.view
end

function PnlBattleDrawCard:releaseEvent()
    local view = self.view
end

function PnlBattleDrawCard:onDestroy()
    local view = self.view

    for key, value in pairs(self.defCardList) do
        value:release()
    end

    for key, value in pairs(self.atkCardList) do
        value:release()
    end
end

return PnlBattleDrawCard