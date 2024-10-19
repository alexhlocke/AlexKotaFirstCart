pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--fishing game 🐱 
--by alex & kota
-------------------------------

function _init()
 --set color palette
 reset_pal()
 --shortcuts to make it easier
	--to reset pal
	p=pal
	rp=reset_pal

 --create fish arcetypes
 init_fish()
 
 --set up interactalbes
 init_interactables()
 
 --set update/draw
 _upd=update_game
 _drw=draw_game
 
 --debug
	--add show debug menu item
	menuitem(1,"debug on/off",function()show_debug = not show_debug end)
 
 --init game
 init_game()
end


function _update()
 update_game()
 debug[1]="cpu: "..stat(1)
 debug[2]="mem: "..stat(0)
end


function _draw()
 draw_game()
end


--== random helpers ==----------

--printing

--prints with a border
function bprint(text,x,y,c,bc)
 for i=x-1,x+1 do
  for j=y-1,y+1 do
   print(text,i,j,bc)
  end
 end
 print(text,x,y,c)
end

--prints with a centered border
--(set x=63 to center on screen)
function bprint_cent(str,x,y,c,bc)
 bprint(str,x-(#str*2),y,c,bc)
end


--sprites

--outlined sprite
function ospr(c, n, x, y, w, h, flip_x, flip_y)
	w = w or 1
	h = h or 1
	flip_x = flip_x or false
	flip_y = flip_y or false
	
	pal({[0]=c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c}, 0)
	
	spr(n, x-1, y, w, h, flip_x, flip_y)
	spr(n, x+1, y, w, h, flip_x, flip_y)
	spr(n, x, y-1, w, h, flip_x, flip_y)
	spr(n, x, y+1, w, h, flip_x, flip_y)

	pal(0)
	
	spr(n, x, y, w, h, flip_x, flip_y)
end

--outlined special sprite
function osspr(c, sx, sy, sw, sh, dx, dy, dw, dh)
	w = w or 1
	h = h or 1
	flip_x = flip_x or false
	flip_y = flip_y or false
	
	pal({[0]=c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c}, 0)
	
	sspr(sx,sy,sw,sh,dx-1,dy,dw,dh)
	sspr(sx,sy,sw,sh,dx,dy-1,dw,dh)
	sspr(sx,sy,sw,sh,dx+1,dy,dw,dh)
	sspr(sx,sy,sw,sh,dx,dy+1,dw,dh)
	
	pal(0)
	
	sspr(sx,sy,sw,sh,dx,dy,dw,dh)
end


--prints outlined sprites



--colors

--reset color palette
function reset_pal()
 pal()
 --poke( 0x5f2e, 1 ) --endable hidden colors
 custom_palette = {[0]=0,1,140,12,131,3,139,130,136,14,142,143,15,13,6,7}
 pal( custom_palette, 1 )
end


--== debug stuff ==-------------

--debug
debug={}

show_debug=false
function print_debug()
 for i=1,20 do
  if(debug[i]!=nil) then
   bprint(debug[i],cam.x+1,cam.y+1+(i-1)*6,8,0)
  end
 end
end

function draw_hboxs()
 for i in all(interactables) do
  local hb=i.hbox
  fillp(▒)
  rect(hb.x1,hb.y1,hb.x2,hb.y2,8)
  fillp()
 end
end
-->8
--game / menu


--== game ==--------------------


function init_game()
 --start music
 music(0)

 --freeze player
 player.state="frozen"
 
 --for text boxes
 reading = false
 
 --set pallete
 poke( 0x5f2e, 1 ) --endable hidden colors
 custom_palette = {[0]=0,1,140,12,131,3,139,130,136,14,142,143,15,13,6,7}
	pal( custom_palette, 1 )
end


--== update ==-----------------
function update_game() 
 --update/move player
 if reading then -- if tb_init has been called, reading will be true and a text box is being displayed to the player. it is important to do this check here because that way you can easily separete normal game actions to text box inputs.
		tb_update() -- handle the text box on every frame update.
	else
	
 update_player()
 
 --daycycle stuff
 adv_time()
 pal(pallete[pincrement], 1 )
 
 --update minigame if active
 if(do_minigame)update_minigame()
 
 --update cam
 update_cam()
 
 --update fx
 update_fx()
 
 --muffle music
 if cam.y>127 and player.state=="fishing" then
  poke(0x5f41, 15)
  poke(0x5f43, 15)
 else
  poke(0x5f41, 0)
  poke(0x5f43, 0)
 end
 
	end
 
 --debug
 --if(btnp(❎))start_fishing()
end


--== draw ==--------------------
function draw_game()

 cls(2)
 
 --clouds
 draw_clouds()
 
 --lights
 draw_lights()
 
 --draw water
 draw_water(110) --water y
 
 --draw interior bgs
 --shop
 rectfill(0,128,383,256,4)
 --house
 --could use these to have seethrough windows, maybe not worth tokens though
 rectfill(512,168,616,224,12)
 rectfill(616,176,760,185,12)
 rectfill(616,200,760,224,12)
 rectfill(640,184,728,200,12)
 rectfill(744,184,760,200,12)
 --aqiarium
 rectfill(768,136,1016,248,1)
 rectfill(816,152,976,224,3)
 
 
 --draw map
 map(0,0,0,0,1000,32)

 
 --draw signs
 print("shop",232,73,7)
 print("fish",96,57,7)
 
 --water to block map (ghetto)
 rectfill(384,256,512,7000,2)
 
   --draw npcs
	draw_npcs()  


 --draw player
 draw_player()
 
 
 --==fishing==--
 if do_minigame then
  draw_minigame()
 end
 
 
 --== draw foreground details
 draw_fx()
  
 --draw intreactable prompts
 for i in all(interactables) do
  if(col(player,i)) then
   --debug[6]="hit something"
   show_prompt(i)
  end
 end
 
 tb_draw()
 		
 
 --draw main menu
 if(show_menu)then 
  draw_main_menu()
 else
  --draw clock
  draw_clock(w.t,clock_x,clock_y,clock_size)
 end
 


 --== debug stuff
 --cam.y=128
 --sz=2+sin(t()/3)
 --osspr(3,0,72,16,8,cam.x+10,cam.y+10,16*sz,8*sz)
 
 --fish display [debug]
 --display_fish=rnd(fishes)
 if(btn(⬆️))then
  display_fish=display_fish
  draw_fish_got(display_fish)
 else
  display_fish=rnd(fishes)
 end
 
 if(show_debug)then
  draw_hboxs()
  print_debug()
 end
end 


--== main menu ==---------------
show_menu=true

--displays menu overlay on top
--of game
function draw_main_menu()
 --stop drawing menu if btn
 if(btn(❎)or btn(🅾️)) then 
  show_menu=false
  player.state="walking"
 end

 cx=cam.x
 cy=cam.y
 
 --draw logo
 ovalfill(cx+34,cy+30,cx+90,cy+70,1) 
 osspr(0,0,96,56,37,cx+36,34,53,37)
 
 bprint_cent("press ❎ or 🅾️ to continue",cam.x+60,cam.y+110,15,0)
end


function draw_lights()
local color =15
 if(w.t<60) then
	 color=15
	elseif (w.t<105) then
		color=9
	else
		color=15
	end
	
	--lamps
	rectfill(137,75,140,78,color)
	rectfill(281,75,284,78,color)
	rectfill(409,75,412,78,color)
	
	--windows
	rectfill(24,48,32,88,color)
	rectfill(56,48,80,88,color)
	rectfill(24,48,32,88,color)
	
	rectfill(160,40,216,88,color)
	
	rectfill(304,64,312,88,color)
	rectfill(328,48,344,88,color)
	
end

-->8
--fish

--[[ fish structure
 name, scale, sprt (sprite #)
 , w, h (sprite width/height)
 ,shinycols
]]--

fishes={
} --arcetype table

--add fish to fishes table
function make_fish(name,sprt,w,h,scale,shinycols)
 add(fishes,
  {name=name
  ,sprt=sprt
  ,w=w,h=h
  ,scale=scale
  ,shinycols=shinycols}
 )
end

--fully populates fishes table
--◆this can be optimized for
--tokens if need be
function init_fish()
 --default scale = 2
 --1x1 fish
 make_fish("moss slug"
  ,135,1,1,2,{{6,3},{5,2},{4,1}})
 make_fish("stromateidae"
  ,136,1,1,2)
 make_fish("darwin fish"
  ,137,1,1,2)
 make_fish("omega fish"
  ,138,1,1,2)
 make_fish("greenback"
  ,139,1,1,2)
 make_fish("shad"
  ,152,1,1,2)
 make_fish("pinktail"
  ,153,1,1,2,{{8,2},{9,3},{2,8},{3,9}})
 make_fish("shrimp"
  ,154,1,1,1,{{12,3},{11,2},{10,4}})
 make_fish("jumbo shrimp"
  ,154,1,1,3,{{12,3},{11,2},{10,4}})
 make_fish("pennon"
  ,155,1,1,2)
 make_fish("pufferfish"
  ,151,1,1,2)
 make_fish("seapony"
  ,134,1,1,2)
  
 --1x2 fish
 make_fish("axolittle"
  ,168,2,1,2)
 make_fish("trout"
  ,184,2,1,2)
  
 --2x2 fish
 make_fish("solfish"
  ,170,2,2,2)
 make_fish("spade"
  ,172,2,2,2)
 make_fish("amgler"
  ,174,2,2,2,{{6,15},{5,15},{4,15},{1,14},{7,13},{11,0},{12,15}})
 
 --xl fish
 make_fish("swordfish"
  ,140,4,2,3,{{3,9},{2,8},{1,7}})
 make_fish("hammerhead"
  ,164,4,2,3,{})
 make_fish("giant squid"
  ,160,4,2,3,{})
 
 
-- make_fish("rainbow trout"
--  ,184,2,1,2)
-- make_fish("betta"
--  ,22,2,1,1)
-- make_fish("bluegill"
--  ,8,1,1,1)  
-- make_fish("goldfish"
--  ,9,1,1,1)
-- make_fish("shad"
--  ,10,1,1,1)
-- make_fish("neon tetra"
--  ,24,1,1,1)
-- make_fish("shrimp"
--  ,25,1,1,1)
-- make_fish("minnow"
--  ,26,1,1,1)
-- make_fish("swordfish"
--  ,11,4,2,1)
end

function find_fish(search_term)
 for f in all(fishes) do
  if(f.sprt==search_term
  or f.name==search_term)then
   return f
  end
 end
end


--== fish display ==------------


function draw_fish_got(fish)
 --debugging shiny
 fish=find_fish("jumbo shrimp")
 fish.shiny=true
 
 --get fish h and w
 local h=fish.h*8
 local w=fish.w*8
 local scale=fish.scale
 
 --upd scale
 --scale=fish.scale+0.5*sin(t()/4)
 
 --set inverse draw mode + fillp
 poke(0x5f34,0x2)
 --draw border circle
 fillp(▒)
 local circ_rad=65
 circfill(cam.x+64,cam.y+64,circ_rad,1 | 0x1800)
 fillp(█)
 
 --draw fish/lines
 local y=40
 y+=5*sin(t()/2)
 draw_flourish_lines(cam.x+63,cam.y+y+14)
 
 --draw fish
	osspr(0, fish.sprt%16*8,flr(fish.sprt/16)*8
  ,w,h
  ,cam.x+63-w*scale/2,cam.y+y-h*scale/2
  ,w*scale,h*scale)

 --shiny
 if(fish.shiny)set_shiny_pal(fish)
	
 sspr(fish.sprt%16*8,flr(fish.sprt/16)*8
  ,w,h
  ,cam.x+63-w*scale/2,cam.y+y-h*scale/2
  ,w*scale,h*scale)
 
 --complete palette refresh
 rp() 
  
 --print fish info
 bprint_cent("fish caught:",cam.x+63,cam.y+90,15,0)
 if(fish.shiny)then
  bprint_cent("shiny",cam.x+63,cam.y+98,10,0)  
  bprint_cent(fish.name,cam.x+63,cam.y+105,3,0)  
 else
  bprint_cent(fish.name,cam.x+63,cam.y+98,3,0)
 end
end


--item get lines
function draw_flourish_lines(x,y)
	for i=0,16 do
		local s=sin(time() * 2.1 + i/16)
		local c=cos(time() * 2.1 + i/16)
		local ty=y-14
		local r=20
		line(x+s*r,ty+c*r,x+s*40,ty+c*40,15)
	end
end


--shiny pal
function set_shiny_pal(fish)
 if(fish.shinycols==nil)return
 scols=fish.shinycols
 for i=1,#scols do
  pal(scols[i][1],scols[i][2])
 end
end

function reset_shiny_pal(fish)
	if(fish.shinycols==nil)return
 scols=fish.shinycols
 for i=1,#scols do
  pal(scols[i][2],scols[i][1])
 end
end



-->8
--minigame 


--== hook / tables ==------------------


minigame_state="inactive"
--,inactive,starting,sinking,...
do_minigame=false

hook={
  x=447 --default x
 ,y=90 --default y
 ,xmin=385 ,xmax=449
 ,speed=1
 ,xspeed=2
 ,sprt=47
 ,w=1,h=2
 --states: inactive,starting,active
 ,state="inactive"
 
 --upgrade table
 --[[
  populate when upgrades are 
  purchased from shop
 ]]--
 ,upgrades={
  }
}

function draw_hook()
 local s=hook

 --if state=inactive dont draw
 if(s.state!="inactive")then
  ospr(0,s.sprt,s.x,s.y,s.w,s.h)
 end
 
 --draw fishing line
 line(s.x+5,s.y,player.x+15,player.y+3,0)
end


--== state changing ==----------


--start fishing 
function start_fishing()
 --do initial animation
  --player anim
  --move bobber
 
 --set states
 hook.state="active"
 player.state="fishing"
 minigame_state="starting"
 
 do_minigame=true
end


function update_minigame()
 --update hook
 --sink hook
 hook.y+=hook.speed
 
 --hook x movement
 if(btn(⬅️))then
  hook.x-=hook.xspeed
 end
 if(btn(➡️))then
  hook.x+=hook.xspeed
 end
 
 --clamp hook pos
 if(hook.x<384)hook.x=384
 if(hook.x>504)hook.x=504
end


--== draw minigame ==--


fishing_bgy=128
fishing_bgy2=256
function draw_minigame()
 --draw water bg
 if(cam.y>128)then
  --cam dif
  cd1=cam.y-fishing_bgy
  cd2=cam.y-fishing_bgy2
  if(cd1>=128)then
   fishing_bgy+=2*cd1
  end
  if(cd2>=128)then
   fishing_bgy2+=2*cd2
  end
  
  --bg map tiles
	 map(48,16,384,fishing_bgy,16,16)
	 map(64,0,384,fishing_bgy2,16,16)
 end
 
 --hook
 draw_hook()
 
 --print ui
 bprint("depth: "..flr((hook.y-70)/10),cam.x+2,cam.y+2,3,1)
end
-->8
--player / cam


--== player table ==-------------


--main x limits for player
--[[
 these can change depending on
 special rooms / states
--]]

main_xl_limit=0
main_xr_limit=408
--interior y player val
int_y=230
default_y=81
frame=0
walkframe=0

player={
  x=250
 ,y=81
 ,default_y=81
 ,speed=1
 ,direct=false
 --player sprites
 ,s0=0
 --player x limits
 ,xl_limit=main_xl_limit
 ,xr_limit=main_xr_limit
 --player hitbox
 ,hbox={x1,y1,x2,y2}
 --states: walking,idle,fishing,frozen (for menus)
 ,state="frozen"
 ,tail=3
 ,feetsies=18
}


--== player functions ==--------


--update player
function update_player()
 local s=player
 frame+=1
 
 if s.frozen then
  debug[9]="player frozen"
 end
 
 --sprites for animation
	if(frame%4==0) then
		cat_tail()
		walk_spr()
	end
	
	--default state
	if(s.state=="fishing"
	or s.state=="frozen") then
	 --
	else
	 if(btn(⬅️)or btn(➡️))then
	  s.state="walking"
	 else
	  s.state="idle"
	 end
	end
 
 --== movement ==--
 --if state=walking move
 if(s.state=="walking") then
 
		--sprint if 🅾️
		if(btn(🅾️))then
		 s.speed=2
		else
		 s.speed=1
		end
		
		--move player
		if(btn(⬅️))then
		 s.x-=s.speed
		 s.direct=true
		end
		if(btn(➡️)) then
		 s.x+=s.speed
		 s.direct=false
		end
		
		--clamp pos
		if(s.x<s.xl_limit)then
		 s.x=s.xl_limit
		end
		if(s.x>s.xr_limit)then
		 s.x=s.xr_limit
		end 
		
	end

 
 --== interations ==--
 
 --update hbox
 local hb = s.hbox
 hb.x1=s.x
 hb.x2=s.x+15
 hb.y1=s.y-3
 hb.y2=s.y+18
 
 
 --collisions
 for i in all(interactables) do
  if(col(player,i)) then
   if btnp(❎) then
    i.on_click()
   end
  end
 end
 
 --press ❎ to interact
 if(btnp(❎)) then
  --interact with shit
 end
	
	
	--debug
	debug[3]="px: "..player.x.." - py: "..player.y
 debug[4]="state: "..player.state
end


--draw player
function draw_player()
	local s=player
	
	--shadow
	--ovalfill(s.x+2,s.y+13,s.x+13,s.y+17,1)
	
	--animate cat sprites
	cat_animation(s.x,s.y)
 
 --debug draw hbox
 if(show_debug)then
 	fillp(▒)
 	local hb=s.hbox
 	rect(hb.x1,hb.y1,hb.x2,hb.y2,8)
 	fillp()
 end
end


--player teleportation
function tp(x,y,camx,camy)
 --default vals
 xp=x or 400
 yp=y or player.default_y
 camx=camx or cam.x
 camy=camy or cam.y
 --move player
 player.x=xp
 player.y=yp
 --move cam
 cam.x=camx
 cam.y=camy
end


function set_player_limits(x1,x2)
 --default x limits
 x1=x1 or main_xl_limit
 x2=x2 or main_xr_limit
 --set player lims
 player.xl_limit=x1
 player.xr_limit=x2
end


--== cat animation ==-----------


--cat tail sprite--
function cat_tail()
	if(player.tail < 4) then
		player.tail+=1
	else
		player.tail=2
	end
	return player.tail
end

--cat feet sprite--
function walk_spr()
	if(player.feetsies < 20) then
		player.feetsies +=2
	else
		player.feetsies=18
	end
	return player.feetsies
end

--animation of cat
function cat_animation(x,y)
	local s=player
	local sstate=s.state
	
	if(sstate == "idle"
	or sstate == "fishing"
	or sstate == "frozen") then
	 --turn player if fishing
	 if(sstate=="fishing")s.direct=false
		spr(s.s0,x,y,2,2,s.direct)
		if (s.direct) then
		spr(s.tail,x+14,y+7,1,1,s.direct)
		else
		spr(s.tail,x-7,y+7,1,1)
		end	

	else if (sstate == "walking") then
		spr(s.feetsies,x,y+8,2,1,s.direct)
		if(s.direct) then
		spr(s.tail,x+12,y+2,1,1,s.direct)
		sspr(0,0,14,9,x,y-1,14,9,s.direct)
		else
		spr(s.tail,x-4,y+2,1,1,s.direct)
		sspr(0,0,14,9,x+3,y-1,14,9,s.direct)
		end
	end
	end
	
	--draw fishing rod if fishing
	if(sstate=="fishing")then
	 ospr(7,37,s.x+9,s.y+4)
	 debug[8]="draw rod"
	end
end



--== camera ==-------------------

cam={x=0,y=0}

function update_cam()
 --if minigame
 if(player.state=="fishing")then
  cam.x=384
  
  if(cam.y < hook.y-42)then
   cam.y+=2
  else
   cam.y=hook.y-40
  end
  
  camera(cam.x,cam.y)
  return
 end

 local px=player.x

 --stop camera for static rooms
 if(px>0 and px<128)then
  cam.x=0
 end
 if(px>384)then
  cam.x=384
 end
 
 --scrolling town/interiors
 --town/shop
 if(px>128 and px<384)then
  cam.x=px-59
  if(cam.x<128)cam.x=128
  if(cam.x>256)cam.x=256
 end
 
 --aquarium
 if(px>512 and px<=768)then
  cam.x=px-59
  if(cam.x<512)cam.x=512
  if(cam.x>640)cam.x=640
 end
 
 --home
 if(px>768 and px<1024)then
  cam.x=px-59
  if(cam.x<768)cam.x=768
  if(cam.x>896)cam.x=896
 end
 

 --move camera
 camera(cam.x,cam.y)
end


-->8
--background


--== clouds ==-------------------

bgx=0
bgx2=-30
bgx3=-20
bgx4=-90

cmx=112 cmy=0 --cloud map coords

function draw_clouds()
 --draw static bg
 fillp(▒)
 circfill(cam.x+100,cam.y+155,80,1)
 circfill(cam.x+13,cam.y+155,80,1)
 fillp()

 --update bgx
 bgx-=.6
 if(bgx<-128)bgx=0
 bgx2-=.4
 if(bgx2<-128)bgx2=0
 bgx3-=.3
 if(bgx3<-128)bgx3=0
 bgx4-=.2
 if(bgx4<-128)bgx4=0
 
 --bg clouds
 --single map clouds
 
 --dark bg
 local c=10
 pal({[0]=c,c,c,c,c,c,c,c,c,c,c,c,c,c,12,12},0)
 --palt(14,1)
 --top
 map(cmx,cmy,cam.x+bgx3,cam.y-10,16,6)
 map(cmx,cmy,cam.x+bgx3+128,cam.y-10,32,6)
 --bottom
 map(cmx,cmy+6,cam.x+bgx4,cam.y+78,16,10)
 map(cmx,cmy+6,cam.x+bgx4+128,cam.y+78,32,10)
 --reset pal
 palt(14,0)
 pal(0)
 
 --main
 --top
 map(cmx,cmy,cam.x+bgx,cam.y+0,16,6)
 map(cmx,cmy,cam.x+bgx+128,cam.y+0,32,6)
 --bottom
 map(cmx,cmy+6,cam.x+bgx2,cam.y+68,16,10)
 map(cmx,cmy+6,cam.x+bgx2+128,cam.y+68,32,10)
end

--== fx/particles ==-------------

--== particle system ==--

fxs={} --fx table

--update all fx
function update_fx()
 for fx in all(fxs) do
  --age fxs
  fx.age+=1
  
  --remove timed out fxs
  if(fx.age>fx.life)del(fxs,fx)
  
  --do other udpates
  if(fx.upd!=nil)then
		 fx.upd(fx)
  end
 end
end

--draw all fx
function draw_fx()
 for fx in all(fxs) do
  --if custom draw, do it
  --otherwise color pixel fx.col
  if(fx.draw!=nil)then
   fx.draw(fx)
  else
   pset(fx.x,fx.y,fx.col)
  end
 end
end

--add fx to fx table
---x,y,life,col,upd,drw
function add_fx(x,y,life,col,upd,draw)
 local fx={
   age=0
  ,x=x, y=y
  ,life=life
  ,col=col or 15 --default col=white
  ,upd=upd or nil
  ,draw=draw or nil
 }
 add(fxs,fx)
 return fx
end


--== water ==--

--draw water
function draw_water(wl)--wl=water line
 wl=wl or 80
 rectfill(0,wl,512,1000,2)
 
 --draws top of water at x pnt
 local xpnt=424
 draw_waterline(wl,xpnt)
 draw_waterline(wl,xpnt)
 draw_waterline(wl,xpnt)
 draw_waterline(wl,xpnt)
 draw_waterline(wl,xpnt)
end

--waterline
function draw_waterline(wl,x)
 add_fx(
   rnd(128)+x
  ,wl
  ,rnd(30)+60
  ,13
  ,function(s)
    if(s.age/s.life>.15)s.col=14
    if(s.age/s.life>.25)s.col=15
    if(s.age/s.life>.75)s.col=14
    if(s.age/s.life>.85)s.col=13
   end
  ,nil
 )
end
-->8
--overworld stuff


--== doors / interactables ==---


interactables={}

function add_interactable(
hbx1,hby1,hbx2,hby2
,prompt,on_click,id)
 add(interactables,{
  hbox={x1=hbx1,y1=hby1,x2=hbx2,y2=hby2}
  ,prompt=prompt
  ,on_click=on_click
  ,id=id or "unindentified"
 })
end


function show_prompt(i) --i=interactabble
 --main prompt
 --print prompt at top of hbox
 xp=i.hbox.x1+((i.hbox.x2-i.hbox.x1)/2)
 yp=i.hbox.y1
 
 --aquarium case
 if(i.id=="aquarium exit")then
  xp+=10
 end
 
-- if(i.id=="shop keep")then
-- 	show_❎(xp-2,yp-8)
-- else
--	 --show little ❎ button
--	 show_❎(xp-2,yp+9)
-- end
 
 show_❎(xp-2,yp+9)

 bprint_cent(i.prompt,xp,yp,15,0)
end

function show_❎(x,y,c,bc)
 c=c or 15
 bc=bc or 0
 bprint_cent("❎",x,y,c,bc)
 bprint_cent("❎",x,y-sin(t()),c,bc)
end


--== filling interact table ==---


function init_interactables()
 --overworld doors
 add_interactable(304,55,344,100
  ,"enter home"
  ,function() 
    tp(528,int_y-20,512,128)
    set_player_limits(513,752)
    sfx(51,3)
   end
  ,"home door")
 add_interactable(169,55,208,100
  ,"enter shop"
  ,function()
    tp(144,int_y-20,128,128)
    set_player_limits(129,368)
    sfx(51,3)
   end
  ,"shop door")
 add_interactable(54,55,104,100
  ,"enter aquarium"
  ,function() 
    tp(784,int_y-4,768,128)
    set_player_limits(769,1008)
    sfx(51,3)
   end
  ,"aquarium door")
  
 --interior exits
 add_interactable(128,203,148,256
  ,"exit"
  ,function()
    tp(198,default_y,128,0)
    set_player_limits()
    sfx(51,3)
   end
  ,"shop exit")
 add_interactable(512,203,552,256
  ,"exit home"
  ,function()
    tp(302,default_y,128,0)
    set_player_limits()
    sfx(51,3)
   end
  ,"home exit")
 add_interactable(768,203,808,256
  ,"exit aquarium"
  ,function()
    tp(61,default_y,0,0)
    set_player_limits()
    sfx(51,3)
   end
  ,"aquarium exit")
  
 --fishing
 add_interactable(407,70,460,100
  ,"start fishing"
  ,function()
   if(player.state=="fishing")return
   start_fishing()
   sfx(59,3)
   sfx(48,2)
  end
  ,"fishing zone")
  
 --npcs shop keep
  add_interactable(175,193,194,224
  ,"ahoy"
  ,function()
  		tb_init(6,{"ahoy sailor, how might i be \nable to help?","a fishing rod? which one would \nyou like?"}) -- when calling for a new text box, you must pass two arguments to it: voice (the sfx played) and a table containing the strings to be printed. this table can have any number of strings separated with a comma.
   end
  ,"shop keep")
end


--== collision ==-----------------


function col(a,b)
 --check if hb
 --if(a.hb==nil)debug[8]=a.id..":invalid hb"
 --if(b.hb==nil)debug[8]=b.id..":invalid hb"
 ahb=a.hbox
 bhb=b.hbox

 if(
  ((ahb.x1>=bhb.x1 and ahb.x1<=bhb.x2)
  or (ahb.x2>=bhb.x1 and ahb.x2<=bhb.x2))
 and 
  ((ahb.y1>=bhb.y1 and ahb.y1<=bhb.y2)
  or (ahb.y2>=bhb.y1 and ahb.y2<=bhb.y2))
  ) then 
   return true
 end

 return false
end
-->8

--==clock and day cycle==--

w={}
w.t=0
pincrement=1

st=time()

clock_x=121
clock_y=6
clock_size=4 --radius of clock
clock_color=15 
min_hand_color=7

pallete={
		--day
		{[0]=0,1,140,12 ,131,3  ,139,130,136,14 ,142,143,15 ,13 ,6  ,7}
		--transition 1
	,{[0]=0,1,140,12 ,1  ,131,3  ,128,136,14 ,130,142,15 ,13 ,6  ,7}
		--transition 2
	,{[0]=0,129,1,140,1  ,131,3  ,128,136,14 ,130,141,15 ,13 ,141,6}
		--night
	,{[0]=7,0,1  ,140,129,131,3  ,128,2  ,135,130,141,13 ,133,141,6}
}

function adv_time(sp)
  w.t=(time()-st)
  
   if (w.t==56 or w.t==118) then
 			pincrement=2
 		elseif (w.t==58 or w.t==116) then
 				pincrement=3
 		elseif (w.t==60) then
 				pincrement=4
 		elseif (w.t==0 or w.t==120) then
 				pincrement=1
 		end  
  
  if (w.t>=120) then
    st=time()
    w.t=0
  end 

end

-- draw_clock(minute, hour, origin x, origin y, radius)
function draw_clock(m,x,y,r)
		spr(111,x-3,y-3)
		x=cam.x+x
		y=cam.y+y
  local mh_len=(r-1)*1.0 -- min hand 1 px smaller
  m_x,m_y=clock_hand_position(m,x,y,mh_len)
  circfill(x,y,r+1,clock_color)
  circ(x,y,r+1,min_hand_color)
  line(x,y,m_x,m_y,min_hand_color)
end

-- clock_hand_position(tick, origin x, origin y, multiplier for hand length)
function clock_hand_position(t,o_x,o_y,m)
  -- rusty trig ahead. beware.
  t-=30
  t=t%120 -- handle 60 tick factors
  t=120-t
  -- determine x,y from cos/sin
  local x=cos(t/120.0)
  local y=sin(t/120.0)
  -- multiply the x & y by `m`
  x*=m
  y*=m
  -- offset from originating coords
  x+=o_x
  y+=o_y
  return x,y
end




-->8
--==npcs==--


function draw_npcs()
--shop keep

 pal(10,13,0)
 pal(11,14,0)
 pal(12,15,0)
 
-- sspr(0,0,14,9 ,x  ,y-1,14,9,s.direct)
	sspr(0,0,16,16,175,208,16,16,true,false)
	sspr(56,96,16,16,175,202,16,16,true) --hat
	spr(player.tail,190,214,1,1,true)  --tail
	
	pal()
	pal(pallete[pincrement], 1 )
	spr(26,172,216)			--table
	spr(46,180,216)   --table
	spr(27,188,216)   --table
end

function tb_init(voice,string) -- this function starts and defines a text box.
	reading=true -- sets reading to true when a text box has been called.
	tb={ -- table containing all properties of a text box. i like to work with tables, but you could use global variables if you preffer.
	str=string, -- the strings. remember: this is the table of strings you passed to this function when you called on _update()
	voice=voice, -- the voice. again, this was passed to this function when you called it on _update()
	i=1, -- index used to tell what string from tb.str to read.
	cur=0, -- buffer used to progressively show characters on the text box.
	char=0, -- current character to be drawn on the text box.
	x=0, -- x coordinate
	y=106, -- y coordginate
	w=127, -- text box width
	h=22, -- text box height
	col1=1, -- background color
	col2=12, -- border color
	col3=12, -- text color
	}
end

function tb_update()  -- this function handles the text box on every frame update.
	if tb.char<#tb.str[tb.i] then -- if the message has not been processed until it's last character:
		tb.cur+=0.5 -- increase the buffer. 0.5 is already max speed for this setup. if you want messages to show slower, set this to a lower number. this should not be lower than 0.1 and also should not be higher than 0.9
		if tb.cur>0.9 then -- if the buffer is larger than 0.9:
			tb.char+=1 -- set next character to be drawn.
			tb.cur=0	-- reset the buffer.
			if (ord(tb.str[tb.i],tb.char)!=32) sfx(tb.voice) -- play the voice sound effect.
		end
		if (btnp(5)) tb.char=#tb.str[tb.i] -- advance to the last character, to speed up the message.
	elseif btnp(5) then -- if already on the last message character and button ❎/x is pressed:
		if #tb.str>tb.i then -- if the number of strings to disay is larger than the current index (this means that there's another message to display next):
			tb.i+=1 -- increase the index, to display the next message on tb.str
			tb.cur=0 -- reset the buffer.
			tb.char=0 -- reset the character position.
		else -- if there are no more messages to display:
			reading=false -- set reading to false. this makes sure the text box isn't drawn on screen and can be used to resume normal gameplay.
		end
	end
end

function tb_draw() -- this function draws the text box.

	if reading then -- only draw the text box if reading is true, that is, if a text box has been called and tb_init() has already happened.
		rectfill(cam.x,cam.y+128,cam.x+tb.w,cam.y+128-tb.h,tb.col1) -- draw the background.
		rect(    cam.x,cam.y+127,cam.x+tb.w,cam.y+128-tb.h,tb.col3) -- draw the border.
		print(sub(tb.str[tb.i],1,tb.char),cam.x+2,cam.y+130-tb.h,tb.col3) -- draw the text.
	end
end






__gfx__
0077000000770000000077000000770000000770000000000b00000000000000eeeeeeee000000000eeeeeeeeeeeeee0066065000050500089230000bbbbbbbb
07cb700007bc70000007cc700007cc7000007cc7000000000b00000000c09000ecb5bc5d09c0c9000e333333333333d0005550000005000089235660b452377b
07ccb7777bcc70000007cb700007cb7000007cb7000000000b00000000998000ebbbbb5d089c98000e336333333353d00404040000ddd00088225550b452377b
07bbbbbbbbbb700000007b700007b7000007bb70000000000bcccc0000888000eb7b7b5d089998000e365533333544d0004440007777777777777777b452377b
77bbb7bbb7bb770000007bb70007b7000007b700000000000aaaaa0000040000e5bcb55d008980000e3373333b3373d007aaa7007accccc77ccccca7b442277b
07bbb7bbb7bb7000000007b70007bb770007bb77000000000700070006040600e4aaa44d500800500e337333313373d007baa7007abbbbb77bbbbba7baaaaaab
77bbbbbcbbbb7700000007bb000077bb000077bb000000000700070000545000dddddddd450605400e665666656656d007bbb7007abbbbb77bbbbba7bde7777b
007bbbbbbbb7000000000077000000770000007700000000070007000077700000000000045654000eddddddddddddd0007770007abbffb77bffbba7bde7777b
0007aaaaaa7000000000777bbbbb70000000777bbbbb7000000000b00000000000000000000400000000000000000000000006507abbccb77bccbba7bde9998b
007bbbbbbb7000000007cccbbbbbb7000007cccbbbbb7000000000b000000000000fffd0012333000000000000000000060050057abbbbb77bbbbba7bdd8888b
07bbabbbb70000000007bbbaaaabab700007bbbaaabb7000000000b009999999999fffd001233300cccccccccccccccc005006057abbbbb77bbbbba7baaaaaab
07babbbbb7000000007b7ba7777a7ab70007bba777ab700000ccccb009999999999dddd001233300bbbbbbbbbbbbbbbb005000047abbbbb77bbbbba7b567777b
07bbb77bb770000007ba7b7007a707a70007ba707a7a700000aaaaa00888888888888880012233000770000000000770050060407abbbbb77bbbbba7b567777b
07ab7bc7bbc7000007a77a7007a70070007ba7007a7ab7000070007007700000000007700122330007a0000000000a70005454007aaaaaa77aaaaaa7b567777b
07aaaaa7aaa7000000707aa707aa7000007a7a70077ab700007000700a70000000000a700112220007a0000000000a700baaaab07777777777777777b557777b
007777707770000000000777007770000007777000077000007000700a70000000000a700111110007a0000000000a700077770000aaa000000aaa00baaaaaab
3ffffffffffffffffffffff3bbbbbbbb003333000000003200000065000000980cccccccccccccc000dffd0000000000000e000000000300000000000000ddd0
231111111111111111111132bbbbbbbb03bbbb30000003200000065000000980bbbbbbbbbbbbbbba00dfed0000ddd00000ded0000012300000000000000d000d
213333333333333333333312bbbbbbbb3b0000b3000032000000650000009800bbbbbbbbbbbbbbba00dfed000fdedf0000d0d0000b222000cccccccc000d000d
213333333333333333333312aaaaaaaa30000003000320000006500000098000bbbbbbbbbbbbbbba00dffd00defffed000ded00000456000bbbbbbbb000d000d
2133f3333333333333333312aaaaaaaa30000003002100000054000000870000bbbbbbbbbbbbbbba00defd007deeed70000e000000445600000000000000ddd0
213f333333333333333333127777777730000003021000000540000008700000bbbbbbbbbbbbbbba00defd007fdddf7000ded0000044560000000000000000d0
213f33333333333333333312777777773000000321e0000054e0000087e00000aaaaaaaaaaaaaaa700defd007e7f7e7000d0d0000004456000000000000000d0
213f333333333333333333127777777730000003100000004000000070000000077777777777777000dffd007e7e7e7000ded0000000b00600000000000000dd
213f33333333333333333312bcccccca3333333300000000030206050000000000effe00213f3333eeeeeeeeeeeeeeee000e00000cccccc03333331200f0000d
213f33333333333333333312cabbbb7c30000003009880000030005000998800099ee890213f3333effffffeeffffffe00e0e00007bbbb70333333120ee0000d
213f33333333333333333312cbabb7ac300000030fffff007221f54700700700f870078f213f3333ef7ff7feeffffffe0e000e00007aac0033333312dd00000d
2133f3333333333333333312cbba7aac30000003fffffed07721d47707000070fe0000ef213f3333ef7777edef7ff7ede00600e0007aa60033333312dd00000d
213333333333333333333312cbb7baac300000039ffeed807c7777a789999998d970078d213f3333efeeeeedefffffede05460e0007a5c0033333312d000000d
213333333333333333333312cb7aabac3000000389ddd8707b7ba7a798888887088dd890213f3333deeeeeeddeeeeeedabbbba70007a4c0033333312d10000dd
232222222222222222222232c7aaaabc3bbbbbb3088887007b7ba7a79888888700deed00213f3333dddddddddddddddd0aaaa700007aa40033333312dd1111d0
311111111111111111111113accccccbaaaaaaaa007770007b7ba7a78777777800000000213f3333077007700770077000777000007a4c00333333120dddddd0
66666666666666666666666677777777788879887777777700000033333333333333333333000000122333331100000000000000cffffffcffffffffffffffff
666666666666666666666666777777777888778878888888000003222222222222222222223000001122222211000000000000000cffffc0fffffbbaffffbfff
5555555555555555555555557777777778888888788888880000322111111111111111111223000071111111111000000000000000000000ffffbccbaffbcbff
54545454545454545454545477777777788888887888888800032211111111111111111111223000a7111111111000000000000000000000ffffcffcbafcfcff
4444444444444444444444447777777778888888788888880032211177777777777777771112230077777777111100000000000000000000ffffcbffcbfffcff
7777777774777777777747777777777778888888788888883322117bbb7bbba7bbbba7bb771122337aaa7aaa111110000000000000000000fffffcfffcbbbcff
777777777747777777757777777777777888888878888888222117a7aa7aaaa7aaaaa7aa7a7112227bbb7bbb111111000cffffc000000000ffffffffffcccfff
77777777757777777777577777777777788888887888888811117ba777777777777777777aa711117777777711111110cffffffc00000000ffffffffffffffff
ccbbbbbb00000000000000007777777777777777bb7acba7007acba7baaaa7bb777777777aba70003333322111111110000000ccffffffffc000000000bbbbbb
cbbb7ebb00809000007a00007777777777777777777acba7007acba7777777777ff7ffa77aba7000222222111111110000ccccfffffffffffccccc00007000a7
bbb7afbb00788000bb7abb0077edd77777777777bb7acba7007acba7ba7bbbbb7cf7cfa77aba700011111117111110000cffffffffffffffffffffc0007700a7
bb7abfbb00778000777a770077ddd7777ed77777aa7acba7007acba7aa7bbbaa7cc7cca77aba70001111117a11110000fffffcffffffffffffcfffff070070a7
b7abb8bb05050000007a000077ddd7777dd77777777acba7007acba777777777777777777aba70007777777711100000cfffcfcffcffffcffcfcfffc000000a7
bbbbbbbb00454000bb7abb007777777777777777bb7acba7007acba7bbbba7bb7ff7ffa77aba7000aa7aaaa711100000bcffffcffbccccbffcffffcb000000a7
000a700000040000777a770077777ed777777777aa7acba7007acba7bbaaa7bb7cf7cfa77aba7000bb7bbbb711000000abccccbfffbbbbfffbccccba070070a7
000a7000000400000077000077777dd777777777777acba7007acba7777777777aa7aaa77aba700077777777110000000abbbbffffffffffffbbbba0007700a7
00000000000000000000000009090000b878a7bb7aba7ba7007acba7bbbaa7bbbbbaa7bb7aba700000777700111111110abbbbffffffffffffbbbba0000000a7
00000000066666600000000080008000778877777aba7777007a54a777777777777777777aba7000ab7cc7ba01111110abccccbfffbbbbfffbccccba000000a7
00000000656656660000000008080009b778bbbb7aba7bbb0075cb47b67bbbbbba7bb5b47a6a70007abbbba700111110bcffffcffbccccbffcffffcb000000a7
00000006665565656000000000880880454b6baa7aba7aaa0075cba4aa5b5baaaa7bbb5a7ab5700077aaaa7700011100cfffcfcffcffffcffcfcfffc000000a7
00000065656656566600000090088009744477777aba7777007a6ba474777577775777747aba40007c7777a700011100fffffcffffffffffffcfffff000000a7
0000006656555b656500000008880000de4ee7bb7aba7bb7005acba44bbb574bb4bba7bb7ab470007b7ba7a7000110000cffffffffffffffffffffc0000000a7
000005654555bca456500000800800007ddd77bb7aba7aa70074b5a4b4a4a4b5bb4aa7bb7a4a70007b7ba7a70001100000ccffffffffffffffffcc00000000a7
0000065554455a454560000000080000777777777aba7777004a4a4747474747747777774ab470007b7ba7a700001000000000ccffffffffcc000000000000a7
0006565544444444565660000011110000060000000000000000000000c1110000000000000000000000000077777777000001111111111111000000000000a7
056565b5454444545565665001111110005000000030030000600060c7b1c1100011110001100000000000007bcccbb7000011111111111111100000000006a7
54545bca545445455656556511111111000400000300300000050600bcbcb1110111111011110000000000007aaaaaa700011111111111111111000000060067
454545a5654444556b45645411111111004111000030030000500050ababa11101111110111100000000000077777777000111111111111111110000000504a7
5444545555555555bca4444511111111001111100003001005006005ababa111011111100110000009888ff00000000000011111111111111111000000050047
44444545454555454a444444011111100011111000100100040005047a1a111101111110000001009888ffee0000000000011111111111111111000000004047
44444444545454544444444400111100001111100100100000404004011111100011110000001110888ffeee00000000000011111111111111110000000004a7
044444444444444444444440000000000001110000100100040040400011110000000000000001007777777700000000000001111111111111100000000004a7
000111100000000000000000000000000000000000000000000bc0006060000000eee00000060600000c00c00000000000000000000000000000000000000000
0111111111000000000000000000000000000000000000000cb7ba00505000000eedde000065600000b0000c40000000000000000000003f1000000000000000
111111111111100000000000000000000000000000000000000bba0c05656500ed7dd40e044440000bbb000b0445600000000000000033210000000000000000
1111111111111110000000000000000000000000000000000000bba06656565044de441041555406b7bbb0ba4155550600000000000322100000000000000000
11111111111111100000000000000000000000000000000000c0cba05056565601444101cbbbb450abbbaba0fffeedf000000000003221200000000000000000
1111111111111000000000000000000000000000000000000b00cba044141414001110000aaa40040aaa0ab00dddd00d000000000f32121100000000000033ff
0111111111000000000000000000000000000000000000000b0cba0b01717170000e00000005000000b000ab000e000000000000f221212110000003000f2220
00011110000000000000000000000000000000000000000000baa000000000000000f00000006000000c000a0000f00000000000333322222200002000322200
0000000000000000000000000000000000000000000000000000000000b0b0b000000000000000000cccbc000000f00000000003222223333311112033222100
000000000000000000000000000000000000000000000000000000000acccc0c0000000000000000c7bbabc0000c000000003332232233333333333322211000
00000000000000000000000000000000000000000000000000000000cbccccc0000ff000000ef0000aaa0abc00c7c000332222f7232233333333322311100000
000000000000000000000000000000000000000000000000000000000bb7c7ba0ffeef0f0ff33f090b0b00bb07c7b70c00011177322223333222221122210000
00000000000000000000000000000000000000000000000000000000abbb7bb0e7eddeede722229800c0c0cbc7b7b7b000000011111122222211112011221000
0000000000000000000000000000000000000000000000000000000007abba700dd777d00ddd7780000000ca07b7a70a00000000022211111120002000112000
00000000000000000000000000000000000000000000000000000000c007a00a000e000d000e00080c000cba00ab700000000000003220000020000300001230
0000000000000000000000000000000000000000000000000000000000a00a000000f0000000f00000bbbaa0000a00000000000000033f000003000000000000
00000ee0000000000009999000000000000000000000000000ffdd00000000000000009000000000000000005544000000000000000000000000000000000000
0000e90000000000098888889000000900000000000000fffeed00000000000f00009800090000000000005564000000000000cc000000000007700000000000
000e9800000000009870000089000998000ee00000000feeedd0000000000ffe099980098000ccc0000005664000000000000cbba00000000070070000000000
00e9889000000000800088890799870000edde000000feddd7000000000ffde099f79988000c999800005556640005500000cbbba00000000700007000000000
099877800009999080097077888870890eddde000fffeddd7700000000fddd0099779999999999870005666555505665000aaaaaaaa00000cc00065550000000
977999999098888970970000000778000edd70fffeeeddddd77ff0000eddd700899998889887888705565566666566400abbddbbddba0aa0fc00654445000066
799888888988888877800000988887900ed7efeddddddddddddddff0eddd700008878777877077705665f75666646400abf7bddbbddbadda0006545444550545
9888888888d7777870000009870007890e7ffdddddddddddddddddddddd7000000000890089000004565775665546400ab77bddbbddbddda00654f1444444450
7dd888888d7deed7000998877000007800fedddddddddddeeeeeeeeeeee7000000000056560000000446556656446640aaaaa77aa77a77770044511444114150
877dddddd7def7ed77887000000000000feddd777dddddeefffe77e007eef00000044444456000000004555554004664077a77aa77a707700004455411140415
9887777770de77ed00000000000000000fddd700077ddeef0007dd00007ef0006445555554440046000044454000044000077777777000000600041111400044
09888880000deed778009900000000000fdeed700007ddee00007de00007ef00057f9999ccc564600000046400000000000007aa700000000055411114050000
0098889000007770078888900009989900e7fe7000007ddde000007f00007ee000558888999c4850000000560000000000000077000000000000544440000000
0009980000000000000077899988887000e77e700000077ddef000000000077e654bbbbbccc40495000000046000000000000000000000000000005110000000
0000e900000000000000007887000700000ee700000000077ddf0000000000000000450004500044000000000000000000000000000000000000000551000000
00000ee0000000000000000000000000000000000000000000000000000000000000046000600000000000000000000000000000000000000000000000000000
00000bbbbbb000000000000000000000000000000000000000000000000000000000090000000000000000000000000000000000000000000000000000000000
000bbbbbbbbb0000000000000000bbbb000000000000000000000000000003333000980000000000000000000000000000000000000000000000000000000000
00bbbbbbbbbbb000000000000000bbbb000000000000000000000000000032222300870000000000000000000000000000000000000000000000000000000000
00bbbbbbbbbbb000000000000000bbbb000000000000000000000000000022222208700000000000000000000000000000000000000000000000000000000000
0bbbbb0000bb0000000000000000bbbb000000000000000000000000000122222217000000000000000000000000000000000000000000000000000000000000
0bbbb00000b000000bbbbb0000bbbbbbbbb000000000000000000000032211111172300000000000000000000000000000000000000000000000000000000000
bbbbb0000000000bbbbbbbb000bbbbbbbbb000000000000000000000112222222222117000000000000000000000000000000000000000000000000000000000
bbbb0000000000bbbbbbbbbb00bbbbbbbbb000000000000000000000771111111111770000000000000000000000000000000000000000000000000000000000
bbbb00000000000bbbbbbbbbb0bbbbbbbbb000000000000000000007007777770000000000000000000000000000000000000000000000000000000000000000
bbbb000000000000b000bbbbb000bbbb000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000
bbbb00000000000000000bbbb000bbbb000000000000000000000000000122100000000000000000000000000000000000000000000000000000000000000000
bbbb0000000000000bbbbbbbb000bbbb000000000000000000000000001122000000000000000000000000000000000000000000000000000000000000000000
bbbb000000000000bbbbbbbbb000bbbb000000000000000000000000000111000000000000000000000000000000000000000000000000000000000000000000
bbbb00000000000bbbbbbbbbb000bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbb000000000bbbbbbbbbbb000bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0bbbb00000b000bbbb0222222222bb22000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0bbbbb000bbb00bbbb2222222222b222200000000000222200000000000000000000000000000000000000000000000000000000000000000000000000000000
00bbbbbbbbbbb0bbbb2222222222b2222bb000000000222200000000000000000000000000000000000000000000000000000000000000000000000000000000
00bbbbbbbbbbb0bbbb2222222222bb22bbb000000000222200000000000000000000000000000000000000000000000000000000000000000000000000000000
000bbbbbbbbb000bbb2222bbb0000bbbbbb022222000222200000000000000000000000000000000000000000000000000000000000000000000000000000000
00000bbbbbb00000bb2222bbb00002222bb222222220222200222200000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000022220000000222200222222220222202222220000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000022220000000222202222200220222222222220000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000022222222200222202222000000222222222222000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000022222222200222202222220000222222222222000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000022222222200222200222222200222220022222000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000022222222200222200022222220222200002222000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000022220000000222202200002220222200002222000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000022220000000222202220002220222200002222000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000022220000000222202222222220222200002222000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000022220000000222200222222220222200002222000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000022220000000222200022222000222200002222000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
000046490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007d7e000000000000000000000000000045454545454545454545454545454545454545454545454545454545454545450000004c00000000000000000000004c
000065550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007d4b760000000000000000000000000045454545454545454545454545454545454545454545454545454545454545455e4c5c6d5e4c00000000000000005c6d
0000654a4900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007d7d7d7e00000000000000000000000045454545454545454545454545454545454545454545454545454545454545454f5d6d5d4e4f5e00004c0000006c5d4e
000065676900000046490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007d7d5b6f00000000000000000000000045454545454545454545454545454545454545454545454545454545454545456e4d4d6c5d5e4d005c5d5e4c00004d6c
004647484749000056690000000000000000004648474847484748490000000000000000000000000046490000000000000000000000000000000000000000007d7d0000007a630000000000000000004545454545454545454545454545454545454545454545454545454545454545000000004d4d0000006c4e4f5e000000
00665757575900464748497a7a7a00000000005657585857585857590000000000000000000000004648484900000000000000000000000000000000000000007d7d0000007c7d7e00000000000000004545454545454545454545454545454545454545454545454545454545454545000000000000000000004d4d00000000
0056575857690065585855002c2c00000000006657585868585857690000000000000000004649005658575900000000000000000000000000000000000000007d7d000074006b000000000000000000454545454545454545454545454545454545454545454545454545454545454500000000000000000000000000000000
00566858574a5a656757550028290000000046474747474747474748497a7a0000000000464848496657646900000000000000000000000000000000000000007d5b0000000000000000000000000000454545454545454545454545454545454545454545454545454545454545454500000000000000004c00000000000000
005657475764574a4848474900000000000056576857576857575768592c2c0000000000566858574a47474749000000000000000000000000000000000000007d6f00760000000077007500000000004545454545454545454545454545454545454545454545454545454545454545000000000000005c6d5e4c4c00000000
00665758576568585857575900000000005f56575858575757585857592829000000005f5657575768575768590000000000005f0000000000000000000000007d4b007300000000007c7d7e00000000454545454545454545454545454545454545454545454545454545454545454500000000005c5e5c5d6d4e4f5e000000
00565758576557585857455900606162006f56575858574557585857590060616200006f5657585745575857590000606162006f0000000000000000000000007d7d00007879000000000000000000004545454545454545454545454545454545454545454545454545454545454545000000005c5d6e006c5d6e4d00000000
52666848676557576467446900707172527f66574747674464485a67595170717252517f6667575744576757695000707172527f5100000000000000000000007d5b0000000000000000000000000000454545454545454545454545454545454545454545454545454545454545454500000000000000000000000000000000
414040414242424042414040414040404140404042404040404041424040404140424040404140404140404040404240404140404200000000000000000000007d4b7600000000000000000000000000454545454545454545454545454545454545454545454545454545454545454500000000000000000000000000000000
434343434343434343435443434343434343434343435443434343434343434343434343434343434354434343434343434343434300000000000000000000007d7d7d7e000000000074000063000000454545454545454545454545454545454545454545454545454545454545454500000000000000000000000000000000
4343434343434343434343434343435343434343434343434343434354434343434343434343434343434343544343437d7d7d7d7d00000000000000000000007d7d7d4b0000000000007c7d7d7e0000454545454545454545454545454545454545454545454545454545454545454500000000000000000000000000000000
4343534343434343434343544343434343434343434343435343434343434343434343434343435443434343434343547d7d7d7d7d00000000000000000000007d7d7d7d7e0000000000006b00007700454545454545454545454545454545454545454545454545454545454545454500000000004d0000004d000000000000
4545454545454545454545454545454543434343434343434343434343434343434343434343434343434343434343437d7d7d7d5b000000000000000000000043434343434343434343434343434343434343434343434343434343434343435557575757576857575757576757575757575757685757575757576857575765
4545454545454545454545454545454543434343434343434343434343434343434343434343434343434343434343437d7d7d7d00000000000000000000000043434343434343434343434343434343434343434343434343434343434343435500002c000000000000000000000000000000000000000000000000002c0065
4545454545454545454545454545454543434343434343434343434343434343434343434343434343434343434343437d7d7d7d00000000000000000000000043434343434343434343434343434343434343434343434343434343434343435500003c002021212121212121212121212121212121212121212122003c0065
4545454545454545454545454545454543434343434343434343434343434343434343434343434343434343434343437d7d5b7d00000000000000000000000043434343434343434343434343434343434343434343434343434343434343435500000000390000000000000000000000000000000000000000003e00001c65
4545454545454545454545454545454543434343434343434343434343434343434343434343434343434343434343437d7d006b00000000000000000000000043434343434343434343434343434343434343434343434343434343434343435500000f00390000000000000000000000000000000000000000003e00000f65
4545454545454545454545454545454557685757575767575757575768576757575757576867576857575768576757577d7d0000000063787400000000000000575757575757575757575757575768575757685757675757685757576857675755000c0f07390000000000000000000000000000000000000000003e00001f65
4545454545454545454545454545454555332c2c00000000000000002a002c2c655500002c00000000333300002c00575b6b0000007c7d7d7e0000000000000055070000000000002c2a000000000000001c560000000000000000000000006555007b7b7b390000000000000000000000000000000000000000003e00007b65
4545454545454545454545454545454555002c3300252627008d008f2a00332c655500003c000000007b7b00002c00577e00760000006b787900000000000000550f00090f0000002c2a000000242424000f56000f1c00000000002424001c65550038001c390000000000000000000000000000000000000000003e00000065
4545454545454545454545454545454555003c00000000009c9d9e9f2a00003c655500000024000000002424003c00577e007300000000000000750000000000551f007b7b0000003c2a000000343434001f66007b7b00000000003434000f655500000c0f390000000000000000000000000000000000000000003e0c000065
454545454545454545454545454545457b00000000000000000000002a0038007b7b0009003400282900343400000c574b0000000000000000007300000000007b7b000000081c00002a000000000000007b7b00000000000000000000001f657b00000f1f390000000000000000000000000000000000000000003e0f000065
45454545454545454545454545454545000000002d000000003536002a2b98001c0000330c000000000000000d0f0f577d7e000000000077000000000000000000000d0e000f0f00002a2b0000000000000000000a0b00000d0e000000070f650000001f0f390000000000000000000000000000000000000000003e0f000965
45454545454545454545454545454545003600003d000000003333363a3b3b00333600333333001a1b000033331f1f677d4b750000000079780000000000000000001d1e000f1f003b3a3b00061a2e1b160000001a1b16001d1e0017180f1f650000007b0f390000000000000000000000000000000000000000003e7b000f65
4545454545454545454545454545454523232323232323232323232323232323232323232323232323232323232323237d7d7d7e0000000000000000000000002323232323232323232323232323232323232323232323232323232323232323000000007b303131313131313131313131313131313131313131313200001f65
4545454545454545454545454545454543434343434343434343434343434343434343434343434343434343434343437d7d5b000000630000000000000000004343434343434343434343434343434343434343434343434343434343434343001a2e1b007b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b00003365
4545454545454545454545454545454543434343434343434343434343434343434343434343434343434343434343437d7d4b7600747300000000000000000043434343434343434343434343434343434343434343434343434343434343432323232323232323232323232323232323232323232323232323232323232323
4545454545454545454545454545454543434343434343434343434343434343434343434343434343434343434343437d7d7d7d7e000000000000000000000043434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
__sfx__
010303062453424520245102451024510245100c0001000013000170000c0001000013000170000c0001000013000170000c0001000013000170000c0001000015000170000c0001000015000170000c00010000
010402031777018771187701877000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
010b05080017000160001500014000130001220011200112001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
01050002180521f052000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01050408245341c5301f5301c530245301c5301f5301c5301050013500175000c5001050013500175000c5001050015500175000c5001050015500175000c5001050000500005000050000000000000000000000
01050408245341b5301f5301b530245301b5301f5301b5301050013500175000c5001050013500175000c5001050015500175000c5001050015500175000c5001050000500005000050000000000000000000000
010400002115422151231512415124151241512415118100001000010100101001010010100101001010010100101001010010100100001000010000100001000010000100001000010000100001000010000100
010e000026050170001500012000130000e000100001200017000190001a00019000120000e00010000130000e000100001200013000150000c0000e0001000012000190001c000190001a0000e000100000e000
011200001ca301ca3523a4023a4528a4028a4523a5023a552ca502ca5528a4028a4523a4023a4528a3028a3521a3021a3528a4028a452da402da4528a5028a5532a5032a552da402da4531a4031a452da302da35
011200001ea301ea3525a3025a352aa402aa4525a4025a452da502da552aa502aa5525a4025a452aa402aa4523a3023a3527a3027a352aa402aa4527a4027a452fa502fa5527a5027a5531a4031a452fa402fa45
0112000025a3025a3528a3028a352ca402ca452fa402fa4524a5024a5527a5027a552ba402ba452ea402ea4523a3023a3527a3027a352aa402aa4527a4027a452fa502fa5527a5027a5531a4031a452fa402fa45
0112000020a3020a3527a4027a452ca402ca4527a5027a552fa502fa552aa402aa4523a4023a451aa301aa3519a3019a3520a4020a4525a4025a4520a5020a5528a5028a5520a4020a4519a4019a4520a3020a35
011200001ea301ea3521a4021a4525a4025a452aa502aa5523a5023a5527a4027a452aa402aa4523a3023a351ca301ca3520a4020a4523a5023a551fa501fa551ea401ea4521a4021a4524a3024a351ba501ba55
011200001ea301ea3521a4021a4525a4025a452aa502aa5523a5023a5527a4027a452aa402aa452fa302fa3520a3020a3523a4023a4527a5027a552ca502ca5525a4025a4520a4020a451ca301ca3520a5020a55
011200001ea301ea3521a4021a4525a4025a452aa502aa5523a5023a5527a4027a452aa402aa4523a3023a351ca301ca3520a4020a4523a5023a5525a5025a5527a4027a4528a4028a4527a3027a3520a5020a55
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011200002c9602c9602c9502c9502c9402c9402c9302c9302c9202c9202c9102c9102f7602f7502f7422f7422896028950289502894028930289222891228912345253b52538525285252f5251c5252f5151c515
011200002396023960239502395023940239402393023930239202392023912239122391223912287602a7602c7602c7002d7602c760007002a760007002a9702a7602a7502a7422a73128b0428b050000000000
011200002596025950259552f7602f7502f7552d7602d7552496024950249502876028750287502d7602d7512f7712f7612f7502f7402f7302f7202f7102f7102fc752fc552fc352fc152fc152fc052f8051e800
1912000028c3028c3028c3028c4028c5028c5027d5027d6027d7027d6027d5027d3027d1027d0027d0227d0226d3127d3127d3027d4027d5027d5025d5025d6025d7025d6025d5025d3025d1025d0025d0025d00
1912000028c3028c3028c3028c4028c5028c5027d5027d6027d7027d6027d5027d3027d1027d0027d0127d0128c3128c3128c3028c3028c4028c4028c4028c4028c5028c5028c5028c5028c4028c3228c2228c12
691200002851028520285302854028550285512755127560275702756227552275322751227500275022750226531275312753027540275502755125551255602557025562255522553225512255002550025500
691200002853028530285302854028550285512755127560275702756227552275322751227500275012750128531285312853028530285402854028540285402855028550285522855228542285322852228512
1912000028c3028c3028c3028c4028c5028c5027d5027d6027d7027d6027d5027d3027d1027d0027d0127d0128c3128c3128c3028c4028c4028c3028c2028c152ab002ab002ab002ab002ab002ab002ab002ab00
691200002853028530285302854028550285512755127560275702756227552275322751227500275012750128531285312853028530285402854028541285412a5512a5502a5502a5402a5402a5322a5222a512
011806081ca7520a7523a7528a7023a6027a5028a3228a32000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c10181c8751c8752087520875238752387520875208752f8752f87520875208751c8751c8752087520875238552385520855208551c8551c85520855208550000000000000000000000000000000000000000
01ff00001c7031c7031c7031c70300703007030070300703007030070300703007030070300703007030070300703007030070300703007030070300703007030070300703007030070300703007030070300703
01180e0f1c97520775237752897523905279552874028730287202871028710287102870000905009050090500905009050090500905009050090500905009050090500905009050090500000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000010040110500c0500b0501a0401f03015620156201962013640106400f63010630116300d6300d6400e6400e6400b63009620086200862007620046200461003600016100d6000e6000e6000060000600
010600001c3502035023350283501c3402034023340283401c3502035023350283501c35020350233502835000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300001047310600106001b65300600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000000000000000000
010300001047310600106001b65300600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000000000000000000000000000000000000
0004000013e500000010e5000000000000000017e50000000000010e500fe0013e5000000000000000000000000000fe5000000000000ee500fe500fe50000000000000000000000000000000000000000000000
0004000014e500000015e001fe500000019e501ee0018e00000000000010e50000000fe5000000000001ae0016e500000015e0020e50000001fe5017e00000000000000000000000000000000000000000000000
0004000018e500000015e50000000000020e501ee5018e500000000000000000000016e5000000000001ae50000000000015e50000000000017e5017e50000000000000000000000000000000000000000000000
91010000107511275116751197511d751217512875100701007010070100701007010070100701007010070100701007010070100701007010070100701007010070100701007010070100701007010070100701
490200002324023240232402324028240282402824028240282402824028240282402823028230282302823028230282302823028230282202822028220282202822028220282102821028210282102821028210
000300000c7500f041130311312500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000905009040090400903009031090310902109021090210a0210b0210b0210c0210d0200e0210f02111011120111c0011a0011700116001140011200111001100010d0010d00100001000010000100001
010500000b07012741127350c0000c0701374113735147010c0401372113715167050c0201371113715185021800512200122050a2000a4000a3000a0050a70500000000000d0001400014005000000000000000
010600001c56311500105331051310503105031050513505305041050310505005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
010600000535302344033110401105715123000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020500003c664006353c6000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
010100001861000410186150060500205006050060000600000003c620182103c61524605246053c6000060000600006000060000600006000060000600006000060000000000000000000000000000000000000
__music__
01 08504344
00 09504344
01 08104344
00 09114344
00 08104344
00 0a124344
00 0d155644
00 0e165644
00 0d131544
02 0c171844
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
04 191a1c1b
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
01 34424344
00 35424344
02 36424344
00 35363444

