#!/bin/bash

FOLDER=/Users/chloe/ejectives_abx/results
TEST=by__place_position_question_speaker_vowel

cp $FOLDER/fixed/$TEST/results.csv $FOLDER/results_fixed.csv

cp $FOLDER/egg_fixed/abxpy_mel_$TEST/results.csv $FOLDER/results_egg_abxpy.csv
cp $FOLDER/egg_fixed/amplitude_$TEST/results.csv $FOLDER/results_egg_amplitude.csv
cp $FOLDER/egg_fixed/deltas__$TEST/results.csv $FOLDER/results_deltas.csv
cp $FOLDER/egg_fixed/deltas_carre__$TEST/results.csv $FOLDER/results_deltas_carre.csv
cp $FOLDER/egg_fixed/deltas_log2__$TEST/results.csv $FOLDER/results_deltas_log_2.csv
cp $FOLDER/egg_fixed/deltas_log2_absolute__$TEST/results.csv $FOLDER/results_deltas_log_2_absolute.csv

cp $FOLDER/features/$TEST/results.csv $FOLDER/results_features_all.csv
cp $FOLDER/features/no_vot___$TEST/results.csv $FOLDER/results_features_no_vot.csv
cp $FOLDER/features/vot_only___$TEST/results.csv $FOLDER/results_features_vot_only.csv


sed -e "s/, /,/g" results_fixed.csv > TMP; mv TMP results_fixed.csv

sed -e "s/, /,/g" results_egg_abxpy.csv > TMP; mv TMP results_egg_abxpy.csv
sed -e "s/, /,/g" results_egg_amplitude.csv > TMP; mv TMP results_egg_amplitude.csv
sed -e "s/, /,/g" results_deltas.csv > TMP; mv TMP results_deltas.csv
sed -e "s/, /,/g" results_deltas_carre.csv > TMP; mv TMP results_deltas_carre.csv
sed -e "s/, /,/g" results_deltas_log_2.csv > TMP; mv TMP results_deltas_log_2.csv
sed -e "s/, /,/g" results_deltas_log_2_absolute.csv > TMP; mv TMP results_deltas_log_2_absolute.csv

sed -e "s/, /,/g" results_features_all.csv > TMP; mv TMP results_features_all.csv
sed -e "s/, /,/g" results_features_no_vot.csv > TMP; mv TMP results_features_no_vot.csv
sed -e "s/, /,/g" results_features_vot_only.csv > TMP; mv TMP results_features_vot_only.csv

