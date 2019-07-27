pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

dir=nil
l=0
r=1
u=2
d=3

p1 = {}
p2 = {}

p1.x = 58
p1.y = 64
p1.len = 4

p2.x = 70
p2.y = 64
p2.len = 4
-- p2 = {x: 66, y: 64}
-- ps = [p1, p2]

-- [ ] push head to array
-- [ ] pop tail from array
-- [ ] white head, when started
-- [ ] collision with other ps
-- [ ] reappear when reached edge
-- [ ] fruits (apple sprite)

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
  pset(p1.x,p1.y,12)
  pset(p2.x,p2.y,10)
end

function left()
  p1.x = p1.x-1
end

function right()
  p1.x = p1.x+1
end

function up()
  p1.y = p1.y-1
end

function down()
  p1.y = p1.y+1
end
