local isCustomizationScript=sim.getScriptAttribute(sim.getScriptHandle(sim.handle_self),sim.scriptattribute_scripttype)==sim.scripttype_customizationscript

if not sim.isPluginLoaded('Bwf') then
    function sysCall_init()
    end
else
    function sysCall_init()
        model={}
        simBWF.appendCommonModelData(model,simBWF.modelTags.RAGNARCAMERA)
        if isCustomizationScript then
            -- Customization script
            if model.modelVersion==1 then
                require("/BlueWorkforce/scripts/ragnarCamera/common")
                require("/BlueWorkforce/scripts/ragnarCamera/customization_main")
                require("/BlueWorkforce/scripts/ragnarCamera/customization_data")
                require("/BlueWorkforce/scripts/ragnarCamera/customization_ext")
                require("/BlueWorkforce/scripts/ragnarCamera/customization_dlg")
            end
        else
            -- Child script
            if model.modelVersion==1 then
                require("/BlueWorkforce/scripts/ragnarCamera/common")
                require("/BlueWorkforce/scripts/ragnarCamera/child_main")
                require("/BlueWorkforce/scripts/ragnarCamera/child_ext")
                require("/BlueWorkforce/scripts/ragnarCamera/child_simCamDisp")
                require("/BlueWorkforce/scripts/ragnarCamera/child_realCamDisp")
            end
        end
        sysCall_init() -- one of above's 'require' redefined that function
    end
end
