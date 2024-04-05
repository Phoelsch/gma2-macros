--[[
  Creates selective groups from given template effect range.

  Author: Philipp Hölscher
  Date: 2024-03-05
]]--


function main ()
    if not gma.gui.confirm('Are you sure you want to continue?', 'This plugin overwrites conflicting effects. Ensure to create a backup before and review afterwards.') then
        gma.feedback("Candeled execution")
        return
    end

    local fromEffectStart = tonumber(gma.textinput('Start template effect', '1'))
    local fromEffectEnd  = tonumber(gma.textinput('End template effect', '1'))
    local toEffectStart = tonumber(gma.textinput('Start selective effects', '1'))
    local groupId = tonumber(gma.textinput('Destination group', '1'))

    local groupHandle = gma.show.getobj.handle("Group " .. groupId)
    if groupHandle == nil then
        gma.gui.msgbox("Error", "Group does not exist")
        return
    end

    local c = 0
    for i = fromEffectStart, fromEffectEnd do
        local effectHandle = gma.show.getobj.handle("Effect " .. i)
        if effectHandle ~= nil  then
            local newEffectIndex = toEffectStart + c
            local newEffectName =  gma.show.getobj.label(groupHandle) .. " " .. gma.show.getobj.label(effectHandle)
            
            -- Copy and rename effect
            gma.cmd("COPY Effect " .. i .. " At Effect " .. newEffectIndex .. " /o")
            gma.cmd("LABEL Effect " .. newEffectIndex .. " \"" .. newEffectName .. "\"")

            -- Assign group to newly created effect
            gma.cmd("Group " .. gma.show.getobj.number(groupHandle) .. " At Effect " .. newEffectIndex)
            gma.cmd("Store Effect 1." .. newEffectIndex .. ".* /o")
            gma.cmd("ClearAll")

            gma.feedback("Created effect " .. newEffectName .. " at index " .. newEffectIndex)
        end

        c = c + 1
    end

end
    
return main