pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
x=64
y=64

function _update()
  if (btn(0)) then x=x-1 end
  if (btn(1)) then x=x+1 end
  if (btn(2)) then y=y-1 end
  if (btn(3)) then y=y+1 end
end

function _draw()
		rectfill(0,0,127,127,12)
		circfill(x,y,7,8)
end
