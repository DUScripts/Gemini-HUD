if #loglist ~= 0 then
    if #loglist < 3 then --system print performance (spam many radar targets/warping)
       for i = 1, #loglist do
          system.print(loglist[1])
          table.remove(loglist, 1)
       end
    else
       for i = 1, 3 do
          system.print(loglist[1])
          table.remove(loglist, 1)
       end
    end
 end