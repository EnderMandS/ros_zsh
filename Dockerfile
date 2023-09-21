FROM osrf/ros:noetic-desktop-full-focal

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO noetic

RUN apt update && \
    apt install -y python3-catkin-tools ros-noetic-geographic-msgs ros-noetic-tf2-sensor-msgs ros-noetic-tf2-geometry-msgs ros-noetic-image-transport && \
    apt install -y git wget vim net-tools && \
    rm -rf /var/lib/apt/lists/*

ARG USERNAME=m
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t robbyrussell  \ 
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting 

WORKDIR /home/$USERNAME/

ENTRYPOINT [ "/bin/zsh" ]