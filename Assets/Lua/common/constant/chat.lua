constant.CHAT_TYPE_WORLD = 1
constant.CHAT_TYPE_UNION = 2

function constant.initChatConstant()
    constant.CHAT_CHANNEL_INFO = {
        [constant.CHAT_TYPE_WORLD] = {
            autoPushKey = constant.AUTOPUSH_CFGID_CAHT_WORLD_NEW,
            redPointKey = RedPointChatWorld.__name,
        },
    
        [constant.CHAT_TYPE_UNION] = {
            autoPushKey = constant.AUTOPUSH_CFGID_CAHT_UNION_NEW,
            redPointKey = RedPointChatUnion.__name,
        }
    }
end

