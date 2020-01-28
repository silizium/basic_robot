local coroutine, yield=_G.coroutine, _G.coroutine.yield
local tostring=_G.tostring

local verse={
  "Ich bin Holzfaeller und mir geht's gut,",
  "am Tag packt mich die Arbeitswut.",
  "Er ist Holzfaeller und ihm geht's gut,",
  "am Tag packt ihn die Arbeitswut!",
  "Ich faell' den Baum und ess' mein Brot,",
  "geh' auch mal auf's WC!",
  "Am Mittwoch geh' ich bummeln",
  "und nehm Gebaeck zum Tee!",
  "Ich faell' den Baum und spring herum,",
  "an Bluemchen hab' ich Spass!",
  "Ich trage Frauenfummel",
  "und haeng herum in Bars!",
  "Ich faell' den Baum, trag Stoeckelschuh',",
  "Strapse und BH!",
  "Ich waer' so gern ein Maedel,",
  "genau wie mein Papa!",
  "Oh, Bavis! Und ich dachte immer, du waerst so maennlich!",
}
local function cost(actioncost)
	--say(string.format("actions %d cost %d", actions, actioncost))
	actioncost=actioncost or 2
	actions=actions-actioncost
	if actions<=0 then
		--say("yielding...")
		yield()
		actions=8
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

-- recursive treestrip
function treestrip(n,toside)
   local gotsome=false
   if not read_node.forward():match("air") then 
      turtle("F")
	  gotsome=true
   end
   turtle("f")
   for i=1,toside do
	   if not read_node.left():match("air") then
		  turtle("L")
		  gotsome=true
	   end
	   turtle("l")
   end
   turtle(string.format("%dr",toside))
   for i=1,toside do
	   if not read_node.right():match("air") then
		  turtle("R")
		  gotsome=true
	   end
	   turtle("r")
   end
   turtle(string.format("%dl",toside))
   if gotsome and n>1 then treestrip(n-1, toside) end
   turtle("b")
   return gotsome
end


if not step then
   self.label("Kanadischer Holzfaeller")
   actions=0
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
      turtle("Ff")
      -- Start des Stripmining
      local height=1
	  local toside=2
	  local gotsome
	  local air
      repeat
		 gotsome=false
         for i=1,4 do
            gotsome=gotsome or treestrip(height, toside)
            turtle("<")
         end
         air=read_node.up():match("air")
         if not air then
            turtle("U")
			gotsome=true
         end
         height=height+1
         turtle("u")
		 --say(tostring(gotsome))
      until not gotsome
      turtle(string.format("10P%dd4P",height))
	  cost(2) place.down("default:sapling")
      self.remove()
   end)
else
  step()
end

