pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
--snake remade
--recreated by mr awesome
player = {
	x=64, --x position
	y=64, --y position
	f=2, --facing, for sprite rendering
	lx=64, --previous move x (for moving)
	ly=64,  --previous move y (for moving)
	w=8, --width, for collisions
	h=8 --height, for collisions
}
boundry = {
	x=0,
	y=0,
	w=256,
	h=256
}
function gridcol(obj,obj2)
	return obj.x == obj2.x and obj.y == obj2.y
end
function showboundry()
	rect(boundry.x,boundry.y,boundry.w-1,boundry.h-1)
end
--[[
for whatever reason,
this code is required
instead of a #
it creates a blinking of
snake parts
|
v
--]]
function tl(t)
	local tc = 0
	for _ in pairs(t) do tc+=1 end
	return tc
end


eaten = true -- if you have eaten a berry
parts = {} --to hold data for snake parts
moving = false --if you have pressed keys

function addpart(x,y) --to easily add parts
	local data = {x=x,y=y,w=8,h=8} --to hold data
	add(parts,data,1)
end
function detectdeath()
	local isended = false
	for k,v in pairs(parts) do
		if gridcol(player,parts[k]) then isended=true end
	end
	if player.x < boundry.x or player.x > boundry.x+boundry.w or player.y < boundry.y or player.y > boundry.y + boundry.h then isended=true end
	return isended
end
addpart(64,88)
addpart(64,80)
addpart(64,72)
player.draw = function() 
	spr(player.f--[[the way sprites are organized allows for this--]],player.x,player.y)
end
function getinput()
	if btnp() != 0 then moving=true end
	if(parts[1] == nil) then
	--^ tests if there are parts
	--[[
	below is possible because
	of the sprite layout. 0-3 is
	only for snake head sprites
	in a specific order
	]]--
		if btn(0) then player.f = 0 end
		if btn(1) then player.f = 1 end
		if btn(2) then player.f = 2 end
		if btn(3) then player.f = 3 end
	else
		if btn(0) and parts[1].x >= player.x then player.f = 0 end
		if btn(1) and parts[1].x <= player.x then player.f = 1 end
		if btn(2) and parts[1].y >= player.y then player.f = 2 end
		if btn(3) and parts[1].y <= player.y then player.f = 3 end
	end
end
function updpos()
	player.lx = player.x
	player.ly = player.y
	--player smart control
	--checks where to move, then moves
	if moving then
		if player.f == 0 then player.x -= 8 end
		if player.f == 1 then player.x += 8 end
		if player.f == 2 then player.y -= 8 end
		if player.f == 3 then player.y += 8 end
		--[[
		removes the last part, and
		adds a new one at the beggining
		]]--
		if not eaten then --allows for eating berries
			parts[tl(parts)] = nil
		end
		addpart(player.lx,player.ly)
		eaten = false
	end
end	
ticks = 0
function _update()
	cls(1)
	if not moving then
		print('press any button to start',player.x-48,player.y-48)
	end
	if detectdeath() then
		for k,v in pairs(parts) do
			parts[k]=nil
		end
		player.x = (boundry.x+boundry.w)/2
		player.y = (boundry.y+boundry.h)/2
		moving = false
	end
	for k,v in pairs(parts) do
		--[[
		loops through all values
		in the parts table
		k is the key in the table
		v is the value (if you need it)
		--]]
		spr(4,parts[k].x,parts[k].y)
	end
	player.draw()
	showboundry()
	getinput()
	if ticks%6==0 then updpos() end
	if(boundry.x+boundry.w > 128 or boundry.y+boundry.h > 128) then
		camera(player.x-64,player.y-64)
	end
	ticks+=1
end

__gfx__
22222222222222222222222222222222222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
28111882288117822888888228888882288888820003000000000000000000000000000000000000000000000000000000000000000000000000000000000000
28711882288111822718871228888882288888820000300000000000000000000000000000000000000000000000000000000000000000000000000000000000
28888882288888822118811221188112288888820088880000000000000000000000000000000000000000000000000000000000000000000000000000000000
28888882288888822118811221188112288888820088880000000000000000000000000000000000000000000000000000000000000000000000000000000000
28111882288117822888888221788172288888820088880000000000000000000000000000000000000000000000000000000000000000000000000000000000
28711882288111822888888228888882288888820008800000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222222222222222222222222222222222220008800000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
