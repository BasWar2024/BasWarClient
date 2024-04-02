PledgeBox = PledgeBox or class("PledgeBox", ggclass.UIBaseItem)
PledgeBox.events = {"onVipPledgeChange"}

function PledgeBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PledgeBox:onInit()
    local transform = self.transform
    self.imgIconBg = transform:Find("Root/ImgIconBg"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgIcon = transform:Find("Root/ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.slider = transform:Find("Root/Slider"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.btnDesc = transform:Find("Root/BtnDesc").gameObject
    self.txtDesc = transform:Find("Root/BtnDesc/BgDesc/TxtDesc"):GetComponent(UNITYENGINE_UI_TEXT)

    self.imgTitles = transform:Find("Root/ImgTitles"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgTitles2 = transform:Find("Root/ImgTitles2"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.txtPledge = transform:Find("Root/TxtPledge"):GetComponent(UNITYENGINE_UI_TEXT)

    self.scrollView = transform:Find("Root/ScrollView")
    self.content = transform:Find("Root/ScrollView/Viewport/Content"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM)

    self.layoutBuy = transform:Find("Root/LayoutBuy")
    self.btnBuy = self.layoutBuy:Find("BtnBuy").gameObject
    self:setOnClick(self.btnBuy, gg.bind(self.onBtnBuy, self))

    self.txtBuy = self.btnBuy.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtBuyDesc = self.layoutBuy:Find("TxtBuyDesc"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtTime = transform:Find("Root/TxtTime"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtDesc = transform:Find("Root/TxtDesc"):GetComponent(UNITYENGINE_UI_TEXT)

    self.itemList = {}
    self.scrollView = UIScrollView.new(self.scrollView, "PledgeItem", self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))

    self.btnPledge = transform:Find("Root/BtnPledge").gameObject
    self:setOnClick(self.btnPledge, gg.bind(self.onBtnPledge, self))
end

function PledgeBox:onOpen(...)
    self:refresh()
    PlayerData.C2S_Player_PayChannelInfo()

    self:refreshAudit()
end

function PledgeBox:refreshAudit()
    if IsAuditVersion() then
        self.imgTitles:SetActiveEx(false)
        self.imgTitles2:SetActiveEx(true)
        self.txtDesc:SetActiveEx(false)
    else
        self.imgTitles:SetActiveEx(true)
        self.imgTitles2:SetActiveEx(false)
    end
end

function PledgeBox:refresh()
    -- gg.printData(VipData.vipData)
    -- VipData.vipData.mit = 8100000
    -- gg.printData(VipData.vipData)
    gg.timer:stopTimer(self.timer)

    VipData.vipData.endTime = VipData.vipData.endTime or 0
    if VipData.vipData.endTime == 0 then
        self.vipCfg = Utils.getCurVipCfgByMit(VipData.vipData.mit)

        self.txtTime.transform:SetActiveEx(false)
    else
        self.vipCfg = cfg.vip[VipData.vipData.vipLevel]
        self.txtTime.transform:SetActiveEx(true)

        self.timer = gg.timer:startLoopTimer(0, 0.3, -1, function()
            local time = VipData.vipData.endTime - Utils.getServerSec()

            local hms = gg.time.dhms_time({
                day = 1,
                hour = 1,
                min = 1,
                sec = 1
            }, time)
            self.txtTime.text = string.format("%sdays %s:%s:%s", hms.day, hms.hour, hms.min, hms.sec)
        end)
    end

    -- self:selectBuyData(cfg.vip[self.vipCfg.cfgId + 1])
    self:selectBuyData(nil)

    -- if self.vipCfg.cfgId == 0 then
    --     self:selectBuyData(cfg.vip[self.vipCfg.cfgId + 1])
    -- else
    --     self:selectBuyData(cfg.vip[self.vipCfg.cfgId])
    -- end

    

    -- if self.vipCfg.cfgId < #cfg.vip then
    --     self.slider.transform:SetActiveEx(true)
    --     self.txtPledge.transform:SetActiveEx(true)
    --     self.slider.value = VipData.vipData.mit / self.vipCfg.maxMit
    --     self.txtPledge.text = VipData.vipData.mit / 1000 .. "/" .. self.vipCfg.maxMit / 1000
    -- else
    --     self.slider.transform:SetActiveEx(false)
    --     self.txtPledge.transform:SetActiveEx(false)
    -- end
    gg.setSpriteAsync(self.imgIcon, string.format("Pledge_Atlas[iconvip%s]",  self.vipCfg.cfgId))
    self.dataList = {}

    for key, value in pairs(cfg.vip) do
        table.insert(self.dataList, value)
    end

    table.sort(self.dataList, function (a, b)
        return a.cfgId < b.cfgId
    end)

    self.scrollView:setItemCount(#self.dataList)
end

function PledgeBox:onClose()
    gg.timer:stopTimer(self.timer)
end

function PledgeBox:onRenderItem(obj, index)
    local item = PledgeItem:getItem(obj, self.itemList, self)
    item:setData(self.dataList[index])
    self.content:SetRectPosY(self.vipCfg.cfgId * 74)
end

function PledgeBox:selectBuyData(data)
    self.buyData = data
    self.layoutBuy:SetActiveEx(false)
    if data and data.cfgId >= self.vipCfg.cfgId then
        local product = ShopUtil.getProduct(data.productId)
        if product then
            -- self.layoutBuy:SetActiveEx(true)
            self.txtBuy.text = product.price .. "$"
            self.txtBuyDesc.text = "buy 30 days vip " .. data.cfgId
        end
    end

    for key, value in pairs(self.itemList) do 
        value:refreshSelect()
    end
end

function PledgeBox:onBtnBuy()
    if self.buyData.productId and self.buyData.productId ~= "" then
        ShopUtil.buyProduct(self.buyData.productId)
    end
    -- ShopUtil.getProduct(self.buyData.productId)
end

function PledgeBox:onBtnPledge()
    CS.UnityEngine.Application.OpenURL(AutoPushData.getVipUrl())
end

function PledgeBox:onVipPledgeChange()
    self:refresh()
end

function PledgeBox:onRelease()
    self.scrollView:release()
end

----------------------------------------------------------
PledgeItem = PledgeItem or class("PledgeItem", ggclass.UIBaseItem)
function PledgeItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PledgeItem:onInit()
    self.imgLight = self:Find("ImgLight", UNITYENGINE_UI_IMAGE)
    self.imgIcon = self:Find("ImgIcon", UNITYENGINE_UI_IMAGE)
    self.txtName = self:Find("TxtName", UNITYENGINE_UI_TEXT)

    self.layoutNormal = self:Find("LayoutNormal").transform

    self.txtNeedMit = self:Find("LayoutNormal/TxtNeedMit", UNITYENGINE_UI_TEXT)
    self.txtHydPlus = self:Find("LayoutNormal/TxtHydPlus", UNITYENGINE_UI_TEXT)
    self.txtAddAtk = self:Find("LayoutNormal/TxtAddAtk", UNITYENGINE_UI_TEXT)
    self.txtBuildQuene = self:Find("LayoutNormal/TxtBuildQuene", UNITYENGINE_UI_TEXT)
    self.txtWithdrawReduce = self:Find("LayoutNormal/TxtWithdrawReduce", UNITYENGINE_UI_TEXT)

    self.layoutAudit = self:Find("LayoutAudit").transform
    self.txtAddAtk2 = self:Find("LayoutAudit/TxtAddAtk2", UNITYENGINE_UI_TEXT)
    self.txtBuildQuene2 = self:Find("LayoutAudit/TxtBuildQuene2", UNITYENGINE_UI_TEXT)

    self.imgSelect = self:Find("ImgSelect", UNITYENGINE_UI_IMAGE)

    -- self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))

    if IsAuditVersion() then
        self.layoutNormal:SetActiveEx(false)
        self.layoutAudit:SetActiveEx(true)
    else
        self.layoutNormal:SetActiveEx(true)
        self.layoutAudit:SetActiveEx(false)
    end
end

function PledgeItem:setData(data)
    self.data = data

    gg.setSpriteAsync(self.imgIcon, string.format("Pledge_Atlas[iconvip%s]",  data.cfgId))

    self.txtName.text = "VIP " .. data.cfgId
    self.txtNeedMit.text = math.floor(data.minMit / 1000)
    self.txtHydPlus.text = "+" .. math.floor(data.hydroxylAddition / 20) .. "%" --Utils.getShowRes(data.hydroxylAddition)
    -- self.txtHydPlus.text = "+" .. math.floor(math.max(data.hydroxylAddition - 100, 0)) .. "%" --Utils.getShowRes(data.hydroxylAddition)
    self.txtAddAtk.text = "+" .. data.battleNumAdd
    self.txtBuildQuene.text = "+" .. data.buildQueue

    self.txtAddAtk2.text = "+" .. data.battleNumAdd
    self.txtBuildQuene2.text = "+" .. data.buildQueue

    self.imgLight.transform:SetActiveEx(data == self.initData.vipCfg)

    local oneDaySec = 24 * 60 * 60

    local day = math.floor(data.withdrawReduce / oneDaySec)

    self.txtWithdrawReduce.text = string.format(Utils.getText("activity_LoginSurp_CountdownDay"), day)


    self:refreshSelect()
    
    -- gg.printData(data)
end

function PledgeItem:refreshSelect()
    self.imgSelect:SetActiveEx(self.data == self.initData.buyData)
end

function PledgeItem:onClickItem()
    self.initData:selectBuyData(self.data)
end

-- function PledgeItem:onRelease()
--     self.rewardScrollView:release()
-- end