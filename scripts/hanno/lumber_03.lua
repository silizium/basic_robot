--coroutine

-- Creat new canvas with default values. 
local Turtle = {}
Turtle.__index = Turtle
Turtle._VERSION="turtle 1.0"
setmetatable(Turtle, {
	__call=function(cls, ...)
		return cls.new(...)
	end,
})
function Turtle.new()
    local self = setmetatable({}, Turtle)
    self.clear(self)
    -- This applies to waht Turtle.frame() will return.
    self.alpha_threshold = 10 -- Pixels with a alpha value below are printed as a space.
    self.esccodes = false -- Turn ecsape codes off (false) to use only your Terminal Standard Color.
	self:reset() -- reset turtle attributes
    return self
end


function Turtle.line(x1, y1, x2, y2)
    --Returns the Bresnham line coords between (x1, y1), (x2, y2)
    --@Parameter: x1 coordinate of the startpoint
    --@Parameter: y1 coordinate of the startpoint
    --@Parameter: x2 coordinate of the endpoint
    --@Parameter: y2 coordinate of the endpoint
	--@Returns: a coroutine yielding x,y
	--
	return coroutine.wrap(function()
		local x1 = math.floor(x1+.5)
		local y1 = math.floor(y1+.5)
		local x2 = math.floor(x2+.5)
		local y2 = math.floor(y2+.5)

		local dx = math.abs(x2-x1)
		local dy = -math.abs(y2-y1)
		local sx=x1<x2 and 1 or -1
		local sy=y1<y2 and 1 or -1
		local err, e2=dx+dy, 0
		
		repeat
			coroutine.yield (x1, y1)
			if x1==x2 and y1==y2 then break end
			e2=2*err
			if e2>dy then err=err+dy; x1=x1+sx end
			if e2<dx then err=err+dx; y1=y1+sy end
		until false
	end)	
end

function Turtle.ellipse(xm, ym, a, b)
    --[[Returns the Bresnham line coords between (x1, y1), (x2, y2)
    @Parameter: xm coordinate of the middlepoint
    @Parameter: ym coordinate of the middlepoint
    @Parameter: a radius x
    @Parameter: b radius y
	@Returns: a coroutine yielding x,y
    ]]
	return coroutine.wrap(function()
		a,b=math.floor(a+.5),math.floor(b+.5)
		local dx, dy = 0, b
		local a2, b2 = a^2, b^2
		local err, e2 = b2-(2*b-1)*a2, 0
		repeat
			coroutine.yield(xm+dx, ym+dy)
			coroutine.yield(xm-dx, ym+dy)
			coroutine.yield(xm-dx, ym-dy)
			coroutine.yield(xm+dx, ym-dy)
			e2=2*err
			if e2 <  (2*dx+1)*b2 then
				dx=dx+1; err=err+(2*dx+1)*b2
			end
			if e2 > -(2*dy-1)*a2 then
				dy=dy-1; err=err-(2*dy-1)*a2
			end
		until dy<0
	end)	
end



function Turtle:reset(x,y,dir,down)
	self.x		=x or 0
	self.y		=y or 0
	self.dir	=dir or 0
	self.down	=down or true
	self.stack	={}
end
function Turtle:up()
	self.down = false
end
function Turtle:down()
	self.down = true
end
function Turtle:forward(step, r, g, b)
	local x = self.x + math.cos(math.rad(self.dir)) * step
	local y = self.y + math.sin(math.rad(self.dir)) * step
	--prev_brush_state = self.brush_on
	--self.brush_on = True
	self:move(x, y, r, g, b)
	--self.brush_on = prev_brush_state
end
function Turtle:back(step)
	self:forward(-step)
end
function Turtle:move(x,y)
	if self.down then
		for lx, ly in Canvas.line(self.x, self.y, x, y) do
			self:set(lx, ly)
		end
	end
	self.x = x
	self.y = y
end
function Turtle:right(angle)
	self.dir=self.dir+angle
end
function Turtle:left(angle)
	self.dir=self.dir-angle
end
function Turtle:push()
	table.insert(self.stack, self.dir)
	table.insert(self.stack, self.x)
	table.insert(self.stack, self.y)
	return self.dir, self.x, self.y
end
function Turtle:pop()
	self.y=table.remove(self.stack) or self.y
	self.x=table.remove(self.stack) or self.x
	self.dir=table.remove(self.stack) or self.dir
	return self.dir, self.x, self.y
end
function Turtle:draw(str)
	--
	--  Draw a lindenmayer string with the canvas draw "language"
	--  @Parameter: str the lindenmayer string
	--   The drawing language interprets following commands:
	--   F - draw forward
	--   L - turn left
	--   R - turn right
	--   M - move without drawing
	--   N - reset position to all 0,0
	--   S - define stepsize (defaults 1)
	--   T - define turnsize (defaults 1 deg)
	--   X - eXchange rule with new one
	--   Z - Zufall (random) select symbol
	--   + Push pos+rotation
	--   - Pull pos+rotation
	--   <num> repeats following command num times
	--  @Return: self
	local rep,step,turn=0,1,1
	for c in str:gmatch(".") do
		if c=="F" then 	-- forward
			self.down=true
			self:forward((rep>1 and rep or 1)*step)
			rep=0
		elseif c=="+" then -- push rot
			self:push()
		elseif c=="-" then -- pull rot
			self:pop()
		elseif c=="L" then -- turn left
			self:left((rep>1 and rep or 1)*turn)
			rep=0
		elseif c=="R" then -- turn right
			self:right((rep>1 and rep or 1)*turn)
			rep=0
		elseif c=="M" then -- move without drawing
			self.down=false
			self:forward((rep>1 and rep or 1)*step)
			rep=0
		elseif c=="N" then -- reset postion to 0
			self:reset()
			rep,step=0,1
		elseif c=="S" then -- default stepsize
			step=rep>1 and rep or 1
			rep=0
		elseif c=="T" then -- default turnsize
			turn=rep>1 and rep or 1
			rep=0
		elseif c:match("%d") then -- allow repeated commands
			rep=rep*10+tonumber(c)
		end
	end
	return self
end

function string:lindenmayer(n,subst)
	-- Lindenmayer string substituation		
	--	@Parameter: n	number depth of iteration of the lindenmayer substitution
	--	@Parameter: var	string of to replace symbols
	--	@Parameter: subst table of substituations for symbols
	--	@Return: returns lindenmayer string
	--	
	--	Example for the Hilbert curve implemented by Lindenmayer system
	--	local str="3S90TA" -- stepsize=3 turnsize=90 startsymbol="A"
	--	str=str:lindenmayer(3,"AB",{["A"]="LBFRAFARFBL",["B"]="RAFLBFBLFAR"})
	--	print(c:frame(str))
	
	subst=subst or {} --["A"]="LBFRAFARFBL",["B"]="RAFLBFBLFAR"}
	for i=1,n do
		self=self:gsub("X(.-)X(.-)X", function(k,v)
			subst[k]=v
			return ""                                                            
		end)
		self=self:gsub("Z(.-)Z", function(c)
			local r=math.random(#c)
			return c and c:sub(r,r) or c
		end)
		for k,v in pairs(subst) do
			if #k>1 then
				self=self:gsub(k,v)
			end
		end
		self=self:gsub("(.)", function(c) 
			return subst[c] or c
		end)
	end
	return self
end




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

