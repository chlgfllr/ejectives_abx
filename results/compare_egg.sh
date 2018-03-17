#!/bin/bash

cp egg_fixed/_avion/results.csv results_egg.csv
cp egg_fixed/egg_1000/results.csv results_egg_1000.csv

sed -e "s/, /,/g" results_egg.csv > TMP; mv TMP results_egg.csv
sed -e "s/, /,/g" results_egg_1000.csv > TMP; mv TMP results_egg_1000.csv
