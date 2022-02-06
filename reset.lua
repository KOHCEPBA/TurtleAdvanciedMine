require "settingsModule/configuration";

configuration.WriteDefauldProperties(PropertiesPath)

print("Set default settings:")
configuration.Print_Table(configuration.ReadPropertiesFile(PropertiesPath, {}))
