BoxMail = class("BoxMail")

function BoxMail:ctor(data, obj, id)
    self.data = data
    self.obj = obj
    self.id = id

    self:onShow()
end

function BoxMail:onShow()
    self:bindEvent()
    self:setView()
end

function BoxMail:setView()
    local data = self.data
    local obj = self.obj
    local icon

    if data.read then
        -- gg.setSpriteAsync(obj.transform:GetComponent(UNITYENGINE_UI_IMAGE), "Have read bar_icon")
        if self.id == data.id then
            obj.transform:Find("PitchOn").gameObject:SetActive(true)
            icon = gg.getSpriteAtlasName("Mail_Atlas", "Have read_icon_B")
            obj.transform:Find("TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT).color =
                Color.New(0xfe / 0xff, 0xfd / 0xff, 0xf6 / 0xff)
            obj.transform:Find("TxtSender"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0xfe / 0xff,
                0xfd / 0xff, 0xf6 / 0xff)
            obj.transform:Find("TxtDate"):GetComponent(UNITYENGINE_UI_TEXT).color =
                Color.New(0xfe / 0xff, 0xfd / 0xff, 0xf6 / 0xff)

        else
            icon = gg.getSpriteAtlasName("Mail_Atlas", "Have read_icon_A")
            obj.transform:Find("PitchOn").gameObject:SetActive(false)
            obj.transform:Find("TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT).color =
                Color.New(0x3d / 0xff, 0x97 / 0xff, 0xff / 0xff)
            obj.transform:Find("TxtSender"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0x3d / 0xff,
                0x97 / 0xff, 0xff / 0xff)
            obj.transform:Find("TxtDate"):GetComponent(UNITYENGINE_UI_TEXT).color =
                Color.New(0x3d / 0xff, 0x97 / 0xff, 0xff / 0xff)
        end

    else
        -- gg.setSpriteAsync(obj.transform:GetComponent(UNITYENGINE_UI_IMAGE), "Unread bar_icon")
        icon = gg.getSpriteAtlasName("Mail_Atlas", "Unread_icon")
        obj.transform:Find("PitchOn").gameObject:SetActive(false)
        obj.transform:Find("TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT).color =
            Color.New(0x3d / 0xff, 0x97 / 0xff, 0xff / 0xff)
        obj.transform:Find("TxtSender"):GetComponent(UNITYENGINE_UI_TEXT).color =
            Color.New(0x3d / 0xff, 0x97 / 0xff, 0xff / 0xff)
        obj.transform:Find("TxtDate"):GetComponent(UNITYENGINE_UI_TEXT).color =
            Color.New(0x3d / 0xff, 0x97 / 0xff, 0xff / 0xff)

    end

    if data.canGet then
        obj.transform:Find("IconTreasure").gameObject:SetActive(true)
    else
        obj.transform:Find("IconTreasure").gameObject:SetActive(false)
    end

    local sendDate = os.date("%Y-%m-%d", data.sendTime)

    obj.transform:Find("TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT).text = data.title
    obj.transform:Find("TxtSender"):GetComponent(UNITYENGINE_UI_TEXT).text = data.sendName
    obj.transform:Find("TxtDate"):GetComponent(UNITYENGINE_UI_TEXT).text = sendDate

    gg.setSpriteAsync(obj.transform:Find("IconMail"):GetComponent(UNITYENGINE_UI_IMAGE), icon, nil, nil, true)

end

function BoxMail:bindEvent()
    CS.UIEventHandler.Get(self.obj):SetOnClick(function()
        self:onBtn()
    end)
    -- gg.event:addListener("onRefreshMail", self)
end

function BoxMail:releaseEvent()
    CS.UIEventHandler.Clear(self.obj)

    -- gg.event:removeListener("onRefreshMail", self)
end

function BoxMail:onBtn()
    MailData.C2S_Player_GetMail(self.data.id)
    -- gg.event:dispatchEvent("onRefreshMail", self.data.id)
end

-- function BoxMail:onRefreshMail(id)
--     if id == self.data.id then
--         obj.transform:Find("PitchOn").gameObject:setActive(true)
--     else
--         obj.transform:Find("PitchOn").gameObject:setActive(false)
--     end
-- end

function BoxMail:releaseBoxMail()
    self:releaseEvent()
    ResMgr:ReleaseAsset(self.obj)
    self.data = nil
    self.obj = nil
end

return BoxMail
