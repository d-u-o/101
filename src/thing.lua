-- vim : ft=lua ts=2 sw=2 sts=2 et : cindent : formatoptions+=cro
-- Duo101  copyright (c) 2018,2019 Tim Menzies, timm@ieee.org 
-- All rights reserved, opensource.org/licenses/BSD-3-Clause
--------- --------- --------- --------- --------- --------- ---------
require 'use'
local Object = use 'src/lib.lua'
--------- --------- --------- --------- --------- --------- ---------

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
  if x==Duo.ignore then return x end
  self.n = self.n + 1
  self:add1(x) 
  return x
end

function Thing:sub(x)
  if x==Duo.ignore then return x end
  if self.n < 3    then return x end
  self.n = self.n - 1
  self:sub1(x) 
  return x
end

function Thing:norm(x) return x end

function Thing:sub1()  assert(false,"implemented by subclass") end
function Thing:add1()  assert(false,"implemented by subclass") end

--------- --------- --------- --------- --------- --------- ---------
return isMain('thing') and rogues() or Thing
