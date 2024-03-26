FilterWords = FilterWords or {}

function FilterWords.filterWords(str)
    for index, value in ipairs(cfg.filterWords) do
        local matchWord = value.word
        str = FilterWords.recursiveReplace(str, matchWord)
        -- local startByte, endByte = string.find(str, matchWord)
        -- if startByte ~= nil and endByte ~= nil and endByte >= startByte then
        --     --local rep = FilterWords.getReplaceStr(matchWord)
        --     -- local rep = FilterWords.getReplaceStr(string.sub(str, startByte, endByte))
        --     -- str = string.gsub(str, matchWord, rep)
        -- end
    end
    return str
end

function FilterWords.isExistSensitiveWord(str)
    for index, value in ipairs(cfg.filterWords) do
        local matchWord = value.word
        local startByte, endByte = string.find(string.upper(str), string.upper(matchWord))
        if startByte ~= nil and endByte ~= nil and endByte >= startByte then
            return true, string.sub(str, startByte, endByte) --matchWord
        end
    end
    return false
end

function FilterWords.getReplaceStr(str)
    local lenth = string.utf8len(str)
    local rep = ""
    for i = 1, lenth do
        rep = rep .. "*"
    end
    return rep
end

function FilterWords.recursiveReplace(str, matchWord)
    local startByte, endByte = string.find(string.upper(str), string.upper(matchWord))
    if startByte ~= nil and endByte ~= nil and endByte >= startByte and string.len(matchWord) == endByte - startByte + 1 then
        local rep = FilterWords.getReplaceStr(string.sub(str, startByte, endByte))
        str = string.gsub(str, matchWord, rep, 1)
        return FilterWords.recursiveReplace(str, matchWord)
    end
    return str
end
