# GoCD Agent Docker image
GoCD Windows Agent Docker image (windows 10 Version 1903 (OS Build 18362.116))

# GoCD Agent Docker image

[GoCD agent](https://www.gocd.io) docker image based on ubuntu 18.04.


# Issues, feedback?

Please make sure to log them at https://github.com/DanH91/gocd-agent-windows-10-1903.

# Usage

Start the container with this:

```
docker run -d -e GO_SERVER_URL=... danh91/gocd-agent-windows-10-1903:v2019.5.0
```

**Note:** Please make sure to *always* provide the version. We do not publish the `latest` tag. And we don't intend to.

This will start the GoCD agent and connect it the GoCD server specified by `GO_SERVER_URL`.

> **Note**: The `GO_SERVER_URL` must be an HTTPS url and end with `/go`, for e.g. `https://ip.add.re.ss:8154/go`

## Usage with docker GoCD server

If you have a [gocd-server container](https://hub.docker.com/r/gocd/gocd-server/) running and it's named `angry_feynman`, you can connect a gocd-agent container to it by doing:

```
docker run -d -e GO_SERVER_URL=https://$(docker inspect --format='{{(index (index .NetworkSettings.IPAddress))}}' angry_feynman):8154/go danh91/gocd-agent-windows-10-1903:v2019.5.0
```
OR

If the docker container running the gocd server has ports mapped to the host,

```
docker run -d -e GO_SERVER_URL=https://<ip_of_host_machine>:$(docker inspect --format='{{(index (index .NetworkSettings.Ports "8154/tcp") 0).HostPort}}' angry_feynman)/go danh91/gocd-agent-windows-10-1903:v2019.5.0
```

# Available configuration options

## Auto-registering the agents

```
docker run -d \
        -e AGENT_AUTO_REGISTER_KEY=... \
        -e AGENT_AUTO_REGISTER_RESOURCES=... \
        -e AGENT_AUTO_REGISTER_ENVIRONMENTS=... \
        -e AGENT_AUTO_REGISTER_HOSTNAME=... \
        danh91/gocd-agent-windows-10-1903:v2019.5.0
```

If the `AGENT_AUTO_REGISTER_*` variables are provided (we recommend that you do), then the agent will be automatically approved by the server. See the [auto registration docs](https://docs.gocd.io/current/advanced_usage/agent_auto_register.html) on the GoCD website.

## Usage with docker and swarm elastic agent plugins (Work in progress)

This image will work well with the [docker elastic agent plugin](https://github.com/gocd-contrib/docker-elastic-agents) and the [docker swarm elastic agent plugin](https://github.com/gocd-contrib/docker-swarm-elastic-agents). No special configuration would be needed.

# Troubleshooting

## The GoCD agent does not connect to the server

- Check if the docker container is running `docker ps -a`
- Check the STDOUT to see if there is any output that indicates failures `docker logs CONTAINER_ID`
- Check the agent logs `docker exec -it CONTAINER_ID powershell`.


# License

```plain
Copyright 2019 DanielK.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
