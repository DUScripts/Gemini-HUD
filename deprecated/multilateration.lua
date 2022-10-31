--unit.start:

--timezonee = 3 --export: time zone
--require('autoconf/custom/CFCS_HUD/VR')

--unit.hide()
--system.createWidgetPanel('TEST')

--myfunction(system)

---------------------------------


--feli ::pos{0,0,-43444811.6972,22521531.4367,-48844295.7649}
--sinnen ::pos{0,0,58543373.1261,29616903.0503,58049826.3334}
--lacobus ::pos{0,0,98778326.5840,-13441144.3062,-806891.3039}
--symeon ::pos{0,0,14523791.3243,-85546713.5184,-894809.5085}
--UTCscaner(system)


function myfunction(system)

--p1=vec3(-43444811.6972,22521531.4367,-48844295.7649)
--p2=vec3(58543373.1261,29616903.0503,58049826.3334)
--p3=vec3(98778326.5840,-13441144.3062,-806891.3039)
--p4=vec3(14523791.3243,-85546713.5184,-894809.5085)

p1=vec3(-43534464.00,22565536.00,-48934464.00) -- feli
p2=vec3(58665536.00,29665536.00,58165536.00) -- sinnen
p3=vec3(98865536.00,-13534464.00,-934464.00) -- lacobus
p4=vec3(14165536.00,-85634464.00,-934464.00) -- symeon

FELI=6824.03
SYMEON=6175.58
SINNEN=6365.32
LACOBUS=6252.43

r1=FELI*200000
r2=SINNEN*200000
r3=LACOBUS*200000
r4=SYMEON*200000

    if r1 < r2 then
        r1, r2 = r2, r1
        p1, p2 = p2, p1
    end
    
    if r2 < r3 then
        r2, r3 = r3, r2
        p2, p3 = p3, p2
    end
    
    if r3 < r4 then
        r3, r4 = r4, r3
        p3, p4 = p4, p3
    end

                local r1s, r2s, r3s = r1*r1, r2*r2, r3*r3
                local v2 = p2 - p1
                local ax = v2:normalize()
                local U = v2:len()
                local v3 = p3 - p1
                local ay = (v3 - v3:project_on(ax)):normalize()
                local v3x, v3y = v3:dot(ax), v3:dot(ay)
                local vs = v3x*v3x + v3y*v3y
                local az = ax:cross(ay)  
                local x = (r1s - r2s + U*U) / (2*U) 
                local y = (r1s - r3s + vs - 2*v3x*x)/(2*v3y)
                local m = r1s - (x^2) - (y^2) 
                if m<0 then 
        return system.print("m<0")
       end
                local z = math.sqrt(m)
                local t1 = p1 + ax*x + ay*y + az*z
                local t2 = p1 + ax*x + ay*y - az*z
              
                if math.abs((p4 - t1):len() - r4) < math.abs((p4 - t2):len() - r4) then
                local pos = '::pos{0,0,'..t1.x..','..t1.y..','..t1.z..'}'
                poss=t1
                   system.print("----------------------------")
                   system.print(pos)
                   system.logInfo('cva: '..pos..'')
                   asteroidPOS = ""..pos..""
                   asteroidcoord = zeroConvertToWorldCoordinatesG(asteroidPOS,system)
                else
                  local pos = '::pos{0,0,'..t2.x..','..t2.y..','..t2.z..'}'
                  poss=t2
                   system.print("----------------------------")
                   system.print(pos)
                   --system.logInfo('webhook: '..pos..'') --deprecated
                   asteroidPOS = ""..pos..""
                   asteroidcoord = zeroConvertToWorldCoordinatesG(asteroidPOS,system)
                   --system.logInfo('webhook: '..pos..'') --deprecated
                   asteroidPOS = ""..pos..""
                   asteroidcoord = zeroConvertToWorldCoordinatesG(asteroidPOS,system)
                end
end