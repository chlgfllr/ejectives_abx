#!/bin/bash

set -e

source activate easyabx

TEST=features
FOLDER=by__place_position_question_speaker_across__vowel
DIR=../results/$TEST

NAME=abx

TASK_FILE=$DIR/$FOLDER/$NAME.abx
DISTANCE_FILE=$DIR/$FOLDER/$NAME.distance
OUTPUT_TXT=$DIR/$FOLDER/distance.txt

echo
echo "Running easyabx test and extracting distances"
echo

mkdir -p $DIR/$FOLDER && \
  prepare_abx $DIR/abx.csv $DIR/$FOLDER/$NAME --header \
     --col_features 14-16 --col_labels 5-12 --col_items 1,2,3 && \
  run_abx $DIR/$FOLDER/$NAME --on "type" --by place position question speaker --across vowel &&\
  python dis2txt.py $TASK_FILE $DISTANCE_FILE $OUTPUT_TXT && \
  cp $DIR/$FOLDER/abx.csv $DIR/$FOLDER/results.csv; rm $DIR/$FOLDER/abx.csv && \
  sed -e "s/{}/ /g" $DIR/$FOLDER/abx.item > TMP; mv TMP $DIR/$FOLDER/abx.item && \
  sed -e "s/{}/ /g" $DIR/$FOLDER/distance.txt > TMP; mv TMP $DIR/$FOLDER/distance.txt

source deactivate
