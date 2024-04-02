

PnlTaskRewardDesc = class("PnlTaskRewardDesc", ggclass.UIBase)

function PnlTaskRewardDesc:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onFingerUp" }
end

function PnlTaskRewardDesc:onAwake()
    self.view = ggclass.PnlTaskRewardDescView.new(self.pnlTransform)

end

--args = {reward, pos}
function PnlTaskRewardDesc:onShow()
    self:bindEvent()

    local reward = self.args.reward
    
    if reward.rewardType == constant.ACTIVITY_REWARD_ITEM then
        local itemCfg = cfg.item[reward.cfgId]

        print(itemCfg.languageNameID, Utils.getText(itemCfg.languageNameID))

        self.view.txtType.text = Utils.getText(itemCfg.languageNameID)
        self.view.txtBoxResDetailedDesc.text = Utils.getText(itemCfg.languageDescID)
    end

    local localPos = self.view.transform:InverseTransformPoint(self.args.pos)
    local anchorPos = UnityEngine.Vector2(localPos.x, localPos.y - 20)

    local minY = -self.view.transform.rect.height / 2 + self.view.layoutDetailed.transform.rect.height

    anchorPos.y = math.max(minY, anchorPos.y)

    -- if anchorPos.y <  then
        
    -- end


    self.view.layoutDetailed.transform.anchoredPosition = anchorPos

    -- self.view.layoutDetailed.transform.position = self.args.pos
    -- if self.args.pos then
    --     self.view.layoutDetailed.transform.position = self.args.pos
    -- end

    -- self.followTrans = 
end

function PnlTaskRewardDesc:onFingerUp()
    self:close()
end

function PnlTaskRewardDesc:onHide()
    self:releaseEvent()

end

function PnlTaskRewardDesc:bindEvent()
    local view = self.view
end

function PnlTaskRewardDesc:releaseEvent()
    local view = self.view


end

function PnlTaskRewardDesc:onDestroy()
    local view = self.view

end

return PnlTaskRewardDesc