# Git Action构建ROS Noetic zsh docker镜像

## Tag

- `humble-base`, `humble-desktop`
- `jazzy-base`, `jazzy-desktop`

## Requirments

You should have nvidia-docker installed:
``` shell
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && \
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list && \
# sudo vim /etc/apt/sources.list.d/nvidia-container-toolkit.list
# deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://mirrors.ustc.edu.cn/libnvidia-container/stable/ubuntu18.04/amd64 /

sudo apt update
sudo apt install -y nvidia-container-toolkit
sudo systemctl restart docker
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

## Usage

### Proxy

Edit `/etc/docker/daemon.json`, add following params:
``` json
{
    "proxies": {
            "http-proxy": "http://ip:port",
            "https-proxy": "http://ip:port"
    }
}
```

### Base
``` shell
docker pull endermands/ros:humble-base
docker run --name humble_base -itd \
    --runtime=nvidia --gpus all \
    --network=host --ipc=host \
    -e ROS_DOMAIN_ID=$ROS_DOMAIN_ID \
    -e RMW_IMPLEMENTATION=$RMW_IMPLEMENTATION \
    ghcr.io/endermands/ros:humble-base
```

### Desktop
``` shell
xhost +local:docker
docker pull endermands/ros:humble-desktop
docker run --name humble_desktop -itd \
    --runtime=nvidia --gpus all \
    --network=host --ipc=host \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY \
    -e ROS_DOMAIN_ID=$ROS_DOMAIN_ID \
    -e RMW_IMPLEMENTATION=$RMW_IMPLEMENTATION \
    ghcr.io/endermands/ros:humble-desktop
```

## Visualization on Windows11

There are two ways to visualize using SSH X11 Forwarding: WSL2 and VsXsrv.

Edit remote `/etc/ssh/sshd_config`, make sure that:
``` shell
X11Forwarding yes
X11UseLocalhost no
```

Restart SSH service after config file changed:
``` shell
sudo systemctl restart sshd
```

### WSL2

Install wsl2 following [here](https://learn.microsoft.com/en-us/windows/wsl/install)

Install Xserver:
``` shell
sudo apt update
sudo apt install -y xauth x11-apps
ssh -Y -C name@ip
xeyes
```

### VcXsrv

Download [VcXsrv](https://sourceforge.net/projects/vcxsrv/), launch:
1. Display settings → Multiple windows → Next
2. Client startup → Start no client → Next
3. Extra settings → Disable access control → Next

On windows terminal:
``` shell 
ssh -Y -C name@ip
xeyes
```

### Visualization remote docker containers

After successfully visulize remote GUI apps, you can get some display info:
``` shell
echo $DISPLAY # like localhost:10.0
xauth list "$DISPLAY" # like myhost/unix:11 MIT-MAGIC-COOKIE-1 0123456789abcdef0123456789abcdef
```

Enter the container and set `DISPLAY` and `xauth` using outputs before:
``` shell
export DISPLAY=localhost:10.0
xauth add myhost/unix:11 MIT-MAGIC-COOKIE-1 0123456789abcdef0123456789abcdef
xeyes
```

### Issues

#### Xauthority file permission
```
rm -r ~/.Xauthority
touch ~/.Xauthority
chmod 600 ~/.Xauthority
chown $(id -u):$(id -g) ~/.Xauthority
```
