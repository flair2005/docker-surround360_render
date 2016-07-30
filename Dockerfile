FROM juanferreira/opencv:3.1.0
MAINTAINER Juan Ferreira "juan.ferreira@me.com"

ARG DIR="/source"
# Use MODE Debug for debugging
ARG MODE="Release"

# Install dependencies
RUN apt-get update && \ 
	apt-get install -y software-properties-common python-software-properties && \
	add-apt-repository -y ppa:mc3man/trusty-media && \
	apt-get update && \
	apt-get install -y git ffmpeg \
	python python-pip python-wxgtk2.8 \
	libgflags2 libgflags-dev libgoogle-glog-dev

# Install Gooey
RUN pip install --upgrade pip && \
	pip install Gooey

# Make directory
RUN mkdir -p $DIR

WORKDIR $DIR

RUN git clone https://github.com/facebook/Surround360.git

WORKDIR Surround360/surround360_render

RUN cmake -DCMAKE_BUILD_TYPE=$MODE && make

WORKDIR $DIR

VOLUME [ "$DIR" ]

# Clean up apt-get cache (helps keep the image size down)
RUN apt-get remove --purge -y git
RUN apt-get autoclean && apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/*