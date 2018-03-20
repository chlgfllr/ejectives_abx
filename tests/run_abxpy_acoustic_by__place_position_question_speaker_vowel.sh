#!/bin/bash

set -e

source activate abxenv

TEST=fixed
FOLDER=by__place_position_question_speaker_vowel
DIR=../results/$TEST

FEATURE_FILE=mono_mfcc.h5f
ITEM_FILE=$DIR/abx.item

TASK_FILE=$DIR/$FOLDER/abx.abx
DISTANCE_FILE=$DIR/$FOLDER/abx.distance
SCORE_FILE=$DIR/$FOLDER/abx.score

RESULTS_FILE=$DIR/$FOLDER/results.csv
OUTPUT_TXT=$DIR/$FOLDER/distance.txt

echo
echo "Running ABXpy test and extracting distances"
echo

mkdir -p $DIR/$FOLDER && \
  abx-task $ITEM_FILE $TASK_FILE --on type --by place position question speaker vowel && \
  abx-distance $FEATURE_FILE $TASK_FILE $DISTANCE_FILE --normalization 1 --njobs 1 && \
  abx-score $TASK_FILE $DISTANCE_FILE $SCORE_FILE && \
  abx-analyze $SCORE_FILE $TASK_FILE $RESULTS_FILE && \
  rm -f $OUTPUT_TXT && \
  python ./dis2txt.py $TASK_FILE $DISTANCE_FILE $OUTPUT_TXT

cp $ITEM_FILE $DIR/$FOLDER/abx.item

source deactivate abxenv
