-- vim: ts=2 sw=2 sts=2 expandtab:cindent:formatoptions+=cro   
--------- --------- --------- --------- --------- ---------  

require "lib"
require "num"
require "sym"
require "rows"

-- This code rewrites the contents of
-- the numeric independent variables as ranges (e.g. 23:45).
-- Such columns `c` are sorted then explored for a `cut` where
-- the expected value of the variance after cutting is 
-- minimized. Note that this code endorses a cut only if:
--
-- - _Both_ the expected value of
--   the standard deviation of `c` and the goal column
--   `goal` are  minimized
-- - The minimization is create than some trivially
--   small change (defaults to 5%, see `Lean.super.margin`);
-- - The number of items in each cut is greater than 
--   some magic constant `enough` (which defaults to
--   the square root of the number of rows, see
--   `Lean.super.enough`)
--
-- After finding a cut, this code explores both 
-- sides of the cut for recursive cuts.
-- 
-- Important note: this code **rewrites** the table
-- so the only thing to do when it terminates is
-- dump the new table and quit.

function rank(data,goal,enough,       
              rows,doms,label,seen)
  rows  = data.rows
  label = label or #(rows[1]) 
  goal  = goal  or label - 1
  seen,all={},{}
  for _,c in pairs(data.indeps) do
    for r=1,#rows do
      local v = rows[r][c]
      local this = c .. "=" .. v
      if not seen[this] then
        n = num(this)
        n.c= c
        n.v= v
        all[#all+1] = n
        seen[this] = #all
      end
      local tmp= all[ seen[this] ]
      numInc(tmp, rows[r][goal])
    end
  end
  all=ksort("mu",all)       
  for i,one in pairs(all) do
    print(i,one.c, one.v, one.mu)
  end
end

-- Main function, if this is called top-level.

return {main=function() return rank(rows()) end}
