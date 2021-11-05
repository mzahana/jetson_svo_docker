# jetson_svo_docker
A Docker image for the [SVO Pro](https://github.com/uzh-rpg/rpg_svo_pro_open) (visual inertial odomotery/SLAM) package, for Nvidia Jetson boards.

**This is tested on Jetson Xavier NX with Jetpack 4.4 [L4T 32.4.3]**

# Setup

## Hardware
* It's recommended to use Xavier NX with SSD drive for best performance. Check [this video](https://www.youtube.com/watch?v=ZK5FYhoJqIg&t=327s) to see how to use Xavier NX image from the SSD drive

## Docker Default Runtime

To enable access to the CUDA compiler (nvcc) during `docker build` operations, add `"default-runtime": "nvidia"` to your `/etc/docker/daemon.json` configuration file before attempting to build the containers:

``` json
{
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    },

    "default-runtime": "nvidia"
}
```

You will then want to restart the Docker service or reboot your system before proceeding.

## Building the docker image
* In Jetson, open a terminal , and execute the following commands
    ```bash
    # Create a directory to clone this package into
    mkdir -p $HOME/src && cd $HOME/src/
    # Clone this package
    git clone https://github.com/mzahana/jetson_svo_docker.git
    ```

* Build the `mzahana:jetson_svo` Docker image
    ```bash
    cd $HOME/src/jetson_svo_docker
    ./scripts/setup_jetson.sh
    ```
    You may need to provide passowrd for `sudo` when asked

* Once the image is built, you can verify that by listing Docker images `docker images`. You should see `mzahana:jetson_svo` availble in the listed images

* An alias will be added in the `~/.bashrc` for convenience. The alias is called `svo_container`. You can simply run the SVO container by executing `svo_container` in a terminal window

* Once the container is running, an interactive terminal inside the container can be used. 

**NOTE** The docker image includes installations of `Realsense SDK` and `realsense-ros` in case the D435i cameras is to be used with VINS. Make sure to download the [installRealSenseROS](https://github.com/mzahana/installRealSenseROS) package on the Jetson board, and run the `disableAutosuspend.sh` to turn off the USB autosuspend setting on the Jetson so that the camera is always available. Then reboot for the changes to take effect.

# Using SVO with cameras
Description will be added soon.

