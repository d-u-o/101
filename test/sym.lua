-- vim: ts=2 sw=2 sts=2 expandtab:cindent:formatoptions+=cro 
--------- --------- --------- --------- --------- --------- 

if not use then dofile '../use' end

use "src/sym.lua"
use "src/ok.lua"

ok  { baseSym=function(  s)
	s=syms{ 'y','y','y','y','y','y','y','y','y',
	        'n','n','n','n','n'}
	assert( close( symEnt(s),  0.9403) )
end }

ok { inc=function(        s,datas,data,syms,kept) 
  datas,kept = {},{}
  rseed(1)
  syms={"a","b","c","d","e","f","g","h","i","j","k","l"}
  for i=1,20 do
    data={}
    datas[ i ] = data
    for j=1,20 do data[j] = any(syms) end end
  s= sym()
  for i=1,20 do
    map(datas[i], function (z) symAdd(s, z) end)
    kept[i] = symEnt(s)
  end
  for i=20,3,-1 do
    assert(symEnt(s) == kept[i])
    map(datas[i], function (z) symSub(s, z) end)
  end
end }
