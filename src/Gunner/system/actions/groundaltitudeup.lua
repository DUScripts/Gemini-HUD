start:
--mRadar.onlyIdentified = not mRadar.onlyIdentified
sizeState = sizeState + 1
if sizeState == 7 then sizeState = 1 end
defaultSize = size[sizeState]
system.print(defaultSize)
