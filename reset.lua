require "settingsModule/configuration";

configuration.WriteDefauldProperties(PropertiesPath)

print("Установлены дефолтные настройки")
configuration.Print_Table(configuration.ReadPropertiesFile(PropertiesPath, {}))
