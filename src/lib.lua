-- vim : ft=lua ts=2 sw=2 sts=2 et : cindent : formatoptions+=cro
-- Duo101  copyright (c) 2018,2019 Tim Menzies, timm@ieee.org 
-- All rights reserved, opensource.org/licenses/BSD-3-Clause
--------- --------- --------- --------- --------- --------- ---------

require 'use' 
use 'src/config.lua'

--------- --------- --------- --------- --------- --------- ---------
-- ## Unique ids

do 
  local oids = 0
  function id() oids = oids+1; return oids end
end

--------- --------- --------- --------- --------- --------- ---------
-- ## String Stuff

function fmt(f,s) return string.format(f,s) end

function split(s, sep,    t,notsep)
  t, sep = {}, sep or ","
  notsep = "([^" ..sep.. "]+)"
  for y in string.gmatch(s, notsep) do t[#t+1] = y end
  return t
end

function fy(x)  io.stderr:write(x) end
function fyi(x) io.stderr:write(x .. "\n") end

function gsub(s,a,b,  _)
  s,_ = string.gsub(s,a,b)
  return s
end

--------- --------- --------- --------- --------- --------- ---------
-- ##  Random Stuff

do
  local seed0     = Duo.random.seed
  local seed      = seed0
  local modulus   = 2147483647
  local multipler = 16807
  function rseed(n) seed = n or seed0 end
  function rand() -- park miller
    seed = (multipler * seed) % modulus
    return seed / modulus end
end

-- function another(x,t,     y)
--   y = cap(math.floor(0.5+rand()*#t),1,#t)
--   if x==y then return another(x,t) end
--   if t[y] then return t[y] end
--   return another(x,t)
-- end

function any(t,    x)
  return t[ cap(math.floor(0.5+rand()*#t),1,#t) ]
end

--------- --------- --------- --------- --------- ---------  --------- 
-- ## Table Stuff

function first(t)  return t[ 1] end
function second(t) return t[ 2] end
function last(t)   return t[#t] end

function push(t, a)
  t[#t+1]=a
  return a
end

function appends(...)
  local t={}
  for _,x in pairs{...} do
    for _,y in pairs(x) do
      t[#t+1] = y end end
  return t
end

function member(x,t)
  for _,y in pairs(t) do if y==x then return true end end
  return false
end

function map(t1,f,    t2)
  t2 = {}
  for i,v in pairs(t1) do t2[i] = f(v) end
  return t2
end

function copy(t) -- actually, deepCopy
  if type(t) ~= "table" then return t end
  return map(t, copy)
end

function splice(t,m,n,f,    u)
  f = f or function(x) return x end
  m = m or 1
  n = n or #t
  if n > #t then n=#t end
  u = {}
  for i=m,n do u[ #u+1 ]= f(t[i]) end
  return u
end

--------- --------- --------- --------- --------- ---------  --------- 
-- ## Table Sorting Stuff

function sorted(t,f)
  table.sort(t,f)
  return t
end

function shuffle( t )
  for i= 1,#t do
    local j = i + math.floor((#t - i) * rand() + 0.5)
    t[i],t[j] = t[j], t[i] end
  return t
end

function ksort(k,t, reverse,  f) 
  reverse = reverse and reverse or false
  f=function(x,y)
       x,y=x[k], y[k]
       if     x=="?" then return false
       elseif y=="?" then return true
      else return x<y end end
  table.sort(t,f)
  return t
end  

function ordered(t,  i,keys)
  i,keys = 0,{}
  for key,_ in pairs(t) do keys[#keys+1] = key end
  table.sort(keys)
  return function ()
    if i < #keys then
      i=i+1; return keys[i], t[keys[i]] end end 
end

--------- --------- --------- --------- --------- ---------  --------- 
-- ## Table Printing Stuff

cat  = table.concat
show = function (t) print(table.concat(t,",")) end

function dump(a,sep)
  for i=1,#a do print(cat(a[i],sep or ",")) end
end

-- Print a nested table, one line per item, with indents
function o(t,    indent,   formatting)
  indent = indent or 0
  for k, v in ordered(t) do
    if not (type(k)=='string' and k:match("^_")) then
      formatting = string.rep("|  ", indent) .. k .. ": "
      if type(v) == "table" then
        print(formatting)
        o(v, indent+1)
      else
        print(formatting .. tostring(v)) end end end
end

-- Print a nested table, on one line
function str(t,pre,   s)
  s = "{"
  for k, v in ordered(t)  do
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

-- Print a 2d matrix, columns lined-up
function cols(t,     numfmt, sfmt,noline,w,txt,sep)
  w={}
  for i,_ in pairs(t[1]) do w[i] = 0 end
  for i,line in pairs(t) do
    for j,cell in pairs(line) do
      if type(cell)=="number" and numfmt then
        cell    = fmt(numfmt,cell)
        t[i][j] = cell end
      w[j] = max( w[j], #tostring(cell) ) end end
  for n,line in pairs(t) do
    txt,sep="",""
    for j,cell in pairs(line) do
      sfmt = "%" .. (w[j]+1) .. "s"
      txt = txt .. sep .. fmt(sfmt,cell)
      sep = ","
    end
    print(txt)
    if (n==1 and not noline) then
      sep="#"
      for _,w1 in pairs(w) do
        io.write(sep .. string.rep("-",w1)  )
        sep=", " end
      print("") end end
end

--------- --------- --------- --------- --------- ---------  --------- 
-- ## Num Stuff

function max(x,y) return x>y and x or y end
function min(x,y) return x<y and x or y end
function abs(x) return x<0 and -1*x or x end

function close(x,y,  c)
  c=c or 0.01
  return assert(math.abs((x-y)/x) < c)
end

int = function(x) return math.floor(0.5 + x) end

function cap(x, lo, hi)
  return min(hi, max(lo, x))
end

--------- --------- --------- --------- --------- --------- ---------
-- Object stuff

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
function Object:ako(x) return getmetatable(self) == x end
function Object:add()  assert(false,"implemented by subclass") end
function Object:sub()  assert(false,"implemented by subclass") end

--------- --------- --------- --------- --------- --------- ---------
-- Testing stuff

function rogues(    ignore)
  ignore = {jit=true, utf8=true, math=true, package=true,
            table=true, coroutine=true, bit=true, os=true,
            io=true, bit32=true, string=true, arg=true,
            debug=true, _VERSION=true, _G=true }
  for k,v in pairs( _G ) do
    if type(v) ~= "function" and not ignore[k] then
      if k:match("^[^A-Z]") then
        fyi("-- rogue variable: ["..k.."]") end end end
end

function off(t) return t end

do
  local tries, fails = 0,0
  function okReport( x)
    x = (tries-fails)/ (tries+10^-64)
    return math.floor(0.5 + 100*(1- x)) end

  function ok(t,  n,score,      passed,err,s)
    for x,f in pairs(t) do
      tries = tries + 1
      print("-- Test #" .. tries ..
            " (oops=".. okReport() ..
            "%). Checking ".. x .."... ")
      Duo = Duo0()
      passed,err = pcall(f)
      if not passed then
        fails = fails + 1
        print("-- E> Failure " .. fails .. " of " ..
              tries ..": ".. err) end end
    rogues()
  end
end

--------- --------- --------- --------- --------- --------- ---------
-- Misc stuff

function isMain(x)
  return arg and tostring(arg[0]):match('^'.. x ..'.lua$') 
end

return isMain('lib') and rogues() or Object
