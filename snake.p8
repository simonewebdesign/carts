pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- fruit snake brawl
-- by simone

start_length=5
grow_rate=6

dot = {}
chery = {}
ps = {}
colors = { 12, 8, 10, 11, 9, 2, 14, 5 }

psel = 1   -- default n.of players

game_started=false
in_initial_screen=true

snk_anim = {
 stage = 1,
 spr = 1,
 pos = { x = 0, y = 24 },
 delay = -50,
}


function _init()
 music()

 local offx = 26
 local offy = 16
 draw_bg()
 spr(6,3+offx,0+offy,8,4)
 spr(64,0+offx,31+offy,10,3)
 txt_press_to_start()

 local pos1, pos2 = rand_pos(), rand_pos()
 dot.x, dot.y = pos1[1], pos1[2]
 chery.x, chery.y = pos2[1], pos2[2]
end


function _update()
 if in_players_select then
  if psel < 8 and (btnp(1,0) or btnp(2,0)) then
   psel+=1
  elseif psel > 1 and (btnp(3,0) or btnp(0,0)) then
   psel-=1
  elseif btnp(4,0) then -- game can start
   -- generate players
   for i=1,psel do
    add(ps, {
     len = start_length,
     trail = {},
     color = colors[i]
    })
   end

   -- assign coords
   if     psel == 1 then
    ps[1].x, ps[1].y = 64, 64
   elseif psel == 2 then
    ps[1].x, ps[1].y = 56, 64
    ps[2].x, ps[2].y = 72, 64
   elseif psel == 3 then
    ps[1].x, ps[1].y = 48, 64
    ps[2].x, ps[2].y = 64, 72
    ps[3].x, ps[3].y = 80, 64
   elseif psel == 4 then
    ps[1].x, ps[1].y = 48, 56
    ps[2].x, ps[2].y = 56, 72
    ps[3].x, ps[3].y = 64, 72
    ps[4].x, ps[4].y = 72, 56
   elseif psel == 5 then
    ps[1].x, ps[1].y = 48, 56
    ps[2].x, ps[2].y = 56, 72
    ps[3].x, ps[3].y = 64, 80
    ps[4].x, ps[4].y = 72, 72
    ps[5].x, ps[5].y = 80, 56
   elseif psel == 6 then
    ps[1].x, ps[1].y = 48, 72
    ps[2].x, ps[2].y = 64, 80
    ps[3].x, ps[3].y = 80, 72
    ps[4].x, ps[4].y = 48, 40
    ps[5].x, ps[5].y = 64, 48
    ps[6].x, ps[6].y = 80, 40
   elseif psel == 7 then
    ps[1].x, ps[1].y = 32, 48
    ps[2].x, ps[2].y = 40, 72
    ps[3].x, ps[3].y = 48, 64
    ps[4].x, ps[4].y = 56, 80
    ps[5].x, ps[5].y = 64, 64
    ps[6].x, ps[6].y = 72, 72
    ps[7].x, ps[7].y = 80, 48
   elseif psel == 8 then
    ps[1].x, ps[1].y = 44, 60
    ps[2].x, ps[2].y = 52, 68
    ps[3].x, ps[3].y = 60, 74
    ps[4].x, ps[4].y = 68, 82
    ps[5].x, ps[5].y = 76, 82
    ps[6].x, ps[6].y = 84, 74
    ps[7].x, ps[7].y = 92, 68
    ps[8].x, ps[8].y = 100,60
   end

   d_players_select=false
   in_players_select=false
   d_game_start=true
   game_started=true
   music(8)
   return
  end
 end

 if in_initial_screen and btnp(4,0) then
  d_players_select=true
  in_players_select=true
  in_initial_screen=false
 end

 if (not game_started) return

 if is_all_game_over() then
  in_game_over=true
  --game_started=false
  music(-1)
  return
 end

 for i=1,psel do
  local pl = ps[i]

  if pl.game_over then
    update_game_over(pl)
    goto continue
  end

  set_player_dir(pl, i)
  update_snake(pl)
  ::continue::
 end
end


