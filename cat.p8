pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

 



-->8
--sprite drawing
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
		sspr(0,0,13,21,x,y)
		spr(ct,x-7,y+8,1,2)
end
__gfx__
00070000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007b70000007b7000000000000007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007cb700007bc700000770000007cc70000077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007ccb7777bcc700007cc7000007bc700007cc700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007bbbbbbbbbb700007cb7000007b7700007bc700007700000000000000000000000000000000000000000000000000000000000000000000000000000000000
077bbbbbbbbbb770007bb7000007b7000007b700007cc70000000000000000000000000000000000000000000000000000000000000000000000000000000000
007bbb7bbb7bb7000007b700007bb700007bb700007bc70000000000000000000000000000000000000000000000000000000000000000000000000000000000
077bbbbbbbbbb7700007b700007b7000007b700007bb700000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007bbbbcbbb70000007bb70007b7000007b700007b7000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00007aaaaaa7000000007b70007bb770007bb77007bb777000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007bbbbbbb7000000007bb00007bbb00007bbb0007bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000
007bbbbbbbb700000000077000007770000077700007777000000000000000000000000000000000000000000000000000000000000000000000000000000000
07bbbbbbbbb700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07bbbbbbbbb700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7bbbbbbbbbb700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7bbbbbbbbb7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
