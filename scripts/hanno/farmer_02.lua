local coroutine, yield=_G.coroutine, _G.coroutine.yield
local tostring=_G.tostring
local function cost(actioncost)
	actioncost=actioncost or 2
	actions=actions-actioncost
	if actions<=0 then
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

local ripe={"farming:wheat_8","farming:cotton_8"}
local seed={"farming:seed_wheat", "farming:seed_cotton"}

function farm(fld)
   local type
   local node=read_node.forward()
   for i=1,#ripe do
     if node==ripe[i] then
        turtle("F")
        cost(2) place.forward(seed[i])
     elseif node=="air" then
        cost(2) place.forward(seed[fld])
     end
   end
   turtle("f")
end

if not step then
  self.label("Bob der Farmer")
  actions=0
   row=27
   line=3
   fields=2
   step=coroutine.wrap(function() 
      turtle("f>")
      for fld=1,fields do 
        for l=1,line do
           for j=1,row do
             farm(fld)
           end
           turtle("f") 
           if (l+fld)%2==0 then turtle("l") else turtle("r") end 
           turtle("<<")
        end
        turtle("r")
     end
     turtle("l")
     turtle("b")
     for i=1,32 do
        repeat
           m=check_inventory.self("", "main", i)
           if m~="" then 
              cost(2) insert.backward(m)
           end
        until m==""
     end
     for i=1,#seed do
       for j=1,10 do cost(2) take.backward(seed[i]) end
     end 
     turtle("f7r<")
     self.remove()
   end)
else
   step()
end

