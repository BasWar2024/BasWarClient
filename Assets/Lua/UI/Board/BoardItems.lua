NewsItem = NewsItem or class("NewsItem", ggclass.UIBaseItem)

function NewsItem:ctor(obj)
    UIBaseItem.ctor(self, obj)
end

function NewsItem:onInit()
    self.text = self:Find("Text", "Text")
    self.image = self:Find("Image", "Image")
    self.txtDesc = self:Find("TxtDesc", "Text")
    -- self:setOnClick(self.image.gameObject, gg.bind(self.onClickImg, self))
end

function NewsItem:onClickImg()
    CS.UnityEngine.Application.OpenURL(self.data.url)
end

function NewsItem:setData(data)
    self.data = data
    self:downLoadSprite(data.imageUrl)
    self.txtDesc.text = data.text
end

function NewsItem:downLoadSprite(url)
    if self.coroutine then
        gg.httpComponent:cancelCoroutine(self.coroutine)
    end
    self.coroutine, self.uwr = CS.DownloadUtils.DownloadSprite(url, function (sprite, error)
        if error then
            print(error)
            self:downLoadSprite(url)
            return
        end
        self.image.sprite = sprite
        self.coroutine = nil
        gg.timer:stopTimer(self.progressTimer)
        self.text.text = "100%"
    end)
    gg.timer:stopTimer(self.progressTimer)
    self.progressTimer = gg.timer:startLoopTimer(0, 0.01, 999999999, function ()
        self.text.text = (self.uwr.downloadProgress - self.uwr.downloadProgress % 0.0001) * 100 .. "%"
    end)
end

function NewsItem:onRelease()
    if self.coroutine then
        gg.httpComponent:cancelCoroutine(self.coroutine)
    end
    gg.timer:stopTimer(self.progressTimer)
end
---------------------------------------------------------------------
NewsCountItem = NewsCountItem or class("NewsCountItem", ggclass.UIBaseItem)

function NewsCountItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function NewsCountItem:onInit()
    self.imgLight = self:Find("imgLight", "Image")
    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self))
end

function NewsCountItem:setData(index)
    self.index = index
end

function NewsCountItem:setSelect(isActive)
    self.imgLight.transform:SetActiveEx(isActive)
end

function NewsCountItem:onBtnItem()
    self.initData:setNewsIndex(self.index)
end
