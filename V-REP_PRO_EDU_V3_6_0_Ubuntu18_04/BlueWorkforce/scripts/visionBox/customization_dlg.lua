model.dlg={}

function model.dlg.updateEnabledDisabledItems()
    if model.dlg.ui then
        local config=model.readInfo()
        simUI.setEnabled(model.dlg.ui,2,config.visionBoxServerName~=simBWF.NONE_TEXT,true)
--        simUI.setEnabled(model.dlg.ui,5,simStopped,true) -- simBWF.getReferencedObjectHandle(model,model.objRefIdx.PALLET)>=0,true)
    end
end

function model.dlg.refresh()
    if model.dlg.ui then
        local config=model.readInfo()
        local sel=simBWF.getSelectedEditWidget(model.dlg.ui)
        simUI.setEditValue(model.dlg.ui,1365,simBWF.getObjectAltName(model.handle),true)
        simUI.setCheckboxValue(model.dlg.ui,30,simBWF.getCheckboxValFromBool(sim.boolAnd32(config['bitCoded'],1)~=0),true)

        model.dlg.updateVisionBoxServerNameCombobox()
        model.dlg.updateCameraComboboxes()
        model.dlg.updateVisionWindowComboboxes()
        
        model.dlg.updateEnabledDisabledItems()
        simBWF.setSelectedEditWidget(model.dlg.ui,sel)
    end
end

function model.dlg.updateCameraComboboxes()
    model.dlg.cameras_comboboxItems={}
    local loc=model.getAvailableCameras()
    for i=1,C.CAMERACNT,1 do
        model.dlg.cameras_comboboxItems[i]=simBWF.populateCombobox(model.dlg.ui,11+i-1,loc,{},simBWF.getObjectAltNameOrNone(simBWF.getReferencedObjectHandle(model.handle,model.objRefIdx.CAMERA1+i-1)),true,{{simBWF.NONE_TEXT,-1}})
    end
end

function model.dlg.updateVisionWindowComboboxes()
    model.dlg.visionWindows_comboboxItems={}
    local loc=model.getAvailableVisionWindows()
    for i=1,C.VISIONWINDOWCNT,1 do
        model.dlg.visionWindows_comboboxItems[i]=simBWF.populateCombobox(model.dlg.ui,21+i-1,loc,{},simBWF.getObjectAltNameOrNone(simBWF.getReferencedObjectHandle(model.handle,model.objRefIdx.VISIONWINDOW1+i-1)),true,{{simBWF.NONE_TEXT,-1}})
    end
end


function model.dlg.serverNameComboChange_callback(uiHandle,id,newValue)
    local newServerName=model.dlg.comboServerNames[newValue+1][1]
    local c=model.readInfo()
    c['visionBoxServerName']=newServerName
    model.writeInfo(c)
    simBWF.markUndoPoint()
    model.updatePluginRepresentation()
    model.dlg.refresh()
end

