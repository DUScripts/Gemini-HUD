--hit timer
if string.sub(tag, 1, 1) == 'h' then
    local curTime = system.getArkTime()
    local time = curTime - lastHitTime[tag].time
    if time >= 2 then time = 2 end
    lastHitTime[tag].hitOpacity = lastHitTime[tag].hitOpacity - 0.02
    local top = 45 - time * 5
    local right = time * 10
    if lastHitTime[tag].hitOpacity <= 0 then lastHitTime[tag].hitOpacity = 0 end
    hithtml = [[
        <style>
        .]]..tag..[[ {
            top: ]]..top..[[vh;
            left: calc(56.5% + ]]..right..[[vh);
            position: absolute;
            text-alight: center;
            font-size: 40px;
            font-family: "Tahoma", "Geneva" sand-serif;
            font-style: normal;
            font-weight: bold;
            color: yellow;
            text-shadow: 5px 0 1px orange, 0 1px 1px #000, -1px 0 1px #000, 0 -1px 1px #000;
            opacity: ]]..lastHitTime[tag].hitOpacity..[[;
            transform: translate(-50%, -50%);
        }
        </style>
        <div class="]]..tag..[[">HIT ]]..lastHitTime[tag].damage..[[ HP</div>]]

        if time == 2 then
            hithtml = ''
            table.remove(lastHitTime, lastHitTime[tag])
            unit.stopTimer(tag)
        end
    end
--miss timer
    if string.sub(tag, 1, 1) == 'm' then
        local curTime = system.getArkTime()
        local time = curTime - lastMissTime[tag].time
        local missOpacity = (lastMissTime[tag].time + 1) - curTime
        if time >= 2 then time = 2 end
        missOpacity = missOpacity - 0.02
        local top = 45 - time * 5
        local left = time * 10
        if hmissOpacity <= 0 then missOpacity = 0 end
        misshtml = [[
            <style>
            .]]..tag..[[ {
                top: ]]..top..[[vh;
                left: calc(47.5% - ]]..left..[[vh);
                position: absolute;
                text-alight: center;
                font-size: 40px;
                font-family: "Tahoma", "Geneva" sand-serif;
                font-style: normal;
                font-weight: bold;
                color: red;
                text-shadow: 5px 0 1px orange, 0 1px 1px #000, -1px 0 1px #000, 0 -1px 1px #000;
                opacity: ]]..missOpacity..[[;
                transform: translate(-50%, -50%);
            }
            </style>
            <div class="]]..tag..[[">MISS</div>]]
    
            if time == 2 then
                hithtml = ''
                table.remove(lastMissTime, lastMissTime[tag])
                unit.stopTimer(tag)
            end
        end    