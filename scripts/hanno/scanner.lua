--coroutine
s="Ore-detector3 v0.2"
say(s)
self.label(s)
--Table of stuff to search:
local ores={'@diamond', '@mese', '@gold', 
  '@copper', '@iron', '@coal', 
--'!torch', '!torch_wall',
  '!lava_source',  '!lava_flowing',
  '!water_source', '!water_flowing',
}   --todo: moreores, mobs
say(string.format("I am searching for %d items.", #ores))

local searching="Searching for "
for k,ore in ipairs(ores) do
	ores[k]=ore:gsub("@","default:stone_with_"):gsub("!", "default:")
	searching=searching..ores[k]..", "
end
say(searching)
local found={}
for dist=1,8 do
local line=nil
	for k,ore in ipairs(ores) do
		if not found[ore] and find_nodes(ore, dist) then
			line=line and line..", "..ore or dist..": "..ore
			found[ore]=true
		end
	end
	if dist==4 and k==1 then pause() end
	if line then say(line) end
end
self.remove()
