#!/usr/bin/env bash

# get current file path
script_path_in_package=$(readlink -f -- "$0")

# get current file grandfather directory path, like this: ../../
root_directory=${script_path_in_package%/*/*}

# get train directory
train_directory=$root_directory"/output/train"

# make a dir to storage test images
mkdir $root_directory/test_images

# copy jupyter notebook test file to output directory
cp $root_directory"/resource/pretrain/object_detection_tutorial.ipynb" $root_directory/

