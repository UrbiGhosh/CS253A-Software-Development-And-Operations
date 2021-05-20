#!/bin/bash
url="https://api.covid19india.org/v4/data.json"
csv="processed_Covid_Data_190924.csv"
json="covid_Data.json"
unknown="\"Unknown\""
now=$(date)

echo "Running script on: $now"

echo "Downloading JSON File"
if [ -f $json ]; then
   rm $json
fi
wget -nv $url -O $json
echo "Done"

echo "Creating CSV File"
if [ -f $csv ]; then
   rm $csv
fi
touch $csv
echo "state,district,confirmed_Cases,recovery_Rate" >> $csv
echo "Done"


jq -c '.|keys|.[]' $json | while read i; do
    echo "Processing state: $state"
    state=$i
    if [ "$state" == "$unknown" ]; then
        continue
    fi
    district=""
    confirmed_Cases=0
    recovery_Rate=0
    while read j; do
        curr_district=$j
        if [ "$curr_district" == "$unknown" ]; then
            continue
        fi
        confirmed=$(jq ".[$state].districts|.[$curr_district].total.confirmed|values" $json)
        recovered=$(jq ".[$state].districts|.[$curr_district].total.recovered|values" $json)
        recovery=$(echo "scale=2; 100 * $recovered / $confirmed" | bc)
        if [ "$confirmed" -lt 5000 ]; then
            continue
        fi
        if (( $(echo "$recovery >= $recovery_Rate" |bc -l) )); then
            district="$curr_district"
            confirmed_Cases="$confirmed"
            recovery_Rate="$recovery"
        fi
    done <<< "$(jq -c ".[$state].districts|keys|.[]" $json)"
    if [ "$confirmed_Cases" -ge 5000 ]; then
        echo "$state,$district,$confirmed_Cases,$recovery_Rate" >> $csv
    fi
done

echo "----------------"
