-- vim: ts=2 sw=2 sts=2 expandtab:cindent:formatoptions+=cro 
--------- --------- --------- --------- --------- --------- 

if not use then dofile '../use' end

use "src/num.lua"
use "src/ok.lua"

ok {numOkay = function(    n,t)
  n = nums{ 
       4,  10, 15, 38, 54, 57, 62, 83, 100,100,174,190,215,225,
       233,250,260,270,299,300,306,333,350,375,443,475,
       525,583,780,1000}
  assert(close(n.mu, 270.3  ))
  assert(close(n.sd, 231.946))
end}

ok { inc=function( tmp,n, datas,data,syms,kept) 
  datas,kept = {},{}
  rseed(1)
  for i=1,20 do
    data={}
    datas[ i ] = data
    for j=1,20 do data[j] = rand() end end
  n = num()
  for i=1,20 do
    map(datas[i], function (z) numAdd(n, z) end)
    kept[i] = n.sd
  end
  for i=20,1,-1 do
    tmp = n.sd/kept[i] 
    assert( 0.999 <= tmp and tmp <= 1.001)
    map(datas[i], function (z) numSub(n, z) end)
  end
end }
