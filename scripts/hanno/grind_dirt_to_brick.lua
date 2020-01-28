--coroutine
self.label("Grinder")
local fuel="default:leaves"
local grind="default:dirt"

local function generate(pow)
   while machine.energy()<pow do
      local m=check_inventory.self(fuel)
      if not m then 
           say("No fuel")
           self.remove() 
      else
         machine.generate_power(fuel)
         pause()
      end
  end
end


for i=1,99 do
   generate(0.5)
   say(string.format("%d pass %.3f energy... grinding",i, machine.energy(), grind))
   if machine.grind(grind) then
      pause()
   else
      say("Ready with grinding")
      pause()
      break
   end
end
-- smelt
local smelt="default:clay_lump"
while check_inventory.self(smelt) do
   generate(.2)
   machine.smelt(smelt,0.2, "default:clay_brick") pause()
end
say("Ready with smelting")
say("Crafting")
local build="default:brick"
while check_inventory.self("default:clay_brick 4") do
    craft(build, 23) 
end
say("Done")
