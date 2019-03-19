-- Functions:
-------------------------------------------------------
function model.readInfo()
    -- Read all the data stored in the model
    
    local data=sim.readCustomDataBlock(model.handle,model.tagName)
    if data then
        data=sim.unpackTable(data)
    else
        data={}
    end
    
    -- All the data stored in the model. Set-up default values, and remove unused values
    if not data['version'] then
        data['version']=1
    end
    if not data['subtype'] then
        data['subtype']='visionBox'
    end
    data['visionBoxSerial']=nil
    if not data['visionBoxServerName'] then
        data['visionBoxServerName']=simBWF.NONE_TEXT
    end
    if not data['bitCoded'] then
        data['bitCoded']=1 -- 1=hidden during simulation
    end
    if not data['visionBoxJson'] then
        data['visionBoxJson']=''
    end
    
    return data
end

function model.writeInfo(data)
    -- Write all the data stored in the model. Before writing, make sure to always first read with readInfo()
    
    if data then
        sim.writeCustomDataBlock(model.handle,model.tagName,sim.packTable(data))
    else
        sim.writeCustomDataBlock(model.handle,model.tagName,'')
    end
end

function model.copyModelParamsToJob(data,jobName)
    -- Copy the model parameters that are job-related to a specific job
    -- Job must already exist!
    local job=data.jobData.jobs[jobName]
--    job.refreshMode=data.refreshMode
end

function model.copyJobToModelParams(data,jobName)
    -- Copy a specific job to the model parameters that are job-related
    local job=data.jobData.jobs[jobName]
--    data.refreshMode=job.refreshMode
end


-- Various constants
-------------------------------------------------------
C={}
C.CAMERACNT=4
C.VISIONWINDOWCNT=4

-- IOHUB referenced object slots (do not modify):
-------------------------------------------------------
model.objRefIdx={}
model.objRefIdx.CAMERA1=1
model.objRefIdx.CAMERA2=2
model.objRefIdx.CAMERA3=3
model.objRefIdx.CAMERA4=4
model.objRefIdx.VISIONWINDOW1=11
model.objRefIdx.VISIONWINDOW2=12
model.objRefIdx.VISIONWINDOW3=13
model.objRefIdx.VISIONWINDOW4=14
model.objRefJobInfo={20} -- information about jobs stored in object references. Item 1 is where job related obj refs start, other items are obj ref indices that are in the job scope


-- Handles:
-------------------------------------------------------
model.handles={}
model.handles.body=sim.getObjectHandle('visionBox_obj')