function model.dlg.updateVisionBoxServerNameCombobox()
    local c=model.readInfo()
    local resp,data
    if simBWF.isInTestMode() then
        resp='ok'
        data={}
        data.visionServerNames={'visionBoxServer-1','visionBoxServer-2','visionBoxServer-x'}
    else
        resp,data=simBWF.query('get_visionServerNames')
        if resp~='ok' then
            data.visionServerNames={}
        end
    end
    
    local selected=c['visionBoxServerName']
    local isKnown=false
    local items={}
    for i=1,#data.visionServerNames,1 do
        if data.visionServerNames[i]==selected then
            isKnown=true
        end
        items[#items+1]={data.visionServerNames[i],i}
    end
    if not isKnown then
        table.insert(items,1,{selected,#items+1})
    end
    if selected~=simBWF.NONE_TEXT then
        table.insert(items,1,{simBWF.NONE_TEXT,#items+1})
    end
    model.dlg.comboServerNames=simBWF.populateCombobox(model.dlg.ui,1200,items,{},selected,false,{})
--    model.updatePluginRepresentation()
end


function model.dlg.hiddenDuringSimulation_callback(ui,id,newVal)
    local c=model.readInfo()
    c['bitCoded']=sim.boolOr32(c['bitCoded'],1)
    if newVal==0 then
        c['bitCoded']=c['bitCoded']-1
    end
    simBWF.markUndoPoint()
    model.writeInfo(c)
    model.dlg.refresh()
end

function model.dlg.nameChange(ui,id,newVal)
    if simBWF.setObjectAltName(model.handle,newVal)>0 then
        simBWF.markUndoPoint()
        model.updatePluginRepresentation()
        simUI.setTitle(ui,simBWF.getUiTitleNameFromModel(model.handle,model.modelVersion,model.codeVersion))
    end
    model.dlg.refresh()
end

function model.dlg.onRejectVisionBoxEdit()
    sim.auxFunc('enableRendering')
end

function model.dlg.onAcceptVisionBoxEdit(arg1)
    sim.auxFunc('enableRendering')
    local c=model.readInfo()
    c.visionBoxJson=arg1
    model.writeInfo(c)
end

function model.dlg.edit_callback()
    local c=model.readInfo()
    if c.visionBoxServerName~=simBWF.NONE_TEXT then
        local data={}
        data.visionServerName=c.visionBoxServerName
        data.visionJson=c.visionBoxJson
        data.onReject='model.dlg.onRejectVisionBoxEdit'
        data.onAccept='model.dlg.onAcceptVisionBoxEdit'
        sim.auxFunc('disableRendering')
        local reply=simBWF.query('open_visionServer',data)
        if reply~='ok' then
            sim.auxFunc('enableRendering')
        end
    end
end


function model.dlg.cameraChange_callback(ui,id,newIndex)
    local idd=id-10
    local newCamera=model.dlg.cameras_comboboxItems[idd][newIndex+1][2]
    simBWF.setReferencedObjectHandle(model.handle,model.objRefIdx.CAMERA1+idd-1,newCamera)
    for i=1,C.CAMERACNT,1 do
        -- Make sure that the same camera is not connected several times
        if i~=idd then
            if simBWF.getReferencedObjectHandle(model.handle,model.objRefIdx.CAMERA1+i-1)==newCamera then
                simBWF.setReferencedObjectHandle(model.handle,model.objRefIdx.CAMERA1+i-1,-1)
            end
        end
    end
    simBWF.markUndoPoint()
    model.updatePluginRepresentation()
    model.dlg.updateCameraComboboxes()
end

function model.dlg.visionWindowChange_callback(ui,id,newIndex)
    local idd=id-20
    local newWiondow=model.dlg.visionWindows_comboboxItems[idd][newIndex+1][2]
    simBWF.setReferencedObjectHandle(model.handle,model.objRefIdx.VISIONWINDOW1+idd-1,newWiondow)
    for i=1,C.VISIONWINDOWCNT,1 do
        -- Make sure that the same camera is not connected several times
        if i~=idd then
            if simBWF.getReferencedObjectHandle(model.handle,model.objRefIdx.VISIONWINDOW1+i-1)==newWiondow then
                simBWF.setReferencedObjectHandle(model.handle,model.objRefIdx.VISIONWINDOW1+i-1,-1)
            end
        end
    end
    simBWF.markUndoPoint()
    model.updatePluginRepresentation()
    model.dlg.updateVisionWindowComboboxes()
end

function model.dlg.createDlg()
    if (not model.dlg.ui) and simBWF.canOpenPropertyDialog() then
        local xml =[[
        <tabs id="77">
            <tab title="General">
            <group layout="form" flat="false">
                <label text="Name"/>
                <edit on-editing-finished="model.dlg.nameChange" id="1365" style="* {min-width: 300px;}"/>
                
                <label text="Vision box server"/>
                <combobox id="1200" on-change="model.dlg.serverNameComboChange_callback"> </combobox>
                
                <label text="Vision tool settings"/>
                <button text="Edit" style="* {min-width: 300px;}" on-click="model.dlg.edit_callback" id="2" />
                
            </group>
            </tab>
    <tab title="Cameras">
            <group layout="form" flat="false">
                <label text="Camera 1"/>
                <combobox id="11" on-change="model.dlg.cameraChange_callback">
                </combobox>
                
                <label text="Camera 2"/>
                <combobox id="12" on-change="model.dlg.cameraChange_callback">
                </combobox>

                <label text="Camera 3"/>
                <combobox id="13" on-change="model.dlg.cameraChange_callback">
                </combobox>

                <label text="Camera 4"/>
                <combobox id="14" on-change="model.dlg.cameraChange_callback">
                </combobox>
            </group>
    </tab>
    <tab title="Vision windows">
            <group layout="form" flat="false">
                <label text="Vision window 1"/>
                <combobox id="21" on-change="model.dlg.visionWindowChange_callback">
                </combobox>
                
                <label text="Vision window 2"/>
                <combobox id="22" on-change="model.dlg.visionWindowChange_callback">
                </combobox>
                
                <label text="Vision window 3"/>
                <combobox id="23" on-change="model.dlg.visionWindowChange_callback">
                </combobox>
                
                <label text="Vision window 4"/>
                <combobox id="24" on-change="model.dlg.visionWindowChange_callback">
                </combobox>
                
            </group>
    </tab>
            
            <tab title="More">
            <group layout="form" flat="false">
                <label text="Hidden during simulation"/>
                <checkbox text="" checked="false" on-change="model.dlg.hiddenDuringSimulation_callback" id="30"/>
            </group>
            </tab>
            
       </tabs>
        ]]

        model.dlg.ui=simBWF.createCustomUi(xml,simBWF.getUiTitleNameFromModel(model.handle,model.modelVersion,model.codeVersion),model.dlg.previousDlgPos,false,nil,false,false,false)

        model.dlg.refresh()
        simUI.setCurrentTab(model.dlg.ui,77,model.dlg.mainTabIndex,true)
    end
end

function model.dlg.showDlg()
    if not model.dlg.ui then
        model.dlg.createDlg()
    end
end

function model.dlg.removeDlg()
    if model.dlg.ui then
        local x,y=simUI.getPosition(model.dlg.ui)
        model.dlg.previousDlgPos={x,y}
        model.dlg.mainTabIndex=simUI.getCurrentTab(model.dlg.ui,77)
        simUI.destroy(model.dlg.ui)
        model.dlg.ui=nil
    end
end

function model.dlg.showOrHideDlgIfNeeded()
    local s=sim.getObjectSelection()
    if s and #s>=1 and s[#s]==model.handle then
        model.dlg.showDlg()
    else
        model.dlg.removeDlg()
    end
end

function model.dlg.init()
    model.dlg.mainTabIndex=0
    model.dlg.previousDlgPos=simBWF.readSessionPersistentObjectData(model.handle,"dlgPosAndSize")
end

function model.dlg.cleanup()
    simBWF.writeSessionPersistentObjectData(model.handle,"dlgPosAndSize",model.dlg.previousDlgPos)
end
