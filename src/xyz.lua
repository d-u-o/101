-- vim: ft=lua ts=2 sw=2 sts=2 et:cindent:formatoptions+=cro
--------- --------- --------- --------- --------- ---------

if not use then dofile '../use' end

use 'src/num.lua'
use 'src/sym.lua'

-- ## Example 
-- This code handles tables of data, like the following.
--
--     outlook, $temp, <humid, wind, !play
--     over,	64,	65,	TRUE,	yes
--     over,	64,	65,	TRUE,	yes
--     over,	72,	90,	TRUE,	yes
--     over,	83,	86,	FALSE,	yes
--     sunny,	69,	70,	FALSE,	yes
--     sunny,	69,	70,	FALSE,	yes
--     rainy,	65,	70,	TRUE,	no
--     sunny,	75,	70,	TRUE,	yes
--     sunny,	75,	70,	TRUE,	yes
--     sunny,	85,	85,	FALSE,	no
--     rainy,	71,	91,	TRUE,	no
--     rainy,	70,	96,	FALSE,	yes
--     rainy,	70,	96,	FALSE,	yes
--
-- Note that first row describes each columns.
-- The special sympols `$<>!` will be defined below.
--
-- Tables can be created two ways
--
-- - From ram data: using the function `header` and `row` to handle
--   the first, then subsequent lines
-- - From disk data: using `rows` which internally calls `header` and `row`.
--
-- These functions are discussed further, below.
--
-- ## Inside  a `data`
--
-- A `data` object holds lists of various things, including `rows` of the actual data
-- plus some meta knowledge. 
--
-- - E.g. `name[c]` is the name of column `c`. 
-- - Some columns are goals we want to achienge and each of
--   those has a weight `w` (and `w[c]==-1` means _minimize_
--   and w[c]==1 means _maximize_).
-- - `Data` may have one (and only) one `class` column.

function three() return {id=id(), x={},y={},z={}} end

function xyz(header)
  return {show=nil, header=header, 
          at={map={},xnums={},yums={},class=nil}
          meta=three(),  
          all={} } 
end

local function null(_)      return {} end
local function nullAdd(t,x) return x end
local function nullSub(t,x) return x end

local function where(t)
  if   t.txt:match(":") then return "z" 
  else return x.txt:match("[<>%!]") and "y" or "x" end 
end

local function ignorep(t) return t.txt:find("?")  ~= nil end
local function classp(t)  return t.txt:match("!") ~= nil end
local function weight(t)  return t.txt:match("<") and -1 or 1 end
local function nump(t)    return t.txt:match("[<>%$]") ~= nil end

local function about(t)
  if     t.where == "z" then return null(), nullAdd 
  elseif nump(t.txt)    then return num(),  numAdd 
  else   return sym(), symAdd end
end

local function column(t, new,add)
  new,add = about(t)
  new.add = add
  new.txt = t.txt
  new.w   = weight(t)
  return new
end

local function xyz0(aXyz,cells,       pos,m,to,t)
  aXyz = aXyz or xyz(cells)
  if aXyz.show then show(cells) end
  aXyz.header = cells
  to=0
  for from,txt in pairs(cells) do
    if not ignorep(txt) then
      to       = to + 1
      t        = {from=from, to=to, txt=txt}
      t.where  = where(t)
      t.about  = column(t)
      m        = aXyz.meta[t.where]
      t,pos    = w == "z" and txt or #m+1
      m[t.pos] = t.about
      push(aXyz.at.map, t)
      if classp(txt) then aXyz.at.class = t end 
      if w=="x" then
          push( nump(txt) and aXyz.at.xnums or aXyz.at.xsyms,
                t) end end end
  return aXyz
end

function flatten3(aXyz,one)
  return map(aXyz,at.map, function (x) return 
             one[x.where][x.to] end)
end

function xyzAdd(aXyz,cells,     new,val)
  if aXyz.show then show(cells)  end
  new = three()
  for _,t in pairs(aXyz.at.map) do
    val = cells[t.from]
    if not ignorep(val) then
      val = tonumber(val) or val
      t.about.add(t.about, val)
      new[t.where][t.pos] = val end end
  aXyz.all[ #aXys.all + 1 ] = new
  return aXyz
end  

function clone(old, all,   data1)
   new = xyz0(old.header)
   for _,cells in pairs(all or aXyz.all) do 
     xyzAdd(new, cells) end
   return new
end

local function xyzsRead(file, aXyz,f0,f,   stream,first,line,cells)
  stream = file and io.input(file) or io.input()
  aXyz   = aXyx or xyz()
  f0     = f0 or xyz0, 
  f      = f or xyzAdd
  line   = io.read()
  first  = true
  while line do
    line= line:gsub("[\t\r ]*","")
              :gsub("#.*","")
    cells = split(line)
    line = io.read()
    if #cells > 0 then
      if first then f0(aXyz,cells) else f(aXyz,cells) end end
      first = false
  end 
  io.close(stream)
  return aXyz
end

return arg[0]:find('xyz.lua$') and xyzRead() or xyzRead
