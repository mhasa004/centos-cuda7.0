FROM centos
MAINTAINER Mahmudul Hasan <mhasa004@ucr.edu>

# A docker container with the Nvidia kernel module, CUDA drivers, and torch7 installed

ENV CUDA_RUN http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/cuda_7.0.28_linux.run

# The one inside the cuda_7.0.28_linux.run does not mathces with the driver of the host machine
# Following driver version matches our host machine driver. 
ENV CUDA_DRIVER http://us.download.nvidia.com/XFree86/Linux-x86_64/352.21/NVIDIA-Linux-x86_64-352.21.run

RUN yum -y update 
RUN yum install -q -y wget
RUN yum -q -y groupinstall 'Development Tools'
RUN yum -y install module-init-tools

RUN cd /opt
RUN wget $CUDA_DRIVER
RUN chmod +x *.run 
RUN ./NVIDIA-Linux-x86_64-352.21.run -s -N --no-kernel-module

RUN wget $CUDA_RUN
RUN mkdir nvidia_installers 
RUN ./cuda_7.0.28_linux.run -extract=`pwd`/nvidia_installers
RUN cd nvidia_installers
RUN ./cuda-linux64-rel-7.0.28-19326674.run -noprompt

# Ensure the CUDA libs and binaries are in the correct environment variables
ENV LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-7.0/lib64
ENV PATH=$PATH:/usr/local/cuda-7.0/bin
