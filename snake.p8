pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- fruit snake

dot = {}

p1 = {}
p1.x = 58
p1.y = 64
p1.len = 5
-- dir is nil by default
p1.trail = {}


p2 = {}
p2.x = 70
p2.y = 64
p2.len = 5

-- todo priorities:
-- [ ] collision with other ps
-- [ ] reappear when reached edge
-- [ ] white head, when started

function _init()
 -- random initial coords
 dot.x = flr(rnd(127))
 dot.y = flr(rnd(127))
end

function _update()
 if (btnp(0,0)) then p1.dir=0 end
 if (btnp(1,0)) then p1.dir=1 end
 if (btnp(2,0)) then p1.dir=2 end
 if (btnp(3,0)) then p1.dir=3 end

 if (btnp(0,1)) then p2.dir=0 end
 if (btnp(1,1)) then p2.dir=1 end
 if (btnp(2,1)) then p2.dir=2 end
 if (btnp(3,1)) then p2.dir=3 end

 if     p1.dir==0 then
  add(p1.trail, {x=p1.x, y=p1.y})
  p1.x-=1
 elseif p1.dir==1 then
  add(p1.trail, {x=p1.x, y=p1.y})
  p1.x+=1
 elseif p1.dir==2 then
  add(p1.trail, {x=p1.x, y=p1.y})
  p1.y-=1
 elseif p1.dir==3 then
  add(p1.trail, {x=p1.x, y=p1.y})
  p1.y+=1
 else end -- no dir, initial state

 if     p2.dir==0 then p2.x-=1
 elseif p2.dir==1 then p2.x+=1
 elseif p2.dir==2 then p2.y-=1
 elseif p2.dir==3 then p2.y+=1
 else end -- no dir, initial state

 if #p1.trail >= p1.len+1 then
  local hd = p1.trail[1]

  -- del() shifts the indexes
  -- so trail becomes a queue
  del(p1.trail, hd)
 end

 printh("trail="..tostrtable(p1.trail))
end

function _draw()
 -- cleanup first
 if #p1.trail >= p1.len then
  local tail = p1.trail[1]
  printh("tail="..tostrcoord(tail))

  -- cut p1's tail
  pset(tail.x,tail.y,0)
 end

 -- the dot/fruit
 spr(2,dot.x,dot.y)

 -- draw p1's head
 pset(p1.x,p1.y,12)
 printh("head="..tostrcoord({x=p1.x, y=p1.y}))

 -- draw p2's head
 pset(p2.x,p2.y,10)
end

function tostrtable(t)
 local s = ""
 for v in all(t) do
  s = s .. tostrcoord(v) .. " "
 end
 return s
end

function tostrcoord(c)
 return "{x="..c.x..",y="..c.y.."}"
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700007788000003300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000078888800078880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000088888800088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700008888000008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001415013150141501415014150141501415015150161501715018150191501a1501b1501e1501f1502215022150231502415025150261502615027150291502a1502b1502d1502f150301503215034150
