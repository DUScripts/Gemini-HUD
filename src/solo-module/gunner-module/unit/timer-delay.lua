if firstload == 0 then firstload1=firstload1+1 end
if firstload1==5 then --5 sec radar delay for 1st run all targets fix
   firstload = 1
   unit.setTimer("coroutine", 0.016) --main
   if GHUD_log_stats then
      unit.setTimer("logger", 0.5)
   end
   unit.stopTimer("delay")
end