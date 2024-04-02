PnlMaterialReward = class("PnlMaterialReward", ggclass.UIBase)

PnlMaterialReward.infomationType = ggclass.UIBase.INFOMATION_RES

function PnlMaterialReward:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onSetReward"}

    self.boxlMaterialRewardList = {}
end

function PnlMaterialReward:onAwake()
    self.view = ggclass.PnlMaterialRewardView.new(self.pnlTransform)

end

function PnlMaterialReward:onShow()
    self:bindEvent()
    self.view.viewDetailed:SetActiveEx(false)

    self:loadBoxlMaterialReward()
    self:onSetReward()
end

function PnlMaterialReward:onHide()
    self:releaseEvent()

    self:releaseBoxlMaterialReward()

end

function PnlMaterialReward:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnReceive):SetOnClick(function()
        self:onBtnReceive()
    end)
    CS.UIEventHandler.Get(view.btnCloseViewDetailed):SetOnClick(function()
        self:onBtnCloseViewDetailed()
    end)
end

function PnlMaterialReward:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnReceive)
    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlMaterialReward:onDestroy()
    local view = self.view

end

function PnlMaterialReward:onBtnClose()
    self:close()
end

function PnlMaterialReward:onBtnReceive()
    local data = GalaxyData.gridReward
    local total = data.unionMit + data.unionCarboxyl + data.otherUnionMit + data.otherUnionCarboxyl +
                      data.personalUnionMit + data.personalUnionCarboxyl

    if total > 0 then
        GalaxyData.C2S_Player_DrawMyStarmapReward()
    end
end

function PnlMaterialReward:onBtnCloseViewDetailed()
    self.view.viewDetailed:SetActiveEx(false)
end

function PnlMaterialReward:releaseBoxlMaterialReward()
    if self.boxlMaterialRewardList then
        for k, v in pairs(self.boxlMaterialRewardList) do
            ResMgr:ReleaseAsset(v)
        end
        self.boxlMaterialRewardList = {}
    end
end

function PnlMaterialReward:loadBoxlMaterialReward()
    self:releaseBoxlMaterialReward()
    local isHaveBlue = true
    for k, v in pairs(GalaxyData.gridRewardRecords) do
        local curHaveBlue = isHaveBlue
        isHaveBlue = not isHaveBlue
        ResMgr:LoadGameObjectAsync("BoxlMaterialReward", function(go)
            go.transform:SetParent(self.view.content, false)
            local bgImage = go.transform:GetComponent(UNITYENGINE_UI_IMAGE)
            local curCfg = gg.galaxyManager:getGalaxyCfg(v.cfgId)

            if curHaveBlue then
                bgImage.color = Color.New(1, 1, 1, 1)
            else
                bgImage.color = Color.New(1, 1, 1, 0)
            end
            local txtRtype = ""
            local rtype = v.rewards[1].rtype
            if rtype == 1 then
                txtRtype = string.format(Utils.getText("league_Battle_Own"), curCfg.name, curCfg.pos.x, curCfg.pos.y,
                    v.rewards[1].carboxyl / 1000)
            elseif rtype == 2 then
                txtRtype = string.format(Utils.getText("league_Battle_Guild"), curCfg.name, curCfg.pos.x, curCfg.pos.y,
                    v.rewards[1].carboxyl / 1000)
            elseif rtype == 3 then
                txtRtype = string.format(Utils.getText("league_Occupy_Own"), curCfg.name, curCfg.pos.x, curCfg.pos.y,
                    v.rewards[1].carboxyl / 1000)
            elseif rtype == 4 then
                txtRtype = string.format(Utils.getText("league_Occupy_Guild"), curCfg.name, curCfg.pos.x, curCfg.pos.y,
                    v.rewards[1].carboxyl / 1000)
            end

            go.transform:Find("TxtInfo"):GetComponent(UNITYENGINE_UI_TEXT).text = txtRtype

            go.transform:Find("TxtTime"):GetComponent(UNITYENGINE_UI_TEXT).text = gg.time.utcDate(v.timestamp)
            table.insert(self.boxlMaterialRewardList, go)
            CS.UIEventHandler.Get(go.transform:Find("BtnView").gameObject):SetOnClick(function()
                self:onBtnView(v)
            end)
            return true
        end, true)
    end
end

function PnlMaterialReward:onSetReward()
    local data = GalaxyData.gridReward

    local view = self.view

    view.transform:Find("BgInfo/BoxPersonal/ResMit/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = "x " ..
                                                                                                       Utils.scientificNotationInt(
            data.personalUnionMit / 1000)
    view.transform:Find("BgInfo/BoxPersonal/ResHy/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = "x " ..
                                                                                                      Utils.scientificNotationInt(
            data.personalUnionCarboxyl / 1000)

    view.transform:Find("BgInfo/BoxGuildRes/ResMit/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = "x " ..
                                                                                                       Utils.scientificNotationInt(
            data.unionMit / 1000)
    view.transform:Find("BgInfo/BoxGuildRes/ResHy/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = "x " ..
                                                                                                      Utils.scientificNotationInt(
            data.unionCarboxyl / 1000)

    view.transform:Find("BgInfo/BoxDivideRes/ResMit/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = "x " ..
                                                                                                        Utils.scientificNotationInt(
            data.otherUnionMit / 1000)
    view.transform:Find("BgInfo/BoxDivideRes/ResHy/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = "x " ..
                                                                                                       Utils.scientificNotationInt(
            data.otherUnionCarboxyl / 1000)

end

function PnlMaterialReward:onBtnView(data)
    local view = self.view

    -- local txtRtype = ""
    -- local rtype = data.rewards[1].rtype
    -- if rtype == 1 then
    --     txtRtype = string.format(Utils.getText("league_Battle_Own"), curCfg.name, curCfg.pos.x, curCfg.pos.y,
    --         data.rewards[1].carboxyl / 1000)
    -- elseif rtype == 2 then
    --     txtRtype = string.format(Utils.getText("league_Battle_Guild"), curCfg.name, curCfg.pos.x, curCfg.pos.y,
    --         data.rewards[1].carboxyl / 1000)
    -- elseif rtype == 3 then
    --     txtRtype = string.format(Utils.getText("league_Occupy_Own"), curCfg.name, curCfg.pos.x, curCfg.pos.y,
    --         data.rewards[1].carboxyl / 1000)
    -- elseif rtype == 4 then
    --     txtRtype = string.format(Utils.getText("league_Occupy_Guild"), curCfg.name, curCfg.pos.x, curCfg.pos.y,
    --         data.rewards[1].carboxyl / 1000)
    -- end

    local curCfg = gg.galaxyManager:getGalaxyCfg(data.cfgId)

    view.txtTitleviewDetailed.text = curCfg.name
    view.txtPos.text = string.format("(x:%s, y:%s)", curCfg.pos.x, curCfg.pos.y)
    view.txtBasic.text = Utils.getText("league_AwardDetails_BasicGet") .. " " .. data.rewards[1].carboxyl  / 1000

    view.txtTotal.text = data.rewards[1].total
    view.txtMy.text = data.rewards[1].myVal
    view.txtProfit.text = data.rewards[1].carboxyl / 1000
    view.txtMyTotal.text = Utils.getText("league_AwardDetails_MyIncomeShow") .. " " .. data.rewards[1].carboxyl / 1000

    self.view.viewDetailed:SetActiveEx(true)
end

return PnlMaterialReward
