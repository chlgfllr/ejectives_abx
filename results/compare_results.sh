#!/bin/bash

FOLDER=/Users/chloe/ejectives_abx/results
TEST=by__place_position_question_speaker_vowel

cp $FOLDER/fixed/$TEST/results.csv $FOLDER/results_fixed.csv
cp $FOLDER/egg_fixed/$TEST/results.csv $FOLDER/results_egg_1000.csv
cp $FOLDER/features/$TEST/results.csv $FOLDER/results_features_all.csv
cp $FOLDER/egg_fixed/deltas__$TEST/results.csv $FOLDER/results_deltas.csv
cp $FOLDER/features/no_vot___$TEST/results.csv $FOLDER/results_features_no_vot.csv
cp $FOLDER/features/vot_only___$TEST/results.csv $FOLDER/results_features_vot_only.csv

sed -e "s/, /,/g" results_fixed.csv > TMP; mv TMP results_fixed.csv
sed -e "s/, /,/g" results_egg_1000.csv > TMP; mv TMP results_egg_1000.csv
sed -e "s/, /,/g" results_features_all.csv > TMP; mv TMP results_features_all.csv
sed -e "s/, /,/g" results_deltas.csv > TMP; mv TMP results_deltas.csv
sed -e "s/, /,/g" results_features_no_vot.csv > TMP; mv TMP results_features_no_vot.csv
sed -e "s/, /,/g" results_features_vot_only.csv > TMP; mv TMP results_features_vot_only.csv

