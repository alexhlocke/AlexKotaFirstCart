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
 _upd()
 debug[1]="cpu: "..stat(1)
 debug[2]="mem: "..stat(0)
end


function _draw()
 _drw()
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
	pal(pallete[pincrement],1)

end


--== debug stuff ==-------------

--debug
debug={}

show_debug=true
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
 --freeze player
 player.state="frozen"
 
 --set pallete
 poke( 0x5f2e, 1 ) --endable hidden colors
	pal(pallete[pincrement], 1 )
end


--== update ==-----------------
function update_game() 
 --update/move player
 update_player()
 
 adv_time()
 pal(pallete[pincrement], 1 )
 
 --update minigame if active
 if(do_minigame)update_minigame()
 
 --update cam
 update_cam()
 
 --update fx
 update_fx()
 
 --debug
 --if(btnp(❎))start_fishing()
end


--== draw ==--------------------
function draw_game()
 cls(2)
 
 --drawbg
 --clouds
 draw_clouds()
 
 draw_lights()
 
 --draw water
 draw_water(110) --water y
 
 --draw interior bgs
 --rectfill(0,128,383,256,4)
-- rectfill(512,128,1080,256,1)
-- rectfill(512,232,1080,256,1)
 
 --draw map
 map(0,0,0,0,1000,32)
 
 --water to block map (ghetto)
 rectfill(384,256,512,7000,2)  

 --draw player
 draw_player()
 
 --==fishing==--
 if do_minigame then
  draw_minigame()
 end
 
 --== draw foreground details
 draw_fx()
 
 --draw clock
 draw_clock(w.t,clock_x,clock_y,clock_size)

 
 --draw intreactable prompts
 for i in all(interactables) do
  if(col(player,i)) then
   --debug[6]="hit something"
   show_prompt(i)
  end
 end
 		
 
 --draw main menu
 if(show_menu)draw_main_menu()


 --== debug stuff
 
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
show_menu=false

--displays menu overlay on top
--of game
function draw_main_menu()
 --stop drawing menu if btn
 if(btn(❎)or btn(🅾️)) then 
  show_menu=false
  player.state="walking"
 end

 print("★ this is the main menu ★",10,60,14)
 print("∧press ❎ or 🅾️ to continue∧",4,67,14)
end

function draw_background()
	sspr(32,32,32,32,0,0,128,180)
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

--★ todo: shinies

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
 make_fish("mOSS sLUG"
  ,135,1,1,2,{{6,3},{5,2},{4,1}})
 make_fish("fish 1"
  ,136,1,1,2)
 make_fish("fish 2"
  ,137,1,1,2)
 make_fish("fish 3"
  ,138,1,1,2)
 make_fish("fish 4"
  ,152,1,1,2)
 make_fish("pINKTAIL"
  ,153,1,1,2,{{8,2},{9,3},{2,8},{3,9}})
 make_fish("sHRIMP"
  ,154,1,1,1)
 make_fish("jUMBO sHRIMP"
  ,154,1,1,3)
 make_fish("fish 7"
  ,155,1,1,2)
 make_fish("fish 8"
  ,136,1,1,2)
  
 --1x2 fish
 make_fish("aXOLITTLE"
  ,168,2,1,2)
 make_fish("fish 10"
  ,184,2,1,2)
  
 --2x2 fish
 make_fish("fish 11"
  ,170,2,2,2)
 make_fish("fish 12"
  ,172,2,2,2)
 make_fish("aMGLERFISH"
  ,174,2,2,2,{{6,15},{5,15},{4,15},{1,14},{7,13},{11,0},{12,15}})
 
 --xl fish
 make_fish("sWORDFISH"
  ,140,4,2,3,{{3,9},{2,8},{1,7}})
 
 
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


--== fish display ==------------


function draw_fish_got(fish)
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

 --shiny (debug)
 set_shiny_pal(fish)
	
 sspr(fish.sprt%16*8,flr(fish.sprt/16)*8
  ,w,h
  ,cam.x+63-w*scale/2,cam.y+y-h*scale/2
  ,w*scale,h*scale)
 
 --complete palette refresh
 rp() 
  
 bprint("holy fucking shit",cam.x+30,cam.y+90,15,1)
 bprint("a fucking fish",cam.x+35,cam.y+97,14,1)
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
 line(s.x+5,s.y,player.x+9,player.y+10,0)
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
 bprint("depth: "..hook.y-70,cam.x+2,cam.y+2,3,1)
end
-->8
--player / cam


--== player table ==-------------


--main x limits for player
--[[
 these can change depending on
 special rooms / states
--]]
--main_xl_limit=20
--main_xr_limit=407
main_xl_limit=-1000
main_xr_limit=2000
--interior y player val
int_y=230
default_y=81
frame=0
walkframe=0

player={
  x=400, y=81
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
 ,state="walking"
 ,tail=3
 ,feetsies=18
}


--== player functions ==--------


--update player
function update_player()
 local s=player
 frame+=1
 
 --sprites for animation
	if(frame%4==0) then
		cat_tail()
		walk_spr()
	end
	
	--default state
	if(s.state=="fishing") then
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

--== cat anim


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
		
			if(s.state == "idle"
			or s.state == "fishing") then
					spr(s.s0,x,y,2,2,s.direct)
					if (s.direct) then
					spr(s.tail,x+14,y+7,1,1,s.direct)
					else
					spr(s.tail,x-7,y+7,1,1)
					end	

			else if (s.state == "walking") then
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
end



--== camera ==-------------------

cam={x=0,y=0}

function update_cam()
 --if minigame
 if(player.state=="fishing")then
  cam.x=384
  cam.y=hook.y-40
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
 
 bprint_cent(i.prompt,xp,yp,15,0)
 --show little ❎ button
 show_❎(xp-1,yp+9)
