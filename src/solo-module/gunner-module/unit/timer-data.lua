local data = weapon_1.getWidgetData()
zone = data:match('"outOfZone":(.-),')
probil = tonumber(data:match('"hitProbability":(.-),'))