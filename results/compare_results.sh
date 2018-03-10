#!/bin/bash

FOLDER=/Users/chloe/ejectives_abx/results
TEST=by__place_question_speaker_vowel
STANDARD_PATH=fixed
SMALL_PATH=different_mfcc/smaller/fixed
LARGE_PATH=different_mfcc/larger/fixed

cp $FOLDER/$SMALL_PATH/$TEST/results.csv $FOLDER/results_small.csv
cp $FOLDER/$STANDARD_PATH/$TEST/results.csv $FOLDER/results_standard.csv
cp $FOLDER/$LARGE_PATH/$TEST/results.csv $FOLDER/results_large.csv

sed -e "s/, /,/g" results_small.csv > TMP; mv TMP results_small.csv
sed -e "s/, /,/g" results_large.csv > TMP; mv TMP results_large.csv
sed -e "s/, /,/g" results_standard.csv > TMP; mv TMP results_standard.csv
