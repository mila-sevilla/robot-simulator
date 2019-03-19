local isCustomizationScript=sim.getScriptAttribute(sim.getScriptHandle(sim.handle_self),sim.scriptattribute_scripttype)==sim.scripttype_customizationscript

if not sim.isPluginLoaded('Bwf') then
    function sysCall_init()
    end
else
    function sysCall_init()
        model={}
        simBWF.appendCommonModelData(model,simBWF.modelTags.TRACKINGWINDOW)
        if isCustomizationScript then
            -- Customization script
            if model.modelVersion==1 then
                require("/BlueWorkforce/scripts/trackingWindow/common")
                require("/BlueWorkforce/scripts/trackingWindow/customization_main")
                require("/BlueWorkforce/scripts/trackingWindow/customization_data")
                require("/BlueWorkforce/scripts/trackingWindow/customization_ext")
                require("/BlueWorkforce/scripts/trackingWindow/customization_constr")
                require("/BlueWorkforce/scripts/trackingWindow/customization_dlg")
            end
        else
            -- Child script
            if model.modelVersion==1 then
                require("/BlueWorkforce/scripts/trackingWindow/common")
                require("/BlueWorkforce/scripts/trackingWindow/child_main")
            end
        end
        sysCall_init() -- one of above's 'require' redefined that function
    end
end
