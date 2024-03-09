FixItem = FixItem or class("FixItem", ggclass.UIBaseItem)

function FixItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function FixItem:onInit()
    -- self.tmpAttr = self.transform:Find("TmpAttr"):GetComponent("TextMeshProUGUI")

    self.sliderLife = self.transform:Find("SliderLife"):GetComponent("Slider")
    self.imgItem = self.transform:Find("ImgItem"):GetComponent("Image")
    self.txtItem = self.transform:Find("TxtItem"):GetComponent("Text")
    self.goFixing = self:Find("goFixing")
    self.goFixing:SetActiveEx(false)

    self.txtFixing = self:Find("goFixing/Text"):GetComponent("Text")

    self.txtItem.transform:SetActiveEx(false)
    CS.UIEventHandler.Get(self.gameObject):SetOnClick(function()
        self:onBtnItem()
    end)
end

function FixItem:setData(data)
    self.data = data
    if not data then
        self.txtItem.transform:SetActiveEx(true)
        self.txtItem.text = ""
        self.sliderLife.gameObject:SetActiveEx(false)
        return
    end

    local itemCfg = cfg.get("etc.cfg.item")[data.cfgId]
    self.cfg = itemCfg
    self.sliderLife.value = data.curLife / data.life
    self.sliderLife.gameObject:SetActiveEx(true)
    self.txtItem.transform:SetActiveEx(false)

    ResMgr:LoadSpriteAsync(itemCfg.icon, function(sprite)
        self.imgItem.sprite = sprite
    end)
    -- local fixData = ItemUtil:getFixingData(data.id)
    -- if fixData then
    --     self.goFixing:SetActiveEx(true)
    --     local min = 60
    --     local hour = 60 * min
    --     self.timer = gg.timer:startLoopTimer(0, 0.3, 99999999, function()
    --         -- local time = fixData.endTime - os.time()
    --         -- local h = math.floor(time / hour)
    --         -- local m = math.floor((time - h * 60 * 60) / min)
    --         -- local s = time - h * 60 * 60 - m * 60
    --         local hms = gg.time.dhms_time({day=0,hour=1,min=1,sec=1}, fixData.endTime - os.time())
    --         self.txtFixing.text = string.format("%sh%sm%ss", hms.hour, hms.min, hms.sec)
    --     end)
    -- else
    --     self.goFixing:SetActiveEx(false)
    -- end
end

function FixItem:onBtnItem()
    self.initData:chooseFixItem(self.data, self.cfg)
end

function FixItem:onRelease()
    CS.UIEventHandler.Clear(self.gameObject)
end
