#!/bin/bash

set -e

source activate easyabx

TEST=features
FOLDER=by__place_question_speaker_vowel
DIR=../results/$TEST

NAME=abx

TASK_FILE=$DIR/$FOLDER/$NAME.abx
DISTANCE_FILE=$DIR/$FOLDER/$NAME.distance
OUTPUT_TXT=$DIR/$FOLDER/distance.txt

echo
echo "Running easyabx test"
echo

mkdir $DIR/$FOLDER

./prepare_abx.py $DIR/abx.csv $DIR/$FOLDER/$NAME --header \
     --col_features 14 --col_labels 7-12 --col_items 4,3,2,1

./run_abx.py $DIR/$FOLDER/$NAME --on "type" --by place position question speaker vowel

echo
echo "Extracting distances"
echo

python dis2txt.py $TASK_FILE $DISTANCE_FILE $OUTPUT_TXT

cp $DIR/$FOLDER/abx.csv $DIR/$FOLDER/results.csv; rm $DIR/$FOLDER/abx.csv

source deactivate
