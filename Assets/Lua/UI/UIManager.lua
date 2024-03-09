local UIManager = class("UIManager")

function UIManager:ctor()
    self.openWindows = {}               -- 
    self.closeWindows = {}              -- ()
    self.topWindow = nil                -- 
    --self.openWindows = {}
    self.uiRoot = nil

    self.uiRoot = ggclass.UIRoot.new()
    UnityEngine.GameObject.DontDestroyOnLoad(self.uiRoot.gameObject)
end

function UIManager:getWindow(windowName)
    local window = self.openWindows[windowName]
    if not window then
        window = self.closeWindows[windowName]
    end
    return window
end

function UIManager:destroyWindow(windowName)
    local window = self:getWindow(windowName)
    if not window then
        logger.error("destroy error. window name : " .. windowName)
        return
    end
    if window:isShow() then
        logger.error("destroy error. open window destroy : " .. windowName)
        self:closeWindow(windowName)
    else
        self.closeWindows[windowName] = nil
    end
    window:destroy()
end

function UIManager:destroyAllWindows()
    for key, value in pairs(self.openWindows) do
        self:closeWindow(value.name)
    end

    for key, value in pairs(self.closeWindows) do
        value:stopDestroyTimer()
        self:destroyWindow(value.name)
    end
end

function UIManager:openWindow(windowName, args, callback)

    reload(windowName)
    local window = self:getWindow(windowName)
    if not window then
        -- 
        window = ggclass[windowName].new(args, callback)
    else
        window:setArgs(args)
        if window.status < UIState.show then
            return
        end

        window.onOpen = callback
        window:show()
    end
    self.openWindows[windowName] = window
    self.closeWindows[windowName] = nil

    return window
end

function UIManager:closeWindow(windowName)

    local window = self.openWindows[windowName]
    if not window then
        return
    end
    self.closeWindows[windowName] = window
    self.openWindows[windowName] = nil

    window:hide()
end

function UIManager:setUITouch(touch)
    if self.uiRoot.eventSystem then
        self.uiRoot.eventSystem.enabled = touch
    end
end

function UIManager:pushWindow(window)
    if not self.topWindow then
        self.topWindow = window
    else
        window.prevWindow = self.topWindow
        self.topWindow.nextWindow = window
        self.topWindow = window
    end
end

function UIManager:popWindow(window)
    local prevWindow = window.prevWindow
    local nextWindow = window.nextWindow
    if prevWindow then
        prevWindow.nextWindow = nextWindow
    end
    if nextWindow then
        nextWindow.prevWindow = prevWindow
    else
        self.topWindow = prevWindow
    end
end

function UIManager:showTip(txt)
    --local text = i18n.format(txt)
    local window = self:getWindow("PnlTip")
    if not window then
        self:openWindow("PnlTip", txt)
    else
        window:setTipText(txt)
    end
end

return UIManager
