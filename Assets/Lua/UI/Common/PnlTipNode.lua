

PnlTipNode = class("PnlTipNode", ggclass.UIBase)

function PnlTipNode:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.tips
    self.events = { }
end

function PnlTipNode:onAwake()
    self.view = ggclass.PnlTipNodeView.new(self.pnlTransform)
    self.tipsNodeList = {TipsNode.new(self.view.tipsNode, self)}
    self.tipsNodeMap = {}
end

function PnlTipNode:onShow()
    self:bindEvent()

end

function PnlTipNode:showTipsNode(content, nodeName, pos)
    local tipsNode = self:getTipsNode(nodeName)
    self.tipsNodeMap[nodeName] = tipsNode

    tipsNode.transform:SetActiveEx(true)

    tipsNode.transform.position = pos
    tipsNode:showTips(content)
end

function PnlTipNode:getTipsNode(nodeName)
    if self.tipsNodeMap[nodeName] then
        return self.tipsNodeMap[nodeName]
    end

    if #self.tipsNodeList > 0 then
        return table.remove(self.tipsNodeList, 1)
    end

    local tipsNode = TipsNode.new(UnityEngine.GameObject.Instantiate(self.view.tipsNode), self)
    tipsNode.transform:SetParent(self.view.transform)

    return tipsNode
end

function PnlTipNode:freeNode(node)
    for key, value in pairs(self.tipsNodeMap) do
        if value == node then
            table.insert(self.tipsNodeList, value)
            self.tipsNodeMap[key] = nil
        end
    end
end

function PnlTipNode:onHide()
    self:releaseEvent()

end

function PnlTipNode:bindEvent()
    local view = self.view

end

function PnlTipNode:releaseEvent()
    local view = self.view


end

function PnlTipNode:onDestroy()
    local view = self.view

end

---------------------------------------------------------------------------------
TipsNode = TipsNode or class("TipsNode", ggclass.UIBaseItem)
function TipsNode:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

-- TipsNode.events = {"onRedPointChange"}

function TipsNode:onInit()
    self.tipsList = {}
    self.tipsQuene = {}
    self.tweenMap = {}

    for i = 1, self.transform.childCount, 1 do
        local text = self.transform:GetChild(i - 1):GetComponent(UNITYENGINE_UI_TEXT)
        table.insert(self.tipsList, text)
        text.transform:SetActiveEx(false)
    end
    self.txtTips = self.tipsList[1]
end

TipsNode.MAX_COUNT = 5

function TipsNode:getFreeTips()
    if #self.tipsList > 0 then
        local text = table.remove(self.tipsList, 1)
        table.insert(self.tipsQuene, text)
        return text
    else

        if #self.tipsQuene >= TipsNode.MAX_COUNT then
            local text = table.remove(self.tipsQuene, 1)
            table.insert(self.tipsQuene, text)
            return text
        else
            local text = UnityEngine.GameObject.Instantiate(self.txtTips.gameObject).transform:GetComponent(UNITYENGINE_UI_TEXT)
            text.transform:SetParent(self.transform, false)
            text.transform:SetActiveEx(false)
            table.insert(self.tipsQuene, text)
            return text
        end
    end
end

function TipsNode:showTips(content)
    local text = self:getFreeTips()
    text.text = content

    if self.tweenMap[text] then
        self.tweenMap[text]:Kill()
        self.tweenMap[text] = nil
    end

    text.transform:SetActiveEx(true)
    text.transform.localPosition = CS.UnityEngine.Vector3(0, 0, 0)


    local sequence = CS.DG.Tweening.DOTween.Sequence()
    self.tweenMap[text] = sequence
    sequence:Append(text.transform:DOLocalMoveY(200, 2))
    sequence:AppendCallback(function ()
        self.tweenMap[text] = nil
        text.transform:SetActiveEx(false)

        for index, value in ipairs(self.tipsQuene) do
            if value == text then
                table.remove(self.tipsQuene, index)
            end
        end

        table.insert(self.tipsList, text)

        self:checkFree()
        -- table.remove()
    end)
end

function TipsNode:checkFree()
    if #self.tipsQuene <= 0 then
        self.initData:freeNode(self)
    end
end

return PnlTipNode