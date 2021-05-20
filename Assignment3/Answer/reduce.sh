#!/bin/bash
echo -n "Enter the value of n > "
read n
echo -n "Enter the value of k > "
read k
#add variable r to array.txt
bash generate.sh $n
g++ -fprofile-arcs -ftest-coverage test/P.cpp -o P
./P < Tests/test0 > /dev/null 2>&1
gcov -b -c P > /dev/null 2>&1
r=$(grep -c "branch  0" P.cpp.gcov)
rm *.gcda
echo "$n $k $r" > array

for ((i=0 ; i<n ;i++));do
    ./P < Tests/test$i > /dev/null 2>&1
    gcov -b -c P > /dev/null 2>&1
    r=$(grep -c "branch  0" P.cpp.gcov)
    for((j=1 ; j<=r ;j++));do
        x=$(grep "branch  0" P.cpp.gcov | sed -n ${j}p | grep -Eo '[0-9]+$')
        if [ -z "$x" ]
        then echo -n "0 " >> array
        elif [[ $x -gt 0 ]] 
        then echo -n "1 " >> array
        else echo -n "0 " >> array
        fi
    done
    echo "" >> array
    rm *.gcda
done
rm *.gcov
rm *.gcno

g++ -std=c++17 reduce.cpp
./a.out
rm a.out
rm P

S="S"
index=0
if [ -d "$S" ]; then
 rm -rf $S
fi
mkdir $S
while IFS= read -r num; 
do
    cp Tests/test$num $S/test$index
    index=$((index+1))
done < "reduced_tests"
rm array
rm reduced_tests

touch test/T
cat Tests/* > test/T
rm -rf Tests

touch test/S
cat S/* > test/S
rm -rf S
