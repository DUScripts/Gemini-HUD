if coroutine.status(main1) ~= "dead" and coroutine.status(main1) == "suspended" then
    coroutine.resume(main1)
 end

 local hitsHUD = ''
 local missesHUD = ''

for k,v in pairs(hits) do
    hitsHUD = hitsHUD .. hits[k].html
end

for k,v in pairs(misses) do
    missesHUD = missesHUD .. misses[k].html
end

system.setScreen(hudHTML .. missesHUD ..hitsHUD)
