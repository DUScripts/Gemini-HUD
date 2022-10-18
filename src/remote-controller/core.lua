--events:
onStressChanged
local ccs1 = stress
if cc1 > 0 then
    ccshit = ccs1
    CCS = math.floor(core.getCoreStress()/coreMaxStress * 100)
    ccshp1 = maxCCS * (CCS * 0.01)
    ccsLineHit = [[<rect x="180.2" y="220.2" width="]]..ccshp1..[[" height="4.8" style="fill: #de1656; stroke: rgba(0,0,0,0);"/>]]
end