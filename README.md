# Jellyfish-docker

Dockerfiles for creating images to build [Jellyfish](https://github.com/FabianLangkabel/Jellyfish).

The [jellyfish](https://hub.docker.com/repository/docker/svenkleinert/jellyfish) image for amd64 machines is available at [dockerhub](https://hub.docker.com/).

The following procedure (especially the graphical forwarding) is tested on debian based amd64 machines (ubuntu+debian).

To run the GUI of Jellyfish run:

```bash
docker run --rm --net=host -e "DISPLAY=$DISPLAY" -it -v $(xauth info | grep "Authority file" | awk '{ print $3 }'):/root/.Xauthority:ro  -v .:/data svenkleinert/jellyfish:1.0
```

The last argument `-v .:/data` mounts the current working directory (`.`) to `/data` inside the container to import/export data to/from the container and needs to be adjusted!

To run the CMD version no graphical forwarding is required but the entrypoint needs to be changed:

```bash
docker run -it -v .:/data --entrypoint JellyfishCMD svenkleinert/jellyfish:1.0
```

To build your own fork of the jellyfish source code, copy the `Dockerfile_local` into your jellyfish source directory.
Afterwards you can build the docker container:

```bash
docker build -t jellyfish-local -f Dockerfile_local .
```

Afterwards you can run your local docker container by replacing `svenkleinert/jellfish:1.0` by `jellfish-local` in the commands above.
