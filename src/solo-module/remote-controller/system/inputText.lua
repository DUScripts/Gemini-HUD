if string.sub((text),1,3) == 'tag' then
    setTag(text)
    transponder.deactivate()
    unit.setTimer('tr',2)
end

if string.find(text,'m::pos') then
    asteroidcoord = zeroConvertToWorldCoordinates(asteroidPOS)
    asteroidPOS = text:sub(2)
    databank.setStringValue(15,asteroidPOS)
end