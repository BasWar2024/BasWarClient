

PnlChangeName = class("PnlChangeName", ggclass.UIBase)

function PnlChangeName:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlChangeName:onAwake()
    self.view = ggclass.PnlChangeNameView.new(self.pnlTransform)
end

-- args = {type, setCallback}

PnlChangeName.TYPE_CHANGE = 1
PnlChangeName.TYPE_CREATE = 0

function PnlChangeName:onShow()
    self:bindEvent()
    local view = self.view

    self.type = PnlChangeName.TYPE_CHANGE
    if self.args then
        self.type = self.args.type or PnlChangeName.TYPE_CHANGE
    end

    if self.type == PnlChangeName.TYPE_CHANGE then
        view.txtCost.gameObject:SetActiveEx(true)
        view.txtTitle.text = Utils.getText("name_Title")
        view.txtBtnSet.text = Utils.getText("name_Change")
        
        local cost = cfg.global.ModifyPlayerNameCostHy.intValue
        if PlayerData.myInfo.modifyNameNum == 0 then
            cost = 0
            view.txtCost.text = 0
        else
            view.txtCost.text = Utils.getShowRes(cost)
        end

        if cost > ResData.getTesseract() then
            view.txtCost.color = constant.COLOR_RED
        else
            view.txtCost.color = constant.COLOR_WHITE
        end

        view.inputName.text = PlayerData.myInfo.name

    elseif self.type == PnlChangeName.TYPE_CREATE then
        view.txtCost.gameObject:SetActiveEx(false)
        view.txtTitle.text = "nickname"
        view.inputName.text = ""
        view.txtBtnSet.text = "NEXT STEP"
    end
end

function PnlChangeName:onHide()
    self:releaseEvent()
end

function PnlChangeName:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnSet):SetOnClick(function()
        self:onBtnSet()
    end)

    view.inputName.onValueChanged:AddListener(gg.bind(self.onInput, self))
    view.inputName.onEndEdit:AddListener(gg.bind(self.onInputEnd, self))
end

function PnlChangeName:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnSet)

    view.inputName.onValueChanged:RemoveAllListeners()
    view.inputName.onEndEdit:RemoveAllListeners()
end

function PnlChangeName:onDestroy()
    local view = self.view
end

function PnlChangeName:onInput(text)
    local view = self.view
    local wordsCount = string.utf8len(text)
    if wordsCount > PlayerData.MAX_NAME_LENTH then
        view.inputName.text = string.utf8sub(text, 0, PlayerData.MAX_NAME_LENTH)
        return
    end
end

function PnlChangeName:onInputEnd(text)
    local view = self.view
    --text = FilterWords.filterWords(text)
    view.inputName.text = text
end

function PnlChangeName:onBtnSet()
    local text = self.view.inputName.text

    local isExistSensitiveWord, matchWord = FilterWords.isExistSensitiveWord(text)
    if isExistSensitiveWord then
        gg.uiManager:showTip(string.format(Utils.getText("universal_InvalidWord"), matchWord))
        -- gg.uiManager:showTip("Invalid role name")
        return
    end

    local nameLenth = string.utf8len(text)
    if nameLenth < PlayerData.MIN_NAME_LENTH or nameLenth > PlayerData.MAX_NAME_LENTH then
        gg.uiManager:showTip("Nickname is limited by 2~16 characters.")
        return
    end

    if self.args and self.args.setCallback then
        self.args.setCallback(text)
    end

    local cost = 0

    if PlayerData.myInfo.modifyNameNum ~= 0 then
        cost = cfg.global.ModifyPlayerNameCostHy.intValue

        if cost > ResData.getTesseract() then
            gg.uiManager:showTip(Utils.getText("conscription_Train_ResNotEnough"))
            return
        end

        local args = {}
        args.txt = string.format(Utils.getText("name_Change_Ask"), Utils.getShowRes(cost))

        args.callbackYes = function ()
            PlayerData.C2S_Player_ModifyPlayerName(text)
            self:close()
        end

        args.yesCostList = {{cost = cfg.global.ModifyPlayerNameCostHy.intValue, resId = constant.RES_TESSERACT}}
        gg.uiManager:openWindow("PnlAlert", args)
    else
        PlayerData.C2S_Player_ModifyPlayerName(text)
        self:close()
    end
end

function PnlChangeName:onBtnClose()
    self:close()
end

return PnlChangeName