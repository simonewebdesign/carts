pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- snake
lf=0
rg=1
up=2
dw=3

dot = {}

p1 = {}
-- p1.i = 0
p1.x = 58
p1.y = 64
p1.len = 5
p1.dir = nil
p1.trail = {}

p2 = {}
-- p2.i = 1
p2.x = 70
p2.y = 64
p2.len = 5
-- [ ] push head to array
-- [ ] pop tail from array
-- [ ] white head, when started
-- [ ] collision with other ps
-- [ ] reappear when reached edge
-- [x] fruits (apple sprite)

function _init()
  -- random coords
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

  if     p1.dir==0 then p1.x-=1
  elseif p1.dir==1 then p1.x+=1
  elseif p1.dir==2 then p1.y-=1
  elseif p1.dir==3 then p1.y+=1
  else end -- no dir, initial state

  if     p2.dir==0 then p2.x-=1
  elseif p2.dir==1 then p2.x+=1
  elseif p2.dir==2 then p2.y-=1
  elseif p2.dir==3 then p2.y+=1
  else end -- no dir, initial state

  add(p1.trail, {p1.x, p2.y})
  -- print(tostr(p1.trail[1][1]))

  if #p1.trail > p1.len then

    for idx,coord in pairs(p1.trail) do
      -- print("idx" .. tostr(idx))
      if idx > #p1.trail then
        del(p1.trail, coord)
      end
    end

  end
end

function _draw()
  -- the dot/fruit
  spr(2,dot.x,dot.y)

  -- draw p1's head
  pset(p1.x,p1.y,12)

  -- draw p2's head
  pset(p2.x,p2.y,10)

  p1_tail = p1.trail[#p1.trail]

  pset(p1_tail[1],p1_tail[2],8)
  print("x" .. tostr(p1_tail[1]))
  print("y" .. tostr(p1_tail[2]))
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
