PveResultStarBox = PveResultStarBox or class("PveResultStarBox", ggclass.UIBaseItem)
function PveResultStarBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PveResultStarBox:onInit()
    self.layoutStars = self:Find("LayoutStars").transform
    self.starList = {}

    for i = 1, 3 do
        local item = {}
        item.transform = self.layoutStars:GetChild(i - 1)
        item.imgLight = item.transform:Find("ImgLight")
        self.starList[i] = item
    end

    self.layoutStarsDesc = self:Find("LayoutStarsDesc").transform
    self.starDescList = {}
    for i = 1, 3 do
        local item = {}
        item.transform = self.layoutStarsDesc:GetChild(i - 1)
        item.imgLight = item.transform:Find("ImgLight")
        item.text = item.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
        self.starDescList[i] = item
    end
end

-- data = C2S_Player_EndBattle
function PveResultStarBox:setData(data)
    self.data = data

    local cfgId = data.endInfo.cfgId
    local pveCfg = cfg.pve[cfgId]


    local star = data.endInfo.star
    for i = 1, 3 do
        self.starList[i].imgLight:SetActiveEx(i <= star)
        self.starDescList[i].imgLight:SetActiveEx(i <= star)
    end

    self.starDescList[1].text.text = Utils.getText("pve_Settlement_TargetOne")
    self.starDescList[2].text.text = string.format(Utils.getText("pve_Settlement_TargetTwo"), pveCfg.secondStarQuest[2])
    self.starDescList[3].text.text = string.format(Utils.getText("pve_Settlement_TargetThree"), pveCfg.thirdStarQuest[2])
end