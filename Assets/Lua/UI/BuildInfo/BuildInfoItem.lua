BuildInfoTechnoItem = BuildInfoTechnoItem or class("BuildInfoTechnoItem", ggclass.UIBaseItem)

function BuildInfoTechnoItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BuildInfoTechnoItem:onInit()
    self.imgIcon = self:Find("imgIcon", "Image")
    self.txtName = self:Find("TxtName", "Text")
end

function BuildInfoTechnoItem:setData(technologyCfg)
    -- print("ffffffffffffffffffffffffffffffffffffff")
    -- gg.printData(technologyCfg)
    self.curCfg = nil
    for key, value in pairs(cfg[technologyCfg.type]) do
        if technologyCfg.level then
            if value.cfgId == technologyCfg.targetCfgId and value.level == technologyCfg.level then
                self.curCfg = value
            end
        elseif value.cfgId == technologyCfg.targetCfgId then
            self.curCfg = value
        end
    end

    if self.curCfg then
        self.txtName.text = self.curCfg.name
    end
    -- gg.printData(self.curCfg)
end
