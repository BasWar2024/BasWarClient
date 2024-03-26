local WarShipView = class("WarShipView")

function WarShipView:ctor()
    self.obj = nil
    self.warShip = nil
    self.cubeCollider = nil
    self.buttonUi = nil
    self.timeBar = nil
    self.operPoint = nil
end

function WarShipView:loadGameObject(cfg, callback)
    ResMgr:LoadGameObjectAsync("BuildingWarShip", function(obj)
        self.obj = obj
        obj.name = "BuildingWarShip"
        -- print(table.dump(gg.buildingManager.ownBase.transform))
        obj:FastSetParent(gg.buildingManager.ownBase.transform, false)
        obj.transform.position = Vector3(-13.25, 0, 27.98)
        obj.transform.rotation = Quaternion.Euler(0, 0, 0)
        self.buttonUi = obj.transform:Find("ButtonUi")

        self.buildingButtonUiBox = BuildingButtonUiBox.new(obj.transform:Find("BuildingButtonUiBox"))
        self.buildingTimeBarBox = BuildingTimeBarBox.new(obj.transform:Find("TimeBar"))

        self.operPoint = self.buildingButtonUiBox.namePoint -- obj.transform:Find("OperPoint").gameObject
        self:loadWarShipObj(cfg, function()
            if callback then
                callback()
            end
        end)
        return true
    end, true)
end

function WarShipView:loadWarShipObj(cfg, callback)
    self:unLoadWarShip()
    ResMgr:LoadGameObjectAsync(cfg.model, function(go)
        self.warShip = go
        self.cubeCollider = go.transform:Find("BuildingWarShipCube").gameObject
        go.transform:SetParent(self.obj.transform, false)
        go.transform.position = Vector3(cfg.worldPos.x, cfg.worldPos.y, cfg.worldPos.z)
        go.transform.localRotation = Quaternion.Euler(0, 180, 0)

        -- local bodyObj = go.transform:Find("Body")
        -- local count = bodyObj.childCount
        -- for i = 0, count - 1, 1 do
        --     bodyObj:GetChild(i).transform:GetComponent("MeshRenderer").material =
        --         bodyObj:GetChild(i).transform:GetComponent("GradualChange").Mat2
        -- end

        if callback then
            callback()
        end

        return true
    end, true)
end

-- ""
function WarShipView:unLoadWarShip()
    if self.warShip then
        ResMgr:ReleaseAsset(self.warShip)
        self.warShip = nil
    end
end

-- ""obj
function WarShipView:onDestory()
    self:unLoadWarShip()
    if self.obj then
        ResMgr:ReleaseAsset(self.obj)
        self.obj = nil
    end
    self.operPoint = nil
    self.buttonUi = nil
    self.timeBar = nil
    self.buildingTimeBarBox:release()
    self.buildingTimeBarBox = nil

    self.buildingButtonUiBox:release()
    self.buildingButtonUiBox = nil
end

return WarShipView
