

PnlBattle = class("PnlBattle", ggclass.UIBase)
local cjson = require "cjson"

function PnlBattle:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlBattle:onAwake()
    self.view = ggclass.PnlBattleView.new(self.transform)

    -- self.operUITable = {btnSolider1 = self.btnSolider1, btnSolider2 = self.btnSolider2, btnSolider3 = self.btnSolider3, btnSolider4 = self.btnSolider4,
    -- btnSolider5 = self.btnSolider5, btnSolider6 = self.btnSolider6, btnSolider7 = self.btnSolider7, btnSolider8 = self.btnSolider8,
    -- btnHero = self.btnHero, btnHeroSkill = self.btnHeroSkill, btnSkill1 = self.btnSkill1, btnSkill2 = self.btnSkill2, btnSkill3 = self.btnSkill3, 
    -- btnSkill4 = self.btnSkill4, btnSkill5 = self.btnSkill5}
end

function PnlBattle:onShow()
    self:bindEvent()
    self.terrain = gg.sceneManager.terrain
    self.mainCamera = UnityEngine.Camera.main
    self.battleMono = gg.battleManager.battleMono
    self.newBattleData = gg.battleManager.newBattleData
    self.closeColor = UnityEngine.Color(0.5, 0.5, 0.5)
    self.openColor = UnityEngine.Color(1, 1, 1)
    
    -- self.skillPoints = self.newBattleData._SkillPoints
    -- self.skillCostPointsDict = self.newBattleData._SkillCostPointsDict
    self.battleMono.ShowOperUI = function()
        self:showOperUI()
    end

    self.battleMono.CloseOperUI = function(oper)
        self:closeOperUI(oper)
    end

    self.battleMono.UpdateSkillPoint = function()
        self:updateSkillCost()
    end

    self.battleMono.BattleLogic.UpdateTime = function(time)
        self:updateTime(time)
    end

    self.battleMono.BattleLogic.ShowResult = function(value)
        self:showResult(value)
    end

    self.battleMono.BattleLogic.EndBattle = function(endBattle)
        self:endBattle(endBattle)
    end

    self:hideOperUI()
end

function PnlBattle:updateSkillCost()
    local view = self.view

    self:updateSkillPoint()

    for k, v in pairs(self.newBattleData._SkillCostPointsDict) do
        local operStrList = string.split(tostring(k), ":")
        local costStrList = string.split(tostring(v), ":")
        local operNum = tonumber(operStrList[2])
        local costNum = tonumber(costStrList[1])

        if(operNum == 10) then
            view.btnHeroSkill.transform:Find("Text"):GetComponent("Text").text = costNum
        else
            local skillBtn = view.skillBtnList[operNum - 9]
            skillBtn.transform:Find("Text"):GetComponent("Text").text = costNum
        end
    end
end

function PnlBattle:closeOperUI(oper)
    if oper == 0 then
        return
    end

    local view = self.view

    if oper < 9 then
        view.soliderBtnList[oper]:GetComponent("Image").color = self.closeColor
    elseif oper == 9 then
        view.btnHero:SetActive(false)
        view.btnHeroSkill:SetActive(true)
    end
end

function PnlBattle:showOperUI()
        local view = self.view
        for k,v in pairs(self.newBattleData._OperSoliderDict) do
            ResMgr:LoadSpriteAsync(v.icon, function(sprite)
                local strList = string.split(tostring(k), ":")
                local solidetBtn = view.soliderBtnList[tonumber(strList[2])]
                solidetBtn.transform:Find("Text"):GetComponent("Text").text = v.Amount
                solidetBtn:GetComponent("Image").sprite = sprite
                solidetBtn:SetActive(true)
            end)
        end

        local heroSkillBtn = view.btnHeroSkill
        heroSkillBtn.transform:Find("Text"):GetComponent("Text").text =  self.newBattleData._OperHeroSkill.OriginCost
        ResMgr:LoadSpriteAsync(self.newBattleData._OperHeroSkill.icon, function(sprite)
            heroSkillBtn:GetComponent("Image").sprite = sprite
            heroSkillBtn:SetActive(false)
        end)

        for k,v in pairs(self.newBattleData._OperSkillDict) do
            ResMgr:LoadSpriteAsync(v.icon, function(sprite)
                local strList = string.split(tostring(k), ":")
                local skillBtn = view.skillBtnList[tonumber(strList[2]) - 9] --10
                skillBtn.transform:Find("Text"):GetComponent("Text").text = v.OriginCost
                skillBtn:GetComponent("Image").sprite = sprite
                skillBtn:SetActive(true)
            end)
        end

        view.btnHero:SetActive(true)
        self:updateSkillPoint()
        view.skillPoint.gameObject:SetActive(true)
end

--
function PnlBattle:onClickOperOrder(order)
    if order == 10 then
        self.battleMono:OnClickHeroSkill()
    else
        self.battleMono:OnOperOrder(order)
    end
end

function PnlBattle:onReturn2Main()
    self.newBattleData:Release()
    self:close()
    gg.sceneManager:enterBaseScene()
end

function PnlBattle:updateSkillPoint()
    local view = self.view
    local skillStrList = string.split(tostring(self.newBattleData._SkillPoints), ":")
    local skillNum = tonumber(skillStrList[1])
    view.txtSkillPoint.text = skillNum
end

function PnlBattle:updateTime(time)
    local view = self.view
    view.txtTime.text = os.date("%M:%S", time)
end

function PnlBattle:showResult(value)
    local view = self.view
    if value then
        view.txtWin:SetActive(true)
    else
        view.txtFail:SetActive(true)
    end
