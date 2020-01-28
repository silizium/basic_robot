local co=_G.coroutine
local yield=co.yield

local stuff="cobble"  -- what to move

local function unload(str)
         local m
         for i=1,32 do
            m=check_inventory.self("", "main", i)
            if m:match(str) then
               insert.left_down(m,str) yield()
            end
         end 
end


if not step then
   step=co.wrap(function()
      unload(stuff)
      for chest=1,4 do
         for i=1,chest do fly.forward() yield() end
      
         for i=1,32 do
              local m=check_inventory.left_down("", "main", i)
              if m:match(stuff) then
                  take.left_down(m) yield()
              end
         end
         for i=1,chest do fly.backward() yield() end
         unload(stuff)
        end
    self.remove()
   end)
else
   step()
end
