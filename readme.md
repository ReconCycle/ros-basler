# Docker [pylon-ROS-camera](https://github.com/basler/pylon-ros-camera)

Basler provides an official [pylon ROS driver](https://github.com/basler/pylon-ros-camera) for Basler GigE Vision and USB3 Vision cameras. This project provides a docker wrapper for it.

Extras:
- `pylon_colour_camera_node.launch` that creates a colour node when using `yuv422` image encoding.

## Getting Started

Run the container with:
```bash
docker-compose up -d
```
This will build the container first.

In the `docker-compose.yml` file, the important line is:
```yaml
command: roslaunch pylon_camera pylon_colour_camera_node.launch
```

## Debugging

Comment out the `command: ...` line.

Enter the container with:
```bash
docker exec -it ros-basler-camera /bin/bash
```

Start the driver with:
```bash
roslaunch pylon_camera pylon_colour_camera_node.launch
```
or
```bash
roslaunch pylon_camera pylon_camera_node.launch
```

GigE Cameras IP Configuration can be done using the command: 
```bash
roslaunch pylon_camera pylon_camera_ip_configuration.launch
```
