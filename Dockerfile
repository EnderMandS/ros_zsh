FROM ros:noetic-ros-base-focal

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO noetic
ARG USERNAME=m

RUN apt update && \
    apt install -y vim tree wget curl git unzip ninja-build && \
    apt install -y libeigen3-dev libopencv-dev && \
    apt install -y ros-${ROS_DISTRO}-cv-bridge && \
    DEBIAN_FRONTEND=noninteractive apt install -y keyboard-configuration && \
    rm -rf /var/lib/apt/lists/*

# setup user
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME

# zsh
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t robbyrussell  \ 
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting && \
    sudo rm -rf /var/lib/apt/lists/*

# # OpenCV
# WORKDIR /home/${USERNAME}/pkg/OpenCV
# RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/4.x.zip && \
#     unzip opencv.zip && rm opencv.zip && mkdir -p build && cd build && \
#     cmake -GNinja ../opencv-4.x && ninja && sudo ninja install && ninja clean && \
#     sudo rm -rf /home/${USERNAME}/pkg
# RUN sudo apt update && \
#     sudo apt install -y ros-${ROS_DISTRO}-cv-bridge && \
#     sudo rm -rf /var/lib/apt/lists/*

WORKDIR /home/${USERNAME}/code/ros_ws

ENTRYPOINT [ "/bin/zsh" ]