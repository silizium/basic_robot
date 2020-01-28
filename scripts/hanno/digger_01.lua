--coroutine
local function cost(buy)
    debit=debit-buy
    if debit <=0 then
      debit=6
      pause()
    end
end
local dirs={"forward", "left", "right", "backward"}

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

local function mine()
    for k,v in ipairs(dirs) do
        local m=read_node[v]()
        if m:match("stone_with") then
            say("digging "..m)
            cost(6) dig[v]()
        end
    end
end

debit=6
self.label("Digger")
cost(2) fly.forward()
repeat 
   if read_node.down() == "air" then
      cost(2) fly.down()
   elseif read_node.down() ~= "default:dirt" then 
      cost(6) machine.generate_power("default:coalblock", 0.04)
      cost(6) dig.down()
      cost(2) fly.down()
   end
   mine()
   dangerscan()
   --cost(2) place.up("default:ladder")
until false
self.remove()
