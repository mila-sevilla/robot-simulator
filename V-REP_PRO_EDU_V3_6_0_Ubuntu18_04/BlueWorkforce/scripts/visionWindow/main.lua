local isCustomizationScript=sim.getScriptAttribute(sim.getScriptHandle(sim.handle_self),sim.scriptattribute_scripttype)==sim.scripttype_customizationscript

if not sim.isPluginLoaded('Bwf') then
    function sysCall_init()
    end
else
    function sysCall_init()
        model={}
        simBWF.appendCommonModelData(model,simBWF.modelTags.VISIONWINDOW)
        if isCustomizationScript then
            -- Customization script
            if model.modelVersion==1 then
                require("/BlueWorkforce/scripts/visionWindow/common")
                require("/BlueWorkforce/scripts/visionWindow/customization_main")
                require("/BlueWorkforce/scripts/visionWindow/customization_data")
                require("/BlueWorkforce/scripts/visionWindow/customization_ext")
                require("/BlueWorkforce/scripts/visionWindow/customization_constr")
                require("/BlueWorkforce/scripts/visionWindow/customization_dlg")
            end
        else
            -- Child script
            if model.modelVersion==1 then
                require("/BlueWorkforce/scripts/visionWindow/common")
                require("/BlueWorkforce/scripts/visionWindow/child_main")
                require("/BlueWorkforce/scripts/visionWindow/child_disp")
            end
        end
        sysCall_init() -- one of above's 'require' redefined that function
    end
end
