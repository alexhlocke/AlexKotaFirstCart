pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--fishing game 🐱 
--by alex & kota
-------------------------------

function _init()
 cam={x=0,y=0}
 
 --muffle music
 music(2)
 poke(0x5f41, 15)
 poke(0x5f43, 15)

 --set color palette
 reset_pal()
 --shortcuts to make it easier
	--to reset pal
	p=pal
	rp=reset_pal

 init_reeling()

 --create fish arcetypes
 init_fish()
 
 --set up interactalbes
 --init_interactables()
 
 --set update/draw
 --_upd=update_game
 --_drw=draw_game
 
 --debug
	--add show debug menu item
	menuitem(1,"debug on/off",function()show_debug = not show_debug end)
end


function _update()
	update_reeling()
 
 shake()
end


function _draw()
 cls(2)
 map()
 
 --draw minigame
 if(draw_reeling_mg)then
	 draw_reeling()
 end
 
 if(show_debug)then
	 print_debug()
	 draw_hboxs()
 end
 
 if(t()<6)then
		bprint("rEELING mINIGAME pROTOTYPE V2.1",1,1,15,1)
		bprint("cTRL+r TO rESET",1,8,14,1)
		bprint("cONTROL WITH o/x + ⬆️⬇️⬅️➡️",19,121,15,0)
 end
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
function osspr(c, sx, sy, sw, sh, dx, dy, dw, dh, flip_x, flip_y)
	w = w or 1
	h = h or 1
	
	flip_x = flip_x or false
	flip_y = flip_y or false
	
	pal({[0]=c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c}, 0)
	
	sspr(sx,sy,sw,sh,dx-1,dy,dw,dh,flip_x,flip_y)
	sspr(sx,sy,sw,sh,dx,dy-1,dw,dh,flip_x,flip_y)
	sspr(sx,sy,sw,sh,dx+1,dy,dw,dh,flip_x,flip_y)
	sspr(sx,sy,sw,sh,dx,dy+1,dw,dh,flip_x,flip_y)
	
	pal(0)
	
	sspr(sx,sy,sw,sh,dx,dy,dw,dh,flip_x,flip_y)
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
 
-- for i in all(enemies) do
--  local hb=i.hbox
--  fillp(▒)
--  rect(hb.x1,hb.y1,hb.x2,hb.y2,8)
--  fillp()
-- end
-- 
-- local hb=mg_fish.hbox
-- fillp(▒)
-- rect(hb.x1,hb.y1,hb.x2,hb.y2,8)
-- fillp()
end




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
-- reeling 
--============================--


function init_reeling()
 do_reeling_mg=true
 draw_reeling_mg=true
 reel_fish_caught=false
 reeling_mg_complete=false
 
 end_countdown=30
end


fish_sound=false
function update_reeling()
 if(not do_reeling_mg)then
  end_countdown-=1
  
  if(end_countdown==0)then
   reel_success2()
  end
 else
 
	 update_wheel()
	 
	 update_reelfish()
	 
	 update_reel_meter()
	 
	  --!! this is temporary and
	 --should be replaced with
	 --proper hitboxes 
	 
	 if(get_distance(reelfish,wpt1)<10
	  or get_distance(reelfish,wpt2)<10)then
	  
	  --print ! above fish
	  show_wow=true
	  
	  --update meter
	  reel_meter+=reel_bonus
	  
	  --manage audio
	  if(not fish_sound)then
	   sfx(45,3)
	   fish_sound=true
	  end
	  
	  if(reel_meter>reel_meter_max)then
	   debug[10]="fish caught!"
	   reel_meter=reel_meter_max
	   reel_success()
	  end
	 else
	  sfx(-1,3)
	  fish_sound=false
	  show_wow=false
	 end
	 
	 debug[1]=get_distance(reelfish,{x=63,y=63})
 end
end


function draw_reeling()
 draw_wheel()
 
 draw_reelfish()
 
 draw_reel_meter()
 
 if(reel_fish_caught)then
  draw_fish_got(uh_um_fish)
 end
end


--== wheel menu ==-----------------

wheel={
  angle=0
 ,spin_rate=.007
 ,retract_rate=.01
 ,radius=10
 ,grow_rate=1
 ,max_r=60
 ,min_r=12
}
wpt1={
 angle=0
 ,x=0,y=0
}
wpt2={
 angle=0.5
 ,x=0,y=0
}

reel_sound=false
function update_wheel()
 --rotate wheel
 if(btn(❎))then
  wheel.angle-=wheel.spin_rate
  if(not reel_sound)then
   sfx(46,2)
   reel_sound=true
  end
 elseif(btn(🅾️))then
  wheel.angle+=wheel.spin_rate
  if(not reel_sound)then
   sfx(47,2)
   reel_sound=true
  end
 else
  sfx(-1,2)
  reel_sound=false
 end
 
 --change wheel radius
 if(btn(⬅️)or btn(⬇️))then
  wheel.radius-=wheel.grow_rate
  if(wheel.radius<wheel.min_r)wheel.radius=wheel.min_r
 end
 if(btn(➡️)or btn(⬆️))then
  wheel.radius+=wheel.grow_rate
  if(wheel.radius>wheel.max_r)wheel.radius=wheel.max_r
 end
