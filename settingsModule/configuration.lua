configuration = {}

PropertiesName = {
    startStep = "startStep",
    count = "count",
    startHeight = "startHeight"
}

defaultProperties = {
    startStep = "1",
    count = "6",
    startHeight = "2"
}
PropertiesPath = "resuorces/setting.properties"

local tablePrintSymb = "."

function configuration.Print_Table (t) 
    local maxLength = 0
    for k, v in pairs (t) do 
        local len = string.len(k)
        maxLength = math.max(len, maxLength)
    end
    for k, v in pairs (t) do 
        local len = string.len(k)

        print(tostring(k).. string.rep(tablePrintSymb, maxLength - len + 10) ..tostring(v)) 
    end
end

function configuration.ReadPropertiesFile (file, parameters)
    local pf_config = io.open(file,'r')
    for line in pf_config:lines() do
        for k, v in string.gmatch(line, "(%w+)=(%w+)") do
            k = k:gsub("%s+", "")
            v = v:gsub("%s+", "")
            parameters[k] = v
        end
    end
    pf_config:close()
    return parameters
end

function configuration.WritePropertiesFile(properties, filename)
    local pf_config = io.open(filename,'w')
    if pf_config == nil then error("Error durring processing file " .. filename) end

    for k, v in pairs(properties) do
        pf_config:write(k .. "=" .. v .. "\n")
    end
    pf_config:close()
end

function configuration.WriteDefauldProperties(filename)
    configuration.WritePropertiesFile(defaultProperties, filename)
end