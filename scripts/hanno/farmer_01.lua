local coroutine=_G.coroutine
local yield=coroutine.yield
local ripe={"farming:wheat_8","farming:cotton_8"}
local seed={"farming:seed_wheat", "farming:seed_cotton"}

function farm(fld)
   local type
   local node=read_node.forward()
   for i=1,#ripe do
     if node==ripe[i] then
        dig.forward()
        place.forward(seed[i])
     elseif node=="air" then
        place.forward(seed[fld])
     end
   end
   move.forward()
end

if not i then
  self.label("Bob der Farmer")
   i=1
   row=27
   line=3
   fields=2
   f=coroutine.wrap(function() 
      move.forward()  turn.right()  yield(true)
      for fld=1,fields do 
        for l=1,line do
           for j=1,row do
             farm(fld) yield(true)
           end
           move.forward() 
           if (l+fld)%2==0 then move.left() else move.right() end 
           yield(true)
           turn.left()
           turn.left()
        end
        move.right() yield(true)
     end
     move.left()
     move.backward() yield(true)
     for i=1,32 do
        repeat
           m=check_inventory.self("", "main", i)
           if m~="" then 
              insert.backward(m) yield(true)
           end
        until m==""
     end
     for i=1,#seed do
       for j=1,10 do take.backward(seed[i]) yield(true) end
     end 
     move.forward() yield(true)
     for i=1,7 do move.right() yield(true) end
     turn.left() yield(true)
   end)
else
   num=f()
   if num==nil then 
      self.remove()
   end
end
