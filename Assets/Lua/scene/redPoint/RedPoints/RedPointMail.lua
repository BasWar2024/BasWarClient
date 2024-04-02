RedPointMail = class("RedPointMail", ggclass.RedPointBase)

function RedPointMail:ctor()
    ggclass.RedPointBase.ctor(self, {}, {"onInitView"})
end

function RedPointMail:onCheck()
    for key, value in pairs(MailData.mailBriefData) do
        if not value.read then
            return true
        end
    end
    return false
end
