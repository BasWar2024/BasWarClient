util = util or {}

function util.cryptPassword(password)
    local password = password .. "starwar"
    return string.lower(CryptUtil.MD5Encrypt16(password))
end

function util.saveAccountPassword(account, password)
    UnityEngine.PlayerPrefs.SetString(constant.BASE_LOGIN_ACCOUNT, account)
    UnityEngine.PlayerPrefs.SetString(constant.BASE_LOGIN_PASSWORD, password)
end

function util.loadAccountPassword()
    local account = UnityEngine.PlayerPrefs.GetString(constant.BASE_LOGIN_ACCOUNT, "")
    local password = UnityEngine.PlayerPrefs.GetString(constant.BASE_LOGIN_PASSWORD, "")
    return account, password
end

-- accountList = {{account = , password = }}
function util.saveAccounts(accountList)
    local accountStr = "<one><a>%s</a><p>%s</p></one>"
    local saveStr = ""

    for i = 1, 10, 1 do
        local value = accountList[i]
        if value then
            saveStr = saveStr .. string.format(accountStr, value.account, value.password)
        end
    end

    -- for index, value in ipairs(accountList) do
    --     saveStr = saveStr .. string.format(accountStr, value.account, value.password)
    -- end

    UnityEngine.PlayerPrefs.SetString(constant.BASE_LOGIN_ACCOUNT_LIST, saveStr)
end

function util.addOneSaveAccount(account, password)
    for i = #gg.client.loginServer.accounts, 1, -1 do
        local data = gg.client.loginServer.accounts[i]
        if data.account == account then
            table.remove(gg.client.loginServer.accounts, i)
        end
    end

    table.insert(gg.client.loginServer.accounts, 1, {account = account, password = password})
    util.saveAccounts(gg.client.loginServer.accounts)
    gg.event:dispatchEvent("onSaveAccountChange")
end

function util.removeOneSaveAccount(account)
    for i = #gg.client.loginServer.accounts, 1, -1 do
        local data = gg.client.loginServer.accounts[i]
        if data.account == account then
            table.remove(gg.client.loginServer.accounts, i)
        end
    end
    util.saveAccounts(gg.client.loginServer.accounts)
    gg.event:dispatchEvent("onSaveAccountChange")
end

util.ACCOUNT_PATTERN = "<a>(.+)</a>"
util.PASSWORD_PATTERN = "<p>(.+)</p>"
util.ONE_ACCOUNT_PATTERN = "<one>.-</one>"

function util.getAccounts()
    local accountStr = UnityEngine.PlayerPrefs.GetString(constant.BASE_LOGIN_ACCOUNT_LIST, "")
    local accountList = {}

    for w in string.gmatch(accountStr, util.ONE_ACCOUNT_PATTERN) do
        local account = string.match(w, util.ACCOUNT_PATTERN)
        local password = string.match(w, util.PASSWORD_PATTERN)
        table.insert(accountList, {account = account, password = password})
    end
    
    return accountList
end

function util.saveRemember(isRemember)
    if isRemember then
        UnityEngine.PlayerPrefs.SetInt(constant.BASE_LOGIN_REMEMBER, 1)
    else
        UnityEngine.PlayerPrefs.SetInt(constant.BASE_LOGIN_REMEMBER, 0)
    end
end

function util.loadRemember()
    local isRemember = UnityEngine.PlayerPrefs.GetInt(constant.BASE_LOGIN_REMEMBER)
    return isRemember == 1
end

function util.copyWord(str)
    UnityEngine.GUIUtility.systemCopyBuffer = str
end

function util.setDetail(status)
    UnityEngine.PlayerPrefs.SetInt(constant.BASE_DETAIL_STATUS, status)
end

function util.getDetail()
    local status = UnityEngine.PlayerPrefs.GetInt(constant.BASE_DETAIL_STATUS)
    return status == 1
end

function util.setInstallStatus(status)
    UnityEngine.PlayerPrefs.SetInt(constant.BASE_LOGIN_INSTALL, status)
end

function util.getInstallStatus()
    local status = UnityEngine.PlayerPrefs.GetInt(constant.BASE_LOGIN_INSTALL)
    return status == 1
end

return util