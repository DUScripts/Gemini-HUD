if string.sub((text),1,3) == 'tag' then
    setTag(text)
    transponder.deactivate()
    unit.setTimer('tr',2)
end