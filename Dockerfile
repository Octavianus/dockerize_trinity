### Dockermized trinity-r20140413
## use the dockerfile/ubuntu base image provided by https://index.docker.io/u/dockerfile/ubuntu/
# The environment is ubuntu-14.04
FROM dockerfile/python

MAINTAINER David Weng weng@email.arizona.edu
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

## Step 1: Install the basic tools to set up the environment.
# Install the wget, gcc, make tools, handling the lib dependency problem.
RUN apt-get install -y wget
RUN apt-get install -y g++

## Step 2: Get the zlib lib that needed for executing the trinity
# Back to the /home/vagrant/ directory
WORKDIR /home/vagrant
RUN wget http://zlib.net/zlib-1.2.8.tar.gz
RUN tar xzvf zlib-1.2.8.tar.gz
WORKDIR zlib-1.2.8
RUN sudo ./configure
# Still in /zlib-1.2.8 directory
RUN make
RUN sudo make install 
## Step 3: Download the binary file.
# Make sure the working directory is Vagrant.
WORKDIR /home/vagrant
RUN wget --trust-server-name http://sourceforge.net/projects/trinityrnaseq/files/trinityrnaseq_r20140413.tar.gz/download
RUN tar xvzf trinityrnaseq_r20140413.tar.gz
WORKDIR trinityrnaseq_r20140413

## Step 4: Make and Install Trinity
RUN make

## Step 5: Add the executables directory to the Path.
#ENV PATH /home/vagrant/trinityrnaseq_r20140413:$PATH
ENTRYPOINT ["/home/vagrant/trinityrnaseq_r20140413/Trinity"]
