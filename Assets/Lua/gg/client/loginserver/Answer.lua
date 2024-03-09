local Answer = {
    code = {},
    message = {},
}

function Answer.response(code)
    assert(code)
    return {
        code = code,
        message = Answer.message[code],
    }
end

local function _(name,code,message)
    Answer.code[name] = code
    Answer.message[code] = message
end


_("OK",0,"OK")
-- [-10000,-20000)
_("APPID_NOEXIST",-10001,"APPID")
_("SIGN_ERR",-10002,"")
_("TOO_BUSY",-10003,"")
_("PARAM_ERR",-10004,"")
_("FAIL",-10005,"")

-- [-20000,-30000)
_("PASSWD_NOMATCH",-20001,"")
_("ACCT_FMT_ERR",-20002,"")
_("NAME_ERR",-20003,"")
_("ACCT_EXIST",-20004,"")
_("ACCT_NOEXIST",-20005,"")
_("ROLE_EXIST",-20006,"")
_("ROLE_NOEXIST",-20007,"")
_("NAME_EXIST",-20008,"")
_("ROLETYPE_ERR",-20009,"")
_("REPEAT_LOGIN",-20010,"")
_("ROLE_OVERLIMIT",-20011,"")
_("PASSWD_FMT_ERR",-20012,"")
_("PLATFORM_UNAUTH",-20013,"")
_("BAN_ACCT",-20014,"")
_("BAN_IP",-20015,"IP")
_("SERVER_REDIRECT",-20016,"")
_("CHANNEL_ERR",-20017,"")
_("BAN_ROLE",-20018,"")
_("SEX_ERR",-20019,"")
_("TOKEN_TIMEOUT",-20020,"TOKEN")
_("LOW_VERSION",-20021,"")
_("CLOSE_CREATEROLE",-20022,"")
_("ROLE_TOO_MUCH",-20023,"")
_("ROLE_FMT_ERR",-20024,"")
_("TOKEN_UNAUTH",-20025,"TOKEN")
_("SERVER_FMT_ERR",-20026,"")
_("SERVER_NOEXIST",-20027,"")
_("PLEASE_LOGIN_FIRST",-20028,"")
_("REPEAT_ENTERGAME",-20029,"")
_("REPEAT_NAME",-20030,"")
_("INVALID_NAME",-20031,"")
_("CLOSE_ENTERGAME",-20032,"")
_("SDK_NOEXIST",-20033,"SDK")
_("PLATFORM_NOEXIST",-20034,"")
_("UNSUPPORT_PLATFORM",-20035,"")
_("TIMEOUT",-20036,"")
_("UNSUPPORT_SDK",-20037,"SDK")
_("REALNAME_FMT_ERR",-20040,"")
_("IDCARD_FMT_ERR",-20041,"")
_("REALNAME_AREADY_AUTH",-20042,"")
_("PLATFORM_ERR",-20043,"")
_("PAY_PRODUCT_NO_EXIST",-20044,"")
_("PAY_ORDER_NO_EXIST",-20045,"")
_("PAY_ORDER_AREADY_SETTLE",-20046,"")
_("NAME_TOO_SHORT",-20047,"")
_("NAME_TOO_LONG",-20048,"")
_("NAME_FMT_ERR",-20049,"")
_("SERVER_STARTING",-20050,"")
_("SERVER_STOPING",-20051,"")
_("ACCOUNT_ADDICT",-20052,"")
_("NOT_A_TEMP_ACCOUNT",-20052,"")

return Answer
