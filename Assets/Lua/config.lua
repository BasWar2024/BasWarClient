return {
    debug = true, -- ""
    appId = "sw", -- ""id
    appKey = "secretStarWar2021", -- ""key

    loglevel = "debug", -- "": debug/trace/info/warn/error/fataljj

    autoCreateRole = true, -- ""
    autoEnterGame = true, -- ""

    enterGameAfterCreateRole = true, -- ""
    loginAfterRegister = true, -- true=""

    -- protoType=protobuf/sproto/json
    protoType = "protobuf",
    protobufConfig = {
        pbfile = "etc/proto/protobuf/all.pb",
        idfile = "etc/proto/protobuf/message_define.lua"
    },
    sprotoConfig = {
        c2s = "etc/proto/sproto/all.spb",
        s2c = "etc/proto/sproto/all.spb",
        binary = true
    },
    jsonConfig = {},
    gameServer = {
        gateType = "tcp",
        handshake = true
    },
    kcpWndSize = 256,
    kcpMtu = 256
}