end

--battleId, bVersion, ret, signinPosId, operate, result
function PnlBattle:endBattle(json)
    print("lua:" .. json)

    local endBattle = cjson.decode(json)

    BattleData.C2S_Player_EndBattle(endBattle.battleId, endBattle.bVersion, endBattle.ret, endBattle.signinPosId, 
        cjson.encode(endBattle.operate), cjson.encode(endBattle.result))
end

--
function PnlBattle:hideOperUI()
    local view = self.view
    view.btnSolider1:SetActive(false)
    view.btnSolider2:SetActive(false)
    view.btnSolider3:SetActive(false)
    view.btnSolider4:SetActive(false)
    view.btnSolider5:SetActive(false)
    view.btnSolider6:SetActive(false)

    view.btnHero:SetActive(false)
    view.btnHeroSkill:SetActive(false)

    view.btnSkill1:SetActive(false)
    view.btnSkill2:SetActive(false)
    view.btnSkill3:SetActive(false)
    view.btnSkill4:SetActive(false)
    view.btnSkill5:SetActive(false)

    view.skillPoint.gameObject:SetActive(false)

    view.txtFail:SetActive(false)
    view.txtWin:SetActive(false)
end

function PnlBattle:onHide()
    local view = self.view
    
    self:releaseEvent()

    for k,v in pairs(view.soliderBtnList) do
        v:GetComponent("Image").color = self.openColor
    end

    gg.battleManager.isInBattle = false
   
    -- self.battleMono.ShowOperUI = nil
    -- self.battleMono.CloseOperUI = nil
    -- self.battleMono.UpdateSkillPoint = nil
    -- self.battleMono.ShowResult = nil

    self.operUITable = nil
    self.terrain = nil
    self.mainCamera = nil
    self.battleMono = nil
    self.newBattleData = nil
    self.closeColor = nil

end

function PnlBattle:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnSolider1):SetOnClick(function()
        self:onClickOperOrder(1)
    end)

    CS.UIEventHandler.Get(view.btnSolider2):SetOnClick(function()
        self:onClickOperOrder(2)
    end)

    CS.UIEventHandler.Get(view.btnSolider3):SetOnClick(function()
        self:onClickOperOrder(3)
    end)

    CS.UIEventHandler.Get(view.btnSolider4):SetOnClick(function()
        self:onClickOperOrder(4)
    end)

    CS.UIEventHandler.Get(view.btnSolider5):SetOnClick(function()
        self:onClickOperOrder(5)
    end)

    CS.UIEventHandler.Get(view.btnSolider6):SetOnClick(function()
        self:onClickOperOrder(6)
    end)

    CS.UIEventHandler.Get(view.btnHero):SetOnClick(function()
        self:onClickOperOrder(9)
    end)

    CS.UIEventHandler.Get(view.btnHeroSkill):SetOnClick(function()

        self:onClickOperOrder(10)
    end)

    CS.UIEventHandler.Get(view.btnSkill1):SetOnClick(function()
        self:onClickOperOrder(11)
    end)

    CS.UIEventHandler.Get(view.btnSkill2):SetOnClick(function()
        self:onClickOperOrder(12)
    end)

    CS.UIEventHandler.Get(view.btnSkill3):SetOnClick(function()
        self:onClickOperOrder(13)
    end)

    CS.UIEventHandler.Get(view.btnSkill4):SetOnClick(function()
        self:onClickOperOrder(14)
    end)

    CS.UIEventHandler.Get(view.btnSkill5):SetOnClick(function()
        self:onClickOperOrder(15)
    end)

    CS.UIEventHandler.Get(view.btnRePlay):SetOnClick(function()
        if(self.newBattleData.RePlayJson == nil or self.newBattleData.RePlayJson == '') then
            gg.uiManager:showTip("RePlayJson is nil")
            return
        end

        self:hideOperUI()

        self.battleMono:OnRePlay()
    end)

    CS.UIEventHandler.Get(view.btnServerRePlay):SetOnClick(function()
        if(self.newBattleData.RePlayJson == nil or self.newBattleData.RePlayJson == '') then
            gg.uiManager:showTip("RePlayJson is nil")
            return
        end

        self.battleMono:OnServerRePlay()
    end)

    CS.UIEventHandler.Get(view.btnReturn2Main):SetOnClick(function()
        self:onReturn2Main()
    end)
end

function PnlBattle:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnSolider1)
    CS.UIEventHandler.Clear(view.btnSolider2)
    CS.UIEventHandler.Clear(view.btnSolider3)
    CS.UIEventHandler.Clear(view.btnSolider4)
    CS.UIEventHandler.Clear(view.btnSolider5)
    CS.UIEventHandler.Clear(view.btnSolider6)

    CS.UIEventHandler.Clear(view.btnHero)
    CS.UIEventHandler.Clear(view.btnHeroSkill)

    CS.UIEventHandler.Clear(view.btnSkill1)
    CS.UIEventHandler.Clear(view.btnSkill2)
    CS.UIEventHandler.Clear(view.btnSkill3)
    CS.UIEventHandler.Clear(view.btnSkill4)
    CS.UIEventHandler.Clear(view.btnSkill5)

    CS.UIEventHandler.Clear(view.btnRePlay)
    CS.UIEventHandler.Clear(view.btnServerRePlay)
    CS.UIEventHandler.Clear(view.btnReturn2Main)

end

function PnlBattle:onDestroy()
    local view = self.view
end

return PnlBattle