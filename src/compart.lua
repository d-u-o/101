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
  t.all     = append(t.stock,t.flow,t.aux)
  t.vals    = {}
  for pos,thing in pairs(t.all) do
    t.vals[thing.txt] = 0
  end
  return t
end

function thingsRun(lst, opt, col)
    lst[what][pos] = head
end
