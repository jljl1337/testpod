# testpod

[![Testing](https://github.com/jljl1337/testpod/actions/workflows/test.yaml/badge.svg)](https://github.com/jljl1337/testpod/actions/workflows/test.yaml)
[![Publish](https://github.com/jljl1337/testpod/actions/workflows/publish.yaml/badge.svg)](https://github.com/jljl1337/testpod/actions/workflows/publish.yaml)
[![Source](https://img.shields.io/badge/Source-GitHub-blue?logo=github)](https://github.com/jljl1337/testpod)
[![Docker](https://img.shields.io/badge/Docker-jljl1337%2Ftestpod-blue?logo=docker)](https://hub.docker.com/r/jljl1337/testpod)
[![License](https://img.shields.io/github/license/jljl1337/testpod)](https://github.com/jljl1337/testpod/blob/main/LICENSE)

A simple web application for container orchestrator testing

This is a simple web application that can be used to test container 
orchestrators like Kubernetes, OpenShift, Docker Swarm, etc. It is a simple web
application that displays the hostname of the pod/container that is serving the
request.

## Usage

The image serves a simple web application on port 8000 by default, which returns
the hostname of the pod/container in a `h1` tag. Besides the root path, the
application also serves a `/api` path that returns the hostname in a `p` tag.

You can also set the `API_URL` environment variable to append content from the
API to the html output, this can be used to simulate full stack applications
with load balancers, databases, etc.

A sample `docker-compose` file is as follows:

```yaml
services:
  frontend:
    image: jljl1337/testpod
    ports:
      - "8000:8000"
    environment:
      - API_URL=http://backend:8000/api

  backend:
    image: jljl1337/testpod
    environment:
      - API_URL=http://database:8000/api

  database:
    image: jljl1337/testpod
```

Examples of Docker Swarm, Kubernetes can be found in the `examples` directory
[here](https://github.com/jljl1337/testpod/tree/main/examples).

The environment variables can be set are:

- `API_URL`: The URL to fetch content from and append to the html output
- `HOST`: The host to serve the application on
- `PORT`: The port to serve the application on

## Development

Files for dev container are included, but you can also run the application
locally.

If you are developing locally, make sure you have Go installed.

Run the following command to start the application:

```bash
go run main.go
```

Or build and run:

```bash
go build -o testpod
./testpod
```

## License

This project is licensed under the MIT License - see the
[LICENSE](https://github.com/jljl1337/testpod/blob/main/LICENSE)