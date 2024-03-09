
PnlInstituteView = class("PnlInstituteView")

PnlInstituteView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent("Text")

    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.btnTopList = {}
    for i = 1, 3 do
        self.btnTopList[i] = transform:Find("Root/TopBtns/btnTop" .. i).gameObject
    end

    self.typeViewList = {}
    self.typeViewList[1] = transform:Find("Root/Force").gameObject
    self.typeViewList[2] = transform:Find("Root/LandMines").gameObject
    self.typeViewList[3] = transform:Find("Root/Drawings").gameObject

    self.scRectForce = transform:Find("Root/Force/scRectForce"):GetComponent("ScrollRect")
    self.scRectMines = transform:Find("Root/LandMines/scRectMines"):GetComponent("ScrollRect")
    self.scRectDrawing = transform:Find("Root/Drawings/scRectDrawing"):GetComponent("ScrollRect")

    self.drawItemList = {}
    for i = 1, 3 do
        self.drawItemList[i] = InstituteDrawItem.new(self.scRectDrawing.content.transform:GetChild(i - 1))
    end
end

return PnlInstituteView