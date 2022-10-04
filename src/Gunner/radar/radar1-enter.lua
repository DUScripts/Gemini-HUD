if (zone == "false" and GHUD_Notifications == true) or (GHUD_SafeNotifications == true and GHUD_Notifications == true) then
    system.playSound(GHUD_message_enter)
    if firstload==1 then
       if GHUD_log_stats then
          t_radarEnter[id] = {pos1 = system.getWaypointFromPlayerPos(), time1 = seconds_to_clock(system.getTime())}
       end
    end
 end