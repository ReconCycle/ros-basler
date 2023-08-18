FROM ros:noetic
LABEL maintainer "Gašper Šavle <gaspersavle13@gmail.com>"

SHELL ["/bin/bash", "-c"]

RUN apt update && apt install --no-install-recommends -y \
	git\
	neovim\
	wget\
	curl\
	python3-catkin-tools\
	ros-noetic-image-proc\
	ros-noetic-image-pipeline\
	x11-apps

ENV CATKIN_WS=/root/catkin_ws
RUN mkdir -p $CATKIN_WS/src
WORKDIR $CATKIN_WS

RUN cd $CATKIN_WS/src && git clone https://github.com/dragandbot/dragandbot_common.git
RUN cd $CATKIN_WS/src && git clone https://github.com/basler/pylon-ros-camera.git

WORKDIR $CATKIN_WS/src/pylon-ros-camera/pylon_camera/launch/
RUN wget https://raw.githubusercontent.com/gaspersavle/basler-calibs/master/pylon_colour_camera_node.launch
RUN wget https://raw.githubusercontent.com/gaspersavle/basler-launches/master/dragandbot_startup.launch
RUN wget https://raw.githubusercontent.com/gaspersavle/basler-launches/master/pylon_camera_grab_and_save_as.launch
RUN wget https://raw.githubusercontent.com/gaspersavle/basler-launches/master/pylon_camera_ip_configuration.launch
RUN wget https://raw.githubusercontent.com/gaspersavle/basler-launches/master/pylon_camera_node.launch
RUN wget https://raw.githubusercontent.com/gaspersavle/basler-launches/master/pylon_colour_camera_node.launch

WORKDIR $CATKIN_WS/src/pylon-ros-camera/pylon_camera/config/
RUN wget https://raw.githubusercontent.com/gaspersavle/basler-calibs/master/colour_camera.yaml

RUN wget https://raw.githubusercontent.com/gaspersavle/basler-calibs/master/calibration_1450x1450_goe.yaml

RUN wget https://raw.githubusercontent.com/gaspersavle/basler-calibs/master/calibration_1450x1450_jsi.yaml

WORKDIR $CATKIN_WS

RUN sh -c 'echo "yaml https://raw.githubusercontent.com/basler/pylon-ros-camera/master/pylon_camera/rosdep/pylon_sdk.yaml" > /etc/ros/rosdep/sources.list.d/30-pylon_camera.list'

RUN source "/opt/ros/$ROS_DISTRO/setup.bash" && \
	rosdep update && \
	rosdep install --from-paths . --ignore-src --rosdistro=$ROS_DISTRO -y

# catkin build
RUN source "/opt/ros/$ROS_DISTRO/setup.bash" && \
	catkin init && \
	catkin clean -y && \
	catkin build


WORKDIR /
# Grab entrypoint function
RUN wget https://raw.githubusercontent.com/gaspersavle/basler-calibs/master/entrypoint.sh
RUN chmod +x /entrypoint.sh

# Always source ros_catkin_entrypoint.sh when launching bash (e.g. when attaching to container)
RUN echo "source /entrypoint.sh" >> /root/.bashrc

# gosu
RUN set -eux; \
	apt-get update; \
	apt-get install -y gosu; \
	rm -rf /var/lib/apt/lists/*; \
# verify that the binary works
	gosu nobody true

ENTRYPOINT ["/entrypoint.sh"]

# stop docker from exiting immediately
CMD tail -f /dev/null 

