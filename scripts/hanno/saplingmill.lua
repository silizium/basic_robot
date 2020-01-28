--coroutine 
say("Sapling-mill v2.0")
self.label("Sapling Mill")

local leaves={ 
      "default:acacia_leaves", --> acacia-tree
      "default:aspen_leaves",  --> aspen-tree
      "default:pine_needles",  --> pine-tree
      "default:leaves",        --> sappling for apple-trees
      "default:jungleleaves",  --> jungle-trees
--      "default:dry_shrub", --> doesn't give anything
--      "default:bush_leaves", --> bush strem? Waiting for long time
--      going on forever from here, no grass lost
      "default:junglegrass",  --> cotton-seeds
      "default:grass",        --> wheat-seeds / server-error ??
      "default:grass_1",      --> wheat-seeds 
}


local function cost(buy)
    debit=debit and debit-buy or 6-buy
    if debit <=0 then
      debit=6
      pause()
    end
end


local function getitem(itemlist)
   local node
   for k,v in ipairs(itemlist) do
     node=check_inventory.self(v, "main")
     if node then 
       node=v  break 
     else
       node=nil
     end
   end
   return node
end

local fail=0
repeat 
   cost(6) dig.forward()	-- first dig & collect, then place
   cost(4) pickup(8)     	-- collect saplings on ground that dropped after dig
 
   cost(2)
   local node=getitem(leaves)
   if node and place.forward(node) then 
      fail=0
   else 
      fail=fail+1 
   end
 
   cost(2) turn.left()
 
until fail>4
say(s.." done with "..leaves)  self.remove()
