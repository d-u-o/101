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

local function  main (file,   blank,all) 
  all={}
  everything = rows(file and io.input(file) or io.input(),
       data(),
       header, 
       function(t,cells,  k)
         blank = blank or clone(t)
         k     = cells[#cells]
         all[k] = all[k] or clone(blank)
         row(t,cells)
         row(all[k],cells) end)
  goal,most = nil,-1
  best,rest,order = {},{},{}
  for k,t in pairs(all) do -- initialize the best rest tables
    best[k], rest[k] = {},{}
    tmp = t.nums[t.col['>dom']].mu
    if tmp > most then most,goal = tmp,k end 
    for c,_ in pairs(t.name) do
      if indep(t,c) then
        best[k][c] = {}
        rest[k][c] = {} end end end
  for k,t in pairs(all) do -- fill in the best,rest tables
    what = k == goal and best or rest
    for c,sym in pairs(t.syms) do
      if indep(t,c) then
        for x,count in pairs(sym.counts) do
          what[k][c][x]  = (what[k][c][x] or 0) + count end end end end --return rank(all)
  nb = #all[goal].rows
  nr = #everything.rows - nb
  print("nb",nb,"nr",nr)
  o(best)
  o(rest)
  for c,_ in pairs(best[goal]) do
    for x,b in pairs(best[goal][c]) do
      r = rest[goal][c][x] or 0
      print(c,x,b,r)
      b = b/(nb + 0.00001)
      r = r/(nr + 0.00001)
      if b > r then
        order[#order+1] = {b^2/(b+r), c,x} end end end
  ksort(1,order)
  for _,o in pairs(order) do
    print(o[1],o[2],o[3])
  end
end

-- Main function, if this is called top-level.

return {main= main}
