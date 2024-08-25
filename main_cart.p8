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
 custom_palette = {[0]=0,1,140,12,131,3,139,130,136,14,142,143,15,13,6,7}
 pal( custom_palette, 1 )
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
 custom_palette = {[0]=0,1,140,12,131,3,139,130,136,14,142,143,15,13,6,7}
	pal( custom_palette, 1 )
end


--== update ==-----------------
function update_game() 
 --update/move player
 update_player()
 
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
 
 --draw water
 draw_water(110) --water y
 
 --draw interior bgs
 rectfill(0,128,1080,256,12)
 
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
 bprint_cent(i.prompt,xp,yp,15,0)
 --show little ❎ button
 show_❎(xp-1,yp+9)
end

function show_❎(x,y)
 bprint_cent("❎",x,y,0,0)
 bprint_cent("❎",x,y-sin(t()),15,0)
end


function init_interactables()
 add_interactable(288,55,328,100
  ,"eNTER hOME"
  ,function() 
    tp(528,int_y,512,128)
   end
  ,"home door")
 add_interactable(184,55,224,100
  ,"eNTER sHOP"
  ,function()
    tp(144,int_y,128,128)
   end
  ,"shop door")
 add_interactable(38,55,88,100
  ,"eNTER aQUARIUM"
  ,function() 
    tp(784,int_y,768,128)
   end
  ,"aquarium door")
 add_interactable(407,70,460,100
  ,"sTART fISHING"
  ,function()start_fishing()end
  ,"fishing zone")
end


