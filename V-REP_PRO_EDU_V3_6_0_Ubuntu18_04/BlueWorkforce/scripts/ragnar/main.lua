local isCustomizationScript=sim.getScriptAttribute(sim.getScriptHandle(sim.handle_self),sim.scriptattribute_scripttype)==sim.scripttype_customizationscript

if not sim.isPluginLoaded('Bwf') then
    function sysCall_init()
    end
else
    function sysCall_init()
        model={}
        simBWF.appendCommonModelData(model,simBWF.modelTags.RAGNAR)
        if isCustomizationScript then
            -- Customization script
            if model.modelVersion==1 then
                require("/BlueWorkforce/scripts/ragnar/common")
                require("/BlueWorkforce/scripts/ragnar/customization_main")
                require("/BlueWorkforce/scripts/ragnar/customization_data")
                require("/BlueWorkforce/scripts/ragnar/customization_ext")
                require("/BlueWorkforce/scripts/ragnar/customization_constr")
                require("/BlueWorkforce/scripts/ragnar/customization_dlg")
            end
        else
            -- Child script
            if model.modelVersion==1 then
                require("/BlueWorkforce/scripts/ragnar/common")
                require("/BlueWorkforce/scripts/ragnar/child_main")
                require("/BlueWorkforce/scripts/ragnar/child_robotPlot")
                require("/BlueWorkforce/scripts/ragnar/child_clearancePlot")
            end
        end
        sysCall_init() -- one of above's 'require' redefined that function
    end
end
