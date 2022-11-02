local count = #string.gsub(text, "[^f]", "")
local f1 = string.sub(text,1,1)
if count == 1 and f1 == "f" then
   mRadar:onTextInput(text)
end
if text == "export" then GEAR(unit,system,text) end
inTEXT(unit,system,text)