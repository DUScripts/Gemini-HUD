if text == "safe" then
    if GHUD_SafeNotifications == false then
        if GHUD_log_stats then
        t_radarEnter = {}
        end
        GHUD_SafeNotifications = true
        system.print("SAFE NOTIFICATIONS ON")   
    else
        if GHUD_log_stats then
        t_radarEnter = {}
        end
        GHUD_SafeNotifications = false
        system.print("SAFE NOTIFICATIONS OFF")
        end
    end
    if text == "ang" then
    if GHUD_Angular_Radial == false then 
        GHUD_Angular_Radial = true
        system.print("ANGULAR SPEED ON")
    else
        GHUD_Angular_Radial = false
        system.print("ANGULAR SPEED OFF")
        end
    end
    if text == "s" then
    mRadar:stopC()
    defaultRadar()
    end
    local count = #string.gsub(text, "[^f]", "") 
    local f1 = string.sub(text,1,1)
    if count == 1 and f1 == "f" then
    mRadar:onTextInput(text)
end