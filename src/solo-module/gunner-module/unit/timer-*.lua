--hit timer
if string.sub(tag, 1, 1) == 'w' then
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
 if string.sub(tag, 1, 1) == 'k' then
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
 --radar notifications
 if string.sub(tag, 1, 1) == 'a' then
    if GHUD_radar_notifications_style == 1 then
       if target[tag].left > 80 and target[tag].one == true then target[tag].left = target.left - 0.25 end
       if target[tag].left <= 80 then target[tag].left = 80 target[tag].one = false end
       local div = [[
       <style>
       .]]..tag..[[ {
          position: relative;
          color: black;
          top: 25vh;
          left: ]]..target[tag].left..[[%;
          opacity: ]]..target[tag].opacity..[[;
          background-color: ]]..GHUD_radar_notification_background_color..[[;
          border: 2px solid black;
          border-radius: ]]..GHUD_border_radius..[[;
          padding: 12px;
          margin-top: -2px;
          font-weight: bold;
          font-size: 20px;
          text-align: left;
       }
       </style>
       <div class="]]..tag..[[">[]]..target[tag].size1..[[] ]]..target[tag].id..[[ - ]]..target[tag].name1..[[</div>]]
       table.insert(targets,div)
       if target[tag].one == false then
          target[tag].delay = target[tag].delay + 1
          if target[tag].delay >= 100 then
             target[tag].opacity = target[tag].opacity - 0.01
             target[tag].left = target[tag].left + 0.25
             if target[tag].opacity <=0 and target[tag].left >= 100 and target[tag].check == true then
                count = count - 1
                target[tag].check = false
             end
          end
          if count == 0 then
             cnt = 0
             target = {}
             unit.stopTimer(tag)
          end
       end
    end--ghud style check
    if GHUD_radar_notifications_style == 2 then
        if target[tag].left > 80 then target[tag].left = target.left - 0.25 end
        if target[tag].left < 80 then target[tag].left = 80 end
        local div = [[
        <style>
        .]]..tag..[[ {
           position: relative;
           color: black;
           top: 25vh;
           left: ]]..target[tag].left..[[%;
           opacity: ]]..target[tag].opacity..[[;
           background-color: ]]..GHUD_radar_notification_background_color..[[;
           border: 2px solid black;
           border-radius: ]]..GHUD_border_radius..[[;
           padding: 12px;
           margin-top: -2px;
           font-weight: bold;
           font-size: 20px;
           text-align: left;
        }
        </style>
        <div class="]]..tag..[[">[]]..target[tag].size1..[[] ]]..target[tag].id..[[ - ]]..target[tag].name1..[[</div>]]
        table.insert(targets,div)
        if target[tag].left == 80 then
           target[tag].delay = target[tag].delay + 1
           if target[tag].delay >= 100 then
              target[tag].opacity = target[tag].opacity - 0.01
              if target[tag].opacity <=0 and target[tag].check == true then
                 count = count - 1
                 target[tag].check = false
              end
           end
           if count == 0 then
              cnt = 0
              target = {}
              unit.stopTimer(tag)
           end
        end
     end--ghud style check
 end