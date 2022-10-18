--events
absorbed:
local damage1 = damage*

if damage1 > 0 then
    local damage = maxSHP * (damage1 * 0.01)
    HP = math.floor(shield.getShieldHitpoints()/shieldMaxHP*100)    
    svghp = maxSHP * (HP * 0.01)
    --damageLine = [[<rect x="]].. svghp + 145 ..[[" y="225" width="]]..damage..[[" height="50" style="fill: #de1656; stroke: #de1656;" bx:origin="0.5 0.5"/>]]
end

