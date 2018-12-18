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

function best(data,goal,enough,       
              rows,doms,label)
  rows   = data.rows
  label  = label or #(rows[1]) 
  goal   = goal  or label - 1

  local function best1(  seen,all,tmp)
	  seen,all={},{}
	  for _,row in pairs(data.rows)  do
	    local label1= row[label]
	    local goal1 = row[goal]
	    if not seen[label1] then
	      all[#all+1]  = num(label1)
	      seen[label1] = #all 
	    end
	    local tmp =  all[ seen[label1] ]
	    numInc(tmp, goal1)
	  end
	  return ksort("mu",all)[#all]
  end
end

-- Main function, if this is called top-level.

return {main=function() return best(rows()) end}
