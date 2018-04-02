#!/bin/bash

set -e

source activate abxenv

TEST=abxpy_mel25_by__place_position_question_speaker_vowel
DIR=../results/egg_fixed/$TEST
CHEMIN=../results/egg_fixed

FEATURE_FILE=egg_mel_25.h5f
ITEM_FILE=$DIR/abx_egg_mel.item

TASK_FILE=$DIR/abx.abx
DISTANCE_FILE=$DIR/abx.distance
SCORE_FILE=$DIR/abx.score

RESULTS_FILE=$DIR/results.csv
OUTPUT_TXT=$DIR/distance.txt

echo
echo "Running ABXpy test and extracting distances"
echo

mkdir -p $DIR && \
  cp $CHEMIN/abx_egg_mel.item $DIR && \
  abx-task $ITEM_FILE $TASK_FILE --on type --by place position question speaker vowel && \
  abx-distance $FEATURE_FILE $TASK_FILE $DISTANCE_FILE --normalization 1 --njobs 1 && \
  abx-score $TASK_FILE $DISTANCE_FILE $SCORE_FILE && \
  abx-analyze $SCORE_FILE $TASK_FILE $RESULTS_FILE && \
  rm -f $OUTPUT_TXT && \
  python ./dis2txt.py $TASK_FILE $DISTANCE_FILE $OUTPUT_TXT

cp $ITEM_FILE $DIR/abx.item

source deactivate abxenv
