pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- fruit snake
-- by simone

dot = {}


p1 = {}
p1.x = 58
p1.y = 64
p1.len = 5
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
 rectfill(0, 0, 127, 127, 0)
 rand_dot_pos()
end


function _update()
 for i=0,1 do
  update_game_over(i)
  set_player_dir(i)
  update_snake(i)
 end
end


function _draw()
 -- dot/fruit cleanup
 if dot.prevx then
  palt(0, false)
  rectfill(
   dot.prevx+2,
   dot.prevy+2,
   dot.prevx+5,
   dot.prevy+5,
   0
  )
  palt()
  dot.prevx = nil
  dot.prevy = nil
 end

 -- the dot/fruit
 ax, ay = dot.x, dot.y
 spr(2, ax, ay)

 for i=0,1 do
  local pl = ps[i+1] -- 1 based

  draw_game_over(pl)
  draw_cut_tail(pl)
 end

 -- p1's head
 if (not p1.game_over) then
  pset(p1.x,p1.y,12)
 end

 -- p2's head
 if (not p2.game_over) then
  pset(p2.x,p2.y,10)
 end
end


-- true if pixel is not black
function collides(c)
 return pget(c.x, c.y) > 0
end


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
    -- {hd.x,hd.y} got deleted
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

-- a is snake, b is sprite/dot
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
