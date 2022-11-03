if shift == true then
  local id = radar_1.getTargetId()
  if id ~= 0 then
     local db = databank_2.getKeyList()
     local keys = databank_2.getNbKeys()
     local check = table.contains(GHUD_friendly_IDs, id)
     if check == true then

        for k,v in pairs(db) do
           if databank_2.getIntValue(k) == 1 then databank_2.clearValue(k) end
        end
        for i = 1, #GHUD_friendly_IDs do
           if GHUD_friendly_IDs[i] == id then table.remove(GHUD_friendly_IDs,i) end
        end
        system.print(id..' ID has been removed from the whitelist databank')
     else
        local dbKey = keys + 1
        databank_2.setIntValue(dbKey,id)
        table.insert(GHUD_friendly_IDs,id)
        system.print(id..' ID has been added to the whitelist databank')
     end
     newWhitelist = checkWhitelist()
     whitelist = newWhitelist
  end
end




