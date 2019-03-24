-- vim : ft=lua ts=2 sw=2 sts=2 et : cindent : formatoptions+=cro
--------- --------- --------- --------- --------- --------- ---------

function str(t,pre,   s, keys, v)
  s, keys = "{",{}
  for key,_ in pairs(t) do keys[#keys+1] = key end
  table.sort(keys)
  for _, k in pairs(keys) do
    v = t[k]
    if not (type(k)== "string" and k:match("^_")) then
      if type(k)   == "string"   then s = s..":"..k.." " end
      if type(v)   == "function" then s = s.."()" end
      if type(v)   == "table"    then s = s..str(v)
      else                          s = s..tostring(v)
      end
      s =  s .. " "
    end
  end
  if s ~= "{" then s = s:sub(1, s:len()-1) end
  return (pre or '') .. s.."}"
end

--------- --------- --------- --------- --------- ---------
local oids = 0
local function id() oids = oids+1; return oids end

local Object={}

function Object:new()
  local o =  {}
  self.__index  = self
  setmetatable(o, self)
  o:init()
  return o
end

function Object:xtras()
  local mt      = getmetatable(self)
  mt.__sub      = self.sub
  mt.__add      = self.add
  mt.__tostring = self.str
end

function Object:init()
  self.oid = id()
  self:xtras()
end

function Object:str()  return str(self) end
function Object:add()  assert(false,"missing method") end
function Object:sub()  assert(false,"missing method") end
function Object:ako(x) return getmetatable(self) == x end
--------- --------- --------- --------- --------- ---------

local Thing=Object:new()

function Thing:init()
   Object.init(self)
   self.w, self.n = 1,0
end

function Thing:adds(t, f)
  f = f or function (z) return z end
  for _,v in pairs(t) do self:add( f(v) ) end 
  return self
end

function Thing:add(x)
  if x=="?"  then return x end
  self.n = self.n + 1
  return self:add1(x) 
end

function Thing:sub(x)
  if x=="?"  then return x end
  if self.n < 3    then return x end
  self.n = self.n - 1
  return self:sub1(x) 
end

local Num=Thing:new()

function Num:init()
   Thing.init(self)
   self.sub={a={1,2,3},b={4,5,6}}
   self.lo = 1/0
   self.hi = -1/0
   self.mu, self.m2 = 0,0
end

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
--------- --------- --------- --------- --------- ---------

if isMain('account.lua')  then
  local m= Num:new()
  print(m:ako(Num))
  for i=1,10^6 do
    m=  m + i
  end
  print(m)
end
