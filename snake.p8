pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- fruit snake

dot = {}

p1 = {}
p1.x = 58
p1.y = 64
p1.len = 0
p1.maxlen = 5
-- dir is nil by default
-- tail is nil by default

p2 = {}
p2.x = 70
p2.y = 64
p2.len = 5
-- [ ] push head to array
-- [ ] pop tail from array
-- [ ] white head, when started
-- [ ] collision with other ps
-- [ ] reappear when reached edge
-- [x] fruits (apple sprite)
-- [ ] dont add/del to trail; simply read from canvas before the move
-- [ ] but you probably need to keep track of the trail somehow
--     unless
-- [ ] find a way to delete tail without tracking the trail
-- [ ] maybe keep track of just the tail, which is essentially the oldest
--     coord in the trail
--     you can start keeping track of the tail when the lenght has been reached
--     and replace it on every frame/update
--     so to recap:
-- [ ] p1.tail is nil at the very beginning
-- [ ] _update: as soon as len => maxlen, populate tail
-- [ ] _draw: if tail ~= nil, do clear the pixel

function _init()
  -- random initial coords
  dot.x = flr(rnd(127))
  dot.y = flr(rnd(127))
end

function _update()
  if (btnp(0,0)) then
    p1.dir=0
  end
  if (btnp(1,0)) then
    p1.dir=1
  end
  if (btnp(2,0)) then
    p1.dir=2
  end
  if (btnp(3,0)) then
    p1.dir=3
  end

  if (btnp(0,1)) then p2.dir=0 end
  if (btnp(1,1)) then p2.dir=1 end
  if (btnp(2,1)) then p2.dir=2 end
  if (btnp(3,1)) then p2.dir=3 end

  if     p1.dir==0 then
    p1.x-=1
  elseif p1.dir==1 then
    p1.x+=1
  elseif p1.dir==2 then
    p1.y-=1
  elseif p1.dir==3 then
    p1.y+=1
  else end -- no dir, initial state

  if     p2.dir==0 then p2.x-=1
  elseif p2.dir==1 then p2.x+=1
  elseif p2.dir==2 then p2.y-=1
  elseif p2.dir==3 then p2.y+=1
  else end -- no dir, initial state
end

function _draw()
  -- the dot/fruit
  spr(2,dot.x,dot.y)

  -- draw p1's head
  pset(p1.x,p1.y,12)

  -- draw p2's head
  pset(p2.x,p2.y,10)
end

function tostrtable(t)
  local s = ""
  for v in all(t) do
    s = state .. tostrcoord(v) .. " "
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
