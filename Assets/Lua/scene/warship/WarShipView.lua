local WarShipView = class("WarShipView")

function WarShipView:ctor()
    self.obj = nil
    self.warShip = nil
    self.buttonUi = nil
    self.timeBar = nil
    self.operPoint = nil
end

function WarShipView:loadGameObject(modelName, callback)
    ResMgr:LoadGameObjectAsync("BuildingWarShip", function(obj)
        self.obj = obj
        obj.name = "BuildingWarShip"
        obj.transform:SetParent(gg.buildingManager.ownBase.transform)
        obj.transform.position = Vector3(-13, 0, 24)
        obj.transform.rotation = Quaternion.Euler(0, 0, 0)
        self.buttonUi = obj.transform:Find("ButtonUi")
        self.timeBar = obj.transform:Find("TimeBar/TimeBar")

        self.buttonOnBuild = self.timeBar.parent.transform:Find("ButtonOnBuild").gameObject
        self.btnBuildSpeedUp = self.buttonOnBuild.transform:Find("BtnBuildSpeedUp").gameObject
        self.txtBuildSpeedUpCost = self.btnBuildSpeedUp.transform:Find("TxtBuildSpeedUpCost"):GetComponent("TextMesh")
        self.operPoint = obj.transform:Find("OperPoint").gameObject
        self:loadWarShipObj(modelName, function()

            if callback then
                callback()
            end

        end)

        return true
    end)
end

function WarShipView:loadWarShipObj(modelName, callback)
    self:unLoadWarShip()
    ResMgr:LoadGameObjectAsync(modelName, function(go)
        self.warShip = go
        go.transform:SetParent(self.obj.transform, false)
        go.transform.localPosition = Vector3(0, 0, 0)
        go.transform.localRotation = Quaternion.Euler(0, 0, 0)
        if callback then
            callback()
        end

        return true
    end, true)
end

function WarShipView:showTimeBar(bool)
    self.buttonOnBuild:SetActiveEx(bool)
    self.timeBar.gameObject:SetActive(bool)
end

function WarShipView:setTimeBar(percent, sec)
    -- percent 0~1
    if not self.timeBar then
        return
    end
    self.timeBar:GetComponent("SpriteRenderer").size = Vector2.New(percent * 1.48, 0.21)
    local str = gg.time:hms_string(sec)
    self.timeBar:Find("BgBar/TxtTime"):GetComponent("TextMesh").text = str
end

--
function WarShipView:unLoadWarShip()
    if self.warShip then
        ResMgr:ReleaseAsset(self.warShip)
        self.warShip = nil

    end
end

--obj
function WarShipView:onDestory()
    self:unLoadWarShip()
    if self.obj then
        ResMgr:ReleaseAsset(self.obj)
        self.obj = nil
    end
    self.operPoint = nil
    self.buttonUi = nil
    self.timeBar = nil
end

return WarShipView