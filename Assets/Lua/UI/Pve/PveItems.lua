
PveDailyRewardItem = PveDailyRewardItem or class("PveDailyRewardItem", ggclass.UIBaseItem)
function PveDailyRewardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PveDailyRewardItem:onInit()
    self.imgIcon = self:Find("ImgIcon", UNITYENGINE_UI_IMAGE)
    self.txtCount = self:Find("TxtCount", UNITYENGINE_UI_TEXT)
end

function PveDailyRewardItem:setData(imgPath, count)
    gg.setSpriteAsync(self.imgIcon, imgPath)
    self.txtCount.text = Utils.getShowRes(count)
end

-------------------------------------------------------------

PveSubRewardBox = PveSubRewardBox or class("PveSubRewardBox", ggclass.UIBaseItem)
function PveSubRewardBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PveSubRewardBox:onInit()
    self.pveRewardItemList = {}
    self.rewardScrollView = UIScrollView.new(self:Find("RewardScrollView"), "PveRewardItem", self.pveRewardItemList)
    self.rewardScrollView:setRenderHandler(gg.bind(self.onRenderRewardItem, self))

    self.imgReceived = self:Find("ImgReceived", UNITYENGINE_UI_IMAGE)
end

function PveSubRewardBox:setData(rewardDataList, isFetch)
    self.rewardDataList = rewardDataList
    self.rewardScrollView:setItemCount(#self.rewardDataList)
    self.imgReceived.transform:SetActiveEx(isFetch)
end

function PveSubRewardBox:onRenderRewardItem(obj, index)
    local item = PveRewardItem:getItem(obj, self.pveRewardItemList)
    local rewardData = self.rewardDataList[index]
    local icon = constant.RES_2_CFG_KEY[rewardData[1]].icon
    item:setData(icon, rewardData[2])
end

function PveSubRewardBox:onRelease()
    self.rewardScrollView:release()
end

---------------------------------------------------------------

PveRewardItem = PveRewardItem or class("PveRewardItem", ggclass.UIBaseItem)
function PveRewardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PveRewardItem:onInit()
    self.imgIcon = self:Find("Bg/ImgIcon", UNITYENGINE_UI_IMAGE)
    self.txtCount = self:Find("TxtCount", UNITYENGINE_UI_TEXT)
end

function PveRewardItem:setData(imgPath, count)
    gg.setSpriteAsync(self.imgIcon, imgPath)
    if count == 0 then
        self:setActive(false)
    else
        self:setActive(true)
    end
    self.txtCount.text = Utils.getShowRes(count)
end

---------------------------------------------------------------

PvePlanetItem = PvePlanetItem or class("PvePlanetItem", ggclass.UIBaseItem)
function PvePlanetItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PvePlanetItem:onInit()
    self.imgIcon = self:Find("ImgIcon", UNITYENGINE_UI_IMAGE)

    self.pvePlanetInfo = self.transform:GetComponent("PVEPlanetInfo")
    self.center = self:Find("ImgIcon/Center")
    self.txtLevel = self:Find("LayoutInfo/TxtLevel", UNITYENGINE_UI_TEXT)

    self.imgDailyReward = self:Find("LayoutInfo/ImgDailyReward")
    self.imgLock = self:Find("LayoutInfo/ImgLock")

    self.layoutStars = self:Find("LayoutInfo/LayoutStars").transform
    self.starList = {}
    for i = 1, 3 do
        local item = {}
        item.transform =  self.layoutStars:GetChild(i - 1)
        item.light = item.transform:Find("ImgLight")
        self.starList[i] = item
    end

    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))

    self.cfgId = self.pvePlanetInfo.CfgId
    self.subCfg = cfg.pve[self.cfgId]

    self.txtLevel.text = self.subCfg.name
    -- self:refresh()
end

function PvePlanetItem:refresh()
    -- local CfgId = 
    self.imgLock.transform:SetActiveEx(false)
    self.imgDailyReward.transform:SetActiveEx(false)

    local passData = BattleData.pvePassMap[self.cfgId]
    if passData then
        for index, value in ipairs(self.starList) do
            value.light:SetActiveEx(passData.star >= index)
        end

        self.imgDailyReward.transform:SetActiveEx(not BattleData.pveDailyRewardMap[self.cfgId])
    else
        for index, value in ipairs(self.starList) do
            value.light:SetActiveEx(false)
        end

        if self.subCfg.preCfgId and not BattleData.pvePassMap[self.subCfg.preCfgId] then
            self.imgLock.transform:SetActiveEx(true)
        end
    end

    -- if not self.subCfg.preCfgId or BattleData.pvePassMap[self.subCfg.preCfgId] then
    --     self.imgLock.transform:SetActiveEx(false)
    --     self.imgDailyReward.transform:SetActiveEx(not BattleData.pveDailyRewardMap[self.subCfg])
    -- else
    --     self.imgLock.transform:SetActiveEx(true)
    --     self.imgDailyReward.transform:SetActiveEx(false)
    -- end
end

function PvePlanetItem:onClickItem()
    self.initData:selectPlanet(self.subCfg, self.center, self.pvePlanetInfo)
end

---------------------------------------------------------------

PveDescLine = PveDescLine or class("PveDescLine", ggclass.UIBaseItem)
function PveDescLine:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PveDescLine:onInit()
    
end

function PveDescLine:setWorldPos(startWorldPos, endWorldPos)
    local vector2 = CS.UnityEngine.Vector2
    local vector3 = CS.UnityEngine.Vector3

    local startPos = self.initData.transform:InverseTransformPoint(startWorldPos)
    local endPos = self.initData.transform:InverseTransformPoint(endWorldPos)

    startPos = vector2(startPos.x, startPos.y)
    endPos = vector2(endPos.x, endPos.y)

    self.transform.anchoredPosition = startPos

    local cross = vector3.Cross(vector3.left, endWorldPos - startWorldPos)
    local angle = vector2.Angle(vector2.left, endPos - startPos)

    if cross.z < 0 then
        angle = -angle
    end

    self.transform.rotation = CS.UnityEngine.Quaternion.Euler(0, 0, angle)

    local distance = vector3.Distance(startWorldPos, endWorldPos)
    self.transform:SetRectSizeX(distance)
end
