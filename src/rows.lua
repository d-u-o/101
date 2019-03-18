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
  return {show=nil, header=header, 
          at={names={},cols={},nums={}, syms={},class=nil}
          x={}, y={},z={},  rows={} } 
end

function row() return {id=id(), x={}, y={}, z={}  } end

function null(_)      return {} end
function nullAdd(t,x) return x end
function nullSub(t,x) return x end

local function cell(r,val,where,pos,add)
  local function where(txt)
  if     txt:match(":")      then return "z" 
  elseif txt:match("[<>%!]") then return "y"
  else                            return "x"
end

local function about(w)
  if     w.where == "z" then return null() 
  elseif w.nump         then return num()
  else                       return sym()
end

local function add1(w)
  if     w.where == "z" then return nullAdd
  elseif w.nump         then return numAdd
  else                       return symAdd
  end
end

local function add(w,     where,pos,add)
  where = w.where
  pos   = w.pos
  add   = add1(w)
  return function(r,val) 
           if val ~= "?" then
              val = tonumber(val) or val
              r[where][pos] = val
              add(about,val) end 
end

local function column(t,c,txt,    w,}
  w        = {name=txt, pos=c}
  w.nump   = txt:match("[<>%$]") ~= nil 
  w.classp = txt:match('!')      ~= nil
  w.where  = where(txt,w)
  w.pos    = #t[w.where] + 1
  w.about  = about(w)
  w.add    = add(w)
  if t.where ~= "z" then
     if t.nump then t.at.nums[w.pos] = w else t.at.syms[w.pos] = w end
  end
  t[where][pos] = w
  t.at.names[txt] = w
  t.at.cols[c]   = w
  if w.classp then t.at.classp = w end
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