--== collision ==--


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
__gfx__
0077000000770000000077000000770000000770000000000000777777770000eeeeeeee000000000eeeeeeeeeeeeee0066c6500005c500089230000bbbbbbbb
07cb700007bc70000007cc700007cc7000007cc7000000000007888888887000ecb5bc5d090009000e333333333333d0005550000005000089235660b452377b
07ccb7777bcc70000007cb700007cb7000007cb7000000000078899889988700ebbbbb5d089098000e336333333353d004c4c40000ddd00088225550b452377b
07bbbbbbbbbb700000007b700007b7000007bb70000000009978899889988799eb7b7b5d089998000e365533333544d0004440007777777777777777b452377b
77bbb7bbb7bb770000007bb70007b7000007b700000000008878888888888788e5bcb55d008980000e3373333b3373d007aaa7007abbbbb77bbbbba7b442277b
07bbb7bbb7bb7000000007b70007bb770007bb77000000007799999999999977e4aaa44d500800500e337333313373d007baa7007abbbbb77bbbbba7baaaaaab
77bbbbbcbbbb7700000007bb000077bb000077bb000000000778888888888777dddddddd450605400e665666656656d007bbb7007abbbbb77bbbbba7bde7777b
007bbbbbbbb7000000000077000000770000007700000000077777777777777000000000045654000eddddddddddddd0007770007abbffb77bffbba7bde7777b
0007aaaaaa7000000000777bbbbb70000000777bbbbb7000000000000000000000777700000400000000000dd0000000000000007abbccb77bccbba7bde9998b
007bbbbbbb7000000007cccbbbbbb7000007cccbbbbb700000000000000000000788887001233300bbbbbbddddbbbbbb000000007abbbbb77bbbbba7bdd8888b
07bbabbbb70000000007bbbaaaabab700007bbbaaabb700000000000000000000789987001233300bbbbbbbbbbbbbbbb000000007abbbbb77bbbbba7baaaaaab
07babbbbb7000000007b7ba7777a7ab70007bba777ab7000eeeee0007700000099899899012333007777777777777777000000007abbbbb77bbbbba7b567777b
07bbb77bb770000007ba7b7007a707a70007ba707a7a7000ddddd0070070000088777788012233000aa0000000000aac000000007abbbbb77bbbbba7b567777b
07ab7bc7bbc7000007a77a7007a70070007ba7007a7ab700d7d7d7700455000079999997012233000ab0000000000abc000000007aaaaaa77aaaaaa7b567777b
07aaaaa7aaa7000000707aa707aa7000007a7a70077ab700ddddd0004606500078888887011222000ab0000000000abc000000007777777777777777b557777b
007777707770000000000777007770000007777000077000777770005000500007777770011111000ab0000000000abc0000000000aaa00000000000baaaaaab
000000000000000077777777bbbbbbbb00000000c32222222222222200000000000000000000000000000000000000000000000000000000000000000000ddd0
000000000000000077777777bbbbbbbb00000000c3200000020000020000000000000000000000000000000000000000000000000000000000000000000d000d
000000000000000077777777bbbbbbbb00000000c3200000020000020000000000000000000000000000000000000000000000000000000000000000000d000d
000000000000000077777777aaaaaaaa00000000c3200000020000020000000000000000000000000000000000000000000000000000000000000000000d000d
000000000000000077777777aaaaaaaa00000000c32000000200000200000000000000000000000000000000000000000000000000000000000000000000ddd0
0000000000b00000777777777777777700000000c3200000020000020000000000000000000000000000000000000000000000000000000000000000000000d0
000000000b000000777777777777777700000000c3200000020000020000000000000000000000000000000000000000000000000000000000000000000000d0
0000000000000000777777777777777700000000c3222222222222220000000000000000000000000000000000000000000000000000000000000000000000dd
0000000000000000000000000000000000000000c320000002000002000000000000000000000000000000000000000000000000000000000000000000f0000d
0000000000000000000000000000000000000000c32000000200000200000000000000000000000000000000000000000000000000000000000000000ee0000d
0000000000000000000000000000000000000000c3200000020000020000000000000000000000000000000000000000000000000000000000000000dd00000d
0000000000000000000000000000000000000000c3200000020000020000000000000000000000000000000000000000000000000000000000000000dd00000d
0000000000000000000000000000000000000000c3200000020000020000000000000000000000000000000000000000000000000000000000000000d000000d
0000000000000000000000000000000000000000c3222222222222220000000000000000000000000000000000000000000000000000000000000000d10000dd
0000000000000000000000000000000000000000c3333333333333330000000000000000000000000000000000000000000000000000000000000000dd1111d0
0000000000000000000000000000000000000000cccccccccccccccc00000000000000000000000000000000000000000000000000000000000000000dddddd0
6666666666666666666666667777777778888888baaaa7bb00000033333333333333333333000000122333330000000000000000cffffffcffffffffffffffff
666666666666666666666666777777777888798877777777000002222222222222222222222000001122222200000000000000000cffffc0fffffbbaffffbfff
5555555555555555555555557777777778887788ba7bbbbb0000222111111111111111111222000071111111000000000000000000000000ffffbccbaffbcbff
54545454545454545454545477777777788888887777777700032211111111111111111111223000a7111111000000000000000000000000ffffcffcbafcfcff
4444444444444444444444447777777778888888788888880032211177777777777777771112230077777777000000000000000000000000ffffcbffcbfffcff
7777777774777777777747777777777778888888788888883322117bbb7bbba7bbbba7bb771122337aaa7aaa000000000000000000000000fffffcfffcbbbcff
777777777747777777757777777777777888888878888888222117a7aa7aaaa7aaaaa7aa7a7112227bbb7bbb000000000cffffc000000000ffffffffffcccfff
77777777757777777777577777777777788888887888888811117ba777777777777777777aa711117777777700000000cffffffc00000000ffffffffffffffff
0000000000000000000000007777777777777777bb7acba7007acba7baaaa7bb777777777aba70003333322100000000000000ccffffffffc000000000000000
0090900000c0c00000007a007777777777777777777acba7007acba7777777777ff7ffa77aba7000222222110000000000ccccfffffffffffccccc0000000000
0089900000acc000bbbb7abb77edd77777777777bb7acba7007acba7ba7bbbbb7cf7cfa77aba700011111117000000000cffffffffffffffffffffc000000000
0088900000aac00077777a7777ddd7777ed77777aa7acba7007acba7aa7bbbaa7cc7cca77aba70001111117a00000000fffffcffffffffffffcfffff00000000
050500000505000000007a0077ddd7777dd77777777acba7007acba777777777777777777aba70007777777700000000cfffcfcffcffffcffcfcfffc00000000
0045400000454000bbbb7abb7777777777777777bb7acba7007acba7bbbba7bb7ff7ffa77aba7000aa7aaaa700000000bcffffcffbccccbffcffffcb00000000
000400000004000077777a7777777ed777777777aa7acba7007acba7bbaaa7bb7cf7cfa77aba7000bb7bbbb700000000abccccbfffbbbbfffbccccba00000000
00040000000400000000770077777dd777777777777acba7007acba7777777777aa7aaa77aba700077777777000000000abbbbffffffffffffbbbba000000000
00000000000000000000000011445000b878a7bb7aba7ba7007acba7bbbaa7bbbbbaa7bb7aba700000777700000000000abbbbffffffffffffbbbba000000000
00000000066666600000000014444000778877777aba7777007a54a777777777777777777aba7000ab7cc7ba00000000abccccbfffbbbbfffbccccba00000000
00000000656656660000000044445400b778bbbb7aba7bbb0075cb47b67bbbbbba7bb5b47a6a70007abbbba700000000bcffffcffbccccbffcffffcb00000000
00000006665565656000000044454500454b6baa7aba7aaa0075cba4aa5b5baaaa7bbb5a7ab5700077aaaa7700000000cfffcfcffcffffcffcfcfffc00000000
00000065656656566600000044445450744477777aba7777007a6ba474777577775777747aba40007c7777a700000000fffffcffffffffffffcfffff00000000
0000006656555b656500000014444440de4ee7bb7aba7bb7005acba44bbb574bb4bba7bb7ab470007b7ba7a7000000000cffffffffffffffffffffc000000000
000005654555bca456500000114454507ddd77bb7aba7aa70074b5a4b4a4a4b5bb4aa7bb7a4a70007b7ba7a70000000000ccffffffffffffffffcc0000000000
0000065554455a454560000011114500777777777aba7777004a4a4747474747747777774ab470007b7ba7a700000000000000ccffffffffcc00000000000000
00065655444444445656600011444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088000088
056565b5454444545565665014444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000008
54545bca545445455656556544445400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
454545a5654444556b45645444454540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5444545555555555bca4444544445450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444545454555454a44444414444500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444545454544444444411445000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000008
04444444444444444444444011114000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088000088
000000000000000000000000000000000000000000000000000000006060000000eee00000060600000c00c0000000000000000000000000ff00000000000000
00000000000000000000000000000000000000000000000000000000505000000eedde000065600000b0000c40000000000000000000003f1000000000000000
0000000000000000000000000000000000000000000000000000000005656500ed7dd40e044440000bbb000b0445600000000000000033210000000000000000
000000000000000000000000000000000000000000000000000000006656565044de441041555406b7bbb0ba4155550600000000000322100000000000000000
000000000000000000000000000000000000000000000000000000005056565601444101cbbbb450abbbaba0fffeedf000000000003221200000000000000000
0000000000000000000000000000000000000000000000000000000044141414001110000aaa40040aaa0ab00dddd00d000000000f32121100000000000033ff
0000000000000000000000000000000000000000000000000000000001717170000e00000005000000b000ab000e000000000000f221212110000003000f2220
00000000000000000000000000000000000000000000000000000000000000000000f00000006000000c000a0000f00000000000333322222200002000322200
000000000000000000000000000000000000000000000000000000000000000000000000000000000cccbc000000f00000000003222223333311112033222100
00000000000000000000000000000000000000000000000000000000000000000000000000000000c7bbabc0000c000000003332232233333333333322211000
0000000000000000000000000000000000000000000000000000000000000000000ff000000ef0000aaa0abc00c7c000332222f7232233333333322311100000
00000000000000000000000000000000000000000000000000000000000000000ffeef0f0ff33f090b0b00bb07c7b70c00011177322223333222221122210000
0000000000000000000000000000000000000000000000000000000000000000e7eddeede722229800c0c0cbc7b7b7b000000011111122222211112011221000
00000000000000000000000000000000000000000000000000000000000000000dd777d00ddd7780000000ca07b7a70a00000000022211111120002000112000
0000000000000000000000000000000000000000000000000000000000000000000e000d000e00080c000cba00ab700000000000003220000020000300001230
00000000000000000000000000000000000000000000000000000000000000000000f0000000f00000bbbaa0000a00000000000000033f000003000000000000
00000000000000000000000000000000000000000000000000000000000000000000009000000000000000005544000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000009800090000000000005564000000000000cc000000000007700000000000
0000000000000000000000000000000000000000000000000000000000000000099980098000ccc0000005664000000000000cbba00000000070070000000000
000000000000000000000000000000000000000000000000000000000000000099f79988000c999800005556640005500000cbbba00000000700007000000000
000000000000000000000000000000000000000000000000000000000000000099779999999999870005666555505665000aaaaaaaa00000cc00065550000000
0000000000000000000000000000000000000000000000000000000000000000899998889887888705565566666566400abbddbbddba0aa0fc00654445000066
000000000000000000000000000000000000000000000000000000000000000008878777877077705665f75666646400abf7bddbbddbadda0006545444550545
000000000000000000000000000000000000000000000000000000000000000000000890089000004565775665546400ab77bddbbddbddda00654f1444444450
000000000000000000000000000000000000000000000000000000000000000000000056560000000446556656446640aaaaa77aa77a77770044511444114150
000000000000000000000000000000000000000000000000000000000000000000044444456000000004555554004664077a77aa77a707700004455411140415
00000000000000000000000000000000000000000000000000000000000000006445555554440046000044454000044000077777777000000600041111400044
0000000000000000000000000000000000000000000000000000000000000000057f9999ccc564600000046400000000000007aa700000000055411114050000
000000000000000000000000000000000000000000000000000000000000000000558888999c4850000000560000000000000077000000000000544440000000
0000000000000000000000000000000000000000000000000000000000000000654bbbbbccc40495000000046000000000000000000000000000005110000000
00000000000000000000000000000000000000000000000000000000000000000000450004500044000000000000000000000000000000000000000551000000
00000000000000000000000000000000000000000000000000000000000000000000046000600000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000808080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000464900000000000000000000007f7f00000000000000000000000000007f7f00000000000000000000000000007f7f0000000000000000000000000000004343434343434343434343434343434340404040404040404040404040404040404040404040404040404040404040400000004c00000000000000000000004c
000065550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004300000000000000000000000000004340000000000000000000000000000040400000000000000000000000000000405e4c5c6d5e4c00000000000000005c6d
0000654a4900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004370000000000000000000000000704340000000000000000000000000000040400000000000000000000000000000404f5d6d5d4e4f5e00004c0000006c5d4e
000065676900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004300000000000000000000000070704340000000000000000000000000000040400000000000000000000000000000406e4d4d6c5d5e4d005c5d5e4c00004d6c
00464748474900000000000000000000000000000000000000000000000000000000004647474900000000000000000000000000000000000000000000000000430000000000000000000000007070434000000000000000000000000000004040000000000000000000000000000040000000004d4d0000006c4e4f5e000000
00665757575946474900000000000000000000000000000000000000000000000000005657585900000000000000000000000000000000000000000000000000430000000000000000000000007070434000000000000000000000000000004040000000000000000000000000000040000000000000000000004d4d00000000
0056575857696558550000000000000000000000000046490000000000000000000000566757590000000000000000000000000000000000000000000000000043700000000000000000000000707043400000000000000000000000000000404000000000000000000000000000004000000000000000000000000000000000
00566858574a656455000000000000000000000000464748474946484900000000004647485a690000000000000000000000000000000000000000000000000043700000000000000000000000007043400000000000000000000000000000404000000000000000000000000000004000000000000000004c00000000000000
0056574757644a484749000000000000000000000056575868655567690000000000565768574a47484849000000000000000000000000000000000000000000437000000000000000000000000000434000000000000000000000000000004040000000000000000000000000000040000000000000005c6d5e4c4c00000000
006657685765575757590000000000000000000000565747574a474848490000000056575857575757685900000000000000000000000000000000000000000043700000000000000000000000000043400000000000000000000000000000404000000000000000000000000000004000000000005c5e5c5d6d4e4f5e000000
00565757576568584559000000606162000000000056575857455758575960616200565758574557585759000000000000606162000000000000000000000000437000000000000000000000000000434000000000000000000000000000004040000000000000000000000000000040000000005c5d6e006c5d6e4d00000000
5266686467656467446900505270717252606250516668476744644867697071725266674857446448676900500060616270717200000000000000000000000043700000000000000000000000707043400000000000000000000000000000404000000000000000000000000000004000000000004d0000004d000000000000
4140404142424240424140404140404041404040424040404040414240404041404240404041404041404040404042404041404042000000000000000000000043700000000000000000000000707043400000000000000000000000000000404000000000000000000000000000004000000000000000000000000000000000
4343434343434343434354434343434343434343434354434343434343434343434343434343434343544343434343434343434343000000000000000000000043000000000000000000000000007043400000000000000000000000000000404000000000000000000000000000004000000000000000000000000000000000
4343434343434343434343434343435343434343434343434343434354434343434343434343434343434343544343434343534343000000000000000000000043000000000000000000000000007043400000000000000000000000000000404000000000000000000000000000004000000000000000000000000000000000
4343534343434343434343544343434343434343434343435343434343434343434343434343435443434343434343544343434343000000000000000000000043434343434343434343434343434343404040404040404040404040404040404040404040404040404040404040404000000000000000000000000000000000
7474747474747474747474747474747457575757575757575757575757575757575757575757575757575757575757574343434343434343434343434343434357575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757
7400000000000000000000000000007457000000000000000000000000000057000000000000000000000000000000574370000000000000000000000000704357000000000000000000000000000057000000000000000000000000000000575700000000000000000000000000005700000000000000000000000098000057
74000000000000000000000000000074570000000000000000000000000000005700000000000000000000000000005743707000000000000000000000707043570000000000000000000000000000005700000000000000000000000000005757000000000000009b0000000000000057a8a900000000000000000000000057
74000000000000000000000000000074570000000000000000000000000000570000000000000000000000000000005743707000000000000000000000707043570000000000000000000000000000570000000000000000000000000000005757990000000000000000008b0000005700000000000000000000000000008b57
740000000000000000000000000000745700000000000000000000000000000057000000000000000000000000000057437070000000000000000000000070435700000000000000000000000000000057000000000000000000000000000057570000000000000000000000000000005700000000000000008b000000000057
740000000000000000000000000000745700000016160016001600001616001616160000000000000000000000000057437000000000000000000000000000435700000000000000000000000000005700000000000000000000000000000057570000008b000000000000000000005700000000000000000000000000000057
740000000000000000000000000000745700001600000016001600160016001600160000000000000000000000000057430000000000000000000000000000435700000000000000000000000000000057000000000000000000000000000057570000000000000000000000008b00005700000000009a00008a000000000057
7400000000000000000000000000007457000016161600161616001600160016161600000000000000000000000000574300000000000000000000000000004357000000000000000000000000000057000000000000000000000000000000575700000000000000a8a900000000005700000000000000000000000000000057
7400000000000000000000000000007457000000001600160016001600160016570000000000000000000000000000574370000000000000000000000000004357000000000000000000000000000000570000000000000000000000000000575700000000000000000000000000000057009b00000000000000000000008857
74000000000000000000000000000074570000161600001600160016160000160000000000000000000000000000005743700000000000000000000000707043570000000000000000000000000000570000000000000000000000000000005757000000009a0000000000000000005700000000000000009a00009800000057
740000000000000000000000000000745700000000000000000000000000000057000000000000000000000000000057437070000000000000000000707070435700000000000000000000000000000f5700000000000000000000000000005757000000000000000000009a0000000057000000000000000000000000000057
74000000000000000000000000000074570000000000000000000000000000570000000000000000000000000000005743707000000000000000000070707043570000090000000d0e000a0b00000f1f00000000000000000000000000000057570000000000000000000000000000570000000000008b000000000000000057
74000000000000000000000000000074570000000000000000000000000000005700000000000000000000000000005743707000000000000000000070707043570000190607001d1e001a1b000c1f0f57000000000000000000000000000057578800000000000000008b000000000057000000000000000000000000000057
740000000000000000000000000000745700000000000000000000000000005700000000000000000000000000000057437070000000000000000000000070432424242424242424242424242424242400000000000000000000000000000057570000000000990000000000000000570000000000000000000000009b000057
7400000000000000000000000000007457000000000000000000000000000000570000000000000000000000000000574370000000000000000000000000004324242424242424242424242424242424570000000000000000000000000000575700000000000000000000008700000057000000008800000000000000000057
7474747474747474747474747474747457575757575757575757575757575757575757575757575757575757575757574343434343434343434343434343434323232323232323232323232323232323575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757
__sfx__
00010000100501005011050120501305016050170501a0501e0502405000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
