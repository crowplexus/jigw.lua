local TRIM_PATTERN = "^%s*(.-)%s*$"
local NO_BRACKETS_PATTERN = "[%[%]]"
local NO_QUOTE_PATTERN = "[\"']"
local split_t

local function gsplit(s) table.insert(split_t, s) end
local function split(str, sep, t)
    split_t = t or {}
    string.gsub(str, (sep and sep ~= "") and "([^" .. sep .. "]+)" or ".", gsplit)
    return split_t
end

local function first(str, pat) return string.sub(str, 1, 1) == pat end
local function last(str, pat) return string.sub(str, #str - #pat + 1, #str) == pat end
local function trim(str) return string.match(str, TRIM_PATTERN) end

local function tovalue(x)
    x = trim(string.gsub(string.gsub(x, "\"", ""), "'", ""))
    if tonumber(x) then return tonumber(x) end
    if x == "true" then return true end
    if x == "false" then return false end

    if first(x, "[") and last(x, "]") then -- this only supports 1 line arrays for now
        local xm = string.gsub(x, "[%[%]]", "")
        local t = {}
        for k, v in pairs(split(xm, ",")) do t[k] = trim(v) end
        --print(t)
        return t
    end
    return x
end

--- Parser for cfg, ini, and toml plain text config files.
local plaincfg = {}

--- Parses the content of a plain text config file.
--- @param content string  The content of the file.
function plaincfg.parse(content)
    local file = {}
    local contable = split(content, "\n")
    local category = ""

    for i = 1, #contable do
        local line = contable[i]
        local isComment = first(line, "#")
        if line == "" or isComment then
            if isComment then -- saving the comments just in case
                file.comments = file.comments or {}
                local comment = string.match(string.gsub(line, "#", ""), TRIM_PATTERN)
                file.comments[#file.comments + 1] = string.gsub(comment, NO_QUOTE_PATTERN, "")
            end
        else
            local keyv = split(string.match(line, TRIM_PATTERN), "=")
            if #keyv == 1 then
                category = string.gsub(keyv[1], NO_BRACKETS_PATTERN, "")
                local nested = split(category, ".")
                local current = file
                for j = 1, #nested do
                    local subcat = nested[j]
                    --print("next category is " .. nested[1] .. "." .. subcat)
                    current[subcat] = current[subcat] or {}
                    current = current[subcat]
                end
            end
            -- place values
            if #keyv > 1 then
                local current = file
                local nested = split(category, ".")
                for j = 1, #nested do current = current[nested[j]] end
                current[keyv[1]] = tovalue(keyv[2])
                --print("added key " .. keyv[1] .. " to " .. cat .. " in plaincfg file")
            end
        end
    end

    return file
end

return plaincfg
