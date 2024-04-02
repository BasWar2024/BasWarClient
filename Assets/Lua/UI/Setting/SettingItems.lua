ProducerItem = ProducerItem or class("ProducerItem", ggclass.UIBaseItem)

function ProducerItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function ProducerItem:onInit()
    self.txtDute = self:Find("TxtDute", "Text")
    self.txtName = self:Find("TxtName", "Text")
end

function ProducerItem:setData(dute, name)
    self.txtDute.text = dute
    self.txtName.text = name
end