-- vim: ft=lua ts=2 sw=2 sts=2 et:cindent:formatoptions+=cro
--------- --------- --------- --------- --------- ---------

if not use then dofile '../use' end

use 'src/lib.lua'

function thing(txt,lo,hi)
  return { txt= txt, 
           lo = lo or 0, 
           hi = hi or 100 }
end

function restrain(t,x)
  return max(t.lo, min(t.hi, x))
end

S,A,G = thing, thing, thing

function things(t,      i,j,y)
  t         = t or {}
  t.dt      = opt.dt  or 1
  t.max     = opt.max or 30
  t.verbose = opt.verbose or true
  t.aux     = t.aux or {}
  t.flow    = t.flow or {}
  t.stock   = t.stock or {}
  t.aux     = ksort("txt", t.aux)
  t.flow    = ksort("txt", t.flow)
  t.stock   = ksort("txt", t.stock)
  t.txt,sep = "",""
  thingsLabels(t,function(i,j,y) 
    t.xt  = t.txt .. sep .. y.txt
    sep   = ","
  end)
  return t
end

function thingsLabel(lst, f)
  for i,x in pairs {"stock","flow","aux"} do
    for j,y in pairs(lst[x]) do
      f(i,j,y)
  end end 
end

function thingsRun(lst, opt, col)
    lst[what][pos] = head
end
