--events
absorbed:

local shield_hp = shield.getShieldHitpoints()
if shield_hp < last_shield_hp then
    HP = shield_hp/shieldMaxHP * 100
    formatted_hp = string.format('%0.0f',math.ceil(HP))
    local hit = last_shield_hp - shield_hp
    local damage1 = hit/shieldMaxHP*100
    damage = maxSHP * (damage1*0.01)   
    svghp = maxSHP * (HP*0.01)
    last_shield_hp = shield_hp
    --damageLine = [[<rect x="]].. svghp + 145 ..[[" y="225" width="]]..damage..[[" height="50" style="fill: #de1656; stroke: #de1656;" bx:origin="0.5 0.5"/>]]
end