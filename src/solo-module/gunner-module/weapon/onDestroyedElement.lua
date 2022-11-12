local element = system.getItem(elementId) --DeadRank
local name = element['displayName']
system.print(string.format('Destroyed %s on %s',name,radar_1.getConstructName(targetId)))