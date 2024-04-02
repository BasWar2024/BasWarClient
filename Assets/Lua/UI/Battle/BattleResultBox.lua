BattleResultBox = BattleResultBox or class("BattleResultBox", ggclass.UIBaseItem)

function BattleResultBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BattleResultBox:onInit()
    self.events = {"onPnlLoadingOpen"}

    self.audioInstence = nil

    self.bgWin = self:Find("BgWin")
    self.bgLose = self:Find("BgLose")

    self.txtScore = self:Find("TxtScore", UNITYENGINE_UI_TEXT)
    self.layoutReceive = self:Find("LayoutMid/LayoutReceive").transform
    self.txtGetNothing = self.layoutReceive.transform:Find("TxtGetNothing"):GetComponent(UNITYENGINE_UI_TEXT)
    self.layoutReceiveItems = self:Find("LayoutMid/LayoutReceive/LayoutItems")

    self.txtReceive = self.layoutReceive:Find("TxtReceive"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgLineReceive = self.layoutReceive:Find("ImgLineReceive"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.receiveItemMap = {}
    for i = 1, self.layoutReceiveItems.transform.childCount, 1 do
        local trans = self.layoutReceiveItems.transform:GetChild(i - 1)
        self.receiveItemMap[trans.name] = BattleReceiveItem.new(trans)
    end

    self.layoutCasualties = self:Find("LayoutMid/LayoutCasualties").transform

    self.txtCasualties = self.layoutCasualties:Find("TxtCasualties"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgLineCasualties = self.layoutCasualties:Find("ImgLineCasualties"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.casualtiesItemList = {}
    self.casualtiesScrollView = UIScrollView.new(self:Find("LayoutMid/LayoutCasualties/CasualtiesScrollView"),
        "BattleReceiveItem", self.casualtiesItemList)
    self.casualtiesScrollView:setRenderHandler(gg.bind(self.onRenderCasualtiesItem, self))
    self.txtCasualtiesScrollView = self:Find("LayoutMid/LayoutCasualties/CasualtiesScrollView/Text", "Text")

    self.btnReturn = self:Find("BtnReturn").gameObject
    self:setOnClick(self.btnReturn, gg.bind(self.onBtnReturn, self))

    self.btnReturnBase = self:Find("BtnReturnBase").gameObject
    self:setOnClick(self.btnReturnBase, gg.bind(self.onBtnReturn, self, true))

    self.battleResultStrengthBox = BattleResultStrengthBox.new(self:Find("LayoutMid/BattleResultStrengthBox"))

    self.layoutMid = self:Find("LayoutMid").transform

    Utils.fixUiResolutionW(self.layoutMid)
end

local COLOR_WIN = UnityEngine.Color(0xff/0xff, 0xff/0xff, 0xcb/0xff, 1)
local COLOR_LOSE = UnityEngine.Color(0x46/0xff, 0xb2/0xff, 0xfd/0xff, 1)

function BattleResultBox:setResult(data)
    self.data = data

    local txtBadge = data.badge
    if data.badge >= 0 then
        txtBadge = "+" .. txtBadge
    end
    self.txtScore.text = BattleData.pvpData.myScore .. string.format("[<color=#ffae00>%s</color>]", txtBadge)

    local audioInfo
    if data.result == 1 then
        audioInfo = constant.AUDIO_BATTLE_WIN

        self.bgWin:SetActiveEx(true)
        self.bgLose:SetActiveEx(false)

        self.txtReceive.color = COLOR_WIN
        self.txtCasualties.color = COLOR_WIN

        gg.setSpriteAsync(self.imgLineReceive, "Result_Atlas[line02_icon]")
        gg.setSpriteAsync(self.imgLineCasualties, "Result_Atlas[line02_icon]")

        self.layoutReceive:SetActiveEx(true)
        self.layoutCasualties:SetActiveEx(true)
        self.battleResultStrengthBox.transform:SetActiveEx(false)
    else
        audioInfo = constant.AUDIO_BATTLE_LOSE

        self.bgWin:SetActiveEx(false)
        self.bgLose:SetActiveEx(true)

        self.txtReceive.color = COLOR_LOSE
        self.txtCasualties.color = COLOR_LOSE

        gg.setSpriteAsync(self.imgLineReceive, "Result_Atlas[line01_icon]")
        gg.setSpriteAsync(self.imgLineCasualties, "Result_Atlas[line01_icon]")

        self.layoutReceive:SetActiveEx(false)
        self.layoutCasualties:SetActiveEx(true)
        self.battleResultStrengthBox.transform:SetActiveEx(true)
    end

    AudioFmodMgr:LoadAudioInstance(audioInfo.event, audioInfo.bank, function (instance)
        self.audioInstence = instance
        if self.stage ~= UIBaseItem.STAGE_RELEASE and self.initData and not self.initData:isShow() then
            self.audioInstence:release()
            self.audioInstence = nil
        else
            self.audioInstence:start()
            -- AudioFmodMgr:SetInstanceCallback(self.audioInstence, function (type)
            --     print(type)
            -- end)
            
            -- //instance.setCallback((type, _event, parameters) =>
            -- //{
            -- //    UnityEngine.Debug.Log($"audioCB {eventName} {type} {_event}");
            -- //    return RESULT.OK;
            -- //});
        end
    end)
    AudioFmodMgr:PauseBgm(true)

    local isShowGetNothing = true
    for key, value in pairs(data) do
        if self.receiveItemMap[key] then

            if value <= 0 then
                self.receiveItemMap[key]:setActive(false)
            else
                isShowGetNothing = false
                self.receiveItemMap[key]:setActive(true)

                if key ~= "badge" then
                    value = Utils.getShowRes(value, true)
                end

                self.receiveItemMap[key]:setData({
                    type = BattleReceiveItem.TYPE_RES,
                    param1 = value
                })
            end
        end
    end
    self.txtGetNothing.transform:SetActiveEx(isShowGetNothing)

    self.casualtiesDataList = {}
    for index, value in ipairs(data.soliders) do
        table.insert(self.casualtiesDataList, {
            type = BattleReceiveItem.TYPE_SOLDIER,
            param1 = value
        })
    end

    local itemCount = #self.casualtiesDataList
    self.casualtiesScrollView:setItemCount(itemCount)

    -- local itemWidth = 140
    -- local spancing = 13
    -- local width = (itemWidth + spancing) * itemCount - spancing
    -- self.casualtiesScrollView.transform:SetRectSizeX(math.min(width, 1560))

    self.txtCasualtiesScrollView.transform:SetActiveEx(itemCount <= 0)
end

function BattleResultBox:onRenderCasualtiesItem(go, index)
    local item = BattleReceiveItem:getItem(go, self.casualtiesItemList)
    item:setData(self.casualtiesDataList[index])
end

function BattleResultBox:onBtnReturn(isReturnBase)
    if isReturnBase then
        gg.sceneManager:clearEnterSceneOpenWindows(constant.SCENE_BASE)
    else
        gg.sceneManager:addEnterSceneOpenWindows(constant.SCENE_BASE, "PnlPvp")
    end

    if self.audioInstence then
        self.audioInstence:stop()
        self.audioInstence:release()
        self.audioInstence = nil
    end
    BattleUtil.returnFromResult()
    AudioFmodMgr:PauseBgm(false)
    -- gg.battleManager.newBattleData:Release()
    -- gg.sceneManager:returnFormBatter()

    -- if self.audioInstence then
    --     self.audioInstence:stop()
    --     self.audioInstence:release()
    --     self.audioInstence = nil
    -- end
    -- AudioFmodMgr:PauseBgm(false)
end

function BattleResultBox:onPnlLoadingOpen()
    self.initData:close()
end

function BattleResultBox:onRelease()
    self.casualtiesScrollView:release()
    self.initData = nil
    if self.audioInstence then
        self.audioInstence:stop()
        self.audioInstence:release()
        self.audioInstence = nil
    end

    self.battleResultStrengthBox:release()
end

-----------------------------------------------------
BattleReceiveItem = BattleReceiveItem or class("BattleReceiveItem", ggclass.UIBaseItem)

function BattleReceiveItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BattleReceiveItem:onInit()
    self.layoutRes = self:Find("LayoutRes")
    self.imgResIcon = self:Find("LayoutRes/icon", "Image")
    self.txtReceive = self:Find("LayoutRes/txtReceive", "Text")
    self.layoutSoldier = self:Find("LayoutSoldier")
    self.commonItemItem = CommonHeroItem.new(self.layoutSoldier.transform:Find("CommonHeroItem"))
    self.txtSoldier = self:Find("LayoutSoldier/Text", "Text")
end

BattleReceiveItem.TYPE_RES = 1
BattleReceiveItem.TYPE_SOLDIER = 2

-- data = {type = , param1 = , icon = }
function BattleReceiveItem:setData(data)
    local type = data.type
    if type == BattleReceiveItem.TYPE_RES then
        self.layoutRes:SetActiveEx(true)
        self.layoutSoldier:SetActiveEx(false)
        self.txtReceive.text = "x" .. data.param1
        if data.icon then
            local icon = data.icon
            gg.setSpriteAsync(self.imgResIcon, icon)
        end
    elseif type == BattleReceiveItem.TYPE_SOLDIER then
        local soldier = data.param1
        self.layoutRes:SetActiveEx(false)
        self.layoutSoldier:SetActiveEx(true)

        local str = "-" .. soldier.dieCount
        local cfgId = soldier.cfgId

        self.commonItemItem:setQuality(0)
        if SoliderUtil.getSoliderCfgMap()[cfgId] then
            local soldierCfg = SoliderUtil.getSoliderCfgMap()[cfgId][1]
            self.commonItemItem:setIcon("Soldier_A_Atlas", soldierCfg.icon)
        elseif HeroUtil.getHeroCfgMap()[cfgId] then
            local subCfg
            for key, value in pairs(HeroUtil.getHeroCfgMap()[cfgId]) do
                subCfg = value[1]
                break
            end
            self.commonItemItem:setIcon("Hero_A_Atlas", subCfg.icon)
        end

        self.txtSoldier.text = str
    end
end