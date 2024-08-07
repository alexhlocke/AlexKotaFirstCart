pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--map blockout


--[[===========================

★ use the arrow keys to move ★
★ hold ❎ (x) to speed up    ★

--]]--=========================



cam={x=0,y=0}
speed=1

function _init()
 reset_pal()
end

function _update60()
 if(btn(❎)) then
  speed=3
 else
  speed=1
 end
 
 if(btn(⬆️))then
  cam.y-=speed
 end
 if(btn(⬇️))then
  cam.y+=speed
 end
 if(btn(⬅️))then
  cam.x-=speed
 end
 if(btn(➡️))then
  cam.x+=speed
 end
 
 camera(cam.x,cam.y)
end



function _draw()
 cls()
 
 --bg
 sspr(0,32,32,32,cam.x,cam.y,128,128)
 
 map()
 
 --level border
 linecol=8
 line(-1,-1,512,-1,linecol) 
 line(-1,-1,-1,128,linecol) 
 line(-1,128,512,128,linecol) 
 line(512,-1,512,128,linecol)
 
 line(127,-1,127,128)
 line(128,-1,128,128)
 line(383,-1,383,128)
 line(384,-1,384,128)
 
 --labels
 print("ocean/river",2,2,linecol)
 print("town 1",130,2,linecol)
 print("town 2 [same screen]",260,2,linecol) 
 print("lake/pond",390,2,linecol) 
end


function reset_pal()
 poke( 0x5f2e, 1 ) --endable hidden colors
 custom_palette = {[0]=0,1,140,12,131,3,139,130,136,14,142,143,15,13,6,7}
 pal( custom_palette, 1 )
end
__gfx__
00000000555555552222222277777777cccccccc0000000000000000000000000000000000000000000000000000000000000000000000000099990000000000
00000000555555552222222277777777cccccccc0000000000000000000000000000000000000000000000000000000000000000000440000997a99000000440
00700700555555552222222277777777cccccccc000000000000000000000000000000000000000000000000000000000000998000444400097aaa9000004470
00077000555555552222222277777777cccccccc00000000000000000000000000000000000000000000000000000000000998a00444444009aaaa9000044070
00077000555555552222222277777777cccccccc0000000000000000000000000000000000000000000000000000000099088aa000ffff0009aaaa9000440070
00700700555555552222222277777777cccccccc000000000000000000000000000000000000000000000000000000000998aa0000ff0f0009aa9a9004400070
00000000555555552222222277777777cccccccc000000000000000000000000000000000000000000000000000000000099000000ff0f00099aa99004000080
00000000555555552222222277777777cccccccc0000000000000000000000000000000000000000000000000000000000090000000000000099990000000000
00000000770770770000000000000000000000000000000000000000000000000000000000000000000000000000000880000000000000008888888800080000
00000000700000070000000000000000000000000000000000000000000000000000000000000000000000000000000880000000000000000000000000080000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000880000000000000000000000000080000
00000000700000070000000000000000000000000000000000000000000000000000000000000000000000000000000880000000000000000000000000080000
00000000700000070000000000000000000000000000000000000000000000000000000000000000000000000000000880000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000880000000000000000000000000080000
00000000700000070000000000000000000000000000000000000000000000000000000000000000000000000000000880000000000000000000000000000000
00000000770770770000000000000000000000000000000000000000000000000000000000000000000000000000000880000000888888880000000088888888
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33333333333333333333333333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33333333333333333333333333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33333333333333333333333333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333333333333333333333333333ffff3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3333333333333333333333333fffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333333333fff333333333333fffeefff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3333fff3fffff33333333333feffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333fffffffffff333333333fffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33ffffffffefff33333fffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33fffeefffffefff33ffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffeeffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffefffffffffffffffeeefffffefff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fffffffffffffffffffeefffffeeffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffffffeeefffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
23233333233223322333322332322332000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222222222222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222222222222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222222222222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11122222222222222222222222222211000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111222222222222222222222222111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111112222222222222222222211111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111112222222222222211111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000001010101010101010101000000000000000000000000000000000000000000000000000000000000000100000000000001010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10000000000000000000000000000010000000000000001f00000000000000000000000000000000001f0000000000101000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
100000000000000000000000000000100000000000001b0c1c0000000000000000000000000000001b0d1c00000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10000000000000000000000000000010000000000004001e0000000000001f000000000000000000001e0000000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10000000000000000000000000000010000000000004000000000000001b0e1c000000000000000000000000000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000003030303030303000000001e00000000000000040003030000000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000040404040400000000000000000000000000040303030300000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000040404030400000000030300000000000000030304040303000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000040404040400000003030303000000000003030404040400000000001000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000001f0000100000030303030304040000030304040303000000030303030404040000000000100000001f000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10000000000000000000001b0f1c001000000004040404040400000004040404000000000004040404030400000000001000001b0f1c0000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000001e0000100000000404030403040000000404030400000000000403040404040000000010100000001e000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000004040304040400000004040304000000000004030404040400000000101000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202010101010101010101010101010101010101010101010101010101010101010101010101010101010101020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202010101010101010101010101010101010101010101010101010101010101010101010101010101010101020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020101010100000000000000000000000000000002020202020202020202020202020203030101010102020202020202020202021000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202010100000000000000000000000000000002020202020202020202020202020202030101010202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020100000000000000000000000000000000020202020202020202020202020202030101010202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020100000000000000000000000000000000020202020202020202020202020202020101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000030202020202020202020202020202020101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000030202020202020202020202020202030101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000030302020202020202020202020203030102020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000030302020202020202020202020203030102020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000030302020202020202020202020203030202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000020202020202020202020202020202030202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000020302020202020202020202020202030202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000030302020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000030302020202020202020202020203030202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000030202020202020202020202020303030202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000030202020202020202020202020202030202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000030202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000