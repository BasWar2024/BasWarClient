FixItem = FixItem or class("FixItem", ggclass.UIBaseItem)

function FixItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function FixItem:onInit()
    self.commonBagItem = CommonBagItem.new(self:Find("CommonBagItem"))
    self.sliderLife = self.transform:Find("SliderLife"):GetComponent(UNITYENGINE_UI_SLIDER)
    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self))

    self.sliderTime = self:Find("SliderTime", "Slider")
    self.imgSelect = self:Find("ImgSelect", "Image")

    self.layoutTime = self:Find("LayoutTime").transform
    self.imgTime = self.layoutTime:Find("ImgTime"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgTimeRunning = self.layoutTime:Find("ImgTime/ImgTimeRunning"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtTime = self.layoutTime:Find("TxtTime"):GetComponent(UNITYENGINE_UI_TEXT)
end

function FixItem:onRelease()
    -- self.sliderTime:DOKill()
    gg.timer:stopTimer(self.timer)
end

function FixItem.getNewItemData(id, repairLessTickEnd, icon, life, curLife, quality, name)
    return {
        id = id,
        repairLessTickEnd = repairLessTickEnd,
        icon = icon,
        life = life,
        curLife = curLife,
        quality = quality,
        name = name,
    }
end

-- data = {id , repairLessTickEnd, icon, life, curLife, quality}
function FixItem:setData(data)
    self.data = data
    self:refreshSelect()

    if not data then
        self.sliderLife.gameObject:SetActiveEx(false)
        self.layoutTime.gameObject:SetActiveEx(false)
        self.commonBagItem:setQuality(0)
        self.commonBagItem:setIcon(false)
        return
    end
    
    self.layoutTime.gameObject:SetActiveEx(true)
    self.sliderLife.gameObject:SetActiveEx(true)

    self.sliderLife.value = data.curLife / data.life
    local icon = gg.getSpriteAtlasName("Icon_E_Atlas", data.icon .. "_E")
    self.commonBagItem:setIcon(icon)
    self.commonBagItem:setQuality(data.quality)

    gg.timer:stopTimer(self.timer)
    -- data.repairLessTickEnd = os.time() + 100

    if data.repairLessTickEnd > os.time() then
        self.txtTime.transform:SetActiveEx(true)
        self.imgTimeRunning.transform:SetActiveEx(true)
        self.timer = gg.timer:startLoopTimer(0, 0.3, 999999999, function()
            local hms = gg.time.dhms_time({day=0,hour=1,min=1,sec=1}, data.repairLessTickEnd - os.time())
            self.txtTime.text = string.format("%sh%sm%ss", hms.hour, hms.min, hms.sec)
        end)
    else
        self.txtTime.transform:SetActiveEx(false)
        self.imgTimeRunning.transform:SetActiveEx(false)
    end
end

function FixItem:onBtnItem()
    self.initData:chooseFixItem(self.data, self.cfg)
end

function FixItem:refreshSelect()
    if self.initData.showingItemData and self.data then
        self.imgSelect.gameObject:SetActiveEx(self.initData.showingItemData.id == self.data.id)
    else
        self.imgSelect.gameObject:SetActiveEx(false)
    end
end

