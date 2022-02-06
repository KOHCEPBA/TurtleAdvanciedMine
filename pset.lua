require "settingsModule/configuration";

local parameter, value = ...
if parameter == nil then
    print("Use 'pset <keyName> <value>'")
    print("Actual settings:")
    configuration.Print_Table(configuration.ReadPropertiesFile(PropertiesPath, {}))
    return
end
local properties = configuration.ReadPropertiesFile(PropertiesPath, {})
if value == nil then
    properties[parameter] = nil
    value = "nil"
else
    properties[parameter] = tostring(value)
end
print("Parameter " .. parameter .. " set to " .. value)
configuration.WritePropertiesFile(properties, PropertiesPath)
print("New settings: ")
configuration.Print_Table(configuration.ReadPropertiesFile(PropertiesPath, {}))