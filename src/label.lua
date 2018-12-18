-- vim: ts=2 sw=2 sts=2 expandtab:cindent:formatoptions+=cro 
--------- --------- --------- --------- --------- ---------~

require "lib"
require "num"
require "rows"

function label(data,  enough,rows, most,cohen)
  rows = data.rows
  enough = (#rows)^Lean.label.enough 

  local function band(c,lo,hi)
    if lo==1 then
      return "..".. rows[hi][c]
    elseif hi == most then
      return rows[lo][c]..".."
    else
      return rows[lo][c]..".."..rows[hi][c] end
  end

  local function argmin(c,lo,hi,     l,r,cut,best ,tmp,x)
    if (hi - lo > 2*enough) then
      l,r = num(), num()
      for i=lo,hi do numInc(r, rows[i][c]) end
      best = r.sd
      for i=lo,hi do
        x = rows[i][c]
        numInc(l, x)
        numDec(r, x)
        if l.n >= enough and r.n >= enough then
          if l.hi - l.lo > cohen then
            if r.hi - r.lo > cohen then
            tmp = numXpect(l,r) * Lean.label.margin
            if tmp < best then
               cut,best = i, tmp end end end end end end 
    return cut
  end

  local function cuts(c,lo,hi,pre,       cut,txt,b)
    txt = pre..tostring(rows[lo][c])..".. "..tostring(rows[hi][c])
    cut = argmin(c,lo,hi)
    if cut then
      fyi(txt)
      cuts(c,lo,   cut, pre.."|.. ")
      cuts(c,cut+1, hi, pre.."|.. ")
    else
      b= band(c,lo,hi)
      fyi(txt.." ("..b..")")
      for r=lo,hi do
        rows[r][c+1]=b end end
  end

  local c=#data.name
  ksort(c,rows)
  local all = num()
  for i=1,#data.rows  do numInc(all, rows[i][c]) end
  cohen = all.sd*Lean.label.cohen
  fyi("\n-- ".. data.name[c] .. "----------")
  cuts(c,1,#data.rows,"|.. ") 
  print(cat(data.name,", ") .. ",!klass" )
  dump(rows)
end

return {main=function() return label(rows()) end}
