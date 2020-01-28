local coroutine, yield=_G.coroutine, _G.coroutine.yield
local tostring=_G.tostring

local verse=[[
Michael Palin:
Ich bin Holzfaeller und mir geht's gut,
am Tag packt mich die Arbeitswut!

Mounties:",
Er ist Holzfaeller und ihm geht's gut,
am Tag packt ihn die Arbeitswut!

Palin:
Ich faell' den Baum und ess' mein Brot,
geh' auch mal auf's WC!
Am Mittwoch geh' ich bummeln
und nehm Gebaeck zum Tee!

Mounties:
Er faellt den Baum und isst sein Brot,
geht auch mal auf's WC!
Am Mittwoch geht er bummeln
und nimmt Gebaeck zum Tee!
Er ist Holzfaeller und ihm geht's gut!
Am Tag packt ihn die Arbeitswut!

Palin:
Ich faell' den Baum und spring herum,
an Bluemchen hab' ich Spass!
Ich trage Frauenfummel
und haeng herum in Bars!

Mounties:
Er faellt den Baum und springt herum,
an Bluemchen hat er Spass!
Er traegt gern Frauenfummel?
Und...? HAENGT HERUM IN BARS?
Er ist Holzfaeller und ihm geht's gut!
Am Tag packt ihn die Arbeitswut!

Palin:
Ich faell' den Baum, trag Stoeckelschuh',
Strapse und BH!
Ich waer' so gern ein Maedel, 
genau wie mein Papa!

Mounties:
Er faellt den Baum, traegt Stoeckelschuh'?
Strapse und ... BH?
(verlassen murrend und schimpfend das Bild)

Palin:
Ich waer' so gern ein Maedel,
genau wie mein Papa!

Maedchen (Connie Booth):
Oh, Bavis! Und ich dachte immer, du waerst so maennlich! (rennt weg)
]]

local function cost(actioncost)
	actioncost=actioncost or 2
	actions=actions-actioncost
	if actions<=0 then
		if sing then sing() end
		yield()
		actions=6
	end
end

local cmd = {
	["f"]=function() cost(2) fly.forward() end,
	["b"]=function() cost(2) fly.backward() end,
	["l"]=function() cost(2) fly.left() end,
	["r"]=function() cost(2) fly.right() end,
	["u"]=function() cost(2) fly.up() end,
	["d"]=function() cost(2) fly.down() end,

	["<"]=function() cost(2) turn.left() end,
	[">"]=function() cost(2) turn.right() end,

	["F"]=function() cost(6) dig.forward() end,
	["B"]=function() cost(6) dig.backward() end,
	["L"]=function() cost(6) dig.left() end,
	["R"]=function() cost(6) dig.right() end,
	["U"]=function() cost(6) dig.up() end,
	["D"]=function() cost(6) dig.down() end,

	["P"]=function(n) cost(4) pickup(n or 8) end,
}

function turtle(str)
	local rep,step,turn=0,1,1
	for c in str:gmatch(".") do
		if c:match("[fblrud]")~=nil then 
			rep=rep>1 and rep or 1
			for i=1,rep*step do cmd[c]() end
			rep=0
		elseif c:match("[FBLRUD]")~=nil then 
			cmd[c]()
			rep=0
		elseif c:match("[<>]")~=nil then 
			rep=(rep>1 and rep or 1)%4
			for i=1,rep do cmd[c]() end
			rep=0
		elseif c=="+" then -- push rot
			--self:push()
		elseif c=="-" then -- pull rot
			--self:pop()
		elseif c=="N" then -- reset postion to 0
			--self:reset()
			--rep,step=0,1
		elseif c=="S" then -- default stepsize
			step=rep>1 and rep or 1
			rep=0
		elseif c=="P" then -- Pickup
            cmd[c](rep)
			rep=0
		elseif c:match("%d") then -- allow repeated commands
			rep=rep*10+tonumber(c)
		end
	end
	return str
end

local dir={"forward", "backward", "left", "right", 
   "forward_up", "forward_down",
   "backward_up", "backward_down",
   "left_up", "left_down",
   "right_up", "right_down"}
function harvest_cube()
   local gotsome=false
   for k,v in ipairs(dir) do
	   if not read_node[v]():match("air") then
		   cost(6) dig[v]()
		   gotsome=true
	   end
   end
   return gotsome
end

function treestrip()
   local gotsome=false
   local str="flbbrrff"
   for c in str:gmatch(".") do
      gotsome=harvest_cube() or gotsome
      turtle(c)
   end
   turtle("lb")
   return gotsome
end

if not step then
   self.label("Bavis der Holzfaeller")
   actions=0
   verseline=1
   step=coroutine.wrap(function()
      local tree
      for i=1,4 do
         tree=read_node.forward()
         if tree:match("tree") then
            break
         else
            turtle("<")
         end
      end
      if tree=="" then 
         say("Keine Baeume, ich geh' in die Bar") 
         self.remove() 
      end
      -- Init des Baumfarms
      turtle("FfUu")
      -- Start des Stripmining
	  local gotsome
	  local height=2
      repeat
         gotsome=treestrip()
         turtle("u")
         height=height+1
      until not gotsome
      turtle(string.format("10P%dd4Pb",height))
	  yield()
	  local sapling={["default:sapling"]=true, ["default:aspen_sapling"]=true,
	  	["default:junglesapling"]=true, ["default:pine_sapling"]=true, 
		["default:emergent_jungle_sapling"]=true,}
     for i=1,32 do
        m=check_inventory.self("", "main", i)
		if sapling[m] then
           yield() place.forward(m)
		   goto done
        end
     end
	 ::done::

      self.remove()
   end)
   sing=coroutine.wrap(function()
		for line in verse:gmatch("(.-)\n") do
			say(line)
			yield()
		end
		sing=nil
	end)
else
  step()
end

