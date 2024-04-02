
PnlGuideView = class("PnlGuideView")

PnlGuideView.ctor = function(self, transform)

    self.transform = transform
    self.layouClick = self.transform:Find("LayouClick")
    self.mask = self.layouClick:Find("Mask"):GetComponent("HollowOutMask")
    self.btn = self.layouClick:Find("Btn").gameObject
    self.btnSkip = self.layouClick:Find("BtnSkip").gameObject
    self.imgSlider = self.btnSkip.transform:Find("ImgSlider"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.imgBtn = self.btn.transform:GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgBtnInside = self.btn.transform:Find("ImgBtnInside"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.layourArrow = self.transform:Find("LayouClick/LayourArrow")

    self.layourDesc = self.transform:Find("LayouClick/LayourDesc")
    self.textDesc =  self.layourDesc:Find("TextDesc"):GetComponent(typeof(CS.TextYouYU))

    self.transReplace = self.layouClick:Find("TransReplace")
    self.layoutTalk = self.transform:Find("LayoutTalk")

    self.layoutLeft = self.layoutTalk:Find("LayoutLeft")
    self.txtLeftTalk = self.layoutLeft:Find("TxtTalk"):GetComponent(typeof(CS.TextYouYU))

    self.layoutRight = self.layoutTalk:Find("LayoutRight")
    self.txtRightTalk = self.layoutRight:Find("TxtTalk"):GetComponent(typeof(CS.TextYouYU))
end

return PnlGuideView