import os
from os import listdir
from os.path import isfile, join
import sys

if(len(sys.argv) < 2):
    print('directory (directory containing images)')
    sys.exit(1)

# enumerates emails and image names from the image path


def getEmails(imagePath):
    pngFiles = [f for f in listdir(imagePath) if isfile(join(imagePath, f))]

    list = []
    for pngFile in pngFiles:
        if pngFile.endswith('.png'):
            email = pngFile.strip(".png")
            list.append((email, os.path.join(imagePath, pngFile)))
    return list


imagePath=sys.argv[1]
print(f"processing {imagePath} create_draft:{create_draft}")
list=getEmails(imagePath)
for l in list:
    print(l)
