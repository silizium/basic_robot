local co=_G.coroutine
local yield=co.yield


local function unload(str)
         local m
         for i=1,32 do
            m=check_inventory.self("", "main", i)
            if m:match(str) then
               insert.right_down(m,str) yield()
            end
         end 
end


if not step then

   step=co.wrap(function()
      local from="cobble"
      local to="desert"  -- what to move
      -- unload(stuff)
         for i=1,75 do
              local m=check_inventory.left_down("", from, i)
              if m:match(to) then
                  say("Moving "..m)
                  local found
                  repeat
                     found=take.left_down(m,from) 
                     insert.left_down(m,to) yield()
                  until not found
              end
         end
    self.remove()
   end)
else
   step()
end
