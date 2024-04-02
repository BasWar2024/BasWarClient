

PnlDrawCardResult = class("PnlDrawCardResult", ggclass.UIBase)

function PnlDrawCardResult:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlDrawCardResult:onAwake()
    self.view = ggclass.PnlDrawCardResultView.new(self.pnlTransform)

    self.cardItemList = {}

    for i = 1, self.view.layoutCardMore.childCount, 1 do
        self.cardItemList[i] = CardItem.new(self.view.layoutCardMore:GetChild(i - 1))
    end
end

-- args = S2C_Player_drawCardResult
function PnlDrawCardResult:onShow()
    self:bindEvent()
    self.achieveResMap = {}

    local items = self.args.items
    for index, value in ipairs(self.cardItemList) do

        if items[index] ~= nil then
            value:setActive(true)
            value:setData(items[index].cfgId)

            if items[index].resCfgId > 0 then
                value:setTxtRes(items[index].resCount)
            else
                value:setTxtRes(false)
            end
        end

        if items[index] == nil or items[index].cfgId == 0 then
            value:setActive(false)
            -- if items[index] ~= nil and items[index].resCfgId > 0 then
            --     self.achieveResMap[items[index].resCfgId] = self.achieveResMap[items[index].resCfgId] or 0
            --     self.achieveResMap[items[index].resCfgId] = self.achieveResMap[items[index].resCfgId] + items[index].resCount
            -- end
        end
    end

    for key, value in pairs(self.view.resMap) do
        if self.achieveResMap[key] then
            value.transform:SetActiveEx(true)
            value.txtCount.text = self.achieveResMap[key]
        else
            value.transform:SetActiveEx(false)
        end
    end
end

function PnlDrawCardResult:onHide()
    self:releaseEvent()

end

function PnlDrawCardResult:bindEvent()
    local view = self.view

end

function PnlDrawCardResult:releaseEvent()
    local view = self.view


end

function PnlDrawCardResult:onDestroy()
    local view = self.view
    for key, value in pairs(self.cardItemList) do
        value:release()
    end
end

return PnlDrawCardResult