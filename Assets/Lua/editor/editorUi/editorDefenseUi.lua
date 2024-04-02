editorDefenseUi = class("editorDefenseUi", ggclass.UIBase)

function editorDefenseUi:ctor(normalNode)
    self.normalNode = normalNode
    self.pnlBuild = self.normalNode.transform:Find("DefenseUi/PnlBuild")
end

function editorDefenseUi:creatPnlBuild()
    
end

function editorDefenseUi:loadCardModle()
    
end


return editorDefenseUi