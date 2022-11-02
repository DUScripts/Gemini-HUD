if #loglist ~= 0 then
    if #loglist < 5 then --system print performance (spam many radar targets/warping)
       for i = 1, #loglist do
          system.print(loglist[1])
          table.remove(loglist, 1)
       end
    else
       for i = 1, 5 do
          system.print(loglist[1])
          table.remove(loglist, 1)
       end
    end
 end