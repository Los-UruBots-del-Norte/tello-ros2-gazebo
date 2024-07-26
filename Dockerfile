FROM osrf/ros:humble-desktop-full
# Install dependencies
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y git wget \
ros-humble-cv-bridge \
ros-humble-camera-calibration-parsers \
ros-humble-rviz2 \
ros-humble-rviz-common \
ros-humble-rviz-default-plugins \
ros-humble-rviz-visual-tools \
ros-humble-rviz-rendering \
ros-humble-nav2-rviz-plugins

# libignition-rendering3
RUN apt-get install -y libasio-dev
RUN apt-get install -y python3-pip
RUN yes | pip3 install 'transformations==2018.9.5'
RUN pip install -U colcon-common-extensions
RUN apt install ros-humble-ament-cmake
# Gazebo
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
RUN apt-get update -y && apt-get install -y gazebo11 libgazebo11-dev
# Create workspace
WORKDIR /work/tello_ros_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build"
# clone projects
WORKDIR /work/tello_ros_ws/src
RUN git clone https://github.com/Los-UruBots-del-Norte/tello-ros2-gazebo.git
# RUN git clone https://github.com/ptrmu/fiducial_vlam.git
WORKDIR /work/tello_ros_ws
RUN chmod +x src/tello-ros2-gazebo/tello_ros/tello_description/src/replace.py
# Install ros depencies
RUN rosdep install --from-paths src --ignore-src -r -y
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build"
# Gazebo
RUN source install/setup.bash
RUN export GAZEBO_MODEL_PATH=${PWD}/install/tello_gazebo/share/tello_gazebo/models
RUN source /usr/share/gazebo/setup.sh