require "settingsModule/configuration";

pset = {}

local function set(parameter, value)
    pset.setParameter(parameter, value)
    value = value or "nil"
    print("Parameter " .. parameter .. " set to " .. value)
    print("New settings: ")
    configuration.Print_Table(configuration.ReadPropertiesFile(PropertiesPath, {}))
end

function pset.setParameter(parameter, value)
    local properties = configuration.ReadPropertiesFile(PropertiesPath, {})
    if value == nil then
        properties[parameter] = nil
    else
        properties[parameter] = tostring(value)
    end
    configuration.WritePropertiesFile(properties, PropertiesPath)
end


local parameter, value = ...
if parameter == nil then
    print("Use 'pset <keyName> <value>'")
    print("Actual settings:")
    configuration.Print_Table(configuration.ReadPropertiesFile(PropertiesPath, {}))
    return
end
set(parameter, value)
