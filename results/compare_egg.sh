#!/bin/bash

cp egg_fixed/deltas__by__place_position_question_speaker_vowel/results.csv results_deltas.csv
cp egg_fixed/egg_1000/results.csv results_egg_1000.csv

sed -e "s/, /,/g" results_deltas.csv > TMP; mv TMP results_deltas.csv
sed -e "s/, /,/g" results_egg_1000.csv > TMP; mv TMP results_egg_1000.csv
