BattleReportTopButton = BattleReportTopButton or class("BattleReportTopButton", ggclass.UIBaseItem)

BattleReportTopButton.OPEN_TYPE_BASE = 1
BattleReportTopButton.OPEN_TYPE_GALAXY = 2

function BattleReportTopButton:ctor(obj, type)
    UIBaseItem.ctor(self, obj)

    self.events = {}

    self.openType = type
end

function BattleReportTopButton:onInit()
    self.btnTop = {
        [BattleData.BATTLE_TYPE_PVE] = self:Find("BtnPve"),
        [BattleData.BATTLE_TYPE_BASE] = self:Find("BtnPvp"),
        [BattleData.BATTLE_TYPE_SELF] = self:Find("BtnMyCompaign"),
        [BattleData.BATTLE_TYPE_RES_PLANNET] = self:Find("BtnDaoCompaign")
    }

    for k, v in pairs(self.btnTop) do
        self:setOnClick(v, gg.bind(self.onBtnTop, self, k))

    end
end

function BattleReportTopButton:onBtnTop(type)
    for k, v in pairs(self.btnTop) do
        if type == k then
            v.transform:GetComponent(UNITYENGINE_UI_IMAGE).color = Color.New(1, 1, 1, 1)
            v.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color =
                Color.New(0x2a / 0xff, 0xc4 / 0xff, 0xfd / 0xff, 1)
        else
            v.transform:GetComponent(UNITYENGINE_UI_IMAGE).color = Color.New(1, 1, 1, 0)
            v.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color =
                Color.New(0x9f / 0xff, 0x9f / 0xff, 0x9f / 0xff, 1)
        end
    end
    if type == BattleData.BATTLE_TYPE_PVE or type == BattleData.BATTLE_TYPE_BASE then
        if self.openType == BattleReportTopButton.OPEN_TYPE_BASE then
            if BattleReportData.battleReport[type] then
                gg.event:dispatchEvent("onLoadBattleReport", type)
            else
                BattleReportData.C2S_Player_QueryFightReports(type)
            end
        else
            gg.uiManager:openWindow("PnlBattleReport", type, function()
                local window = gg.uiManager:getWindow("PnlUnionWarReport")
                window.destroyTime = -1
                window:close()
            end)
        end

    end
    if type == BattleData.BATTLE_TYPE_SELF or type == BattleData.BATTLE_TYPE_RES_PLANNET then
        if self.openType == BattleReportTopButton.OPEN_TYPE_GALAXY then
            gg.event:dispatchEvent("onChangeReportType", type)

        else
            gg.uiManager:openWindow("PnlUnionWarReport", type, function()
                local window = gg.uiManager:getWindow("PnlBattleReport")
                window.destroyTime = -1
                window:close()
            end)
        end
    end
end

function BattleReportTopButton:onRelease()
    self.btnTop = nil
end
