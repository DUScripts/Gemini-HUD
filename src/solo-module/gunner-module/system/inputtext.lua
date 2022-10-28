if text == "s" then
    mRadar:stopC()
    defaultRadar()
 end
 local count = #string.gsub(text, "[^f]", "")
 local f1 = string.sub(text,1,1)
 if count == 1 and f1 == "f" then
    mRadar:onTextInput(text)
 end

 inTEXT(unit,system,text)