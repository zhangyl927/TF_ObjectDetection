import json as js
import glob
import os
import pandas as pd
from PIL import Image

def json_to_csv(path):
    json_list = []
    for json_file in glob.glob(path + '/*.json'):
        path_img = json_file.split('.',1)
        im = Image.open('{}.jpg'.format(path_img[0]))
        width = im.size[0]
        height = im.size[1]

        fp = open(json_file, 'r')
        json_value = fp.read()
        raw_data = js.loads(json_value)
        member = len(raw_data["shapes"])
        print("current file is:",json_file)
        for i in range(0,member):
            value = (
                    raw_data["imagePath"],
                    int(width),
                    int(height),
                     #########object_name
                     raw_data["shapes"][i]["label"],
                     ####xmin,ymin,xmax,ymax
                     int(raw_data["shapes"][i]["points"][0][0]),
                     int(raw_data["shapes"][i]["points"][0][1]),
                     int(raw_data["shapes"][i]["points"][2][0]),
                     int(raw_data["shapes"][i]["points"][2][1])
                    )
            json_list.append(value)
        column_name = ['filename', 'width', 'height', 'class', 'xmin', 'ymin', 'xmax', 'ymax']

    json_df = pd.DataFrame(json_list, columns=column_name)
    return json_df

def main():
    # for directory in ['test','train']:
    #     image_path = os.path.join(os.getcwd(), 'images/{}'.format(directory))
    #     print(image_path)
    #     json_df = json_to_csv(image_path)
    #     json_df.to_csv('data/{}_labels.csv'.format(directory), index=None)
    # print('Successfully converted json to csv.')
    #code_path = os.getcwd()
    #print("os.getcwd()",os.getcwd())
    superior_path = os.path.abspath(os.path.dirname(os.getcwd()))
    #print("superior_path:", superior_path)
    image_path = os.path.join(superior_path, 'images')
    #print(image_path)
    json_df = json_to_csv(image_path)
    json_df.to_csv('labels.csv', index=None)
    print('Successfully converted json to csv.')


main()
