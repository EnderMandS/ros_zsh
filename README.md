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
docker run --name humble_base -itd --runtime=nvidia --gpus all --network=host \
    ghcr.io/endermands/ros:humble-base
```

### Desktop
``` shell
xhost +local:docker
docker pull endermands/ros:humble-desktop
docker run --name humble_desktop -itd --runtime=nvidia --gpus all --network=host \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME/.Xauthority:/root/.Xauthority \
    -e DISPLAY=$DISPLAY \
    ghcr.io/endermands/ros:humble-desktop
```
