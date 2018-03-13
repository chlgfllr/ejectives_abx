#!/bin/bash

set -e

source activate easyabx

TEST=egg_fixed
FOLDER=by__essai_boston
DIR=../results/$TEST

NAME=abx

TASK_FILE=$DIR/$FOLDER/$NAME.abx
DISTANCE_FILE=$DIR/$FOLDER/$NAME.distance
OUTPUT_TXT=$DIR/$FOLDER/distance.txt

echo
echo "Running easyabx test and extracting distances"
echo

mkdir $DIR/$FOLDER && \
  ~/easy_abxpy/easy_abx/prepare_abx.py $DIR/egg_edit.csv $DIR/$FOLDER/$NAME --header \
     --col_features 14-38 --col_labels 6-12 --col_items 1,2,3 && \
  ~/easy_abxpy/easy_abx/run_abx.py $DIR/$FOLDER/$NAME --on "type" --by place position question speaker vowel &&\
  python dis2txt.py $TASK_FILE $DISTANCE_FILE $OUTPUT_TXT && \
  cp $DIR/$FOLDER/abx.csv $DIR/$FOLDER/results.csv; rm $DIR/$FOLDER/abx.csv && \
  sed -e "s/-/ /g" $DIR/$FOLDER/abx.item > TMP; mv TMP $DIR/$FOLDER/abx.item

source deactivate
