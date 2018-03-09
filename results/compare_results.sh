#!/bin/bash

FOLDER=/Users/chloe/ejectives_abx/results
TEST=by__place_question_speaker_vowel
LARGE_PATH=fixed
SMALL_PATH=smaller_mfcc/fixed

cp $FOLDER/$SMALL_PATH/$TEST/results.csv $FOLDER/results_small.csv
cp $FOLDER/$LARGE_PATH/$TEST/results.csv $FOLDER/results_large.csv

sed -e "s/, /,/g" results_small.csv > TMP; mv TMP results_small.csv
sed -e "s/, /,/g" results_large.csv > TMP; mv TMP results_large.csv