function _draw()
 if d_game_start then
  draw_bg()
  d_game_start=false
 end

 if d_players_select then
  clr_txt()
  txt_players_select()
 end

 -- 16 to 21, and 37 (7 in total)

 if in_initial_screen then
  if snk_anim.delay >= 20 then
   if snk_anim.stage == 1 then
    spr(snk_anim.spr+15, snk_anim.pos.x, snk_anim.pos.y)
   elseif snk_anim.stage == 2 then
    palt(0, false) -- black not transparent
    rectfill(snk_anim.pos.x-8, snk_anim.pos.y, 8, 8, 0)
    palt() -- reset
   end

   snk_anim.spr= snk_anim.spr+1
   snk_anim.delay= snk_anim.delay+1
   if (snk_anim.spr > 6) snk_anim.spr=1
   snk_anim.delay=0
   snk_anim.pos.x= snk_anim.pos.x+8
  else
   snk_anim.delay= snk_anim.delay+1
  end
 end

 if (not game_started) return

 draw_fruits()

 for i=1,psel do
  local pl = ps[i]
  if pl.game_over then
   draw_pl_game_over(pl)
  else
   draw_cut_tail(pl)
   draw_head(pl)
  end
 end

 if in_game_over then
  txt_game_over(1)
 end
end


function draw_bg()
 rectfill(0, 0, 127, 127, 0)
end


function draw_fruits()
 palt(0, false) -- black not transparent

 if dot.prevx then
  rectfill(dot.prevx+2, dot.prevy+2, dot.prevx+5, dot.prevy+5, 0)
  dot.prevx = nil
  dot.prevy = nil
 end

 if chery.prevx then
  palt(0, false)
  rectfill(chery.prevx+2, chery.prevy+2, chery.prevx+5, chery.prevy+5, 0)
  chery.prevx = nil
  chery.prevy = nil
 end

 palt() -- reset transparency

 spr(2, dot.x, dot.y)
 spr(5, chery.x, chery.y)
end


