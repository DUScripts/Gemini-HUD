start:
if lalt == false then
    if shield.isActive() == 0 and shield.isVenting() == 0 then
       shield.activate()
       system.print("SHIELD ONLINE")
    else
       shield.deactivate()
       system.print("SHIELD OFFLINE")
    end
 end