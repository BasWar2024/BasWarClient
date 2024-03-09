gg = gg or {}

gg.config = require "config"

function gg.genI18nTexts()
    local readfile = function (filename,onLoad)
        xlua:LoadTextAsset(filename,function (textAsset)
            local cjson = require "cjson"
            local data = textAsset.bytes
            local texts = cjson.decode(data)
            if onLoad then
                onLoad(texts)
            end
        end)
    end
    local languages = {}
    readfile("etc/i18n/en_US.json",function (en_US)
        for k,v in pairs(en_US) do
            if not languages[k] then
                languages[k] = {}
            end
            languages[k].en_US = v
        end
    end)
    readfile("etc/i18n/zh_TW.json",function (zh_TW)
        for k,v in pairs(zh_TW) do
            if not languages[k] then
                languages[k] = {}
            end
            languages[k].zh_TW = v
        end
    end)
    readfile("etc/i18n/zh_CN.json",function (zh_CN)
        for k,v in pairs(zh_CN) do
            if not languages[k] then
                languages[k] = {}
            end
            languages[k].zh_CN = v
        end
    end)
    return languages
end

function gg.initI18n()
    i18n.init({
        original_lang = "zh_CN",
        languages = gg.genI18nTexts()
    })
end

return gg