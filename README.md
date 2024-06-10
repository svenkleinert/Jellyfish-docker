# Jellyfish-docker
Dockerfiles for creating images to build [Jellyfish](https://github.com/FabianLangkabel/Jellyfish).

The [jellyfish-build](https://hub.docker.com/repository/docker/svenkleinert/jellyfish-build) and [jellyfish](https://hub.docker.com/repository/docker/svenkleinert/jellyfish) images for amd64 machines are available at [dockerhub](https://hub.docker.com/).

The following procedure (especially the graphical forwarding) is tested on debian based amd64 machines (ubuntu+debian).

To run the GUI of Jellyfish run:
```bash
docker run --rm --net=host -e "DISPLAY=$DISPLAY" -it -v $(xauth info | grep "Authority file" | awk '{ print $3 }'):/root/.Xauthority:ro  -v .:/data svenkleinert/jellyfish
```
The last argument `-v .:/data` mounts the current working directory (`.`) to `/data` inside the container to import/export data to/from the container and needs to be adjusted!

To run the CMD version no graphical forwarding is required but the entrypoint needs to be changed:
```bash
docker run -it -v .:/data --entrypoint JellyfishCMD svenkleinert/jellyfish
```
