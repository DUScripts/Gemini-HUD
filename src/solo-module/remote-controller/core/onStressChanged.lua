local stress = core.getCoreStress()
if stress > last_core_stress then
    local newstress = stress - last_core_stress
    local stresschange = newstress/core.getmaxCoreStress()*100
    CCS = stress/core.getmaxCoreStress() * 100
    ccshp1 = maxCCS * (CCS * 0.01)
    ccshit = maxCCS * (stresschange*0.01)
    last_core_stress = stress
    ccsLineHit = [[<rect x="180.2" y="220.2" width="]]..ccshp1..[[" height="4.8" style="fill: #de1656; stroke: rgba(0,0,0,0);"/>]]
end