
PnlRankView = class("PnlRankView")

PnlRankView.ctor = function(self, transform)
    self.transform = transform
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.tmpDesc = transform:Find("Root/TmpDesc"):GetComponent("TextMeshProUGUI")
    self.scrollView = UIScrollView.new(transform:Find("Root/RankScrollView"), "RankItem")

    self.rankItemList = {}
    self.loopScrollView = UILoopScrollView.new(transform:Find("Root/RankScrollView2"))

    self.topBtnList = {}
    for i = 1, 3 do
        local item = {}
        self.topBtnList[i] = item
        item.gameObject = transform:Find("Root/TopBtns/BtnTop" .. i).gameObject
        item.image = item.gameObject:GetComponent("Image")
        item.imgIcon = item.gameObject.transform:Find("Icon"):GetComponent("Image")
    end
end

return PnlRankView