# ros-basler: Docker [pylon-ROS-camera](https://github.com/basler/pylon-ros-camera)

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

## Camera Setup

In UserSet2 specify the following:

- binning 2
- output resolution (after binning) 1450 x 1450
- center x and y

## Camera Calibration

The [pylon ROS driver](https://github.com/basler/pylon-ros-camera) can accept a camera calibration file.

**VERY IMPORTANT** Run `xhost +` on the client in order to see the GUI.

Access the container with:
```bash
docker exec -it ros-basler bash
```

1. To run the calibration on a 10x7 checkerboard with 20.1mm squares:
```bash
rosrun camera_calibration cameracalibrator.py --size 10x7 --square 0.0201 image:=/basler/image_color camera:=/basler
```
[Read the docs for further info](http://wiki.ros.org/camera_calibration).

2. Save the calibration and copy the yaml file from the calibrationdata.tgz

3. paste the calibration in `config/`

4. In `config/colour_camera.yaml` point it to the calibration file.

## Extra

To save an image to file, run:
```bash
rosrun image_view image_saver image:=/basler/image_color
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

## Notes



```xml
<node ns="pylon_camera_node" name="rgb_converter" pkg="image_proc" type="image_proc" >
</node>

<node pkg="nodelet" type="nodelet" name="image_resizer" args="standalone image_proc/resize">
    <param name="scale_width" type="double" value="0.5"/>
    <param name="scale_height" type="double" value="0.5"/>
    
    <remap to="/pylon_camera_node/image_color" from="image"/>
    <remap to="/pylon_camera_node/camera_info" from="camera_info"/>
</node>
```