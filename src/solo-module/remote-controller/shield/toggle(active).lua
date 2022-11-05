if shield.isActive() == 0 then 
    shieldColor = "#fc033d"
    shieldStatus = "DEACTIVE"
else 
    shieldColor = "#2ebac9"
    shieldStatus = "ACTIVE"
    local shield_hp = shield.getShieldHitpoints() 
    last_shield_hp = shield_hp
    HP = shield_hp/shieldMaxHP * 100
    svghp = maxSHP * (HP*0.01)
end