end


function draw_wheel()
 xp=cam.x+63
 yp=cam.y+63
 
 --draw outer/inner limit circs
 fillp(▒)
 circ(xp,yp,wheel.min_r,3)
 circ(xp,yp,wheel.max_r,3)
 fillp()
 
 --draw actual wheel
 circ(xp,yp,wheel.radius,15)
 
 --draw points
 wpt1.y=yp+wheel.radius*sin(wheel.angle+wpt1.angle)
 wpt2.y=yp+wheel.radius*sin(wheel.angle+wpt2.angle)
 wpt1.x=xp+wheel.radius*cos(wheel.angle+wpt1.angle)
 wpt2.x=xp+wheel.radius*cos(wheel.angle+wpt2.angle)
 circfill(wpt1.x,wpt1.y,4,6)
 circfill(wpt2.x,wpt2.y,4,6)
 circ(wpt1.x,wpt1.y,4,5)
 circ(wpt2.x,wpt2.y,4,5)
end


--== reeling fish ==------------


reelfish={
 x=63
 ,y=63
 ,rad=45
}


function update_reelfish()
 reelfish.x=cam.x+63+reelfish.rad*cos(t()/5)
 reelfish.y=cam.y+63+reelfish.rad*sin(t()/13)
end


function draw_reelfish()
 --ospr(3,128,reelfish.x,reelfish.y,2,1,false,false)
 circfill(reelfish.x,reelfish.y,4,9)
 circ(reelfish.x,reelfish.y,4,8)

 if(show_wow)bprint("!",reelfish.x+5,reelfish.y-8,8,0)
end


--== reeling meter ==------------


reel_meter_max=40
reel_meter=20
reel_rate=0.1
reel_bonus=0.3

function update_reel_meter()
 --update reel meter
 reel_meter-=reel_rate
  
 --if reel meter <= 0 end
 if(reel_meter<=0) then
  --end minigame
  reel_meter=0
 end
end


function draw_reel_meter()
 local bottom_y=cam.y+123
 rect(5,bottom_y-reel_meter_max,9,bottom_y,5)
 rectfill(6,bottom_y-reel_meter,8,bottom_y,6)
end


--== other helpers ==------------


--win function--
function reel_success()
 do_reeling_mg=false
 sfx(-1,2)
 sfx(-1,3)
 
 music(-1)
 
 shake_i=15
 
 uh_um_fish=rnd(fishes)
end

function reel_success2()
 music(32)

 reel_fish_caught=true
end


--get distance between 2 tables
function get_distance(point1,point2)
 local dx=point2.x-point1.x
 local dy=point2.y-point1.y
 return sqrt(dx*dx+dy*dy)
end


--wait function
function wait(frames) 
 for i = 1,frames do 
  flip() 
 end 
end


--screenshake--
shake_i=0
function shake()
 local shake_x=rnd(shake_i)-(shake_i/2)
 local shake_y=rnd(shake_i)-(shake_i/2)

 --offset the camera
 camera(cam.x+shake_x,cam.y+shake_y)

 --ease shake and return to normal
 shake_i*=.7
 if shake_i<.3 then 
  shake_i=0 
 end
end
-->8
--spawners

--spawning
spawners={}
function make_spawner(id,make_func,make_func_params,rate,range)
 local s={
  id=id,init_rate=rate,rate=rate
  ,range=range or 0
  ,make_func=make_func or function()print("spawner err no make_func")end
  ,make_func_params=make_func_params
  ,f=1
  ,update=function(s)
   s.f+=1
   if(s.f>s.rate) then
    s.make_func(s.make_func_params)
    s.f=1
    s.rate=s.init_rate+rnd(s.range)-(s.range/2)
   end
  end
 }
 add(spawners,s)
end

function update_spawners()
 for s in all(spawners) do 
  s.update(s)
 end
end 
-->8
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
-- fish=find_fish(160)
-- fish.shiny=true
 
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