function draw_pl_game_over(pl)
 if (#pl.trail <= 0) return

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


function draw_cut_tail(pl)
 if #pl.trail >= pl.len then
  local tail = pl.trail[1]
  -- cut pl's tail
  pset(tail.x,tail.y,0)
 end
end


function draw_head(pl)
 pset(pl.x, pl.y, pl.color)
end


-- true if pixel is not black
function collides(c)
 return pget(c.x, c.y) > 0
end


-- _update functions

function update_game_over(pl)
 local hd = pl.trail[#pl.trail]

 -- del() shifts the indexes
 -- so trail becomes a queue
 del(pl.trail, hd)
end


function set_player_dir(pl, i)
 local idx = i-1

 if (pl.dir ~= 1 and btnp(0,idx)) pl.dir=0
 if (pl.dir ~= 0 and btnp(1,idx)) pl.dir=1
 if (pl.dir ~= 3 and btnp(2,idx)) pl.dir=2
 if (pl.dir ~= 2 and btnp(3,idx)) pl.dir=3
end


function update_snake(pl)
 if pl.dir ~= nil then
  add(pl.trail, {x=pl.x, y=pl.y})
 end

 if     pl.dir==0 then
  -- out-of-bounds?
  if (pl.x <= 0) pl.x = 127

  nextc = {x=pl.x-1, y=pl.y}

  if is_colliding(nextc, dot) then
   on_dot_collected()

   pl.len+= grow_rate
   pl.x-=1
  elseif is_colliding(nextc, chery) then
   on_chery_collected()

   pl.len+= grow_rate
   pl.x-=1
  elseif collides(nextc) then
   sfx(1)
   pl.game_over = true
  else
   pl.x-=1
  end
 elseif pl.dir==1 then
  -- out-of-bounds?
  if (pl.x >= 127) pl.x = 0

  nextc = {x=pl.x+1, y=pl.y}

  if is_colliding(nextc, dot) then
   on_dot_collected()

   pl.len+= grow_rate
   pl.x+=1
  elseif is_colliding(nextc, chery) then
   on_chery_collected()

   pl.len+= grow_rate
   pl.x+=1
  elseif collides(nextc) then
   sfx(1)
   pl.game_over = true
  else
   pl.x+=1
  end
 elseif pl.dir==2 then
  -- out-of-bounds?
  if (pl.y <= 0) pl.y = 127

  nextc = {x=pl.x, y=pl.y-1}

  if is_colliding(nextc, dot) then
   on_dot_collected()

   pl.len+= grow_rate
   pl.y-=1
  elseif is_colliding(nextc, chery) then
   on_chery_collected()

   pl.len+= grow_rate
   pl.y-=1
  elseif collides(nextc) then
   sfx(1)
   pl.game_over = true
  else
   pl.y-=1
  end
 elseif pl.dir==3 then
  -- out-of-bounds?
  if (pl.y >= 127) pl.y = 0

  nextc = {x=pl.x, y=pl.y+1}

  if is_colliding(nextc, dot) then
   on_dot_collected()

   pl.len+= grow_rate
   pl.y+=1
  elseif is_colliding(nextc, chery) then
   on_chery_collected()

   pl.len+= grow_rate
   pl.y+=1
  elseif collides(nextc) then
   sfx(1)
   pl.game_over = true
  else
   pl.y+=1
  end
 else end -- no dir, initial state

 if #pl.trail >= pl.len+1 then
  local hd = pl.trail[1]

  -- del() shifts the indexes
  -- so trail becomes a queue
  del(pl.trail, hd)
 end
end


function on_dot_collected()
 pos = rand_pos()
 dot.prevx, dot.prevy = dot.x, dot.y
 dot.x, dot.y = pos[1], pos[2]
 sfx(0)
end

function on_chery_collected()
 pos = rand_pos()
 chery.prevx, chery.prevy = chery.x, chery.y
 chery.x, chery.y = pos[1], pos[2]
 sfx(0)
end

function rand_pos()
 return {
  flr(rnd(119)), --127-8
  flr(rnd(119))
 }
end

function is_all_game_over()
 for i=1,psel do
  local pl = ps[i]
  if not pl.game_over then
   return false
  end
 end
 return true
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


-- text functions

function txt_game_over(winner)
 text="game over. player " ..
  winner .. " wins!"
 print(text,hcenter(text),vcenter,8)
end

function txt_press_to_start(clr)
 local text="press \x97 to start"
 print(text,hcenter(text)-1,vcenter+20,15)
end


function txt_players_select(clr)
 local text="number of players: " .. psel
 print(text,hcenter(text),vcenter+20,7)
end


function clr_txt()
 rectfill(0, 81, 127, 85, 0)
end

__gfx__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aaa0000000000000000000000000000000
00000000000330000000000000000000000030000000000000000000000000000000aaaaaa0000aa000000aa00000a9990000000000000000000000000000000
00700700007788000003300000000000000330000000000000000000aaaaa00000aa999999a000990000009900000999900aaaaa00aaaaa00000000000000000
000770000788888000788800000330000030030000003000000aaaaa999990000a99999999900099000000990000099990099999aa99999a0000000000000000
00077000088888800088880000088000078008800003030000a9999999999000a999999999900099000000990000000000099999999999990000000000000000
007007000088880000088000000000000880088000800800009999999999000a999999999990009900000099a0000aaaa0099999999999990000000000000000
00000000000880000000000000000000000000000000000000999999900000a99990009999900099000000999000099990099909999009990000000000000000
000000000000000000000000000000000000000000000000009999990000009999000a9999000099000000999000099990000009999009900000000000000000
00000000000000000000000000000000000000000000000000999900aa000a999000a99990000099000000999000099990000009999009900000000000000000
000000000000000000000000000000000000000000000000009999aa9900099990aa999900000099a0000099900009999a000009999000000000000000000000
0000bbbbbbbb0000000000000000000000000000bb00000000999999900009999a999990000000999aa00a999000099999000009999000000000000000000000
bbbb33333333bbbbbbbbbbbb00b7bb00bbb7bb0033b7bb0000999999900009999999990000000099999aa9999000099999000009999000000000000000000000
333300000000333333333333bbbbb80033bbb80000bbb800009999900000099999999000a0000009999999990000099999000009999000000000000000000000
0000000000000000000000003330000000000000000000000099900000000999990000009a000000999999990000099999000009999000000000000000000000
000000000000000000000000000000000000000000000000009990000000099999a0000099000000099999990000099999a00009999000000000000000000000
00000000000000000000000000000000000000000000000000999a0000000999999aa00099a00000009999990000099999900009999a00000000000000000000
00000000000000000000000000000000000000000000000000099900000000990099900a99900000000099900000009999900000999900000000000000000000
000000000000000000000000000000000000000000000000000999a00000009900099aa999900000000000000000009999000000099900000000000000000000
00000000000000000000000000000000000000000000000000099990000000990000999999000000000000000000000000000000009900000000000000000000
0000000000000000000000000000000000000000007bb70000099999000000990000999990000000000000000000000000000000000900000000000000000000
000000000000000000000000000000000000000000b88b0000000000000000000000000000000000066000006000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000055000006000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000006666660060000060000066000006006600006666660000000000000000000000000
00000000000000000000000000000000000000000000000000000000000066555550066000060000655600006066500006555550000000000000000000000000
00000000000000000000000000000000000000000000000000000000000065000000066600060000600600006665000006000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000066666600065560060006600660006666000006666000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000055555600060056660066566566006556600006555000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006600060005660065055056006005660006000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000666666500060000560060000006006000556006666660000000000000000000000000
00000000000000000000000000000000000000000000000000000000000555555000050000050050000005005000005005555550000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000cccc0000000ccc00000000000000cc000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000000
ccccccccc000cccccccc0000000000cccc00c0000000000000000000000000c10c00000000000000000000000000000000000000000000000000000000000000
c111111cc00cccccccccccc000000cccccc01cc0000000000000000000000c11cc00000000000000000000000000000000000000000000000000000000000000
c11111ccc001ccccc11111ccc000ccc22ccc11cc00000000000000000000cc1cc100000000000000000000000000000000000000000000000000000000000000
cc000ccc10011cccc111111ccc0ccc2222ccc11cc000000000c00000000cc10cc100000000000000000000000000000000000000000000000000000000000000
1c00ccc110001ccc10000cccc1cccc2222cccc1cccc000000ccc000000ccc1ccc000000000000000000000000000000000000000000000000000000000000000
1ccccccccc000ccc100ccccc1ccccccccccccc11cccc0000ccccc0000ccc1ccc1000000000000000000000000000000000000000000000000000000000000000
0cc1111111c00ccccccccc11ccccc111111cccc11cccc00ccccccc00cccc1ccc1000000000000000000000000000000000000000000000000000000000000000
01cc111111cc0cccccc1111ccccc11111111cccc11cccc0ccc1ccc0cccc1cccc0000000000000000000000000000000000000000000000000000000000000000
01ccc0000ccc0ccccccc11ccccc1100000011cccc11cccccc111ccccccc1ccc10000000000000000000000000000000000000000000000000000000000000000
00ccc000ccc10cc11ccccc1ccccccccccccccccccc11ccccc101cccccc1cccc10000000000000000000000000000000000000000000000000000000000000000
00cccc0ccc11ccc1100cccc1ccc1111111111cccccc11ccc10001cccc1ccccccc000000000000000000000000000000000000000000000000000000000000000
001cccccc110cc1000c11ccc1111111111111111cccc11c1100011cc1cccccccccccc00000000000000000000000000000000000000000000000000000000000
001ccccc110ccc100cccc11ccc1000000000011111cc0111000001c11111cccccccccccc00000000000000000000000000000000000000000000000000000000
000ccc11100cc100c11111111ccc0000000000001111c0100000001101111111111ccccccc000000000000000000000000000000000000000000000000000000
000cc111000c110011111001111cc0000000000000111c0000000010000011111111111111c00000000000000000000000000000000000000000000000000000
000c1100000110001000000001111c00000000000000110000000000000000000001111111100000000000000000000000000000000000000000000000000000
00011000000100000000000000011100000000000000010000000000000000000000000000100000000000000000000000000000000000000000000000000000
00010000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001315013150141501415014150141501415015150161501715018150191501a1501b1501e1501f1502215022150231502415025150261502615027150291502a1502b1502d1502f150301503215034150
000800003b6703a6603b0603816039060380503705034150321503505030150340502e150320502b1503005026250271502e050231502c050201502a0501e1501d1501a4401d340184401d3301b3301742014420
010d0020030030c0730f3000c0730000024675246000c073000000c073000000c0730000024675246050c073000000c073000002460000000246750c0000c073000000c073000002460000000246752460500000
010d00200e40000000000000e42000000104200000011420000000e420000000e4200000000000000001042000000104200000000000134000000000000134200000013420000000000000000000000000000000
010d01202670026740267402674026740267302673026730267302672026720267202672026720267102671026710297000000029700000000000000000000000000029720287002872000000267200000029720
011000002543529400284350000025435000002543500000274203542037420324203042037420394203042000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 02034444
00 41020344
00 41020344
00 41020344
00 41020304
00 41020304
00 41020304
02 41020304
03 41024344

