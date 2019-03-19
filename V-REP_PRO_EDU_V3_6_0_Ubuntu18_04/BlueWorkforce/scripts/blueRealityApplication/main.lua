local isCustomizationScript=sim.getScriptAttribute(sim.getScriptHandle(sim.handle_self),sim.scriptattribute_scripttype)==sim.scripttype_customizationscript

if not sim.isPluginLoaded('Bwf') then
    function sysCall_init()
        if isCustomizationScript then
            sim.msgBox(sim.msgbox_type_warning,sim.msgbox_buttons_ok,"BWF Plugin","BWF plugin was not found.\n\nThe scene will not operate as expected")
        end
    end
else
    function sysCall_init()
        model={}
        simBWF.appendCommonModelData(model,simBWF.modelTags.BLUEREALITYAPP)
        if isCustomizationScript then
            -- Customization script
            if simBWF.getVrepVersion()<30500 or simBWF.getVrepRevision()<7 then
                sim.msgBox(sim.msgbox_type_warning,sim.msgbox_buttons_ok,"BWF Plugin","BWF plugin was not found.\n\nThe scene will not operate as expected")
            else
            
                -- For backward compatibility:
                local instanciatedPartHolder=sim.getObjectHandle('instanciatedParts@silentError')
                if instanciatedPartHolder==-1 then
                    local h=sim.createDummy(0.001)
                    sim.setObjectInt32Parameter(h,sim.objintparam_visibility_layer,0)
                    local p=sim.getModelProperty(h)
                    sim.setModelProperty(h,p-sim.modelproperty_not_model)
                    sim.setObjectName(h,'instanciatedParts')
                    sim.setObjectParent(h,model.handle,true)
                    local data={}
                    data.version=1
                    data.subtype='partHolder'
                    sim.writeCustomDataBlock(h,simBWF.modelTags.INSTANCIATEDPARTHOLDER,sim.packTable(data))
                    local s=sim.addScript(sim.scripttype_customizationscript)
                    sim.setScriptText(s,"require('/BlueWorkforce/scripts/partCreationAndHandling/main')")
                    sim.associateScriptWithObject(s,h)
                end
                --------------------------------
                
                if model.modelVersion==1 then
                    require("/BlueWorkforce/scripts/blueRealityApplication/common")
                    require("/BlueWorkforce/scripts/blueRealityApplication/customization_main")
                    require("/BlueWorkforce/scripts/blueRealityApplication/customization_data")
                    require("/BlueWorkforce/scripts/blueRealityApplication/customization_floor")
                    require("/BlueWorkforce/scripts/blueRealityApplication/customization_packMlDlg")
                    require("/BlueWorkforce/scripts/blueRealityApplication/customization_actionsDlg")
                    require("/BlueWorkforce/scripts/blueRealityApplication/customization_generalPropDlg")
                    require("/BlueWorkforce/scripts/blueRealityApplication/customization_ext")
                    if simBWF.getApplication()~='br' then
                        require("/BlueWorkforce/scripts/blueRealityApplication/customization_devDlg")
                    end
                end
                sysCall_init() -- one of above's 'require' redefined that function
            end
        else
            -- Child script
            if model.modelVersion==1 then
                require("/BlueWorkforce/scripts/blueRealityApplication/common")
                require("/BlueWorkforce/scripts/blueRealityApplication/child_main")
                require("/BlueWorkforce/scripts/blueRealityApplication/child_timeDlg")
                require("/BlueWorkforce/scripts/blueRealityApplication/child_packMlDlg")
                require("/BlueWorkforce/scripts/blueRealityApplication/child_packMlButtons")
            end
            sysCall_init() -- one of above's 'require' redefined that function
        end
    end
end
