#!/usr/bin/env bash

# you should goto the dir: models/research, and input "export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim" before you run this script.

# this is a directory that you program_output
#program_name=face_bottle_8     # this program name is face_bottle_8

# get current file path
script_path_in_package=$(readlink -f -- "$0")

# get current file grandfather directory path, like this: ../../
root_directory=${script_path_in_package%/*/*}
echo $root_directory

# get object_detection path
object_detection=${script_path_in_package%/*/*/*}
echo $object_detection
#
# make a directory output for program
mkdir $root_directory/output
echo 'successful make a output directory'

# make a directory output for storage generate files
mkdir $root_directory/output/data
echo 'successful make a storage data directory'

# make a directory output for face_bottle_8 files
#mkdir $root_directory/output/$program_name
#echo 'successful make a program_name directory'

# translate json files to csv files
python $root_directory"/code/json_to_csv.py"

# translate csv files to TFRecord
python $root_directory"/code/generate_tfrecord.py" --csv_input=labels.csv --image_dir=../images --output_path=train.record

# move labels.csv & train.record to output/face_bottle_8/
mv labels.csv train.record $root_directory/output/data

# mkdir a directory train for training
mkdir $root_directory/output/train

# copy config file to train directory
# if you want to use fast-rcnn, you shoule replace 'ssd' with 'fast-rcnn'
cp $root_directory/resource/pretrain/config/ssd/* $root_directory/output/train/
# fast-rcnn
#cp $root_directory/resource/pretrain/config/fast-rcnn/* $root_directory/output/train/

# train the model
#python $object_detection/legacy/train.py --logtostderr --train_dir=$root_directory/output/train --pipeline_config_path=$root_directory/output/train/ssd_mobilenet_v1_pets.config
#python $object_detection/model_main.py --alsologtostderr --train_dir=$root_directory/output/train --pipeline_config_path=$root_directory/output/train/ssd_mobilenet_v1_pets.config
#python $object_detection/legacy/train.py --logtostderr --train_dir=$root_directory/output/train --pipeline_config_path=$root_directory/output/train/faster_rcnn_inception_v2_pets.config
python $object_detection/model_main.py \
    --pipeline_config_path=$root_directory/output/train/ssd_mobilenet_v1_pets.config \
    --model_dir=$root_directory/output/train \
    --num_train_steps=5000 \
    --num_eval_steps=2000 \
    --alsologtostderr
