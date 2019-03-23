-- vim: ft=lua ts=2 sw=2 sts=2 et:cindent:formatoptions+=cro
--------- --------- --------- --------- --------- ---------

function str(t,pre,   result, keys, v)
  result, keys = "{",{}
  for key,_ in pairs(t) do keys[#keys+1] = key end
  table.sort(keys)
  for _, k in pairs(keys) do
    v = t[k]
    if not (type(k) == "string" and k:match("^_")) then
      if   type(k) == "string"  then result = result..":"..k.." " end
      if   type(v) == "table"   then result = result..str(v)
      else                           result = result..v
      end
      result =  result .. " "
    end
  end
  if result ~= "{" then result = result:sub(1, result:len()-1) end
  return (pre or '') .. result.."}"
end

--------- --------- --------- --------- --------- ---------
function xtras(self)
  self.__sub      = self.sub
  self.__add      = self.add
  self.__tostring = self.str
end

local Object={}

function Object:new()
  local o =  {}
  self.__index  = self
  setmetatable(o, self)
  o:init()
  return o
end

local ids = 0
function Object:init()
  ids = ids + 1
  self.id = ids
  xtras(self)
end

--------- --------- --------- --------- --------- ---------

local Thing=Object:new()
function Thing:str() return str(self,'thing') end

function Thing:init()
    Object.init(self)
    self.w, self.n = 1,0
end
-- 
function Thing:nump() return false end

function Thing:adds(t, f)
  f = f or function (z) return z end
  for _,v in pairs(t) do self:add( f(v) ) end 
  return self
end

function Thing:add(x)
  if x=="?"  then return x end
  self.n = self.n + 1
  self._p=22
  return self:add1(x) 
end

function Thing:prep(x) return x end

function Thing:sub(x)
  if x=="?"  then return x end
  if self.n < 3    then return x end
  self.n = self.n - 1
  return self:sub1(x) 
end

local Num= Thing:new()
function Thing:str() return  str(self,'num') end

function Num:init()
   Thing.init(self)
   self.sub={a={1,2,3},b={4,5,6}}
   self.lo = 1/0
   self.hi = -1/0
   self.mu, self.m2 = 0,0
end

function Num:nump() return true end

function Num:sd()
  return (self.m2/(self.n - 1 + Burn.zip))^0.5  
end

function Num:add1(x)
  local d = x - self.mu
  self.mu = self.mu + d/self.n
  self.m2 = self.m2 + d*(x - self.mu)
  if    x > self.hi then self.hi = x end
  if    x < self.lo then self.lo = x end
  return self
end

function Num:sub1(x)
  local d = x - self.mu
  self.mu = self.mu - d/self.n
  self.m2 = self.m2 - d*(x - self.mu)
  return self
end

local function isMain(x)
   return arg and tostring(arg[0]):match('^'.. x ..'$') end

if isMain('account.lua')  then
  local m= Num:new()
  m.sub.a[1]=100
  for i=1,100 do
    m=  m + i
  end
  --print(m)
  --print(Num:new())
  local j = 0
  --for i=1,10^6 do j=j+i;Num:new() end
  for i=1,10^6 do j=i end
  print(j)
end

