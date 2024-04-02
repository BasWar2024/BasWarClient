

PnlSettingLanguage = class("PnlSettingLanguage", ggclass.UIBase)

function PnlSettingLanguage:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onLanguageChange" }


end

function PnlSettingLanguage:onAwake()
    self.view = ggclass.PnlSettingLanguageView.new(self.pnlTransform)

    self.languageItemList = {}
    self.languageScrollView = UIScrollView.new(self.view.languageScrollView, "SettingLanguageItem", self.languageItemList)
    self.languageScrollView:setRenderHandler(gg.bind(self.onRenderLanguage, self))
end

function PnlSettingLanguage:onShow()
    self:bindEvent()

    self.dataList = {
        {name = "English", languageType = constant.LAN_TYPE_ENGLISH},
        {name = """", languageType = constant.LAN_TYPE_CHINESE_TW},
        -- {name = """", languageType = constant.LAN_TYPE_CHINESE_SIMPLE},
    }
    self.languageScrollView:setItemCount(#self.dataList)
end

function PnlSettingLanguage:onHide()
    self:releaseEvent()

end

function PnlSettingLanguage:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlSettingLanguage:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlSettingLanguage:onDestroy()
    local view = self.view

end

function PnlSettingLanguage:onBtnClose()
    self:close()
end

function PnlSettingLanguage:onRenderLanguage(obj, index)
    local item = SettingLanguageItem:getItem(obj, self.languageItemList)
    item:setData(self.dataList[index])

end

function PnlSettingLanguage:onLanguageChange()
    for key, value in pairs(self.languageItemList) do
        value:refresh()
    end
    if PlayerData.myInfo then
        PlayerData.C2S_Player_ModifyPlayerLanguage(constant.LAN_TYPE_LIST[LanguageMgr.ShowingTypeId])
    end
end


--------------------------------------
SettingLanguageItem = SettingLanguageItem or class("SettingLanguageItem", ggclass.UIBaseItem)

function SettingLanguageItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function SettingLanguageItem:onInit()
    self.btnSelect = self:Find("BtnSelect")
    self.imgBtn = self:Find("BtnSelect", "Image")
    self.txtBtn = self:Find("BtnSelect/Text", "Text")

    self:setOnClick(self.btnSelect, gg.bind(self.onBtnSelect, self))
end

function SettingLanguageItem:setData(data)
    self.data = data
    self.txtBtn.text = data.name
    self:refresh()
end

function SettingLanguageItem:refresh()
    if self.data.languageType == LanguageMgr.ShowingTypeId then
        gg.setSpriteAsync(self.imgBtn, "Button_Atlas[button 01_button_A]")
        self.txtBtn.color = UnityEngine.Color(0xfe/0xff, 0xd4/0xff, 0x5b/0xff, 1)
    else
        gg.setSpriteAsync(self.imgBtn, "Button_Atlas[button 01_button_B]")
        self.txtBtn.color = UnityEngine.Color(0x31/0xff, 0xd3/0xff, 0xfd/0xff, 1)
    end
end

function SettingLanguageItem:onBtnSelect()
    LanguageMgr:SetShowingLanguage(self.data.languageType)
end

----------------------------------------

return PnlSettingLanguage