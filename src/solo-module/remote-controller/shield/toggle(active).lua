if shield.getState() == 0 then 
    shieldColor = "#fc033d" 
else 
    shieldColor = "#2ebac9"
    local shield_hp = shield.getShieldHitpoints() 
    last_shield_hp = shield_hp
end