end

function show_❎(x,y)
 bprint_cent("❎",x,y,0,0)
 bprint_cent("❎",x,y-sin(t()),15,0)
end


--== filling interact table ==---


function init_interactables()
 --overworld doors
 add_interactable(304,55,344,100
  ,"eNTER hOME"
  ,function() 
    tp(528,int_y-5,512,128)
   end
  ,"home door")
 add_interactable(169,55,208,100
  ,"eNTER sHOP"
  ,function()
    tp(144,int_y-5,128,128)
   end
  ,"shop door")
 add_interactable(54,55,104,100
  ,"eNTER aQUARIUM"
  ,function() 
    tp(784,int_y-20,768,128)
   end
  ,"aquarium door")
  
 --interior exits
 add_interactable(128,203,168,256
  ,"eXIT sHOP"
  ,function()
    tp(198,default_y,128,0)
   end
  ,"shop exit")
 add_interactable(512,203,552,256
  ,"eXIT hOME"
  ,function()
    tp(302,default_y,128,0)
   end
  ,"home exit")
 add_interactable(768,203,808,256
  ,"eXIT aQUARIUM"
  ,function()
    tp(61,default_y,0,0)
   end
  ,"aquarium exit")
  
 --fishing
 add_interactable(407,70,460,100
  ,"sTART fISHING"
  ,function()start_fishing()end
  ,"fishing zone")
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
		{[0]=0,1,140,12 ,131,3  ,139,130,136,14 ,142,143,15,13 ,6  ,7}
		--transition 1
	,{[0]=0,1,140,140,131,3  ,3  ,130,136,14 ,142,143,13,13 ,6  ,6}
		--transition 2
	,{[0]=0,1,1  ,140,129,3  ,3  ,128,136,14 ,142,141,13,13 ,141,6}
		--transition 3
	,{[0]=0,0,1  ,140,129,3  ,3  ,128,136,14 ,130,141,13,13 ,141,6}
		--night
	,{[0]=7,0,1  ,140,129,131,3  ,128,2  ,135,130,141,13,133,141,6}
}

function adv_time(sp)
  w.t=(time()-st)
  
   if (w.t==45 or w.t==115) then
 			pincrement=2
 		elseif (w.t==50 or w.t==110) then
 				pincrement=3
 		elseif (w.t==55 or w.t==105) then
 				pincrement=4
 		elseif (w.t==60) then
 				pincrement=5
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




