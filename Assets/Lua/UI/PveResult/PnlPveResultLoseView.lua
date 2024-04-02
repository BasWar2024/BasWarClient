
PnlPveResultLoseView = class("PnlPveResultLoseView")

PnlPveResultLoseView.ctor = function(self, transform)

    self.transform = transform
    -- self.imgLine = transform:Find("Root/Text/ImgLine"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.btnConfirm = transform:Find("Root/BtnConfirm").gameObject

    self.pveResultStarBox = transform:Find("Root/PveResultStarBox")

    self.btnReturnBase = transform:Find("Root/BtnReturnBase")

    self.battleResultStrengthBox = transform:Find("Root/BattleResultStrengthBox")

    self.battleCasualtiesBox = transform:Find("Root/BattleCasualtiesBox")
end

return PnlPveResultLoseView