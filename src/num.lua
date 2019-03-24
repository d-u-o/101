-- vim: ft=lua ts=2 sw=2 sts=2 et:cindent:formatoptions+=cro
-- Duo101  copyright (c) 2018,2019 Tim Menzies, timm@ieee.org 
-- All rights reserved, opensource.org/licenses/BSD-3-Clause
-- For examples of usage, see demos, at end.
--------- --------- --------- --------- --------- --------- ---------

local Thing=require('use')('src/thing.lua')
--------- --------- --------- --------- --------- --------- ---------

local Num=Thing:new()

function Num:init()
   Thing.init(self)
   self.lo = 1/0
   self.hi = -1/0
   self.mu, self.m2, self.sd = 0,0,0
end

function Num:sd()
  return (self.m2/(self.n - 1 + 10^-9))^0.5  
end

-- Incremenally, add `x` to a `num`.
-- This is [Welford's algorithm](https://en.wikipedia.org/wiki/Algorithms_for_calculating_variance#Online_algorithm)

function Num:add1(x)
  local d = x - self.mu
  self.mu = self.mu + d/self.n
  self.m2 = self.m2 + d*(x - self.mu)
  if    x > self.hi then self.hi = x end
  if    x < self.lo then self.lo = x end
  self.sd = self:stdev()
end

function Num:sub1(x)
  if (self.n == 1) then return x end
  local d = x - self.mu
  self.mu = self.mu - d/self.n
  self.m2 = self.m2 - d*(x - self.mu)
  self.sd = self:stdev()
end

function Num:stdev()
  return (self.n< 2) and 0 
         or (self.m2/(self.n - 1 + 10^-9))^0.5 
end

function Num:norm(x) 
  return x==Duo.ignore and 0.5 
         or (x-self.lo) / (self.hi-self.lo + 10^-9)
end

function Num:pdf(t,x)
  return math.exp(-1*(x - self.mu)^2/(2*self.sd^2)) *
         1 / (self.sd * ((2*math.pi)^0.5))
end

function Num:xpect(i)  
  local n = self.n + i.n +0.0001
  return self.n/n * self.sd+ i.n/n * i.sd
end

--------- --------- --------- --------- --------- --------- ---------
function Num.demo1(n)
  n=Num:new():adds{ 
    4,10,15,38,54,57,62,83,100,100,174,190,
    215,225,233,250,260,270,299,300,306,
  333,350,375,443,475,525,583,780,1000}
  close(n.mu, 270.3  , 0.0001)
  close(n.sd, 231.946, 0.0001)
end 

function Num.demo2(   m,tmp,n, datas,data,syms,kept) 
  datas,kept = {},{}
  rseed(1)
  m=1000
  for i=1,m do
    data={}
    datas[ i ] = data
  for j=1,m do data[j] = rand() end end
  n = Num:new()
  for i=1,m do
    map(datas[i], function (z) n:add(z) end)
    kept[i] = n.sd
  end
  for i=m,1,-1 do
    tmp = n.sd/kept[i] 
    close(tmp, 1, 0.0001)
    map(datas[i], function (z) n:sub(z) end)
  end
end 

--------- --------- --------- --------- --------- --------- ---------
if   not isMain('num') 
then return Num
else ok { adds = Num.demo1 }
     ok { inc  = Num.demo2 }
end
