PnlAcquisition = class("PnlAcquisition", ggclass.UIBase)

function PnlAcquisition:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {}
end

function PnlAcquisition:onAwake()
    self.view = ggclass.PnlAcquisitionView.new(self.pnlTransform)

end

function PnlAcquisition:onShow()
    self:bindEvent()

    self:loadBoxlReceive()
end

function PnlAcquisition:onHide()
    self:releaseEvent()

    self:releaseBoxlReceive()
end

function PnlAcquisition:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnDetermine):SetOnClick(function()
        self:onBtnDetermine()
    end)
end

function PnlAcquisition:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnDetermine)

end

function PnlAcquisition:onDestroy()
    local view = self.view

end

function PnlAcquisition:onBtnDetermine()
    self:close()
end

function PnlAcquisition:loadBoxlReceive()
    self:releaseBoxlReceive()
    self.boxlReceiveList = {}

    for k, v in pairs(self.args) do
        ResMgr:LoadGameObjectAsync("BoxlReceive", function(go)
            go.transform:SetParent(self.view.content, false)

            local type = v.type
            local cfgId = v.cfgId
            local count = v.count
            local icon

            if type == 0 then
                icon = constant.RES_2_CFG_KEY[cfgId].icon
                count = count / 1000
            elseif type == 1 then
                local curCfg = cfg.getCfg("item", cfgId)
                icon = gg.getSpriteAtlasName("Item_Atlas", curCfg.icon)

            end

            gg.setSpriteAsync(go.transform:Find("BoxlReceive/Icon"):GetComponent(UNITYENGINE_UI_IMAGE), icon)
            go.transform:Find("BoxlReceive/TxtNum"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.scientificNotation(count)

            go.transform:Find("BoxlReceive").transform.localPosition = Vector3(0, -500, 0)
            local newPos = Vector3(0, 0, 0)
            go.transform:Find("BoxlReceive").transform:DOLocalMove(newPos, 0.25)

            table.insert(self.boxlReceiveList, go)
            return true
        end, true)
    end
end

function PnlAcquisition:releaseBoxlReceive()
    if self.boxlReceiveList then
        for k, go in pairs(self.boxlReceiveList) do
            ResMgr:ReleaseAsset(go)
        end

        self.boxlReceiveList = nil
    end
end

return PnlAcquisition
