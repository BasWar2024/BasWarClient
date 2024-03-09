return {
    debug = true,                -- 
    appId = "sw",                -- id
    appKey = "secret",           -- key
    loginServerUrl = "http://192.168.0.70:4000",    -- http
    --:http://8.134.94.169:4000
    --allen:http://192.168.0.222:4000
    --http://192.168.0.28:4000
    --http://192.168.0.70:4000

    --version = "99.99.99",           -- : CS.Appconst.RemoteVersion
    platform = "local",             -- ,local=
    sdk = "local",                  -- sdk
    loglevel = "debug",             -- : debug/trace/info/warn/error/fatal

    autoCreateRole = true,              -- 
    autoEnterGame = true,               -- 
    enterGameAfterCreateRole = true,    -- 
    loginAfterRegister = true,          -- true=

    -- protoType=protobuf/sproto/json
    protoType = "protobuf",
    protobufConfig = {
        pbfile = "etc/proto/protobuf/all.pb",
        idfile = "etc/proto/protobuf/message_define.lua",
    },
    sprotoConfig = {
        c2s = "etc/proto/sproto/all.spb",
        s2c = "etc/proto/sproto/all.spb",
        binary = true,
    },
    jsonConfig = {
    },
    gameServer = {
        gateType = "tcp",
        handshake = true,
    },
    kcpWndSize = 256,
    kcpMtu = 256,
}
