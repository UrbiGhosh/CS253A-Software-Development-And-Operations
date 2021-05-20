#!/bin/bash
tests="Tests"
if [ -d "$tests" ]; then
 rm -rf $tests
fi
mkdir $tests
n=$1
for ((i=0 ; i<n ; i++)); do
    touch "$tests/test$i"
    a=$RANDOM
    b=$RANDOM
    c=$RANDOM
    d=$RANDOM
    A=$(($((a<<16))+$b))
    B=$(($((c<<16))+$d))
    sign1=$(($RANDOM % 2))
    sign2=$(($RANDOM % 2))
    if(($sign1==0))
    then
    	A=$((-1 * $A))
	fi
    if(($sign2==0))
    then
    	B=$((-1 * $B))
	fi
    echo "$A $B" > "$tests/test$i"
done
#not generating negative numbers due to some reason
