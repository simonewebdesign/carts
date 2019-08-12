pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- fruit snake
-- by simone


dot = {}
-- dot.w = 8
-- dot.h = 8

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
p2.trail = {}

ps = {
 p1, p2
}

-- todo priorities:
-- [x] forbid going to opposite dir
-- [x] reappear when reached edge
-- [x] eat fruit
-- [ ] and get longer
-- [ ] white head, when started
-- [ ] start screen

-- try to leave refactoring for later
-- and get inspired from jelpi

-- move all update
-- subroutines under update,
-- and all draw ones under draw

function _init()
 -- reset transparency 4 all
 palt(0, false) -- do this when you figured out the code for cleaning up
 -- todo: figure out how to
 -- actually disable transparency, and then
 -- use black as background color
 rectfill(o, o, 127, 127, 0)
 rand_dot_pos()
end


function _update()
 for i=0,1 do
  update_game_over(i)
  set_player_dir(i)
  update_snake(i)
 end

 -- printh("trail="..tostrtable(p1.trail))
end


function _draw()
 -- printh("taken?="..tostr(dot.taken))
 -- bg
 -- rectfill(0, 0, 127, 127, 5)

 -- dot/fruit cleanup
 px, py = dot.prevx, dot.prevy
 if px and py then
  rectfill(px+2,py+2,px+5,py+5,0)
  dot.prevx = nil
  dot.prevy = nil
 end

 -- the dot/fruit
 ax, ay = dot.x, dot.y
 spr(2, ax, ay)


 -- ax, ay = dot.x, dot.y
 -- -- rectfill(ax+1,ay+1, ax+6, ay+6, 0)
 -- if     dot.sprid == 1 then
 --  rectfill(ax+1,ay+1, ax+7, ay+7, 0)
 --  spr(1, ax, ay)

 -- elseif dot.sprid == 2 then
 --  rectfill(ax+1,ay+1, ax+7, ay+7, 0)
 --  spr(2, ax, ay)

 -- elseif dot.sprid == 3 then
 --  rectfill(ax+2,ay+2, ax+6, ay+6, 0)
 --  -- rectfill(ax+1,ay+1, ax+6, ay+6, 0)
 --  spr(3, ax, ay)

 -- elseif dot.sprid == nil then
 --  -- rectfill(ax+2,ay+2, ax+5, ay+5, 1)
 --  rectfill(ax+3,ay+3, ax+5, ay+5, 0)
 -- end

 for i=0,1 do
  local pl = ps[i+1] -- 1 based

  draw_game_over(pl)
  draw_cut_tail(pl)
 end

 -- draw p1's head
 if (not p1.game_over) then
  pset(p1.x,p1.y,12)
  -- printh("head="..tostrcoord({x=p1.x, y=p1.y}))
 end

 -- draw p2's head
 if (not p2.game_over) then
  pset(p2.x,p2.y,10)
 end
end


-- true if pixel is not black
function collides(c)
 -- todo: remove next line
 -- if (pget(c.x, c.y) == 8) return false
 -- todo: change it back to 0 below (was 1 just to test)
 return pget(c.x, c.y) > 0
end

-- coord is on fruit?
-- function is_fruit(c)
--  if (dot.taken) return false

--  x,y = c.x, c.y
--  a,b = dot.x, dot.y

--  return
--   (x >= a+2 and y >= b+2) or
--   (x <= a+6 and y >= b+2) or
--   (x <= a+6 and y <= b+6) or
--   (x >= a+2 and y <= b+6)
--   -- eql(x,y,a+2,b+2) or
--   -- eql(x,y,) or
--   -- eql(x,y,) or
--   -- eql(x,y,) or
--   -- eql(x,y,a+3,b+1) or
--   -- eql(x,y,a+4,b+1) or
--   -- eql(x,y,a+2,b+2) or
--   -- eql(x,y,a+5,b+2) or
--   -- eql(x,y,a+1,b+3) or
--   -- eql(x,y,a+6,b+3) or
--   -- eql(x,y,a+1,b+4) or
--   -- eql(x,y,a+6,b+4) or
--   -- eql(x,y,a+2,b+5) or
--   -- eql(x,y,a+5,b+5) or
--   -- eql(x,y,a+3,b+6) or
--   -- eql(x,y,a+4,b+6)
-- end


-- _update functions

