local data = weapon_1.getData()
zone = data:match('"outOfZone":(.-),')
local hitP = tonumber(data:match('"hitProbability":(.-),'))
probil = math.floor(hitP * 100)
newcolor = "#6affb1"
znak = ""
if dist3>dist1 then dist1=dist3 newcolor = "#00d0ff" znak = "↑" end
if dist3<dist1 then dist1=dist3 newcolor = "#fc033d" znak = "↓" end