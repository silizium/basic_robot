local a2e = function(a,f,g) 
	local b = a; 
	local c = 0; 
	while b>0 and c < f do 
		local d = b%2; 
		c=c+1; 
		g[c] = d 
		b=(b-d)/2 
	end 
	for N = c+1, f do 
		g[N] = 0 
	end 
end 
local e2a = function(e) 
	local f = #e; 
	local g = 0; 
	local h = 1; 
	for c = 1, f do 
		g = g+h*e[c]; 
		h=h*2 
	end 
	return g 
end 
local a2hex = function(a) 
	local b = a; 
	local i = {"0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"}; 
	local c = 0; 
	local j = {}; 
	while b>0 do 
		local d = b%16; 
		c=c+1; 
		j[c] = i[d+1] b=(b-d)/16 
	end 
	local k = {}; 
	for c = 1, #j do 
		k[c] = j[#j-c+1] 
	end 
	return 
	table.concat(k,"") 
end 
local e2hex = function(e) 
	return a2hex(e2a(e)) 
end 
local l = function(C,h, offset1, offset2, g) 
	local m = #C;
	local n = #h; 
	for c = 1,math.min(#C,#h) do 
		g[c] = (C[(c+offset1-1)%m+1]==h[(c+offset2-1)%n+1]) and 0 or 1; 
	end 
end 
local o = function(C,h, offset1, offset2, g) 
	local m = #C;
	local n = #h; 
	for c = 1,#C do 
		g[c] = ((C[c+offset1] or 0) == (h[c+offset2] or 0)) and 0 or 1; 
	end 
end 
local p = function(C,h,g) 
	local q = 0 
	for c = 1,#C do 
		local d = C[c]+h[c]+ q; 
		if d>1 then 
			q = 1; 
			d = d-2 
		else 
			q = 0 
		end 
		g[c] = d 
	end 
end 
local r = function(C,h,g,is_not) 
	if is_not then 
		for c=1,#C do 
			g[c] = (C[c]==1 and h[c]==0) and 1 or 0 
		end 
	else 
		for c=1,#C do 
			g[c] = (C[c]==1 and h[c]==1) and 1 or 0 
		end 
	end 
end 
local s = function(C,h) 
	for c = 1,#C do 
		h[c]=C[c] 
	end 
end 
local t256_ = function(input) 
	local u = {}; 
	s(input,u); 
	local v0 = {};
	local v1 = {};
	local v2 = {};
	local v3 = {}; 
	local v4 = {};
	local v5 = {};
	local v6 = {};
	local v7 = {}; 
	a2e(1779033703,32,v0) 
	a2e(3144134277,32,v1) 
	a2e(1013904242,32,v2) 
	a2e(2773480762,32,v3) 
	a2e(1359893119,32,v4) 
	a2e(2600822924,32,v5) 
	a2e(528734635,32,v6) 
	a2e(1541459225,32,v7) 
	local z = {1116352408,1899447441,3049323471,3921009573,961987163,
	1508970993,2453635748,2870763221,3624381080,310598401,
	607225278,1426881987,1925078388,2162078206,2614888103,
	3248222580,3835390401,4022224774,264347078,604807628,
	770255983,1249150122,1555081692,1996064986,2554220882,
	2821834349,2952996808,3210313671,3336571891,3584528711,
	113926993,338241895,666307205,773529912,1294757372,
	1396182291,1695183700,1986661051,2177026350,2456956037,
	2730485921,2820302411,3259730800,3345764771,3516065817,
	3600352804,4094571909,275423344,430227734,506948616,
	659060556,883997877,958139571,1322822218,1537002063,
	1747873779,1955562222,2024104815,2227730452,2361852424,
	2428436474,2756734187,3204031479,3329325298} 
	local w = {};
	for c = 1,#z do 
		w[c] = {}; 
		a2e(z[c],32,w[c]) 
	end 
	local x = #u; 
	local y = {}; 
	a2e(x,64,y); 
	local z = (x+65) % 512; 
	if z>0 then z = 512-z end 
	x = x + 65+z; 
	u[#u+1 ] = 1; 
	for c = 1,z do 
		u[#u+1] = 0 
	end 
	z = #y; 
	for c=1,z do 
		u[#u+1] = y[z-c+1] 
	end 
	local A = x / 512; 
	local B = {}; 
	local C = {};
	local h = {};
	local d = {};
	local D = {}; 
	local E = {};
	local F = {};
	local G = {};
	local v = {}; 
	for c = 1,64 do 
		B[c] = {} 
	end 
	for chunk = 1, A do 
		for c = 1,16 do 
			for N = 1,32 do 
				B[c][N] = u[(chunk-1)*512+32*(c-1)+N] 
			end 
		end 
		local H0 = {};
		local H1 = {}; 
		for c = 17,64 do 
			l(B[c-15],B[c-15], 7,18,H0); 
			o(H0,B[c-15],0,3,H0) l(B[c-2], B[c-2], 17,19,H1); 
			o(H1, B[c-2], 0,10,H1); 
			p(H0,H1,H1); 
			p(H1,B[c-16],H1); 
			p(H1,B[c-7],B[c]); 
		end 
		s(v0,C) s(v1,h) s(v2,d) s(v3,D) s(v4,E) s(v5,F) s(v6,G) s(v7,v); 
		local I0 = {} ;
		local I1 = {};
		local J ={}; 
		local K = {} ;
		local L1 = {}; 
		local M = {}; 
		local L2 = {}; 
		for c=1,64 do 
			l(E,E,6,11,I1); 
			l(I1,E,0,25,I1) 
			r(E,F,K); 
			r(G,E,J,true); 
			l(K,J,0,0,J); 
			p(v,I1,K); 
			p(K,J,K); 
			p(K,w[c],K); 
			p(K,B[c],L1); 
			l(C,C,2,13,I0); 
			l(I0,C,0,22,I0); 
			r(C,h,K); 
			r(C,d,L2); 
			l(K,L2,0,0,K); 
			r(h,d,L2); 
			l(K,L2,0,0,M); 
			p(I0,M,L2) s(G,v) s(F,G) s(E,F) p(D,L1,E) s(d,D) s(h,d) s(C,h) p(L1,L2,C) 
		end 
		p(v0,C,v0) p(v1,h,v1) p(v2,d,v2) p(v3,D,v3) p(v4,E,v4) p(v5,F,v5) p(v6,G,v6) p(v7,v,v7) 
	end 
	return e2hex(v0) .. e2hex(v1) .. e2hex(v2) .. e2hex(v3) 
		.. e2hex(v4) .. e2hex(v5) .. e2hex(v6) .. e2hex(v7) 
end 
str2e = function(text) 
	local j = {}; 
	local e = {}; 
	for c = 1,string.len(text) do 
		local d = string.byte(text,c); 
		a2e(d,8,e); 
		for N = 1,8 do 
			j[#j+1] = e[N] 
		end 
	end 
	return j 
end 
fun = function(text) return t256_(str2e(text)) end 
 
say(fun("hello world!"))
