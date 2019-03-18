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

function data(header)
  return {class=nil,  show=nil, names={}, name=header, xyz={}, nums={}, syms={},
          x={}, y={},z={},  rows={} } 
end

function xyz() return {x={}, y={}, z={}} end

function row() return {id=id(), x={}, y={}, z={}  } end

function null(_)      return {} end
function nullAdd(t,x) return x end
function nullSub(t,x) return x end

local function cell(r,val,what,pos,add)
  if val ~= "?" then
    val = tonumber(val) or val
    r[what][pos] = val
    add( about, val) end 
end

local function column(t,c,txt,    pos,what,add,about,tmp)
  what = "x"
  if txt:match(":")      then what = "z" end
  if txt:match("[<>%!]") then what = "y" end
  pos = #t[what] + 1
  about,add = null(), nullAdd
  if what ~= "z" then
    if txt:match("[<>%$]") 
    then about,add = num(),numAdd 
         if what == "x" then t.nums[pos] = pos end
    else about,add = sym(),symAdd
         if what == "x" then t.syms[pos] = pos end
  end end
  tmp= {
    txt=    txt, 
    pos=    pos,
    what=   what,
    about=  about, 
    nump=   add == numAdd,
    classp= txt:match('!') ~= nil,
    add=    function (r,z) cell(r,z,what,pos,add) end
  }
  if txt:match("!") then t.classp = tmp end
  t[what][put]   = tmp
  t.nameHas[txt] = tmp
  t.has[c]       = tmp
end

function header(cells,d,       c,w)
  if d.show then show(cells) end
  d = t or data(cells))
  d.header=cells
  for c,txt in pairs(cells) do
    if not x:match("%?")  then column(d,c,txt) end end
  return t
end

function rowAdd(t,cells,     r,val)
  if t.show then show(cells)  end
  r= row()
  for c,xyz in pairs(t.xyz) do xyz.add(r, cells[c]) end
  t.rows[ #t.rows + 1 ] = r
  return t
end  

function clone(data0, rows,   data1)
   data1 = header(data0.header)
   for _,cells in pairs(rows or data0.rows) do 
     rowAdd(data1, cells) end
   return data1
end

function rows1(stream, t,f0,f,   first,line,cells)
  first,line = true,io.read()
  while line do
    line= line:gsub("[\t\r ]*","")
              :gsub("#.*","")
    cells = split(line)
    line = io.read()
    if #cells > 0 then
      if first then f0(cells,t) else f(t,cells) end end
      first = false
  end 
  io.close(stream)
  return t
end

function rows(file,t,f0,f,      stream,txt,cells,r,line)
  return rows1( file and io.input(file) -- reading from some specified file
                      or io.input(),    -- reading from standard input
                t  or data(), f0 or header, f or rowAdd) end 
