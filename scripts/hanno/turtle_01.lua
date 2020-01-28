local coroutine, yield=_G.coroutine, _G.coroutine.yield
local tostring=_G.tostring

local cmd = {
	["f"]=function() fly.forward() yield() end,
	["b"]=function() fly.backward() yield() end,
	["l"]=function() fly.left() yield() end,
	["r"]=function() fly.right() yield() end,
	["u"]=function() fly.up() yield() end,
	["d"]=function() fly.down() yield() end,

	["<"]=function() turn.left() yield() end,
	[">"]=function() turn.right() yield() end,

	["F"]=function() dig.forward() yield() end,
	["B"]=function() dig.backward() yield() end,
	["L"]=function() dig.left() yield() end,
	["R"]=function() dig.right() yield() end,
	["U"]=function() dig.up() yield() end,
	["D"]=function() dig.down() yield() end,

	["P"]=function(n) pickup(n or 8) end,
}

function turtle(str)
	--[[
	  Draw a turtl string with the canvas draw "language"
	  @Parameter: str the lindenmayer string
	   The drawing language interprets following commands:
	   F - draw forward
	   L - turn left
	   R - turn right
	   M - move without drawing
	   N - reset position to all 0,0
	   S - define stepsize (defaults 1)
	   T - define turnsize (defaults 1 deg)
	   X - eXchange rule with new one
	   Z - Zufall (random) select symbol
	   + Push pos+rotation
	   - Pull pos+rotation
	   <num> repeats following command num times
	  @Return: self
	]]
	local rep,step,turn=0,1,1
	for c in str:gmatch(".") do
		if c:match("[fblrud]") then 
			rep=rep>1 and rep or 1
			for i=1,rep*step do cmd[c]() end
			rep=0
		elseif c:match("[FBLRUD]") then 
			cmd[c]()
			rep=0
		elseif c:match("[<>]") then 
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


if not step then
   self.label("Turtle")
   step=coroutine.wrap(function()
	  turtle("10u10f10d10b")
      self.remove()
   end)
else
  step()
end

