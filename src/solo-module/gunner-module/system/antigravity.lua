local tg = radar.getTargetId()
if tg ~= 0 then
   system.print('SELECTED ID: '..tg)
   --local msgs = shipINFO1..' **- Selected ID:**```\\n'..tg..'```'
   --system.logInfo('webhook: '..msgs..'')
   screen_1.setHTML('SELECTED ID: '..tg)
end