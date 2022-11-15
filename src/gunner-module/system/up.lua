start:
buttonSpace=true
if buttonC==true then mRadar:stopC() end
if shift == true then altUP(unit,system,text) end
if gearB == true then
    helper = true
    system.setScreen(helpHTML)
end
stop:
buttonSpace = false
helper = false