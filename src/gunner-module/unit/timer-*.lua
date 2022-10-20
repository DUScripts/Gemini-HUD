--hit timer
if string.sub(tag, 1, 1) == 'd' then
    lastHitTime[tag].time = lastHitTime[tag].time + 0.025
    lastHitTime[tag].hitOpacity = lastHitTime[tag].hitOpacity - 0.025
    local top = 45 - lastHitTime[tag].time*3.25
    local right = 56.5 + lastHitTime[tag].time*2
    if lastHitTime[tag].hitOpacity <= 0 then lastHitTime[tag].hitOpacity = 0 end
    local hit = [[
        <style>
        .]]..tag..[[ {
            top: ]]..top..[[vh;
            left: ]]..right..[[%;
            position: absolute;
            text-alight: center;
            font-size: 40px;
            font-family: "Tahoma", "Geneva" sand-serif;
            font-style: normal;
            font-weight: bold;
            color: yellow;
            text-shadow: 4px 0 1px orange, 0 1px 1px #000, -1px 0 1px #000, 0 -1px 1px #000;
            opacity: ]]..lastHitTime[tag].hitOpacity..[[;
            transform: translate(-50%, -50%);
        }
        </style>
        <div class="]]..tag..[[">HIT ]]..lastHitTime[tag].damage..[[ HP</div>]]
        hits[tag] = {html = hit}

        if lastHitTime[tag].time >= 1.5 then
            hits[tag] = {html = ''}
            if lastHitTime[tag].anims == hitAnimations then
                hits = {} 
                hitAnimations = 0
                lastHitTime = {}
            end
            unit.stopTimer(tag)
        end
    end
--miss timer
    if string.sub(tag, 1, 1) == 'w' then
        lastMissTime[tag].time = lastMissTime[tag].time + 0.025
        lastMissTime[tag].missOpacity = lastMissTime[tag].missOpacity - 0.025
        local top = 45 - lastMissTime[tag].time*3.25
        local left = 47.5 - lastMissTime[tag].time*2
        if lastMissTime[tag].missOpacity <= 0 then lastMissTime[tag].missOpacity = 0 end
        local miss = [[
            <style>
            .]]..tag..[[ {
                top: ]]..top..[[vh;
                left: ]]..left..[[%;
                position: absolute;
                text-alight: center;
                font-size: 40px;
                font-family: "Tahoma", "Geneva" sand-serif;
                font-style: normal;
                font-weight: bold;
                color: red;
                text-shadow: 4px 0 1px orange, 0 1px 1px #000, -1px 0 1px #000, 0 -1px 1px #000;
                opacity: ]]..lastMissTime[tag].missOpacity..[[;
                transform: translate(-50%, -50%);
            }
            </style>
            <div class="]]..tag..[[">MISS</div>]]
            misses[tag] = {html = miss}
    
            if lastMissTime[tag].time >= 1.5 then
                misses[tag] = {html = ''}
                if lastMissTime[tag].anims == missAnimations then
                    misses = {} 
                    missAnimations = 0
                    lastMissTime = {}
                end
                unit.stopTimer(tag)
            end
        end