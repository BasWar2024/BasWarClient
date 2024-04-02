BattleCasualtiesBox = BattleCasualtiesBox or class("BattleCasualtiesBox", ggclass.UIBaseItem)

function BattleCasualtiesBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BattleCasualtiesBox:onInit()
    self.txtTitle = self:Find("TxtTitle", UNITYENGINE_UI_TEXT)
    self.imgLine = self:Find("ImgLine", UNITYENGINE_UI_IMAGE)

    self.txtAlert = self:Find("TxtAlert", UNITYENGINE_UI_TEXT)

    self.itemList = {}
    self.scrollView = UIScrollView.new(self:Find("ScrollView"), "BattleCasualtiesBoxItem")
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
end

local COLOR_WIN = UnityEngine.Color(0xff/0xff, 0xff/0xff, 0xcb/0xff, 1)
local COLOR_LOSE = UnityEngine.Color(0x46/0xff, 0xb2/0xff, 0xfd/0xff, 1)

function BattleCasualtiesBox:setIsWin(isWin)
    if isWin then
        self.txtTitle.color = COLOR_WIN
        gg.setSpriteAsync(self.imgLine, "Result_Atlas[line02_icon]")
    else
        self.txtTitle.color = COLOR_LOSE
        gg.setSpriteAsync(self.imgLine, "Result_Atlas[line01_icon]")
    end
end

function BattleCasualtiesBox:onRenderItem(obj, index)
    local item = BattleCasualtiesBoxItem:getItem(obj, self.itemList)
    item:setData(self.soldiers[index])
end

function BattleCasualtiesBox:onRelease()
    self.scrollView:release()
end

-- {SoliderBattleType, }
function BattleCasualtiesBox:setData(soldiers)
    self.soldiers = soldiers
    if #soldiers <= 0 then
        self.txtAlert.transform:SetActiveEx(true)
        self.scrollView.transform:SetActiveEx(false)
        return
    end

    self.txtAlert.transform:SetActiveEx(false)
    self.scrollView.transform:SetActiveEx(true)
    self.scrollView:setItemCount(#soldiers)
end

-------------------------------------------------

BattleCasualtiesBoxItem = BattleCasualtiesBoxItem or class("BattleCasualtiesBoxItem", ggclass.UIBaseItem)

function BattleCasualtiesBoxItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BattleCasualtiesBoxItem:onInit()
    self.commonHeroItem = CommonHeroItem.new(self:Find("CommonHeroItem"))
    self.txtCount = self:Find("TxtCount", UNITYENGINE_UI_TEXT)
end

function BattleCasualtiesBoxItem:onRelease()
    self.commonHeroItem:release()
end

function BattleCasualtiesBoxItem:setData(data)
    self.txtCount.text = data.dieCount

    local soldierCfg = SoliderUtil.getSoliderCfgMap()[data.cfgId][data.level]
    if soldierCfg then
        self.commonHeroItem:setQuality(0)
        self.commonHeroItem:setIcon("Soldier_A_Atlas", soldierCfg.icon)

    else
        self.commonHeroItem:SetActiveEx(false)
    end
end
