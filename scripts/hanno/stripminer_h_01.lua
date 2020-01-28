--coroutine
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

debit=6
self.label("Horizontal Digger")
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
-- End Setup
-- Start digging, max distance is 32
for i=1,8*2+1 do 
   if read_node.forward() == "air" then
      cost(2) fly.forward()
   elseif read_node.forward() ~= "default:dirt" then 
      cost(6) machine.generate_power("default:coalblock", 0.04)
      cost(6) dig.forward()
      cost(2) fly.forward()
   end
   mine(i)
   dangerscan()
end
for i=1,8 do
   cost(2) fly.backward()
   cost(2) place.forward("tnt:tnt")
   say("Place TNT "..i)
   cost(2) fly.backward()
end
say("End mission")
self.remove()
