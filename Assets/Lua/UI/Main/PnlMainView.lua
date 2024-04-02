
PnlMainView = class("PnlMainView")

PnlMainView.ctor = function(self, transform)

    self.transform = transform
    
    self.btnMap = transform:Find("BtnMap").gameObject
    self.btnChat = transform:Find("BtnChat").gameObject
    self.btnBuild = transform:Find("BtnBuild").gameObject

    self.muneButton = transform:Find("MuneButton").gameObject

    self.btnTask = transform:Find("BtnTask").gameObject

    self.btnRankingList = transform:Find("BtnRankingList").gameObject

    self.btnQuickTrain = transform:Find("BtnQuickTrain").gameObject
    self.btnInstantTrain = transform:Find("BtnInstantTrain").gameObject

    -- self.bulidShop = transform:Find("BuildShop").gameObject
    self.listRes = transform:Find("ListRes")
    self.msgBuilding = transform:Find("MsgBuilding")

    self.bubbleBoatRes = transform:Find("ListRes/BubbleBoatRes")

    -- self.buildSpine = transform:Find("BtnBuild/Spine").gameObject:GetComponent(SPINE_UNIET_SKELETONGRAPHIC)
    -- self.shopSpine = transform:Find("BtnShop/Spine").gameObject:GetComponent(SPINE_UNIET_SKELETONGRAPHIC)
    -- self.matchSpine = transform:Find("BtnMatch/Spine").gameObject:GetComponent(SPINE_UNIET_SKELETONGRAPHIC)
    -- self.mapSpine = transform:Find("BtnMap/Spine").gameObject:GetComponent(SPINE_UNIET_SKELETONGRAPHIC)
    -- self.pveSpine = transform:Find("BtnPVE/Spine").gameObject:GetComponent(SPINE_UNIET_SKELETONGRAPHIC)

    self.btnEdit = transform:Find("BtnEdit").gameObject
    

    self.btnTaskSmall = transform:Find("BtnTask/BtnTaskSmall").gameObject
    self.scrollViewTask = transform:Find("BoxTasks/ScrollViewTask")
    self.boxTasks = transform:Find("BoxTasks").gameObject
    self.txtTaskFinish = transform:Find("BoxTasks/TxtTaskFinish"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnHyList = transform:Find("LayoutActivity/BtnHyList").gameObject
    self.btnActivity = transform:Find("LayoutActivity/BtnActivity").gameObject
    self.btnNewPlayerDay7Act = transform:Find("LayoutActivity/BtnNewPlayerDay7Act").gameObject
    self.btnShop = transform:Find("LayoutActivity/BtnShop").gameObject
end

return PnlMainView