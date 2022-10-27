FROM osrf/ros:galactic-desktop

LABEL maintainer="Jackson Vanderkooy"

ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

RUN apt-get update && apt-get upgrade -y

ADD ./Scripts/container-start.rviz.sh /container-start.sh
RUN chmod +x /container-start.sh