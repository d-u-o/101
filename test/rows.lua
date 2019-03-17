-- vim: ts=2 sw=2 sts=2 expandtab:cindent:formatoptions+=cro 
--------- --------- --------- --------- --------- --------- 

if not use then dofile '../use' end

use "src/lib.lua"
use "src/ok.lua"
use "src/rows.lua"

ok { rows = function (    d) 
    d=rows("../test/data/weather.csv") 
    print(#d._use)
    assert(#d._use == 4)
    assert(d.nums[2].lo == 64)  end }
