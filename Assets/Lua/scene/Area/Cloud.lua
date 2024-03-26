Cloud = class("Cloud")

function Cloud:ctor()
    self.gameObject = nil
    self.transform = nil
end

function Cloud:setData(areaCfg, data)
    self.areaCfg = areaCfg
    self.data = data

    if not self.model then
        ResMgr:LoadGameObjectAsync(data.model, function(go)
            self.gameObject = go
            self.transform = go.transform
            self.transform.rotation = UnityEngine.Quaternion.Euler(90, 0, 0)

            self.transform.parent = gg.areaManager.root.transform
            self.spine = self.transform:Find("Spine").transform:GetComponent("SkeletonAnimation")
            self:refresh()
            return true
        end, true)
    else
        self:refresh()
    end
end

function Cloud:refresh()
    self.spine:ChangeSlots("bin", "res/" .. self.data.slot)

    local pos = self.data.pos
    self.transform.position = UnityEngine.Vector3(pos[1], pos[2], pos[3])

    self.transform.name = self.data.slot
end

-- function Cloud:hide()
--     if self.gameObject then
--         self.gameObject:SetActiveEx(false)
--     end
-- end

function Cloud:release()
    ResMgr:ReleaseAsset(self.gameObject)
    -- GameObject.Destroy(self.gameObject)
end
