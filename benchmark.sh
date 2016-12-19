#!/bin/bash

set -e
if [ -d /opt/DL -a -n "$1" ]; then
        echo "Using caffe-$i"
        source /opt/DL/caffe-$i
fi

# parse and convert images
cd /opt/pet-breed-master/data/stanford-dogs
sudo -E python dog_parse.py
sudo -E ./create_image.sh

cd /opt/pet-breed-master/models/bvlc_googlenet && sudo -E ./train.sh

