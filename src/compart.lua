-- vim: ft=lua ts=2 sw=2 sts=2 et:cindent:formatoptions+=cro
--------- --------- --------- --------- --------- ---------

if not use then dofile '../use' end

use 'src/lib.lua'

function T(txt,init,lo,hi)
  return { txt  = txt, 
           init = init or 0,
           lo   = lo or 0, 
           hi   = hi or 100 }
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
  t.all     = appends(t.stock,t.flow,t.aux)
  t.vals    = {}
  for pos,thing in pairs(t.all) do
    t.vals[thing.txt] = 0
  end
  return t
end

function thingsRun(t)
end


Diapers = {T{
class Diapers(Model):
  def have(i):
    return Things(C = S('clean diapers',100), 
                  D = S('dirty diapers', 0),
                  q = F('cleaning rate',0),  
                  r = F('poop rate',8), 
                  s = F('resupply',0))
  def step(i,dt,t,u,v):
    def saturday(x): return int(x) % 7 == 6
    v.C +=  dt*(u.q - u.r)
    v.D +=  dt*(u.r - u.s)
    v.q  =  70  if saturday(t) else 0 
    v.s  =  u.D if saturday(t) else 0
    if t == 27: # special case (the day i forget)
      v.s = 0

if __name__ == "__main__":
    Diapers().run(tmax=70)


