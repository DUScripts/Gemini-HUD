local data = weapon_1.getWidgetData()
zone = data:match('"outOfZone":(.-),')
--local hitP = tonumber(data:match('"hitProbability":(.-),'))
--probil = math.ceil(hitP * 100)