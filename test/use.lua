-- vim : ft=lua ts=2 sw=2 sts=2 et : cindent : formatoptions+=cro
-- Duo101  copyright (c) 2018,2019 Tim Menzies, timm@ieee.org 
-- All rights reserved, opensource.org/licenses/BSD-3-Clause
--------- --------- --------- --------- --------- --------- ---------

do 
  local root = '../'
  local seen = {}
  function use(f, show)
    if not seen[f] then 
      if show then io.stderr:write('-- ' .. f .. '\n') end
      seen[f] = dofile(root .. f)
    end 
    return seen[f]
  end 
end
