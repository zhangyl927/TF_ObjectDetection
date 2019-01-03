### **Installation**
The tutorial rely on tensorflow-gpu 1.11 or tensorflow 1.11.

Before using this script, you need to follow tensorflow object detection API installation.

#### COCO API installation
```
git clone https://github.com/cocodataset/cocoapi.git
cd cocoapi/PythonAPI
make
cp -r pycocotools <path_to_tensorflow>/models/research/
```
#### Prepare work:
##### 1.Modify files based on the type of objects.
After determining the type of objects that need to be detected，you should modify the following file: **code/generate_tfrecord.py**, **resource/pretrain/config/ssd/object-detection.pbtxt** and **ssd_mobilenet_v1_pets.config**(or other config file).

Following is a example:
```
I want to detect 4 objects: face, bottle, pill and mouth.
1.generate_tfrecord.py, I modify 'class_text_to_int(row_label):'
def class_text_to_int(row_label):
    if row_label == 'bottle':
        return 1
    elif row_label == 'face':
        return 2
    elif row_label == 'pill':
        return 3
    elif row_label == 'mouth':
        return 4
    else:
        None
2.object-detection.pbtxt, the content is:
    item {
      id: 1
      name: 'bottle'
    }

    item {
      id: 2
      name: 'face'
    }

    item {
      id: 3
      name: 'pill'
    }

    item {
      id: 4
      name: 'mouth'
    }
3.ssd_mobilenet_v1_pets.config, I modify 'ssd->num_classes: 4' about line 9.
```

##### 2.Downdoad the model you want to use.
eg:In this tutorial, I used ssd.So I followed this:
```
# From resource/pretrain
wget http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v1_coco_11_06_2017.tar.gz

Then extract current folder.
```

3.Put your images and json files in the **images folder**.

#### Step1: Training
This should be done by running the following command from the
/models/research/object_detection/detOBJ/script/ directory:
```
# From models/research/object_detection/detOBJ/script/
sh prepare.sh
```
**Note**:If you want to use other pre-model,or train steps, you could modify the script.
#### Step2: Test
Input the following command from the sample directory:
```
# From models/research/object_detection/detOBJ/script/
sh test.sh
```
After running test.sh, there will make a test_images, you should put test images in this folder.
#### Step3: Save model
This should be done to save model.
```
# From models/research/object_detection/detOBJ/
python resource/pretrain/export_inference_graph.py \
    --input_type image_tensor \
    --pipeline_config_path output/train/ssd_mobilenet_v1_pets.config \
    --trained_checkpoint_prefix output/train/model.ckpt-20000 \    
    --output_directory detect_grapy
```
**Node**:'pipeline_config_path', 'trained_checkpoint_prefix' and 'output_directory' depend on the truth.

#### Step4: Watch the result by Jupyter Notebook
open object_detection_tutorial.ipynb, modify the content of 'Model preparation->Variables'
