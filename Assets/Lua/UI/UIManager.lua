local UIManager = class("UIManager")

function UIManager:ctor()
    self.openWindows = {} -- ""
    self.closeWindows = {} -- ""("")
    self.topWindow = nil -- ""
    -- self.openWindows = {}
    self.uiRoot = nil

    self.uiRoot = ggclass.UIRoot.new()
    UnityEngine.GameObject.DontDestroyOnLoad(self.uiRoot.gameObject)

    -- ""，""
    self.battleLoadingPnl = nil

    self.linkMsg = {}
end

function UIManager:getWindow(windowName)
    local window = self.openWindows[windowName]
    if not window then
        window = self.closeWindows[windowName]
    end
    return window
end

function UIManager:getOpenWindow(windowName)
    return self.openWindows[windowName]
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
        if value.name ~= "PnlTipNode" then
            self:closeWindow(value.name)
        end
    end

    for key, value in pairs(self.closeWindows) do
        if value.name ~= "PnlConnect" or value.name ~= "PnlTipNode" then
            value:stopDestroyTimer()
            self:destroyWindow(value.name)
        end
    end
end

function UIManager:releaseWindow(windowName)
    local window = self:getWindow(windowName)
    if window then
        if window:isShow() then
            window.destroyTime = 0
            window:close()
        else
            self:destroyWindow("PnlMain")
        end
    end
end

function UIManager:openWindow(windowName, args, callback, isNotPlayOpenAni)

    reload(windowName)
    local window = self:getWindow(windowName)
    if not window then
        -- ""
        window = ggclass[windowName].new(args, callback)
        self.openWindows[windowName] = window
        self.closeWindows[windowName] = nil
        window:setIsNotPlayOpenAni(isNotPlayOpenAni)
    else
        window:setArgs(args)
        if window.status < UIState.show then
            return
        end

        self.openWindows[windowName] = window
        self.closeWindows[windowName] = nil
        window.onOpen = callback
        window:setIsNotPlayOpenAni(isNotPlayOpenAni)
        window:show()
    end

    return window
end

function UIManager:closeWindow(windowName, destroyTime)

    local window = self.openWindows[windowName]
    if not window then
        return
    end
    self.closeWindows[windowName] = window
    self.openWindows[windowName] = nil
    if destroyTime then
        window.destroyTime = destroyTime
    end
    window:hide()
end

function UIManager:refreshWindow(windowName, ...)
    local window = self.openWindows[windowName]
    if not window then
        return
    end
    window:refresh(...)
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
    local text = tostring(i18n.format(txt))

    local window = self:getWindow("PnlTip")
    if not window then
        self:openWindow("PnlTip", text)
    else
        window:setTipText(text)
    end
end

function UIManager:showTipsNode(content, nodeName, pos)
    content = tostring(i18n.format(content))

    local window = self:getWindow("PnlTipNode")
    if window then
        window:showTipsNode(content, nodeName, pos)
    end
end

function UIManager:onOpenPnlLink(msg, isAlpha, isAutoClose, closeSec, callback)
    self:openWindow("PnlLink", {
        isAutoClose = isAutoClose or true,
        closeSec = closeSec,
        callback = callback,
        isAlpha = isAlpha,
        msg = msg
    })
    self.linkMsg[msg] = msg
end

function UIManager:onClosePnlLink(msg)
    if msg == "ClearAll" then
        self.linkMsg = {}
        local window = self:getWindow("PnlLink")
        if window then
            window:closeWindow()
        end
    end
    if self.linkMsg[msg] then
        self.linkMsg[msg] = nil
        local num = 0
        for k, v in pairs(self.linkMsg) do
            num = num + 1
        end
        if num == 0 then
            local window = self:getWindow("PnlLink")
            if window then
                window:closeWindow()
            end
        end
    end
end

function UIManager:showBattleError(code)
    local callbackYes = function()
        self:closeWindow("PnlBattle")
        self:onClosePnlLink("ClearAll")
        BattleData.setIsBattleEnd(true)
        AudioFmodMgr:ClearBattleBank()
        AudioFmodMgr:PauseBgm(false)
        local window = gg.uiManager:getWindow("PnlConnect")
        if not window or window.status ~= UIState.show then
            BattleUtil.returnFromResult()
        else
            self:destroyAllWindows()
            gg.battleManager.newBattleData:Release()

            BattleData.setIsBattleEnd(true)
            AudioFmodMgr:ClearBattleBank()
            gg.sceneManager:releaseBattleMono()

            returnLogin()
        end
    end

    local args = {
        txt = "battle not end completely. \n Error code:" .. code,
        callbackYes = callbackYes,
        txtYes = "Go Back",
        closeType = 0
    }
    self:openWindow("PnlAlert", args)

end

return UIManager
