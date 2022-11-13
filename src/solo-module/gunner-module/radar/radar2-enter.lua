if zone == "false" or GHUD_safeNotifications == true then
    if firstload==1 then
       if GHUD_log_stats then
          t_radarEnter[id] = {pos = system.getWaypointFromPlayerPos()}
       end
    end
 end