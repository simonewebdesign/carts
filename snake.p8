pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
x=64
y=64
dir=nil
l=0
r=1
u=2
d=3

function _init()

end

function _update()
  if (btnp(l)) then dir=l end
  if (btnp(r)) then dir=r end
  if (btnp(u)) then dir=u end
  if (btnp(d)) then dir=d end

  if     dir==l then left()
  elseif dir==r then right()
  elseif dir==u then up()
  elseif dir==d then down()
  else end -- no dir, initial
end

function _draw()
		rectfill(x,y,x+1,y+1,12)
end

function left()
		x = x-1
end

function right()
  x = x+1
end

function up()
  y = y-1
end

function down()
  y = y+1
end
