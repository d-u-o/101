-- vim : ft=lua ts=2 sw=2 sts=2 et : cindent : formatoptions+=cro
-- Duo101 copyright (c) 2018,2019 Tim Menzies, timm@ieee.org 
-- All rights reserved, opensource.org/licenses/BSD-3-Clause
--------- --------- --------- --------- --------- --------- ---------

function Duo0() return  {
  ignore   = "?",
  cohen    = 0.2,
  distance = {k=1, p=2, kernel="triangle", samples=64},
  dom      = {samples=100}, 
  domtree  = {enough=0.5},
  enough   = 100,
  fft      = {min=4},
  label    = {enough=0.5, cohen=0.3, margin=1.05},
  nb       = {m=2, k=1,enough=20},
  num      = {p=2},
  random   = {seed = 10013},
  sample   = {max=512}, 
  sk       = {cohen=0.2,
              conf = 95}, 
  stats    = {conf = 95,
              bootstraps = 375,
              cf = ({0.147,0.33,0.474})[1]}, 
  super    = {enough=0.5, cohen=0.3, margin=1.05},
  tiles    = {width = 50,
              chops = {{0.05,"-"},
                        {0.25," "},
                        {0.5," "},
                        {0.75,"-"},
                        {0.95," "}},
               bar  = "|",
               star = "*",
               num  = "%5.3f",
               sym  = "%20s"}, 
} end

Duo = Duo0()
