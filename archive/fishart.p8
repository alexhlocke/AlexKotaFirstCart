pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--press ⬅️ to view fish
 



-->8
--cat sprite drawing
function _init()
	ct=3 --cattail
	frame = 0
	poke( 0x5f2e, 1 ) --endable hidden colors
 custom_palette = {[0]=0,1,140,12,131,3,139,130,136,14,142,143,15,13,6,7}
	pal( custom_palette, 1 )
end

function _update()

	frame+=1
	if(frame%4==0) then
	cat_tail()
	end
	
end

function _draw()
	cls(2)
	sspr(32,32,32,32,0,0,128,128)
	map(0,0,0,0,128,128)
	cat_idle(25,85)
	
--	just prints some flowers and gates
	spr(80,50,97)
	spr(81,40,97)
	spr(82,0,97)
	spr(82,8,97)
	print("press ⬅️ to view fish",8)
	
	if(btn(0)) then
	cls(12)
 draw_fish_got(fish)
 end
 
end

function cat_tail()
	if(ct < 5) then
		ct+=1
	else
		ct=3
	end
	return ct
end

function cat_idle(x,y)
		spr(0,x,y,2,3)
		spr(ct,x-7,y+8,1,2)
end
-->8
--fish display

--testfish
fish={
 name="mfing trout"
 ,sprt=6
 ,w=2,h=1
 ,shinycols={
   {4,2}
  ,{9,14}
  ,{10,8}
 }
}


function draw_fish_got(fish)
 --get fish h and w
 local h=fish.h*8
 local w=fish.w*8
 local scale=2
 --upd scale
 --scale=3+sin(t()/4)
 
 --set inverse draw mode + fillp
-- poke(0x5f34,0x2)
 --draw border circle
 fillp(░)
 local circ_rad=65
 circfill(64,64,circ_rad,2 | 0x1800)
 fillp(█)
 
 --draw fish/lines
 local y=40
 y+=5*sin(t()/2)
 draw_flourish_lines(63,y+14)
 
-- set_shiny_pal(fish)
	sspr(fish.sprt%16*8,flr(fish.sprt/16)*8
  ,w,h
  ,63-w*scale/2,y-h*scale/2
  ,w*scale,h*scale)
  
 print("holy fucking shit",30,90,8)
 print("a fucking fish",35,97,9)
end


--item get lines
function draw_flourish_lines(x,y)
	for i=0,16 do
		local s=sin(time() * 2.1 + i/16)
		local c=cos(time() * 2.1 + i/16)
		local ty=y-14
		local r=20
		line(x+s*r,ty+c*r,x+s*40,ty+c*40,7)
	end
end


--shiny pal
function set_shiny_pal(fish)
 scols=fish.shinycols
 for i=1,#scols do
  pal(scols[i][1],scols[i][2])
 end
end
__gfx__
00070000000070000000000000000000000000000000000000000056560000000000000000060600000c00c0000000000000000000000000ff00000000000000
007b70000007b700000000000000770000000000000000000004444445600000000000000065600000b0000c00000000000000000000003f1000000000000000
007cb700007bc700000770000007cc700000770000000000644555555444004600000000044440000bbb000b0445600000000000000033210000000000000000
007ccb7777bcc700007cc7000007bc700007cc700000000005799999ccc564600000000041555406b7bbb0ba4155550600000000000322100000000000000000
007bbbbbbbbbb700007cb7000007b7700007bc700007700000558888999c485000000000cbbbb450abbbaba0fffeedf000000000003221200000000000000000
077bbbbbbbbbb770007bb7000007b7000007b700007cc700654bbbbbccc40495000000000aaa40040aaa0ab00dddd00d000000000f32121100000000000033ff
007bbb7bbb7bb7000007b700007bb700007bb700007bc7000000450004500044000000000005000000b000ab000e000000000000f221212110000003000f2220
077bbbbbbbbbb7700007b700007b7000007b700007bb700000000460006000000000000000006000000c000a0000f00000000000333322222200002000322200
0007bbbbcbbb70000007bb70007b7000007b700007b700000000000000cccc0000000000fff000000cccbc00fff0000000000003222223333311112033222100
00007aaaaaa7000000007b70007bb770007bb77007bb777000000000cbbbb9c000000000e7ef0000c7bbabc0d1ef000000003332232233333333333322211000
0007bbbbbbb7000000007bb00007bbb00007bbb0007bbbb00023330cb99998bc00000000e13ef0000aaa0abcdeeef00033222272232233333333322311100000
007bbbbbbbb70000000007700000777000007770000777700172221b988887bc00000000071390000b0b00bb0deee00000011122322223333222221122210000
07bbbbbbbbb700000000000000000000000000000000000001111177877779c0000000000e71390000c0c0cb0eddef0000000011111122222211112011221000
07bbbbbbbbb70000000000000000000000000000000000000000bb8099999bc0000000000e001399000000ca0e00deff00000000022211111120002000112000
7bbbbbbbbbb70000000000000000000000000000000000000000c9b00bbbbc000000000000f007880c000cba00f00dee00000000003220000020000300001230
7bbbbbbbbb7000000000000000000000000000000000000000000bcc00ccc000000000000000078000bbbaa000000de00000000000033f000003000000000000
7b77bbbbbb7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7bbb7bbbbb7700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7abb777ab7bc70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7aabbc7aabbb70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07777777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666677777777aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666677777777aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000000000000000000000000000000000000000000000000000
55555555555555555555555577777777aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000000000000000000000000000000000000000000000000000
54545454545454545454545477777777aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000000000000000000000000000000000000000000000000000
44444444444444444444444477777777aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000000000000000000000000000000000000000000000000000
77777777747777777777477777777777aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000000000000000000000000000000000000000000000000000
77777777774777777775777777777777aaaaaaaabbbbbbbbbbbbbbbbbbaaaaaa0000000000000000000000000000000000000000000000000000000000000000
77777777757777777777577777777777bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
0090900000c0c00007a0007a00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
0089900000acc000b7abbb7a00000000bbbbbbbbbbccccccccccccccbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
0088900000aac00077a7777a00000000bbbcccccccccccccccccccccccccbbbb0000000000000000000000000000000000000000000000000000000000000000
050500000505000007a0007a00000000cccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
0045400000454000b7abbb7a00000000cccccccccccccccffffccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
000400000004000077a7777a00000000cccccccccccccffffffffccccccccccc0000000000000000000000000000000000000000000000000000000000000000
00040000000400000770007700000000ffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000007777aaabbbcccccccccccccccbaa77770000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000777777aabbbccccccccccccbbaa777770000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000077777777aabbbccccccccbbbaa7777770000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000777777777aaabbccccccbbbaa77777770000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000011177777777aabbbbbbbba77777777110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111117777777aaaaaaaaaa77777771110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111111177777777777777777777111110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111111111177777777777777111111110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4041404240424000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343434343434300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343434343434300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343434343434300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000