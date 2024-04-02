RedPointManager = RedPointManager or {} --class("RedPointManager")
--"" onRedPointChange

local redPointClassList = {
    -- ggclass.RedPointHeroUpgrade,
    --     ggclass.RedPointTest2,
    --     ggclass.RedPointTest3,

    ggclass.RedPointMail,

    ggclass.RedPointPnlBuild,
        ggclass.RedPointBuildEconomic,
        ggclass.RedPointBuildDevelopment,
        ggclass.RedPointBuildDefense,

    -- ggclass.RedPointAchievement,

    ggclass.RedPointTask,
        ggclass.RedPointChapterTask,
        ggclass.RedPointBranchTask,
        ggclass.RedPointDailyTask,

    ggclass.RedPointChat,
        ggclass.RedPointChatWorld,
        ggclass.RedPointChatUnion,

    ggclass.RedPointMainMenu,
        ggclass.RedPointDrawCard,
        ggclass.RedPointUnion,
            ggclass.RedPointUnionMint,
            ggclass.RedPointUnionInvite,
            ggclass.RedPointUnionMember,
                ggclass.RedPointUnionApply,
        ggclass.RedPointHeadquarters,
            ggclass.RedPointHeadquartersSwitch,
                ggclass.RedPointHeadquartersWarship,
                ggclass.RedPointHeadquartersHero,
                ggclass.RedPointHeadquartersNewBuild,
        ggclass.RedPointItemBag,
            ggclass.RedPointItemBagNft,
            ggclass.RedPointItemBagDao,
            ggclass.RedPointItemBagItem,
            ggclass.RedPointItemBagSkillCard,
        ggclass.RedPointPve,
            ggclass.RedPointPveDailyRewardFetch,
        

    ggclass.RedPointActivity,
        ggclass.RedPointDailyCheckIn,
        ggclass.RedPointAccruingTes,
            ggclass.RedPointAccruing3Times,
            ggclass.RedPointAccruing5Times,
        ggclass.RedPointActFirstCharge,
        ggclass.RedPointActRecharge,

        ggclass.RedPointNewPlayerLogin,
}

function RedPointManager:init()
    self.redPointMap = {}
    for index, value in ipairs(redPointClassList) do
        self.redPointMap[value.__name] = value.new()
    end
end

function RedPointManager:clear()
    for key, value in pairs(self.redPointMap) do
        value.redMap = {}
        value.isRed = false
    end
end

function RedPointManager:setSubRed(name, childName, isRed)
    if self.redPointMap[name] then
        self.redPointMap[name]:setRed(childName, isRed)
    end
end
-------------------------------------------------------------------------------
function RedPointManager:getIsRed(name)
    if self.redPointMap[name] then
        return self.redPointMap[name].isRed
    end
    return false
end

function RedPointManager:setRedPoint(gameObject, isRed)
    if not gameObject then
        return
    end
    gameObject = gameObject.gameObject
    
    self.redPointImgMap = self.redPointImgMap or {}
    self.redPointImgMap[gameObject] = self.redPointImgMap[gameObject] or {}
    self.redPointImgMap[gameObject].isRed = isRed

    -- local imgRed = self.redPointImgMap[gameObject].imgRed
    local imgRed = gameObject.transform:Find("ImgCommonRedPoint")
    if imgRed then
        imgRed:SetActiveEx(isRed)
        return
    end

    if not self.redPointImgMap[gameObject].loading then
        self.redPointImgMap[gameObject].loading = true
        ResMgr:LoadGameObjectAsync("ImgCommonRedPoint",function (go)
            if not gameObject or not self.redPointImgMap[gameObject] then
                return false
            end
            
            self.redPointImgMap[gameObject].imgRed = go
            self.redPointImgMap[gameObject].loading = false
            go.transform:SetParent(gameObject.transform, false)
            go.transform.anchoredPosition = CS.UnityEngine.Vector2(0, 0)
            go:SetActiveEx(self.redPointImgMap[gameObject].isRed)
            go.name = "ImgCommonRedPoint"
            return true
        end)
    end
end

function RedPointManager:releaseRedPoint(gameObject)
    if not self.redPointImgMap[gameObject] then
        return
    end
    gameObject = gameObject.gameObject

    if self.redPointImgMap[gameObject].imgRed then
        ResMgr:ReleaseAsset(self.redPointImgMap[gameObject].imgRed)
    end
    self.redPointImgMap[gameObject] = nil
end

function RedPointManager:releaseAllRedPoint()
    for key, value in pairs(self.redPointImgMap) do
        if value.imgRed then
            ResMgr:ReleaseAsset(value.imgRed)
        end
    end

    self.redPointImgMap = {}
end
