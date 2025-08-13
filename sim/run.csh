#!/bin/csh 

set cov = 0

make clean

if( ($#argv > 0) && ("$1" == "cov") ) then
    set cov = 1
endif

foreach pat (`cat pat.list | sed '\/\//d'`)
    echo $pat
    if( $cov ) then
        make all_cov TESTNAME=${pat}
        echo "Cov = $cov and pattern is $pat"
    else
        make all TESTNAME=${pat}
        echo "Cov = $cov and pattern is $pat"
    endif
end

if( $cov ) then
    make gen_cov
endif
