--coroutine
--
-- Place TNT stripminer against a wall and start it
--
-- Global setup values, robot needs:
--
-- 8 tnt packages (sensible, more might throw him out of 64 mapload range and fail)
-- 1 goldblock
-- 1 meseblock
-- 1 diamondblock 
-- ~32 block of cobble to stuff holes
--
-- 2 safety should be enough
---------------------------------
debit=6
safety=2
tntloads=10
---------------------------------

local function cost(buy)
    debit=debit-buy
    if debit <=0 then
      debit=6
      pause()
    end
end
local dirs={"left", "right", "up", "down"}

local function dangerscan()
    local danger={
            ["air"]=true, ["default:lava_source"]=true, ["default:water_source"]=true, 
            ["default:lava_flowing"]=true, ["default:water_flowing"]=true,}
    for k,v in ipairs(dirs) do
        local m=read_node[v]()
        --say(v..":"..m)
        if danger[m] then
           say("closing gap with "..m)
           cost(2) place[v]("default:cobble")
        end
    end
end

local function mine(depth)
	depth=depth or "unknown"
    for k,v in ipairs(dirs) do
        local m=read_node[v]()
        if m:match("stone_with") then
            say("digging "..m.." in "..depth)
            cost(6) dig[v]()
        end
    end
end
local function distance(pos1, pos2)
	if not pos1 or not pos2 then return 0 end
	return math.sqrt((pos1.x-pos2.x)^2+(pos1.y-pos2.y)^2+(pos1.z-pos2.z)^2)
end

local ores={'@diamond', '@mese', '@gold', 
  '@copper', '@iron', 
--  '@coal', -- too cheap don't TNT stripmine for coal
--'!torch', '!torch_wall',
--  '!lava_source',  '!lava_flowing',
--  '!water_source', '!water_flowing',
}   --todo: moreores, mobs
for k,ore in ipairs(ores) do
	ores[k]=ore:gsub("@","default:stone_with_"):gsub("!", "default:")
end
local function is_ore(r)
	local found={}
	pause()
	for dist=2,r do
		local line=nil
		for k,ore in ipairs(ores) do
			if not found[ore] and find_nodes(ore, dist) then
				line=line and string.format("%s, %s", line, ore) or string.format("%d: %s", dist, ore)
				found[ore]=true
			end
		end
		if line then say(line) end
	end
	pause()
	return next(found)~=nil
end

local name="Horizontal Digger"
self.label(name)
say(name)
-- Setup against the wall
local n
for i=1,4 do
	n=read_node.forward()
	if n=="air" then
		cost(2) turn.right()
	else
		break
	end
end
if n=="air" then 
	say("No walls to dig")
	self.remove()
end
-- gain safety distance
for i=1,safety do 
	cost(2) dig.forward()
	cost(2) fly.forward()
	dangerscan()
end
-- End Setup
-- Start digging
local stop=false
local boredepth=safety
for hole=1,tntloads do
	--borehole
	for i=1,7 do
		local pos1=self.pos()
		if read_node.forward() == "air" then
			cost(2) fly.forward()
		elseif read_node.forward() ~= "default:dirt" then 
			cost(6) machine.generate_power("default:coalblock", 0.04)
			cost(6) dig.forward()
			cost(2) fly.forward()
		else
			dig.forward()
			cost(2) fly.forward()
		end
		boredepth=boredepth+1
		mine(boredepth)
		dangerscan()
		local pos2=self.pos()
		if distance(pos1,pos2)<0.5 then
			say("run out of controlrange")
			stop=true
			goto exit
		end
   end
   --place TNT
   for i=1,3 do cost(2) fly.backward() end
   if is_ore(3) then
	   stop=not place.backward("tnt:tnt")
	   if stop then goto exit end
	   say("Hole "..hole..": placing TNT and igniting...")
	   ignite.backward()
   else
	   say("Hole "..hole..": no ore in vicinity, no TNT")
   end
   for i=1,3 do cost(2) fly.forward() end
   for i=1,4 do pause() end
   cost(4) pickup(8)
end
::exit::
say("End mission")
self.remove()