__gfx__
0077000000770000000077000000770000000770000000000b00000000000000eeeeeeee000000000eeeeeeeeeeeeee0066065000050500089230000bbbbbbbb
07cb700007bc70000007cc700007cc7000007cc7000000000b00000000c09000ecb5bc5d09c0c9000e333333333333d0005550000005000089235660b452377b
07ccb7777bcc70000007cb700007cb7000007cb7000000000b00000000998000ebbbbb5d089c98000e336333333353d00404040000ddd00088225550b452377b
07bbbbbbbbbb700000007b700007b7000007bb70000000000bcccc0000888000eb7b7b5d089998000e365533333544d0004440007777777777777777b452377b
77bbb7bbb7bb770000007bb70007b7000007b700000000000aaaaa0000040000e5bcb55d008980000e3373333b3373d007aaa7007accccc77ccccca7b442277b
07bbb7bbb7bb7000000007b70007bb770007bb77000000000700070006040600e4aaa44d500800500e337333313373d007baa7007abbbbb77bbbbba7baaaaaab
77bbbbbcbbbb7700000007bb000077bb000077bb000000000700070000545000dddddddd450605400e665666656656d007bbb7007abbbbb77bbbbba7bde7777b
007bbbbbbbb7000000000077000000770000007700000000070007000077700000000000045654000eddddddddddddd0007770007abbffb77bffbba7bde7777b
0007aaaaaa7000000000777bbbbb70000000777bbbbb7000000000b0000000000000000000040000cccccccccccccccc000006507abbccb77bccbba7bde9998b
007bbbbbbb7000000007cccbbbbbb7000007cccbbbbb7000000000b000000000000fffd001233300bbbbbbbbbbbbbbbb060050057abbbbb77bbbbba7bdd8888b
07bbabbbb70000000007bbbaaaabab700007bbbaaabb7000000000b009999999999fffd001233300bbbbbbbbbbbbbbbb005006057abbbbb77bbbbba7baaaaaab
07babbbbb7000000007b7ba7777a7ab70007bba777ab700000ccccb009999999999dddd0012333007777777777777777005000047abbbbb77bbbbba7b567777b
07bbb77bb770000007ba7b7007a707a70007ba707a7a700000aaaaa00888888888888880012233000aa0000000000aa0050060407abbbbb77bbbbba7b567777b
07ab7bc7bbc7000007a77a7007a70070007ba7007a7ab700007000700770000000000770012233000ab0000000000ab0005454007aaaaaa77aaaaaa7b567777b
07aaaaa7aaa7000000707aa707aa7000007a7a70077ab700007000700a70000000000a70011222000ab0000000000ab00baaaab07777777777777777b557777b
007777707770000000000777007770000007777000077000007000700a70000000000a70011111000ab0000000000ab00077770000aaa000000aaa00baaaaaab
3ffffffffffffffffffffff3bbbbbbbb003333000000003200000065000000980cccccccccccccc000dffd0000000000000e000000000300cccccccc0000ddd0
231111111111111111111132bbbbbbbb03200230000003200000065000000980cbbbbbbbbbbbbba700dfed0000ddd00000ded00000123000bbbbbbbb000d000d
213333333333333333333312bbbbbbbb32000023000032000000650000009800cbbbbbbbbbbbbba700dfed000fdedf0000d0d0000b222000bbbbbbbb000d000d
213333333333333333333312aaaaaaaa30000003000320000006500000098000cbbbbbbbbbbbbba700dffd00defffed000ded0000045600077777777000d000d
2133f3333333333333333312aaaaaaaa30000003002100000054000000870000cbbbbbbbbbbbbba700defd007deeed70000e000000445600000000000000ddd0
213f333333333333333333127777777730000003021000000540000008700000cbbbbbbbbbbbbba700defd007fdddf7000ded0000044560000000000000000d0
213f33333333333333333312777777772000000221e0000054e0000087e00000caaaaaaaaaaaaaa700defd007e7f7e7000d0d0000004456000000000000000d0
213f333333333333333333127777777720000002100000004000000070000000077777777777777000dffd007e7e7e7000ded0000000b00600000000000000dd
213f33333333333333333312bcccccca2222222200000000030206050000000000effe00213f3333eeeeeeeeeeeeeeee000e00000cccccc03333331200f0000d
213f33333333333333333312cabbbb7c20000002009880000030005000998800099ee890213f3333effffffeeffffffe00e0e00007bbbb70333333120ee0000d
213f33333333333333333312cbabb7ac300000030fffff007221f54700700700f870078f213f3333ef7ff7feeffffffe0e000e00007aac0033333312dd00000d
2133f3333333333333333312cbba7aac30000003fffffed07721d47707000070fe0000ef213f3333ef7777edef7ff7ede00600e0007aa60033333312dd00000d
213333333333333333333312cbb7baac300000039ffeed807c7777a789999998d970078d213f3333efeeeeedefffffede05460e0007a5c0033333312d000000d
213333333333333333333312cb7aabac3000000389ddd8707b7ba7a798888887088dd890213f3333deeeeeeddeeeeeedabbbba70007a4c0033333312d10000dd
232222222222222222222232c7aaaabcabbbbbba088887007b7ba7a79888888700deed00213f3333dddddddddddddddd0aaaa700007aa40033333312dd1111d0
311111111111111111111113accccccbaaaaaaaa007770007b7ba7a78777777800000000213f3333077007700770077000777000007a4c00333333120dddddd0
66666666666666666666666677777777788879887777777700000033333333333333333333000000122333331100000000000000cffffffcffffffffffffffff
666666666666666666666666777777777888778878888888000002222222222222222222222000001122222211000000000000000cffffc0fffffbbaffffbfff
5555555555555555555555557777777778888888788888880000222111111111111111111222000071111111111000000000000000000000ffffbccbaffbcbff
54545454545454545454545477777777788888887888888800032211111111111111111111223000a7111111111000000000000000000000ffffcffcbafcfcff
4444444444444444444444447777777778888888788888880032211177777777777777771112230077777777111100000000000000000000ffffcbffcbfffcff
7777777774777777777747777777777778888888788888883322117bbb7bbba7bbbba7bb771122337aaa7aaa111110000000000000000000fffffcfffcbbbcff
777777777747777777757777777777777888888878888888222117a7aa7aaaa7aaaaa7aa7a7112227bbb7bbb111111000cffffc000000000ffffffffffcccfff
77777777757777777777577777777777788888887888888811117ba777777777777777777aa711117777777711111110cffffffc00000000ffffffffffffffff
0000000000000000000000007777777777777777bb7acba7007acba7baaaa7bb777777777aba70003333322111111110000000ccffffffffc000000000bbbbbb
000000000090900000007a007777777777777777777acba7007acba777777777700700a77aba7000222222111111110000ccccfffffffffffccccc00007000a7
0000000000ac9000bbbb7abb77edd77777777777bb7acba7007acba7ba7bbbbb700700a77aba700011111117111110000cffffffffffffffffffffc0007700a7
0000000000aac00077777a7777ddd7777ed77777aa7acba7007acba7aa7bbbaa700700a77aba70001111117a11110000fffffcffffffffffffcfffff070070a7
000000000505000000007a0077ddd7777dd77777777acba7007acba777777777777777777aba70007777777711100000cfffcfcffcffffcffcfcfffc000000a7
0000000000454000bbbb7abb7777777777777777bb7acba7007acba7bbbba7bb700700a77aba7000aa7aaaa711100000bcffffcffbccccbffcffffcb000000a7
000000000004000077777a7777777ed777777777aa7acba7007acba7bbaaa7bb700700a77aba7000bb7bbbb711000000abccccbfffbbbbfffbccccba070070a7
00000000000400000000770077777dd777777777777acba7007acba7777777777aa7aaa77aba700077777777110000000abbbbffffffffffffbbbba0007700a7
00000000000000000000000009090000b878a7bb7aba7ba7007acba7bbbaa7bbbbbaa7bb7aba700000777700111111110abbbbffffffffffffbbbba0000000a7
00000000066666600000000080008000778877777aba7777007a54a777777777777777777aba7000ab7cc7ba01111110abccccbfffbbbbfffbccccba000000a7
00000000656656660000000008080009b778bbbb7aba7bbb0075cb47b67bbbbbba7bb5b47a6a70007abbbba700111110bcffffcffbccccbffcffffcb000000a7
00000006665565656000000000880880454b6baa7aba7aaa0075cba4aa5b5baaaa7bbb5a7ab5700077aaaa7700011100cfffcfcffcffffcffcfcfffc000000a7
00000065656656566600000090088009744477777aba7777007a6ba474777577775777747aba40007c7777a700011100fffffcffffffffffffcfffff000000a7
0000006656555b656500000008880000de4ee7bb7aba7bb7005acba44bbb574bb4bba7bb7ab470007b7ba7a7000110000cffffffffffffffffffffc0000000a7
000005654555bca456500000800800007ddd77bb7aba7aa70074b5a4b4a4a4b5bb4aa7bb7a4a70007b7ba7a70001100000ccffffffffffffffffcc00000000a7
0000065554455a454560000000080000777777777aba7777004a4a4747474747747777774ab470007b7ba7a700001000000000ccffffffffcc000000000000a7
0006565544444444565660000011110000060000000000000000000000c1110000000000000000000000000007777777000001111111111111000000000000a7
056565b5454444545565665001111110005000000030030000600060c7b1c1100011110001100000006000060bcccbb7000011111111111111100000000006a7
54545bca545445455656556511111111000400000300300000050600bcbcb1110111111011110000005000500aaaaaa700011111111111111111000000060067
454545a5654444556b45645411111111004111000030030000500050ababa11101111110111100000500005007777777000111111111111111110000000504a7
5444545555555555bca4444511111111001111100003001005006005ababa1110111111001100000500600050000000000011111111111111111000000050047
44444545454555454a444444011111100011111000100100040005047a1a11110111111000000100400050400000000000011111111111111111000000004047
444444445454545444444444001111000011111001001000004040040111111000111100000011100404004000000000000011111111111111110000000004a7
044444444444444444444440000000000001110000100100040040400011110000000000000001000404040000000000000001111111111111100000000004a7
000000000000000000000000000000000000000000000000000bc0006060000000eee00000060600000c00c00000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000cb7ba00505000000eedde000065600000b0000c40000000000000000000003f1000000000000000
000000000000000000000000000000000000000000000000000bba0c05656500ed7dd40e044440000bbb000b0445600000000000000033210000000000000000
0000000000000000000000000000000000000000000000000000bba06656565044de441041555406b7bbb0ba4155550600000000000322100000000000000000
00000000000000000000000000000000000000000000000000c0cba05056565601444101cbbbb450abbbaba0fffeedf000000000003221200000000000000000
0000000000000000000000000000000000000000000000000b00cba044141414001110000aaa40040aaa0ab00dddd00d000000000f32121100000000000033ff
0000000000000000000000000000000000000000000000000b0cba0b01717170000e00000005000000b000ab000e000000000000f221212110000003000f2220
00000000000000000000000000000000000000000000000000baa000000000000000f00000006000000c000a0000f00000000000333322222200002000322200
0000000000000000000000000000000000000000000000000006060000b0b0b000000000000000000cccbc000000f00000000003222223333311112033222100
000000000000000000000000000000000000000000000000006560000acccc0c0000000000000000c7bbabc0000c000000003332232233333333333322211000
00000000000000000000000000000000000000000000000004444000cbccccc0000ff000000ef0000aaa0abc00c7c000332222f7232233333333322311100000
000000000000000000000000000000000000000000000000415554060bb7c7ba0ffeef0f0ff33f090b0b00bb07c7b70c00011177322223333222221122210000
000000000000000000000000000000000000000000000000cbbbb450abbb7bb0e7eddeede722229800c0c0cbc7b7b7b000000011111122222211112011221000
0000000000000000000000000000000000000000000000000aaa400407abba700dd777d00ddd7780000000ca07b7a70a00000000022211111120002000112000
00000000000000000000000000000000000000000000000000050000c007a00a000e000d000e00080c000cba00ab700000000000003220000020000300001230
0000000000000000000000000000000000000000000000000000600000a00a000000f0000000f00000bbbaa0000a00000000000000033f000003000000000000
00000ee0000000000009999000000000000000000000000000ffdd00000000000000009000000000000000005544000000000000000000000000000000000000
0000e90000000000098888889000000900000000000000fffeed00000000000f00009800090000000000005564000000000000cc000000000007700000000000
000e9800000000009870000089000998000ee00000000feeedd0000000000ffe0999800980009990000005664000000000000cbba00000000070070000000000
00e9889000000000800088890799870000edde000000feddd7000000000ffde099f79988000999c800005556640005500000cbbba00000000700007000000000
099877800009999080097077888870890eddde000fffeddd7700000000fddd009977c9999999cc870005666555505665000aaaaaaaa00000cc00065550000000
977999999098888970970000000778000edd70fffeeeddddd77ff0000eddd7008ccc98889887888705565566666566400abbddbbddba0aa0fc00654445000066
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
__label__
fffffffussssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssufffffffuuuuuufffffffussssssssssufffffffuuuuuu
fffufffffssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssfffffufffuffffufffufffffssssssssfffffufffuffffu
ffufufffussssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssufffufuffffffffffufufffussssssssufffufuffffffff
ffuffffuussssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssuuffffuffffffffffuffffuussssssssuuffffuffffffff
ffuuuuuuusuffffusssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssuuuuuuuffffffffffuuuuuuusuffffusuuuuuuuffffffff
fffuuuuusuffffffusssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssuuuuuffffffffffffuuuuusuffffffusuuuuufffffffff
fffff7777ffffffffussssssssssssssssssssssssssssssssssssssssssssssssssssssssuuuuuffffffffffffffffffffff7777fffffffffffffffffffffff
ffff777777fffuffffuuuuussssssssssssssssssssssssssssssssssssssssssssssssssuuuuuuuffffffffffffffuuufff777777fffffffffuuuufffffffff
fff77777777fuuuffffffffusssssssssssssssssssssssssssssssssssssssssssssssssuuffffufffffffffffffuuuuff77777777fffffffuuuuuuffffffff
f7777vvvv777fffffffufffffssssssssssssssssssssssssssssssssssssssssssssssssufffufufffffffffffffffff7777vvvv777ffffffuffffuffffffff
7777vffffv7777777fufufffussssssssssssssssssssssssssssssssssssssssssssssssfffffufffuffffufffff7777777vffffv7777777fffffffffuff777
f777f7777f777f77777ffffuusssssssssssssssssssssssssssssssssssssssssssssssssufffffffuuuuuufff77777f777f7777f777f77777fffffffu77777
7f7777777777f7f777fuuuuuusssssssssssssssssuffffusssssssssssssssssssssssssssuuffffffuuuufffff777f7f7777777777f7f777ffffffffff777f
7f7777777777f7777fvuuuuusssssssssssssssssuffffffussssssssssssssssssssssssssssssuuffffffffffvf7777f7777777777f7777fvffffffffvf777
fv7777777777vffffvuff7777fsssssssssssssuuffffffffusssssssssssssssssssssssssssssssuffffffusuuvffffv7777777777vffffvuff7777fuuvfff
v777777777777vvvvuuf777777fssssssssuuuufffffffffffuuuuusssssssssssssssssssssssssssuffffusuuuuvvvv777777777777vvvvuuf777777fuuvvv
777777777777777777777777777fssssssuffffffffffffffffffffussssssssssssssssssssssssssssuvvvv777777777777777777777777777777777777777
v777777777777777vvu7777v7777ffffffffffuffffffffffffufffffssssssssssssssssssssssssssuvffffv77777777777777vvu7777v7777777777777vvv
fv7777777777777vffvu77vfv77777777ffffufuffuffffuffufufffussssssssssssssssssssssssssvf7777f7777777777777vffvu77vfv77777777777vfff
7f7777777777777f77fvu7f7f7777f77777ffffuffuuuuuuffuffffuussssssssssssssssssssssssssf777f7f7777777777777f77fvu7f7f77777777777f777
7777f7777f77777fv77fv777f777f7f777fuuuuufffuuuufffuuuuuuusuffffusssssssssssssssssss77777f777f7777f77777fv77fv777f777f7777f777777
7777vffffv777777f777fvvvf777f7777fvuuuuffffffffffffuuuuusuffffffusssssssssssssssssssf7777777vffffv777777f777fvvvf777vffffv777777
77777vvvv777777777777fff7777vffffvusssssssuuuuuffffff7777ffffffffusssssssssssssssssssff777777vvvv777777777777fff77777vvvv7777777
77777777777777777777777777777vvvvusssssssuuuuuuuffff777777fffuffffuuuuussssssssssssssssssff7777777777777777777777777777777777777
77fsuvvvv7777777777fsssssssf777777fssssssuuffffufff77777777fuuuffffffffusssssssssssssssssssf777777fsuvvvv7777vvvvusf777777ff7777
7fsuvffffv7777777777fffffsssf7777fsssssssufffffff77777777777fffffffufffffsssssssssssssssssssf7777fsuvffffv77vffffvusf7777fssf777
sssvf7777f777777777777777fsssssssssssssssffff77777777777777777777fufufffussssssssssssssssssssssssssvf7777f77f7777fvsssssssssssss
sssf777f7f77777777777f77777sssssssssssssssu77777f777777777777f77777ffffuussssssssssssssssssssssssssf777f7f77f7f777fsssssssssssss
sss77777f777f7777f77f7f777fssssssssssssssssf777f7f77f7777f77f7f777fuuuuuussssssssssssssssssssssssss77777f7777f77777sssssssssssss
ssssf7777777vffffv77f7777fvssssssssssssssssvf7777f77vffffv77f7777fvuuuuussssssssssssssssssssssssssssf777777777777fssssssssssssss
sssssff777777vvvv777vffffvussssssssssssssssuvffffv777vvvv777vffffvusf7777fsssssssssssssssssssssssssssff77777777ffsssssssssssssss
sssssssssff7777777777vvvvussssssssssssssssssuvvvv777777777777vvvvusf777777fssssssssssssssssssssssssssssssffffsssssssssssssssssss
sssssssssssf777777ff777777fsssssssssssssssssssssssssuvvvv777777777777777777fssccccssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssf7777fssf7777fsssssssssssssssssssssssssuvffffv777777vvu7777v7777fsssssssssssssssssssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssssssssssssvf7777f77777vffvu77vfv777sss11sssssssssssssssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssssssssssssf777f7f77777f77fvu7f7f77css1111sscsssssssssssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssssssssssss77777f777777fv77fv777f7css111111sscssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssf77777777777f777fvvvccss11ivii11ssccssssssssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssssssssssssssff77777777777777fffsss11iuiiui11sssssssssssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssssssssssssssssssff77777777777771111ivuiiuui1111ssssssssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssf777777ff77ccccccccccccccccccccssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssf7777fssfsssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss111111111111111111sssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscss11111111111111111111sscsssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscss111iiiiiiiiiiiiiiii111sscssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssccss11ivvvvvuivvvvvvuivvii11ssccssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss11iuiuuuuuiuuuuuuuiuuiui11sssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss1111ivuiiiiiiiiiiiiiiiiiiuui1111ssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssccccssssssssssssssssiufvuiiiiiiiiivuuuuivviuvuisssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssiufvuii77i77uiiiiiiiiiiuvuisssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssssssss11sssssssssssssssssiufvuii77i77uivuivvvvviuvuisssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssscss1111sscsssssssssssssiufvuii77i77uiuuivvvuuiuvuisssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssscss111111sscssssssssssssiufvuiiiiiiiiiiiiiiiiiiuvuisssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssccss11ivii11ssccssssssssssiufvuii77i77uivvvvuivviuvuisssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssssssss11iuiiui11sssssssssssssiufvuii77i77uivvuuuivviuvuisssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssss1111ivuiiuui1111ssssssssssiufvuiiuuiuuuiiiiiiiiiiuvuisssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssccccccccccccccccccccssssssssiufvuivuuuuivvvoiouivviuvuisssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssiu3juiiiiiiiiiiiooiiiiiuvuisssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssssssss111111111111111111sssssssssi3fvjivuivvvvvviiovvvviuruisssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssscss11111111111111111111sscsssssi3fvujuuivvvuuj3jvrvuuiuv3isssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssscss111iiiiiiiiiiiiiiii111sscssssiurvujiiiiiiiiijjjiiiiiuvujsssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssccss11ivvvvvuivvvvvvuivvii11ssccss3ufvujvvvvuivvd6j66ivviuvjisssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssssssssssssss11iuiuuuuuiuuuuuuuiuuiui11sssssijv3ujvvuuuivvidddiivviujuisssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssss1111ivuiiiiiiiiiiiiiiiiiiuui1111ssjujujiiiiiiiiiiiiiiiiijuvjisssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssiufvuivvvuuivviiiiiiiivuuuuivv1sscccccccccccccccccccccccccccccccssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssiufvuiiiiiiiiii77i77uiiiiiiiii11ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssiufvuivuivv3vji77i77uivuivvvvvi11111111111111111111111111111111sssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssiufvuiuuivvv3ui77i77uiuuivvvuuui11111111111111111111111111111111sscsssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssiufvuiii3iiiijiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii111sscssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssiufvuivjvvuivvi77i77uivvvvuivviuuuiuuuvvivvvuivvivvvuivvivvvuiii11ssccssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssiufvuivvjuuivvi77i77uivvuuuivvivvvivvvuuiuuuuiuuiuuuuiuuiuuuuiiui11sssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssiufvuiijiiiiiiiuuiuuuiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiuui1111ssssssssssssssssssssssss
ssssssssssssssssssssssssssvvvvvvssiufvuivuuuuivvvuuuuivvvuuuuivvvvvuuivvvuuuuivvvuuuuivvvvvuuivviuvuisssssssssssssssssssssssssss
ssssssssssssssssssssssssssisssuissiufvuiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiuvuisssssssssssssssssssssssssss
ssssssssssssssssssssssssssiissuissiufvuivuivvvvvvuivvvvvvuivvvvvvuivv3vjvuivvvvvvuivvvvvvuivv3vjiuvuisssssssssssssssssssssssssss
sssss1s1s1s1s1s1s1s1s1sssi77isuissiufvuiuuivvvuuuuivvvuuuuivvvuuuuivvv3uuuivvvuuuuivvvuuuuivvv3uiuvui1s1s1s1ssssssssssssssssssss
1s1s1s1s1s1s1s1s1s1s1s1s17777suissiufvuiiiiiiiiiiiiiiiiiiiiiiiiiii3iiiijiiiiiiiiiiiiiiiiii3iiiijiuvuis1s1s1s1s1s1s1sssssssssssss
s1s1s1s1s1s1s1s1s1s1s1s1s77771uissiufvuivvvvuivvvvvvuivvvvvvuivvvjvvuivvvvvvuivvvvvvuivvvjvvuivviuvui1s1s1s1s1s1s1s1s1s1ssssssss
1s1s1s1s1s1s1s1s1s1s1s1s1i77isui1siufvuivvuuuivvvvuuuivvvvuuuivvvvjuuivvvvuuuivvvvuuuivvvvjuuivviuvuis1s1s1s1s1s1s1s1s1s1s1sssss
s1s1s1s1s1s1s1s1s1s1s1s1s1iis1uis1iufvuiiiiiiiiiiiiiiiiiiiiiiiiiijiiiiiiiiiiiiiiiiiiiiiiijiiiiiiiuvui1s1s1s1s1s1s1s1s1s1s1s1s1ss
1s1s1s1s1s1s1s1s1s1s1s1s1s1s1sui1siufvuivuuuuivviiiiiiiivuuuuivviiiiiiiivuuuuivviiiiiiiivuuuuivviuvuis1s1s1s1s1s1s1s1s1s1s1s1s1s
s1s1s1s1s1s1s1s1s1s1s1s1s1s1s1uis1iufvuiiiiiiiiii77i77uiiiiiiiiiioooooooiiiiiiiii77i77uiiiiiiiiiiiiui1s1sii1s1s1s1s1s1s1s1s1s1s1
1s1s1s1s1s1s1s1s1s1s1s1s1s1s1sui1siufvuivuivvvvvi77i77uivuivvvvviooooooovuivvvvvi77i77uivuivvvvvifviis1sivfi777f1s1s1s1s1s1s1s1s
r1s1s1s1s1s1s1s1s1s1s1s1s1s1s1uis1iufvuiuuivvvuui77i77uiuuivvvuuiooooooouuivvvuui77i77uiuuivvvuuiffviiiivffi7777f1s1s1s1s1s1s1s1
rr1s1s1s1s1s1s1s1s1s1s1s1s1s1sui1siufvuiiiiiiiiiiiiiiiiiiiiiiiiiioooooooiiiiiiiiiiiiiiiiiiiiiiiiivvvvvvvvvvi77777f1s1s1s1s1s1s1s
r3s1s1s1s1s1s1s1s1s1s1s1s1s1s1uis1iufvuivvvvuivvi77i77uivvvvuivviooooooovvvvuivvi77i77uivvvvuiviivvivvvivvviivv777fffff1s1s1s1s1
3r3s1s1s1s1s1s1s1s1s1s1s1s1s1sui1siufvuivvuuuivvi77i77uivvuuuivviooooooovvuuuivvi77i77uivvuuuivvivvivvvivvvifffv7777777f1s1s1s1s
j3r1s1s1s1s1s1s1s1s1s1s1s1s1s1uis1iufvuiiiiiiiiiiuuiuuuiiiiiiiiiioooooooiiiiiiiiiuuiuuuiiiiiiiiiivvvvfvvvvvii77f777f777771s1s1s1
3r3rrs1s1s1s1s1s1s1s1s1s1s1s1sui1siufvuivvvuuivvvuuuuivvvuuuuivvioooieoovuuuuivvvvvuuivvvuuuuivviivvvvvvvvi7ii7777f7f777fs1s1s1s
33r3rr31s1s1ius1s1e1e1s1s1s1sruis1iu3juiiiiiiiiiiiiiiiiiiiiiiiiiioooiiooiiiiiiiiiiiiiiiiiiiiiiiiiuiuuuuuui7iffi77rrrrrrfv1s1s1s1
3r3r33r3vvvviuvv1sufes1s1s1r1sri1si3fvjivrivvvvvvuivvvvvvuivvvvviooooooovuivvvvvvrivvvvvvuivvvvviuivvvvvvviivfi7r3rr3rrrusf7777f
rvj3rj3jiiiiiuiis1uuf1s1s1s3sjuis1i3fvujuu3v3vuuuuivvvuuuuivvvuuiooooooouuivvvuuuu3v3vuuuuivvvuuiuvivvvvuvviivvirr33r3r3rf777777
vfujjjj37fufiufu13131s1s1s131sji1siurvujijiii3iiiiiiiiiiiiiiiiiiioooooooiiiiiiiiijiii3iiiiiiiiiiiuvivvvvvuvi7ivir3rr3r3rrr777777
jujjjjjjvvvviuvvu1j3j1s1s1s1j1jis13ufvujjvvv3ijvvvvvuivvvvvvuivviooooooovvvvuivvjvvv3ijvvvvvuivviuiivviivvviivvi3r333vr3r37777vv
jjjjjjjjiiiiiuiifu1j1s1s1s1s1jui1sijv3ujvjujujv3vvuuuivvvvuuuivviooooooovvuuuivvvjujujv3vvuuuivviifvvifvivuvvii3j333vfuj3r377vff
jjjjjjj7777fii777fujuuu1s1s1sjuis1jujujijijijijiiiiiiiiiiiiiiiiiioooooooiiiiiiiijijijijiiiiiiiiijiuuuiuuuuuiir333jj33uj3j3r77f77
rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrriiiriiiiirrrrrrrrrrrrrrrrrrrrr
rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j3j
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
iiiiiiiiiiiijiiiiiiiiiiiiiiiiiiiiiiiiiiiijiiiiiiiiiiiiiiiiiiiiiiijiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiijiiiiiiiiiii
iiiiiiiiiii3iiiiiiiiiiiiiiiiiiiiiiiiiiiiiijiiiiiiiiiiiiiiiiiiiiiiijiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii3iiiiiiiiiiii
iiiiiiiiiiii3iiiiiiiiiiiiiiiiiiiiiiiiiiii3iiiiiiiiiiiiiiiiiiiiiii3iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii3iiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii6diiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiddiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii6diiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiddiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii6diiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii6diiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiddiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiddiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000464900000000000000000000000000000000000000000000000000000000434343434343434343434343434343437d7d7d7d5b00000000000000000000007d7e000000000000000000000000000045454545454545454545454545454545454545454545454545454545454545450000004c00000000000000000000004c
000065550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007d4b760000000000000000000000000045454545454545454545454545454545454545454545454545454545454545455e4c5c6d5e4c00000000000000005c6d
0000654a4900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007d7d7d7e00000000000000000000000045454545454545454545454545454545454545454545454545454545454545454f5d6d5d4e4f5e00004c0000006c5d4e
000065676900000046490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007d7d5b6f00000000000000000000000045454545454545454545454545454545454545454545454545454545454545456e4d4d6c5d5e4d005c5d5e4c00004d6c
004647484749000056690000000000000000004648474847484748490000000000000000000000000046490000000000000000000000000000000000000000007d7d0000007a630000000000000000004545454545454545454545454545454545454545454545454545454545454545000000004d4d0000006c4e4f5e000000
006657575759004647484900000000000000005657585857585857590000000000000000000000004648484900000000000000000000000000000000000000007d7d0000007c7d7e00000000000000004545454545454545454545454545454545454545454545454545454545454545000000000000000000004d4d00000000
005657585769006558585500000000000000006657585868585857690000000000000000004649005658575900000000000000000000000000000000000000007d7d000074006b000000000000000000454545454545454545454545454545454545454545454545454545454545454500000000000000000000000000000000
00566858574a5a6567575500000000000000464747474747474747484747490000000000464848496657646900000000000000000000000000000000000000007d5b0000000000000000000000000000454545454545454545454545454545454545454545454545454545454545454500000000000000004c00000000000000
005657475764574a4848474900000000000056576857576857575768592c2c0000000000566858574a47474749000000000000000000000000000000000000007d6f00760000000077007500000000004545454545454545454545454545454545454545454545454545454545454545000000000000005c6d5e4c4c00000000
00665758576568585857575900000000005f56575858575757585857592829000000005f5657575768575768590000000000005f0000000000000000000000007d4b007300000000007c7d7e00000000454545454545454545454545454545454545454545454545454545454545454500000000005c5e5c5d6d4e4f5e000000
00565758576557585857455900606162006f56575858574557585857590060616200006f5657585745575857590000006061626f0000000000000000000000007d7d00007879000000000000000000004545454545454545454545454545454545454545454545454545454545454545000000005c5d6e006c5d6e4d00000000
52666848676557576467446900707172527f66574747674464485a67595170717252517f6667575744576757696061627071727f3700000000000000000000007d5b0000000000000000000000000000454545454545454545454545454545454545454545454545454545454545454500000000004d0000004d000000000000
414040414242424042414040414040404140404042404040404041424040404140424040404140404140404040404240404140404200000000000000000000007d4b7600000000000000000000000000454545454545454545454545454545454545454545454545454545454545454500000000000000000000000000000000
434343434343434343435443434343434343434343435443434343434343434343434343434343434354434343434343434343434300000000000000000000007d7d7d7e000000000074000063000000454545454545454545454545454545454545454545454545454545454545454500000000000000000000000000000000
4343434343434343434343434343435343434343434343434343434354434343434343434343434343434343544343437d7d7d7d7d00000000000000000000007d7d7d4b0000000000007c7d7d7e0000454545454545454545454545454545454545454545454545454545454545454500000000000000000000000000000000
4343534343434343434343544343434343434343434343435343434343434343434343434343435443434343434343547d7d7d7d7d00000000000000000000007d7d7d7d7e0000000000006b00007700454545454545454545454545454545454545454545454545454545454545454500000000000000000000000000000000
4545454545454545454545454545454543434343434343434343434343434343434343434343434343434343434343437d7d7d7d5b000000000000000000000043434343434343434343434343434343434343434343434343434343434343435557575757576857575757576757575757575757685757575757576857575765
4545454545454545454545454545454543434343434343434343434343434343434343434343434343434343434343437d7d7d7d00000000000000000000000043434343434343434343434343434343434343434343434343434343434343435500002c00000000000000000000000000000000001c00000000000000000065
4545454545454545454545454545454543434343434343434343434343434343434343434343434343434343434343437d7d7d7d00000000000000000000000043434343434343434343434343434343434343434343434343434343434343435500003c00202121212200002021212200202121220f00202121212121220065
4545454545454545454545454545454543434343434343434343434343434343434343434343434343434343434343437d7d5b7d00000000000000000000000043434343434343434343434343434343434343434343434343434343434343435500000000395f5f5f3e000d3031313200303131321f00395f5f5f5f5f3e1c65
4545454545454545454545454545454500000000000000000000000000000000000000000000000000000000000000007d7d006b000000000000000000000000434343434343434343434343434343434343434343434343434343434343434355000c0f003031313132000f2e2e2e2e002e2e2e2e2e00395f5f5f5f5f3e0f65
4545454545454545454545454545454500000000000000000000000000000000000000000000000000000000000000007d7d0000000063787400000000000000000000000000000000000000000000000000000000000000000000000000000055007b7b0056484848590c0f2021212121212121220000303131313131321f65
4545454545454545454545454545454543434343434343434343434343434343434343434343434343434343434343435b6b0000007c7d7d7e00000000000000000000000000000000000000000000000000000000000000000000000000000055000000007b7b7b7b7b0f1f395f5f5f5f5f5f5f3e00007b7b7b7b7b7b7b7b65
4545454545454545454545454545454557685757575767575757575768576757575757576867576857575768576757577e00760000006b7879000000000000005757575757575757575757575757685757576857576757576857575768576757550038000020212121221f1f395f5f5f5f5f5f5f3e0000202121212121220065
4545454545454545454545454545454555332c2c00000000000000002a002c2c655500002c00000000333300002c00577e00730000000000000075000000000055070000000000002c2a000000000000001c56000000000000000000000000655500000c0f395f5f5f3e7b2c395f5f5f5f5f5f5f3e1c00395f5f5f5f5f3e0065
4545454545454545454545454545454555002c3300000000008d008f2a00332c655500003c000000002e2e00002c00574b000000000000000000730000000000550f00090f0000002c2a000000000000000f56000f1c00000000000000001c657b00000f1f3031313132003c3031313131313131320f00395f5f5f5f5f3e0065
4545454545454545454545454545454555003c00002829009c9d9e9f2a00003c655500000024000000002424003c00577d7e0000000000770000000000000000551f002e2e0000003c2a000000240024001f66002e2e00240000002424000f650000001f0f56474748591c005647484847474848591f00303131313131320d65
454545454545454545454545454545457b00000000000000000000002a0038007b7b0009003400282900343400000c577d4b75000000007978000000000000002e2e000000081c00002a000000340034002e2e00000000340000003434001f650000000f0f1a2e2e2e2e1b001a2e2e1a2e1b2e2e1b0f001a2e1a2e1b2e1b0f65
454545454545454545454545454545450000002d00252627003536002a2b98001c0000330c000000000000000d0f0f577d7d7d7e00000000000000000000000000000d0e000f0f00002a2b0000000700000000000a0b00000d0e000000070f652323232323232323232323232323232323232323232323232323232323232323
454545454545454545454545454545450036003d001a2e1b003333363a3b3b00333600333333001a1b000033331f1f677d7d5b0000006300000000000000000000001d1e000f1f003b3a3b00061a2e1b160000001a1b16001d1e0017180f1f654343434343434343434343434343434343434343434343434343434343434343
4545454545454545454545454545454523232323232323232323232323232323232323232323232323232323232323237d7d4b7600747300000000000000000023232323232323232323232323232323232323232323232323232323232323234343434343434343434343434343434343434343434343434343434343434343
4545454545454545454545454545454543434343434343434343434343434343434343434343434343434343434343437d7d7d7d7e000000000000000000000043434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
__sfx__
00010000100501005011050120501305016050170501a0501e0502405000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
