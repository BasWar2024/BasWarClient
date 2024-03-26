MailData = {}

MailData.mailBriefData = {}

-- ""
function MailData.C2S_Player_GetMail(id)
    gg.client.gameServer:send("C2S_Player_GetMail", {
        id = id
    })
end

-- ""
function MailData.C2S_Player_DelMail(id)
    gg.client.gameServer:send("C2S_Player_DelMail", {
        id = id
    })
end

-- ""
function MailData.C2S_Player_ReceiveMailAttach(id)
    gg.client.gameServer:send("C2S_Player_ReceiveMailAttach", {
        id = id
    })
end


-- ""
function MailData.C2S_Player_OneKeyDelMails()
    gg.client.gameServer:send("C2S_Player_OneKeyDelMails", {})
end

-- ""
function MailData.C2S_Player_OneKeyReadMails()
    gg.client.gameServer:send("C2S_Player_OneKeyReadMails", {})
end

-- ""
function MailData.S2C_Player_MailUpdate(type, mailList)
    if type == 0 or type == 1 or type == 3 then
        for k, v in pairs(mailList) do
            MailData.mailBriefData[v.id] = v
        end
        if type ~= 0 then
            gg.event:dispatchEvent("onInitView", true)
            gg.event:dispatchEvent("onRefreshMail")
        end
    elseif type == 2 then
        for k, v in pairs(mailList) do
            MailData.mailBriefData[v.id] = nil
        end
        gg.event:dispatchEvent("onInitView", false)
    end
end

-- ""
function MailData.S2C_Player_MailDetail(mail)
    gg.event:dispatchEvent("onRefreshContent", mail)

end

return MailData
