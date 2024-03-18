from launch import LaunchDescription
import launch_ros.actions

def generate_launch_description():
    return LaunchDescription([
        launch_ros.actions.Node(
            namespace= "tello_gazebo", package='tello_gazebo', executable='inject_entity.py', output='screen'),
        launch_ros.actions.Node(
            namespace= "limo_gazebo", package='limo_description', executable='gazebo_models_diff.launch.py', output='screen'),
    ])
