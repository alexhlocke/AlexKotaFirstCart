pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--fishing game 🐱 
--by alex & kota
-------------------------------

function _init()
 --create fish arcetypes
 init_fish()
 
 --set update/draw
 _upd=update_game
 _drw=draw_game
end


function _update()
 _upd()
end


function _draw()
 _drw()
end
-->8
--game/menu
--== game ==--------------------

function init_game()

end


function update_game() 
 ----player cant move if show_menu
 --if(not show_menu)update_player()
end


function draw_game()
 cls(1)
 
 --draw main menu
 if(show_menu)draw_main_menu()
 
 print("this is the game",5,5,12)
end 


--== main menu ==---------------


show_menu=true

--displays menu overlay on top
--of game
function draw_main_menu()
 --stop drawing menu if btn
 if(btn(❎)or btn(🅾️))show_menu=false

 print("★ this is the main menu ★",10,60,7)
 print("∧PRESS ❎ OR 🅾️ TO CONTINUE∧",4,67,13)
end
-->8
--fish

--★ todo: shinies

--[[ fish structure
 name, size, sprt (sprite #)
 , w, h (sprite width/height)
]]--

fishes={} --arcetype table

--add fish to fishes table
function make_fish(name,size,sprt,w,h)
 add(fishes,
  {name=name
  ,sprt=sprt
  ,w=w,h=h
  ,size=size}
 )
end

--fully populates fishes table
--◆this can be optimized for
--tokens if need be
function init_fish()
 --example testing
 make_fish("freshwater fuckass"
  ,10,1,2,1)
 make_fish("jeremy"
  ,4,3,2,1)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
