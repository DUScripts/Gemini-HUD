if coroutine.status(main1) ~= "dead" and coroutine.status(main1) == "suspended" then
    coroutine.resume(main1)
 end

system.setScreen(hudHTML)

--hit/miss concept
if hit == true then
    local curTime = system.getArkTime()
    local time = curTime - lastHitTime
    if time >= 1 then time = 1 end
    hitOpacity = hitOpacity - 0.02
    local top = 20 - time * 5
    local right = time * 10
    hithtml = [[
        <style>
        .hit {
            top: ]]..top..[[vh;
            left: calc(50% + ]].right..[[vh);
            position: absolute;
            text-alight: center;
            font-size: 40px;
            font-family: 'Arial';
            color: yellow;
            letter-spacing: 0.5px;
            line-height: 1.0;
            opacity: ]]..hitOpacity..[[;
            transform: translate(-50%, -50%);
        }
        </style>
        <div class="hit">HIT ]]..damage..[[ HP</div>]]

        if time == 1 then hit = false end
    end

    if miss == true then
        local curTime = system.getArkTime()
        local time = curTime - lastMissTime
        if time >= 1 then time = 1 end
        missOpacity = missOpacity - 0.02
        local top = 20 - time * 5
        local left = time * 10
        misshtml = [[
            <style>
            .miss {
                top: ]]..top..[[vh;
                left: calc(50% - ]].left..[[vh);
                position: absolute;
                text-alight: center;
                font-size: 40px;
                font-family: 'Arial';
                color: red;
                letter-spacing: 0.5px;
                line-height: 1.0;
                opacity: ]]..missOpacity..[[;
                transform: translate(-50%, -50%);
            }
            </style>
            <div class="miss">MISS</div>]]

            if time == 1 then miss = false end
        end

    if miss == true and hit == false then 
        hudHTML = hudHTML .. misshtml 
        system.setScreen(hudHTML) 
    end

    if miss == false and hit == true then 
        hudHTML = hudHTML .. hithtml 
        system.setScreen(hudHTML) 
    end
    
    if miss == true and hit == true then 
        hudHTML = hudHTML .. misshtml .. hithtml 
        system.setScreen(hudHTML) 
    end