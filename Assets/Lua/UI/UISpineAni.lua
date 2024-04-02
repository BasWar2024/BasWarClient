UISpineAni = class("UISpineAni")

function UISpineAni:ctor(spine, aniName)
    self.func = function()
        self:AfterSpineAni(spine)
    end
    spine:SpineAnimPlay(aniName, false)
    spine:AddAniComplete(self.func)

end

function UISpineAni:AfterSpineAni(spine)
    spine:SpineAnimPlay("idle", true)
    spine:DelAniComplete(self.func)

    self = nil
end


return UISpineAni
