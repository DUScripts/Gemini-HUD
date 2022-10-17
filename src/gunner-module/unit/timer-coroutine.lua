if coroutine.status(main1) ~= "dead" and coroutine.status(main1) == "suspended" then
    coroutine.resume(main1)
 end

system.setScreen(hudHTML .. misshtml ..hithtml)