__gfx__
0077000000770000000077000000770000000770000000000000777777770000eeeeeeee000000000eeeeeeeeeeeeee0066065000050500089230000bbbbbbbb
07cb700007bc70000007cc700007cc7000007cc7000000000007888888887000ecb5bc5d09f0f9000e333333333333d0005550000005000089235660b452377b
07ccb7777bcc70000007cb700007cb7000007cb7000000000078899889988700ebbbbb5d089f98000e336333333353d00404040000ddd00088225550b452377b
07bbbbbbbbbb700000007b700007b7000007bb70000000009978899889988799eb7b7b5d089998000e365533333544d0004440007777777777777777b452377b
77bbb7bbb7bb770000007bb70007b7000007b700000000008878888888888788e5bcb55d008980000e3373333b3373d007aaa7007accccc77ccccca7b442277b
07bbb7bbb7bb7000000007b70007bb770007bb77000000007799999999999977e4aaa44d500800500e337333313373d007baa7007abbbbb77bbbbba7baaaaaab
77bbbbbcbbbb7700000007bb000077bb000077bb000000000778888888888777dddddddd450605400e665666656656d007bbb7007abbbbb77bbbbba7bde7777b
007bbbbbbbb7000000000077000000770000007700000000077777777777777000000000045654000eddddddddddddd0007770007abbffb77bffbba7bde7777b
0007aaaaaa7000000000777bbbbb70000000777bbbbb700000000000000000000077770000040000cccccccccccccccc000006507abbccb77bccbba7bde9998b
007bbbbbbb7000000007cccbbbbbb7000007cccbbbbb700000000000000000000788887001233300bbbbbbbbbbbbbbbb060050057abbbbb77bbbbba7bdd8888b
07bbabbbb70000000007bbbaaaabab700007bbbaaabb700000000000000000000789987001233300bbbbbbbbbbbbbbbb005006057abbbbb77bbbbba7baaaaaab
07babbbbb7000000007b7ba7777a7ab70007bba777ab7000eeeee0007700000099899899012333007777777777777777005000047abbbbb77bbbbba7b567777b
07bbb77bb770000007ba7b7007a707a70007ba707a7a7000ddddd0070070000088777788012233000aa0000000000aa0050060407abbbbb77bbbbba7b567777b
07ab7bc7bbc7000007a77a7007a70070007ba7007a7ab700d7d7d7700455000079999997012233000ab0000000000ab0005454007aaaaaa77aaaaaa7b567777b
07aaaaa7aaa7000000707aa707aa7000007a7a70077ab700ddddd0004606500078888887011222000ab0000000000ab00baaaab07777777777777777b557777b
007777707770000000000777007770000007777000077000777770005000500007777770011111000ab0000000000ab00077770000aaa000000aaa00baaaaaab
3ffffffffffffffffffffff3bbbbbbbb003333000000003200000065000000980cccccccccccccc000dffd0000000000000e000000000300cccccccc0000ddd0
231111111111111111111132bbbbbbbb03211230000003200000065000000980cbbbbbbbbbbbbba700dfed0000ddd00000ded00000123000bbbbbbbb000d000d
213333333333333333333312bbbbbbbb32111123000032000000650000009800cbbbbbbbbbbbbba700dfed000fdedf0000d0d0000b222000bbbbbbbb000d000d
213333333333333333333312aaaaaaaa31111113000320000006500000098000cbbbbbbbbbbbbba700dffd00defffed000ded0000045600077777777000d000d
2133f3333333333333333312aaaaaaaa31111113002100000054000000870000cbbbbbbbbbbbbba700defd007deeed70000e000000445600000000000000ddd0
213f333333333333333333127777777731111113021000000540000008700000cbbbbbbbbbbbbba700defd007fdddf7000ded0000044560000000000000000d0
213f33333333333333333312777777772111111221e0000054e0000087e00000caaaaaaaaaaaaaa700defd007e7f7e7000d0d0000004456000000000000000d0
213f333333333333333333127777777721111112100000004000000070000000077777777777777000dffd007e7e7e7000ded0000000b00600000000000000dd
213f33333333333333333312bcccccca2222222200000000030206050000000000effe00213f3333eeeeeeeeeeeeeeee000e00000cccccc03333331200f0000d
213f33333333333333333312cabbbb7c21111112009880000030005000998800099ee890213f3333effffffeeffffffe00e0e00007bbbb70333333120ee0000d
213f33333333333333333312cbabb7ac311111130fffff007221f54700700700f870078f213f3333ef7ff7feeffffffe0e000e00007aac0033333312dd00000d
2133f3333333333333333312cbba7aac31111113fffffed07721d47707000070fe0000ef213f3333ef7777edef7ff7ede00600e0007aa60033333312dd00000d
213333333333333333333312cbb7baac311111139ffeed807c7777a789999998d970078d213f3333efeeeeedefffffede05460e0007a5c0033333312d000000d
213333333333333333333312cb7aabac3111111389ddd8707b7ba7a798888887088dd890213f3333deeeeeeddeeeeeedabbbba70007a4c0033333312d10000dd
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
0000000000000000000000007777777777777777bb7acba7007acba7baaaa7bb777777777aba70003333322111111110000000ccffffffffc000000000000000
0090900000c0c00000007a007777777777777777777acba7007acba7777777777ff7ffa77aba7000222222111111110000ccccfffffffffffccccc0000000000
0089900000acc000bbbb7abb77edd77777777777bb7acba7007acba7ba7bbbbb7cf7cfa77aba700011111117111110000cffffffffffffffffffffc000000000
0088900000aac00077777a7777ddd7777ed77777aa7acba7007acba7aa7bbbaa7cc7cca77aba70001111117a11110000fffffcffffffffffffcfffff00000000
050500000505000000007a0077ddd7777dd77777777acba7007acba777777777777777777aba70007777777711100000cfffcfcffcffffcffcfcfffc00000000
0045400000454000bbbb7abb7777777777777777bb7acba7007acba7bbbba7bb7ff7ffa77aba7000aa7aaaa711100000bcffffcffbccccbffcffffcb00000000
000400000004000077777a7777777ed777777777aa7acba7007acba7bbaaa7bb7cf7cfa77aba7000bb7bbbb711000000abccccbfffbbbbfffbccccba00000000
00040000000400000000770077777dd777777777777acba7007acba7777777777aa7aaa77aba700077777777110000000abbbbffffffffffffbbbba000000000
00000000000000000000000009090000b878a7bb7aba7ba7007acba7bbbaa7bbbbbaa7bb7aba700000777700111111110abbbbffffffffffffbbbba0aaabbbba
00000000066666600000000080008000778877777aba7777007a54a777777777777777777aba7000ab7cc7ba01111110abccccbfffbbbbfffbccccbaabbb7ebb
00000000656656660000000008080009b778bbbb7aba7bbb0075cb47b67bbbbbba7bb5b47a6a70007abbbba700111110bcffffcffbccccbffcffffcbbbb7afbb
00000006665565656000000000880880454b6baa7aba7aaa0075cba4aa5b5baaaa7bbb5a7ab5700077aaaa7700011100cfffcfcffcffffcffcfcfffcbb7abfbb
00000065656656566600000090088009744477777aba7777007a6ba474777577775777747aba40007c7777a700011100fffffcffffffffffffcfffffb7abb8bb
0000006656555b656500000008880000de4ee7bb7aba7bb7005acba44bbb574bb4bba7bb7ab470007b7ba7a7000110000cffffffffffffffffffffc0bbbbbbbc
000005654555bca456500000800800007ddd77bb7aba7aa70074b5a4b4a4a4b5bb4aa7bb7a4a70007b7ba7a70001100000ccffffffffffffffffcc00000ab000
0000065554455a454560000000080000777777777aba7777004a4a4747474747747777774ab470007b7ba7a700001000000000ccffffffffcc000000000ab000
0006565544444444565660000011110000060000000000000000000000c111000000000000000000000000007777777700000111111111111100000088000088
056565b5454444545565665001111110005000000030030000600060c7b1c1100011110001100000000110007bcccbb700001111111111111110000080000008
54545bca545445455656556511111111000400000300300000050600bcbcb1110111111011110000001111007aaaaaa700011111111111111111000000000000
454545a5654444556b45645411111111004111000030030000500050ababa1110111111011110000001111007777777700011111111111111111000000000000
5444545555555555bca4444511111111001111100003001005006005ababa1110111111001100000000110000000000000011111111111111111000000000000
44444545454555454a444444011111100011111000100100040005047a1a11110111111000000100000000000000000000011111111111111111000000000000
44444444545454544444444400111100001111100100100000404004011111100011110000001110000000000000000000001111111111111111000080000008
04444444444444444444444000000000000111000010010004004040001111000000000000000100000000000000000000000111111111111110000088000088
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
66666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
66666ff6666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
66666fff666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
66666fff666666666666666666666666fff666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
666666ff66666666666666666666666ffff6666666666fffff666666000000000000000000000000000000000000000000000000000000000000000000000000
666666ff6666666666fffffff66666fff66666666666ffffff666666000000000000000000000000000000000000000000000000000000000000000000000000
666666fff66666666fffffffff666fff66666666666ffff6fff66666000000000000000000000000000000000000000000000000000000000000000000000000
6666666fff6666666fff6666ff666ff666666666666fff66fff66666000000000000000000000000000000000000000000000000000000000000000000000000
66666666ff666666fff66666ff666ff66666ffff66fff666fff66666000000000000000000000000000000000000000000000000000000000000000000000000
66666666ff666666ff666666ff666ff66666ffff66ff6666ff666666000000000000000000000000000000000000000000000000000000000000000000000000
66666666ff66666fff666666ff666ff66666fff666ff6666ff666666000000000000000000000000000000000000000000000000000000000000000000000000
66666666ff66666ff6666666ff666fff66666ff666ff6666ff666666000000000000000000000000000000000000000000000000000000000000000000000000
66666666fff6666ff6666666ff6666ff66666ff666ff6666ff666666000000000000000000000000000000000000000000000000000000000000000000000000
666666666ff6ff6ff666666fff6666fff6666ff666fff66fff666666000000000000000000000000000000000000000000000000000000000000000000000000
666666666fffff6fff66666ff666666fff66fff6666fff6ff6666666000000000000000000000000000000000000000000000000000000000000000000000000
666666666ffff666ff6666fff6666666ffffff66666ffffff6666666000000000000000000000000000000000000000000000000000000000000000000000000
666666666ff66666ffffffff666666666ffff66666666ffff6666666000000000000000000000000000000000000000000000000000000000000000000000000
6666666666666666fffffff666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000
__label__
1111111111ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
11111111111sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
111111111111ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
111111111111ssssssssssssssssssssssssssssssssssssssssssssscscscscscscscssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
111111111111sssssssssssssssssssssssssssssssssssssscscscssssssssssssssssscscscsssssssssssssssssssssssssssssssssssssssssssssssssss
111111111111ssssssssssssssssssssssssssssssssssscscssssssssssssssssssssssssssscscssssssssssssssssssssssssssssssssssssssssssssssss
111111111111sssssssssssssssssssssssssssssssscssssssssssssssssssssssssssssssssssssscsssssssssssssssssssssssssssssssssssssssssssss
11111111111sssssssssssssssssssssssssssssscssssssssssssssssssssssssssssssssssssssssssscssssssssssssssssssssssssssssssssssssssssss
1111111111sssssssssssssssssssssssssssscscssssssssssssssssssssssssssssssssssssssssssssscscsssssssssssssssssssssssssssssssssssssss
1111111111ssssssssrsssrsssssssssssssscssssssssssssssssssssssssssssssssssssssssssssssssssscssssssssssssssssssssssssssssssssssssss
11111111111ssssssss3srsssssssssssscssssssssssssssssssssssssssssssssssssssssssssssssssssssssscsssssssssssssssssssssssssssssssssss
11111111111sssssss3sss3sssssssssscssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscssssssssssssssssssssssssssssssssss
111111111111sssss3ssrss3sssssssscssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscsssssssssssssssssssssssssssssssss
1111111111111ssssjsss3sjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
11111111111111ssssjsjssjsssscssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscsssssssssssssssssssssssssssss
111111111111111ssjssjsjsssscssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscssssssssssssssssssssssssssss
11111111111111111111111111cssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscsssssssssssssssssssssssssss
1111111111111111111111111c1sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscssssssssssssssssssssssssss
1111111111111111111111111111ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
1111111111111111111111111111ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
1111111111111111111111111111ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
1111111111111111111111111111ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
1111111111111111111111111111ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
111111111111111111111111111sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
11111111111111111111111sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
11111111111111111c1111ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscssssssssssssssssss
1111111111111111c1111ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscsssssssssssssssss
111111111111111c1111ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscssssssssssssssss
11111111111111c1111ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscsssssssssssssss
1111111111111111111sssssssssssssssssssssssssssssssssssssss77777777777sssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
111111111111111111ssssssssssssssssssssssssssssssssssss7777sssssssssss7777sssssssssssssssssssssssssssssssssssssssssssssssssssssss
111111111111111111sssssssssssssssssssssssssssssssss777sssssssssssssssssss777ssssssssssssssssssssssssssssssssssssssssssssssssssss
111111111111c111ssssssssssssssssssssssssssssssss777essssssssssssssssssssssss777ssssssssssssssssssssssssssssssssssscsssssssssssss
11111111111c1111sssssssssssssssssssssssssss11ss7osssossssssssssssssssssssssssss7ssss333sssssssssssssssssssssssssssscssssssssssss
1111111111c11111ssssssssssssssssssssssssss11177ssososssessssssssssssssssssssssss7733rrr33ssssssssssssssssssssssssssscsssssssssss
1111111111111111ssssssssssssssssssssssssss1171ssssoosoosssssssssssssssssssssssssss3rrrrr3sssssssssssssssssssssssssssssssssssssss
1111111111111111ssssssssssssssssssssssssss771sssessoossesssssssssssssssssssssssss3rrrrrrr3ssssssssssssssssssssssssssssssssssssss
111111111c111111sssssssssssssssssssssssss7sssssssooosssssssssssssssssssssssssssss3rrrrrrr3ssssssssssssssssssssssssssscssssssssss
11111111c1111111ssssssssssssssssssssssss7sssssssossosssssssssssssssssssssssssssss3rrrrrrr3sssssssssssssssssssssssssssscsssssssss
1111111111111111sssssssssssssssssssssss7sssssssssssossssssssssssssssssssssssssssss3rrrrr3sssssssssssssssssssssssssssssssssssssss
11111111c1111111ssssssssssssssssssssss7ssssss1111111111111ssssssssssssssssssssssss33rrr33ssssssssssssssssssssssssssssscsssssssss
1111111c11111111sssssssssssssssssssss7ssssss111111111111111sssssssssssssssssssssssss333ss7ssssssssssssssssssssssssssssscssssssss
1111111111111111ssssssssssssssssssss7ssssss11111111111111111ssssssssssssssssssssssssssssss7sssssssssssssssssssssssssssssssssssss
1111111111111111ssssssssssssssssssss7ssssss11111111111111111ssssssssssssssssssssssssssssss7sssssssssssssssssssssssssssssssssssss
111111c111111111sssssssssssssssssss7sssssss11111111111111111sssssssssssssssssssssssssssssss7sssssssssssssssssssssssssssscsssssss
1111111111111111ssssssssssssssssss7ssssssss11111111111111111ssssssssssssssssssssssssssssssss7sssssssssssssssssssssssssssssssssss
1111111111111111ssssssssssssssssss7sssssssss1111111111111111ssssssssssssssssssssssssssssssss7sssssssssssssssssssssssssssssssssss
11111c1111111111sssssssssssssssss7sssssssssss11111111111111ssssssssssssssssssssssssssssssssss7ssssssssssssssssssssssssssscssssss
1111111111111111ssssssssssssssss7ssrssssssssssss11111111ssssssssssssssssssssssssssssssssssssss7sssssssssssssssssssssssssssssssss
11111c1111111111ssssssssssssssss7s3ssssssssssssss111111sssssssssssssssssssssssssssssssssssssss7sssssssssssssssssssssssssscssssss
1111c11111111111ssssssssssssssss7ssjssssssssssssss11111sssssssssssssssssssssssssssssssssssssss7ssssssssssssssssssssssssssscsssss
1111111111111111sssssssssssssss7ssj111sssssssssssss111ssssssscscscsssssssssssssssssssssssssssss7ssssssssssssssssssssssssssssssss
1111c11111111111sssssssssssssss7ss11111ssssssssssss111sssscssssssssscssssssssssssssssssssssssss7sssssssssssssssssssssssssscsssss
1111111111111111sssssssssssssss7ss11111ssssssssssss11sssscssssssssssscsssssssssssssssssssssssss7ssssssssssssssssssssssssssssssss
1111c11111111111ssssssssssssss7sss11111ssssssssssss11sssssssssssssssssssssssssssssssssssssssssss7ssssssssssssssssssssssssscsssss
1111111111111111ssssssssssssss7ssss111ssssssssssssss1sssssssssssssssssssssssssssssssssssssssssss7sssssssssssssssssssssssssssssss
111111111111111sssssssssssssss7sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss7sssssssssssssssssssssssssssssss
111c1111111111ssssssssssssssss7sssssssssssssssssssssscssssssssssssssssssscssssssssssssssssssssss7sssssssssssssssssssssssssscssss
1111111111111ssssssssssssssss7sssssssssssssssssssssscssssssssssssssssssssscssssssssssssssssssssss7ssssssssssssssssssssssssssssss
111c11111111sssssssssssssssss7sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss7ssssssssssssssssssssssssscssss
11111111111ssssssssssssssssss7sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss7ssssssssssssssssssssssssssssss
111c1111111ssssssssssssssssss7ssssssssssssssssssssscssssssssssssssssssssssscsssssssssssssssssssss7ssssssssssssssssssssssssscssss
1111111111sssssssssssssssssss7sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss7ssssssssssssssssssssssssssssss
111c111111sssssssssssssssssss7ssssssssssssssssssssscssssssssssssssssssssssscsssssssssssssssssssss7ssssssssssssssssssssssssscssss
11111111sssssssssssssssssssss7ssssssssssssssssssssssssssssssssssssf111sssssssssssssssssssssssssss7ssssssssssssssssssssssssssssss
111c1111ssssssssssssssssssrss7rsssssssssssssssssssscssssssssssssfiv1f11sssscsssssscsscsssssssssss7ssssssssssssssssssssssssscssss
11111111sssssssssssssssssss3s7ssssssssssssssssssssssssssssssssssvfvfv111ssssssssscsscssssssssssss7ssssssssssssssssssssssssssssss
111c1111ssssssssssssssssss3ss73sssssssssssssssssssssssssssssssssuvuvu111sssssssssscsscsssssssssss7ssssssssssssssssssssssssscssss
11111111sssssssssssssssss3ssr7s3sssssssssssssssssssscsssssssssssuvuvu111sscsssssssscss1ssssssssss7ssssssssssssssssssssssssssssss
111c1111sssssssssssssssssjsss37jssssssssssssssssssssscssssssssssiu1u1111scssssssss1ss1ssssssssss7sssssssssssssssssssssssssscssss
11111111ssssssssssssssssssjsjs7jsssssssssssssssssssssssssssssssss111111ssssssssss1ss1sssssssssss7sssssssssssssssssssssssssssssss
11111111sssssssssssssssssjssjs7sssssssssssssssssssssssssssssssssss1111ssssssssssss1ss1ssssssssss7sssssssssssssssssssssssssssssss
1111c11111ssssssssssssssss11117ssssssssssssssssssssssssssssssssssssssssssssss1111111111111ssssss7ssssssssssssssssssssssssscsssss
1111111111sssssssssssssss1111117ssssssssssssssssssssssssscssssssssssscssssss111111111111111ssss7ssssssssssssssssssssssssssssssss
1111c111111sssssssssssss11111117sssssssssssssssssssssssssscssssssssscssssss11111111111111111sss7sssssssssssssssssssssssssscsssss
11111111111sssssssssssss11111117ssssssssssssssssssssssssssssscscscsssssssss11111111111111111sss7ssssssssssssssssssssssssssssssss
1111c1111111ssssssssssss111111117ssssssssssssssssssssssssssssssssssssssssss11111111111111111ss7ssssssssssssssssssssssssssscsssss
11111c1111111ssssssssssss111111s7ssssssssssssssssssssssssssssssssssssssssss11111111111111111ss7sssssssssssssssssssssssssscssssss
11111111111111ssssssssssss1111ss7sssssssssssssssssssssssssssssssssssssssssss1111111111111111ss7sssssssssssssssssssssssssssssssss
11111c111111111ssssssssssssssssss7sssssssssssssssssssssssssssssssssssssssssss11111111111111ss7ssssssssssssssssssssssssssscssssss
1111111111111111ssssssssssssssssss7sssssssssssssssssssssssssssssssssssssssssssssssssssssssss7sssssssssssssssssssssssssssssssssss
1111111111111111ssssssssssssssssss7111sss11sssssssssssssssssssssssssssssssssssssssssssssssss7sssssssssssssssssssssssssssssssssss
111111c111111111sssssssssssssssss117111s1111sssssssssssssssssssssssssssssssssssssssssssssss7sssssssssssssssssssssssssssscsssssss
1111133333111111sssssssssssssssss111711s1111ssssssssssssssssssssssssssssssssssssssssssssss7sssssssssssssssssssssssssssssssssssss
1111131113111111sssssssssssssssss1117113331sssssssssssssssssssssssssssssssssssssssssssssss7sssssssssssssssssssssssssssssssssssss
1111131c13111111sssssssssssssssss111133rrr33s1sssssssssssssssssssssssssssssssssssssssssss7ssssssssssssssssssssssssssssscssssssss
11111311c3111111ssssssssssssssssss1113rrrrr3111sssssssssssssssssssssssssssssssssssssssss7ssssssssssssssssssssssssssssscsssssssss
1111131113111111ssssssssssssssssssss3rrrrrrr31sssssssssssssssssssssssssssssssssssssssss7ssssssssssssssssssssssssssssssssssssssss
11111311c311111sssssssssssssssssssss3rrrrrrr3sssssssssssssssssssssssssssssssssssssssss7ssssssssssssssssssssssssssssssscsssssssss
11111311131111ssssssssssssssssssssss3rrrrrrr3ssssssssssssssssssssssssssssssssssssssss7ssssssssssssssssssssssssssssssscssssssssss
1111131113111ssssssssssssssssssssssss3rrrrr3sssssssssssssssssssssssssssssssssssssss77sssssssssssssssssssssssssssssssssssssssssss
111113111311sssssssssssssssssssssssss33rrr337sssssssssssssssssssssssssssssssssssss7sssssssssssssssssssssssssssssssssssssssssssss
1111131113cssssssssssssssssssssssssssss333sss77sssssssssssssssssssssssssssssssss77sssssssssssssssssssssssssssssssssscsssssssssss
11111311131csssssssssssssssssssssssssssssssssss7sssssssssssssssssssssssssssssss7ssssssssssssssssssssssssssssssssssscssssssssssss
1111131113sscsssssssssssssssssssssssssssssssssss777sssssssssssssssssssssssss777ssssssssssssssssssssssssssssssssssscsssssssssssss
1111131113sssssssssssssssssssssssssssssssssssssssss777sssssssssssssssssss777ssssssssssssssssssssssssssssssssssssssssssssssssssss
1111131113ssssssssssssssssssssssssssssssssssssssssssss7777sssssssssss7777sssssssssssssssssssssssssssssssssssssssssssssssssssssss
1111131113ssssssssrsssrsssssssssssssssssssssssssssssssssss77777777777sssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
11111311131ssscssss3srsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscsssssssssssssss
11111311131sssscss3sss3sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscssssssssssssssss
111113111311ssssc3ssrss3sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscsssssssssssssssss
1111131113111sssscsss3sjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscssssssssssssssssss
11111311131111ssssjsjssjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
111113111311111ssjssjsjssssssssssssssssssssssssssssssssssssssooossssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
11111311131111111111111111sssssssssssssssssssssssssssssssssooeeeoosssssssssrsssssssssssssssssssssesessssssssssssssssssssssssssss
111113111311111111111111111ssssssssssssssssssssssssssssssssoeeeeeossssssss3sssssssssssssssssssssosssosssssssssssssssssssssssssss
1111131113111111111111111111ssssssssssssssssssssssssssssssoeeeeeeeossssssssjsssssssssssssssssssssososssessssssssssssssssssssssss
1111131113111111111111111111ssssssssssssssssssssssssssssssoeeeeeeeosssssssj111ssssssssssssssssssssoosoosssssssssssssssssssssssss
1111131113111111111111111111ssssssssssssssssssssssssssssssoeeeeeeeosssssss11111sssssssssssssssssessoossessssssssssssssssssssssss
1111131113111111111111111c11sssssssssssssssssssssssssssssssoeeeeeossssssss11111ssssssssssssssssssoooscssssssssssssssssssssssssss
11111311131111111111111111c1sssssssssssssssssssssssssssssssooeeeoossssssss11111sssssssssssssssssossocsssssssssssssssssssssssssss
111113111311111111111111111csssssssssssssssssssssssssssssssssooosssssssssss111ssssssssssssssssssssscssssssssssssssssssssssssssss
11111311131111111111111111sscssssssssssssssssssssssssssssssssssssssssssssssssssssssss1111111111111c1111111ssssssssssssssssssssss
11111311131111111111111111ssssssssssssssssssssssssssssssssssssssssssssssssssssssssss11111111111111111111111sssssssssssssssssssss
111113111311111111111111111ssssscssssssssssssssssssssssssssssssssssssssssssssssssss11111111111c1111111111111ssssssssssssssssssss
111113111311111111111111111sssssscsssssssssssssssssssssssssssssssssssssssssssssssss1111111111c11111111111111ssssssssssssssssssss
1111131113111111111111111111sssssscssssssssssssssssssssssssssssssssssssssssssssssss111111111c111111111111111ssssssssssssssssssss
11111311131111111111111111111sssssssscsssssssssssssssssssssssssssssssssssssssssssss111111c111111111111111111ssssssssssssssssssss
111113111311111111111111111111sssssssscscsssssssssssssssssssssssssssssssssssssssssss11c1c1111111111111111111ssssssssssssssssssss
111113rrr3111111111111111111111sssssssssscsssssssssssssssssssssssssssssssssssssssssssc111111111111111111111sssssssssssssssssssss
111113rrr3111111111111111111111111sssssssssscssssssssssssssssssssssssssssssssssssscsssss11111111ssssssssssssssssssf111ssssssssss
111113rrr31111111111111111111111111sssssssssssscscssssssssssssssssssssssssssscscsssssssss111111sssssssssssssssssfiv1f11sssssssss
111113rrr311111111111111111111111111sssssssssssssscscscssssssssssssssssscscscsssssssssssss11111sssssssssssssssssvfvfv111ssssssss
111113rrr311111111111111111111111111ssssssssssssssssssssscscscscscscscsssssssssssssssssssss111ssssssssssssssssssuvuvu111ssssssss
111111111111111111111111111111111111sssssssssssssssssssssssssssssssssssssssssssssssssssssss111ssssssssssssssssssuvuvu111ssssssss
111111111111111111111111111111111111sssssssssssssssssssssssssssssssssssssssssssssssssssssss11sssssssssssssssssssiu1u1111ssssssss
111111111111111111111111111111111111sssssssssssssssssssssssssssssssssssssssssssssssssssssss11ssssssssssssssssssss111111sssssssss
11111111111111111111111111111111111sssssssssssssssssssssssssssssssssssssssssssssssssssssssss1sssssssssssssssssssss1111ssssssssss

