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

function null(_)      return {} end
function nullAdd(t,x) return x end
function nullSub(t,x) return x end

local function where(txt)
  if   txt:match(":") then return "z" 
  else return txt:match("[<>%!]") and "y" or "x" end 
end

local function nunp(txt)
    return  txt:match("[<>%$]") ~= nil 
end

local function about(w,txt)
  if     w == "z"  then return null(), nullAdd 
  elseif nump(txt) then return num(), numAdd 
  else   return sym(), symAdd end
end

local function weight(txt)
  return  txt:match("<") and -1 or 1 
end

function column(w,txt, new,add)
  new,add = about(w,txt)
  new.add = add
  new.txt = txt
  new.w   = weight(txt)
  return new
end

function xyz0(aXyz,cells,       to,w,a,m,pos,tmp)
  aXyz = aXyz or xyz(cells))
  if aXyz.show then show(cells) end
  aXyz.header = cells
  to = 0
  for from,txt in pairs(cells) do
    if txt:find("?") ~= nil then
      w     = where(txt)
      a     = column(w,txt)
      m     = aXyz.meta[w]
      to    = to+1
      pos   = #m+1
      pos   = w == "z" and txt or pos
      m[pos]= a
      tmp   = {from=from,to=to,where=w,txt=txt,pos=pos,about=a} 
      push(aXyz.at.map, tmp)
      if txt:find("!") then aXyz.at.class = tmp end 
      if w=="x" then
          push( nump(txt) and aXyz.at.xnums or aXyz.at.xsyms,
                tmp) end end end
  return aXyz
end

function flatten3(aXyz,three,out)
  return map(aXyz,at.map, function (x) return 
             three[x.where][x.to] end)
end

function xyzAdd(aXyz,cells,     one,map,val)
  if aXyz.show then show(cells)  end
  one = three()
  map = aXyz.at.map
  for _,x in pairs(aXyz.at.map) do
    val = cells[x.from]
    if val ~= '?' then
      val = tonumber(val) or val
      x.about.add(x.about, val)
      one[x.where][x.pos] = val end end
  aXyz.all[ #aXys.all + 1 ] = one
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
