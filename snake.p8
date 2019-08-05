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
-- dir is nil by default
p1.trail = {}


p2 = {}
p2.x = 70
p2.y = 64
p2.len = 5

-- todo priorities:
-- [ ] forbid going to opposite dir
-- [ ] reappear when reached edge
-- [ ] white head, when started
-- [ ] start screen


-- screen center minus the
-- string height in pixels,
-- cut in half
vcenter=61


function _init()
 -- random initial coords
 dot.x = flr(rnd(127))
 dot.y = flr(rnd(127))
end


function _update()
 if p1.game_over then
  local hd = p1.trail[#p1.trail]

  -- del() shifts the indexes
  -- so trail becomes a queue
  del(p1.trail, hd)
 end

 for i=0,1 do -- todo: 0,n players
	 set_player_dir(i)
 end

 if     not p1.game_over and p1.dir==0 then
  add(p1.trail, {x=p1.x, y=p1.y})
  if collides({x=p1.x-1, y=p1.y}) then
   p1.game_over = true
  else
   p1.x-=1
  end
 elseif not p1.game_over and p1.dir==1 then
  add(p1.trail, {x=p1.x, y=p1.y})
  if collides({x=p1.x+1, y=p1.y}) then
   p1.game_over = true
  else
   p1.x+=1
  end
 elseif not p1.game_over and p1.dir==2 then
  add(p1.trail, {x=p1.x, y=p1.y})
  if collides({x=p1.x, y=p1.y-1}) then
   p1.game_over = true
  else
   p1.y-=1
  end
 elseif not p1.game_over and p1.dir==3 then
  add(p1.trail, {x=p1.x, y=p1.y})
  if collides({x=p1.x, y=p1.y+1}) then
   p1.game_over = true
  else
   p1.y+=1
  end
 else end -- no dir, initial state

 if     p2.dir==0 then p2.x-=1
 elseif p2.dir==1 then p2.x+=1
 elseif p2.dir==2 then p2.y-=1
 elseif p2.dir==3 then p2.y+=1
 else end -- no dir, initial state

 if not p1.game_over and #p1.trail >= p1.len+1 then
  local hd = p1.trail[1]

  -- del() shifts the indexes
  -- so trail becomes a queue
  del(p1.trail, hd)
 end

 printh("trail="..tostrtable(p1.trail))
end


function _draw()
 -- the dot/fruit
 spr(2,dot.x,dot.y)

 if p1.game_over and #p1.trail > 0 then
  local hd = p1.trail[#p1.trail]
  -- cut p1's head
  pset(hd.x,hd.y,0)

  for c in all(p1.trail) do
   if c == hd then
    -- printh("deleted="..tostrcoord({hd.x,hd.y}))
   else
    -- random color except black
    pset(c.x,c.y,flr(rnd(14))+1)
   end
  end
 end

 -- cleanup first
 if #p1.trail >= p1.len then
  local tail = p1.trail[1]
  printh("tail="..tostrcoord(tail))

  -- cut p1's tail
  pset(tail.x,tail.y,0)
 end

 -- draw p1's head
 if (not p1.game_over) then
  pset(p1.x,p1.y,12)
  printh("head="..tostrcoord({x=p1.x, y=p1.y}))
 end

 -- draw p2's head
 if (not p2.game_over) then
  pset(p2.x,p2.y,10)
 end
end


-- true if pixel is not black
function collides(c)
 return pget(c.x, c.y) > 0
end


function set_player_dir(id)
 if (btnp(0,id)) p1.dir=0
 if (btnp(1,id)) p1.dir=1
 if (btnp(2,id)) p1.dir=2
 if (btnp(3,id)) p1.dir=3
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

-- screen center minus the
-- string length times the
-- pixels in a char's width,
-- cut in half
function hcenter(str)
 return 64 -#str * 2
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
00077000078888800078880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000088888800088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700008888000008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001415013150141501415014150141501415015150161501715018150191501a1501b1501e1501f1502215022150231502415025150261502615027150291502a1502b1502d1502f150301503215034150
