fuel_lvl=math.ceil(spacefueltank_1.getItemsVolume()/spacefueltank_1.getMaxVolume()*100)FUEL_svg=maxFUEL*fuel_lvl*0.01;local a=json.decode(unit.getWidgetData()).maxBrake;local b=0;for c,d in pairs(construct.getDockedConstructs())do b=b+construct.getDockedConstructMass(d)end;for c,d in pairs(construct.getPlayersOnBoard())do b=b+construct.getBoardedPlayerMass(d)end;local e=construct.getMass()local f=vec3(construct.getWorldVelocity())local g=f:len()*3.6;local h=Kinematic.computeDistanceAndTime(g/3.6,0,e+b,0,0,a)if h>100000 then brakeDist=string.format(math.floor(h/200000*10)/10)brakeS="SU"elseif h>1000 then brakeDist=string.format(math.floor(h/1000*10)/10)brakeS="KM"else brakeDist=string.format(math.floor(h))brakeS="M"end