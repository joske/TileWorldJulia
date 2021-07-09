# TileWorldJulia

julia main.jl

Docker:

docker build -t tileworld .

macOS (Xquartz needs to run with network access enabled and with xhost +):

docker run -ti -e DISPLAY=host.docker.internal:0 --rm --init tileworld

linux (complicated as it needs to forward the X display socket & xauth):

docker run -ti -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw --volume="$HOME/.Xauthority:/root/.Xauthority:rw" --network=host --privileged --rm --init tileworld