local c = require "i18n.core"
local i18n = setmetatable({},{__index = c})

function i18n.init(option)
    i18n.original_lang = assert(option.original_lang)
    i18n.lang_id = option.lang_id or {}
    i18n.text_id = {}
    local translate_size = 0
    local nlang = 0
    local langs = {}
    if not next(i18n.lang_id) then
        for k,dict in pairs(option.languages) do
            if #langs == 0 then
                for lang in pairs(dict) do
                    if lang ~= i18n.original_lang then
                        langs[#langs + 1] = lang
                    end
                end
            end
            translate_size = translate_size + 1
        end
        table.sort(langs)
        -- original lang id fixed 0
        table.insert(langs,1,i18n.original_lang)
        nlang = #langs
        for id,lang in ipairs(langs) do
            i18n.lang_id[lang] = id - 1
        end
    else
        i18n.lang_id[i18n.original_lang] = 0
        for lang,id in pairs(i18n.lang_id) do
            if id > nlang then
                nlang = id
            end
        end
    end
    i18n.cobj = c.new(nlang,translate_size+1)
    local id
    local sort = true
    local texts = {}
    for k,dict in pairs(option.languages) do
        for lang,v in pairs(dict) do
            if lang == i18n.original_lang then
                id = tonumber(v)
                if id then
                    sort = false
                    texts[id] = k
                else
                    texts[#texts + 1] = k
                end
            end
        end
    end
    if sort then
        table.sort(texts)
    end
    for id,text in ipairs(texts) do
        i18n.cobj:add_text(text,id)
        i18n.text_id[text] = id
    end

    for k,dict in pairs(option.languages) do
        for lang,v in pairs(dict) do
            if lang ~= i18n.original_lang then
                local lang_id = i18n.lang_id[lang]
                local from = i18n.get_text_id(k)
                if v and v ~= "" then
                    local to = i18n.get_text_id(v)
                    i18n.cobj:add_translate(lang_id,from,to)
                end
            end
        end
    end
end

function i18n.format_list(fmt,args,replace_dict)
    local fmt_id = fmt
    if type(fmt) == "string" then
        fmt_id = i18n.get_text_id(fmt)
    end
    local cargs = {}
    if args then
        for i,arg in ipairs(args) do
            if i18n.is_i18n_text(arg) then
                cargs[i] = arg
            else
                cargs[i] = tostring(arg)
            end
        end
    end
    return i18n.cobj:format(fmt_id,cargs,replace_dict)
end

function i18n.format(fmt,...)
    local replace_dict = ...
    if type(replace_dict) == "table" then
        return i18n.format_list(fmt,nil,replace_dict)
    end
    local args = table.pack(...)
    return i18n.format_list(fmt,args)
end

function i18n.translateto(lang,i18n_text)
    if not i18n.is_i18n_text(i18n_text) then
        return i18n_text
    end
    local lang_id = assert(i18n.lang_id[lang],lang)
    return i18n.cobj:translateto(lang_id,i18n_text)
end

function i18n.free_text(i18n_text)
    i18n.cobj.free_text(i18n_text)
end

-- private method
function i18n.get_text_id(text)
    local id = i18n.text_id[text]
    if not id then
        id = i18n.cobj:add_text(text)
        i18n.text_id[text] = id
    end
    return id
end

function i18n.is_i18n_text(obj)
    if type(obj) == "userdata" then
        local meta = getmetatable(obj)
        if meta and meta.__name == "i18n_text" then
            return true
        end
    end
    return false
end

return i18n