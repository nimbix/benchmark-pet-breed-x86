FROM nvidia/caffe

RUN apt-get update && apt-get -y install python-pip cython curl wget unzip && apt-get clean
WORKDIR /opt
RUN wget --no-verbose https://github.com/Junsong-Wang/pet-breed/archive/master.zip && unzip master.zip && rm -f master.zip
WORKDIR /opt/pet-breed-master
RUN cd data/stanford-dogs && curl http://vision.stanford.edu/aditya86/ImageNetDogs/images.tar |tar xf -
RUN cd data/stanford-dogs && curl http://vision.stanford.edu/aditya86/ImageNetDogs/annotation.tar |tar xf -
RUN cd data/stanford-dogs && curl http://vision.stanford.edu/aditya86/ImageNetDogs/lists.tar |tar xf -
RUN cd data/stanford-dogs && python dog_parse.py
RUN ln -s /usr/bin/caffe_convert_imageset /usr/bin/convert_imageset
RUN cd data/stanford-dogs && ./create_image.sh
RUN cd models/bvlc_googlenet && wget http://dl.caffe.berkeleyvision.org/bvlc_googlenet.caffemodel
RUN sed -ie 's/gpu 0/gpu all/g' models/bvlc_googlenet/train.sh
RUN pip install -r requirements.txt
RUN chmod -R a+w models/bvlc_googlenet/.

ADD 00-nimbix /etc/sudoers.d/00-nimbix
RUN chmod 0440 /etc/sudoers.d/00-nimbix