function update_game_over(id)
 local pl = ps[id+1] -- 1 based

 if pl.game_over then
  local hd = pl.trail[#pl.trail]

  -- del() shifts the indexes
  -- so trail becomes a queue
  del(pl.trail, hd)
 end
end


function set_player_dir(id)
 local pl = ps[id+1] -- 1 based

 if (pl.dir ~= 1 and btnp(0,id)) pl.dir=0
 if (pl.dir ~= 0 and btnp(1,id)) pl.dir=1
 if (pl.dir ~= 3 and btnp(2,id)) pl.dir=2
 if (pl.dir ~= 2 and btnp(3,id)) pl.dir=3
end


function update_snake(id)
 -- if (dot.taken) then
 --  dot.taken = false
 --  rand_dot_pos()
 -- end

 local pl = ps[id+1]

 if pl.game_over then return end

 if pl.dir ~= nil then
  add(pl.trail, {x=pl.x, y=pl.y})
 end

 if     pl.dir==0 then
  -- out-of-bounds?
  if (pl.x <= 0) pl.x = 127

  nextc = {x=pl.x-1, y=pl.y}

  if is_colliding(nextc, dot) then
   dot.prevx = dot.x
   dot.prevy = dot.y
   rand_dot_pos()
   pl.grow = 3
   pl.x-=1
  elseif collides(nextc) then
   pl.game_over = true
  else
   pl.x-=1
  end
 elseif pl.dir==1 then
  -- out-of-bounds?
  if (pl.x >= 127) pl.x = 0

  nextc = {x=pl.x+1, y=pl.y}

  if is_colliding(nextc, dot) then
   dot.prevx = dot.x
   dot.prevy = dot.y
   rand_dot_pos()
   pl.grow = 3
   pl.x+=1
  elseif collides(nextc) then
   pl.game_over = true
  else
   pl.x+=1
  end
 elseif pl.dir==2 then
  -- out-of-bounds?
  if (pl.y <= 0) pl.y = 127

  nextc = {x=pl.x, y=pl.y-1}

  if is_colliding(nextc, dot) then
   dot.prevx = dot.x
   dot.prevy = dot.y
   rand_dot_pos()
   pl.grow = 3
   pl.y-=1
  elseif collides(nextc) then
   pl.game_over = true
  else
   pl.y-=1
  end
 elseif pl.dir==3 then
  -- out-of-bounds?
  if (pl.y >= 127) pl.y = 0

  nextc = {x=pl.x, y=pl.y+1}

  if is_colliding(nextc, dot) then
   dot.prevx = dot.x
   dot.prevy = dot.y
   rand_dot_pos()
   pl.grow = 3
   pl.y+=1
  elseif collides(nextc) then
   pl.game_over = true
  else
   pl.y+=1
  end
 else end -- no dir, initial state

 if not pl.game_over and #pl.trail >= pl.len+1 then
  local hd = pl.trail[1]

  -- del() shifts the indexes
  -- so trail becomes a queue
  del(pl.trail, hd)
 end

 printh('p1.grow='..(p1.grow or ''))
 -- printh('sprid='..dot.sprid)
end


function rand_dot_pos()
 dot.x = flr(rnd(119)) --127-8
 dot.y = flr(rnd(119))
end



-- _draw functions

function draw_game_over(pl)
 if pl.game_over and #pl.trail > 0 then
  local hd = pl.trail[#pl.trail]
  -- cut pl's head
  pset(hd.x,hd.y,0)

  for c in all(pl.trail) do
   if c == hd then
    -- printh("deleted="..tostrcoord({hd.x,hd.y}))
   else
    -- random color except black
    pset(c.x,c.y,flr(rnd(14))+1)
   end
  end
 end
end


function draw_cut_tail(pl)
 -- cleanup first
 if #pl.trail >= pl.len then
  local tail = pl.trail[1]
  -- printh("tail="..tostrcoord(tail))

  -- cut pl's tail
  pset(tail.x,tail.y,0)
 end
end



-- utils

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

-- screen center minus the
-- string length times the
-- pixels in a char's width,
-- cut in half
function hcenter(str)
 return 64 -#str * 2
end

-- screen center minus the
-- string height in pixels,
-- cut in half
vcenter=61


-- same coord?
-- function eql(a,b,x,y)
--  return a == x and b == y
-- end

-- false if colliding
-- a is snake, b is sprite/dot
-- function aabb(a, b)
--  return
--    a.x < b.x+b.w or
--    b.x < a.x+a.w or
--    a.y < b.y+b.h or
--    b.y < a.y+a.h
-- end
function is_colliding(a,b)
 return not (
  a.x < b.x+2 or
  b.x+5 < a.x or
  a.y < b.y+2 or
  b.y+5 < a.y)
end


-- function game_over(winner)
--  text="game over. player " ..
--   winner .. " wins!"
--  print(text,hcenter(text),vcenter,8)
-- end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700007788000003300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000078888800078880000033000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000088888800088880000088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700008888000008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001415013150141501415014150141501415015150161501715018150191501a1501b1501e1501f1502215022150231502415025150261502615027150291502a1502b1502d1502f150301503215034150
