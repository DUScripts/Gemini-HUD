if (system.getTime() - startTime) > 5 then
   firstload = 1
   t_radarEnter = {}
   main1 = coroutine.create(main)
   unit.setTimer("data", 0.1)
   unit.setTimer("hud", 0.016)
   if GHUD_log_stats then
      unit.setTimer("logger", 0.5)
   end
   unit.stopTimer("delay")
end