__map__
7d7e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7d4b760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7d7d7d7e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7d7d5b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7d7d0000007a6300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7d7d0000007c7d7e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7d7d000074006b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7d5b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7d00007600000000770075000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7d4b007300000000007c7d7e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7d7d000078790000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7d5b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7d4b760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7d7d7d7e00000000007400006300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7d7d7d4b0000000000007c7d7d7e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7d7d7d7d7e0000000000006b0000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010303062453424520245102451024510245100c0001000013000170000c0001000013000170000c0001000013000170000c0001000013000170000c0001000015000170000c0001000015000170000c00010000
010402031777018771187701877000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
010b05080017000160001500014000130001220011200112001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
01050002180521f052000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01050408245341c5301f5301c530245301c5301f5301c5301050013500175000c5001050013500175000c5001050015500175000c5001050015500175000c5001050000500005000050000000000000000000000
01050408245341b5301f5301b530245301b5301f5301b5301050013500175000c5001050013500175000c5001050015500175000c5001050015500175000c5001050000500005000050000000000000000000000
010206072115422151231512415124151241512415118100001000010100101001010010100101001010010100101001010010100100001000010000100001000010000100001000010000100001000010000100
010f000010000170001500012000130000e000100001200017000190001a00019000120000e00010000130000e000100001200013000150000c0000e0001000012000190001c000190001a0000e000100000e000
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
000300081060010600106001060010600106001060010600286002860028600286000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
01030008235650c505235650c505235650c5052356500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505
010300081c565185051c565185051c565185051c56500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505
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

