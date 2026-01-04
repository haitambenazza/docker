# INCEPTION

*This project has been created as part of the 42 curriculum by hbenazza*

## Project Overview

Inception is a Docker-based project that sets up a complete web infrastructure using containerization. It deploys a WordPress website with a MariaDB database and an Nginx web server, all orchestrated via Docker Compose. This project demonstrates the use of Docker for building, shipping, and running applications in isolated environments.

## Docker Fundamentals

### What is Docker?

Docker is a platform for developing, shipping, and running applications inside containers. Containers are lightweight, portable, and self-sufficient units that package an application and its dependencies.

### Why Docker?

Docker simplifies the process of deploying applications by ensuring consistency across different environments. It eliminates issues like "it works on my machine" by packaging everything needed to run the application.

### How to Use Docker

Docker uses commands like `docker build`, `docker run`, `docker pull`, etc., to manage images and containers.

### When to Use Docker

Docker is ideal for microservices, continuous integration/deployment, and environments where isolation and portability are key.

### Docker vs Virtualization

- **Virtualization**: Uses a hypervisor to create virtual machines with full OS, leading to higher resource usage.
- **Containers**: Share the host OS kernel, making them more efficient and faster to start.

### What is a Container?

A container is a process tricked into thinking it's isolated. This isolation is achieved through three core primitives: namespaces, cgroups, and chroot.

### What is a Container Engine?

A container engine is software that manages the lifecycle of containers, such as Docker Engine.

### How Does the Container Engine Isolate Processes?

Isolation is done using namespaces (e.g., PID, network, mount) to separate processes, filesystems, and networks.

### Docker Runtime, Engine, and Orchestrator

- **Runtime**: Low-level component (e.g., runc) that creates and runs containers.
- **Engine**: The core software (Docker Engine) that includes API, image builder, and runtimes.
- **Orchestrator**: Tools like Docker Compose or Kubernetes for managing multiple containers.

### Docker Levels

Docker operates at multiple levels: high-level (containerd) and low-level (runc).

### How Docker Operates at Low and High Levels

- **Low Level (runc)**: Uses syscalls to create namespaces and cgroups.
- **High Level (containerd)**: Manages images, monitors containers, and interfaces with runc.

### What is Dockerd?

Dockerd is the Docker daemon, the background service that manages Docker objects like images, containers, networks, and volumes.

### What is a Docker Image?

A Docker image is a read-only package containing the OS filesystem, application, and dependencies. Images are built from layers and can be stored in registries like Docker Hub.

### What is a Dockerfile?

A Dockerfile is a plain text file that instructs Docker on how to build an image. It includes instructions like FROM, COPY, RUN, etc.

### How to Build an Image

Use `docker build -t <image_name> <context>` to build an image from a Dockerfile.

## Docker Engine

The Docker Engine is the software that runs and manages containers, often referred to simply as Docker. It consists of multiple components including the API, image builder, high-level runtime (containerd), and low-level runtime (runc).

When Docker was first released, it comprised two major components:
- **Docker Daemon (dockerd)**: Contains code for the API, image builder, runtime, and more.
- **LXC (Linux Containers)**: A set of tools for creating system containers by combining namespaces and cgroups.

However, after 2014, Docker replaced LXC with its own library called libcontainer (now part of runc), since LXC relied on Linux-based systems, limiting portability.

## Docker Image

A Docker image is a read-only package that contains everything needed to build and run an application. Images are composed of stacked layers representing the minimal OS, dependencies, app code, and config files. Images can also be thought of as stopped containers.

- **Storage**: Images are typically stored in `/var/lib/docker/`.
- **Management Commands**:
  - Check images: `docker images` or `docker image ls`.
  - Pull from registries: `docker pull <image>`.
  - Search images: `docker search <image>`.
  - Inspect layers: `docker inspect <image>`.
  - Delete image: `docker rmi <image>` (won't delete if a container uses it).
  - Delete all images: `docker rmi $(docker images -q) -f`.

## Docker Container

If an image is the template or 'class', then a container is the instance— the runtime instance of an image.

- **Starting a Container**: `docker run <image> <app/executable/script>`, optionally with `--name` for naming.
- **Stopping**: `docker stop <container ID>`.
- **Removing**: `docker rm <container ID>`.

A container can be defined as: **Container = Image (Read-only) + Writable Layer + Isolated Process**.

The writable layer stores changes, but data is lost if the container stops or the process exits, necessitating volumes for persistence.

- **Difference from VM**:
  - VMs require a host machine and hypervisor, which claims all CPU, RAM, storage, and creates virtual hardware constructs (hardware virtualization).
  - Containers perform OS virtualization by isolating process trees, filesystems, and network stacks, while the host OS handles hardware resources directly, without a hypervisor.

- **Self-Healing Policies**:
  - **always**: Always restart failing containers unless explicitly stopped (`docker run --restart always` or in YAML).
  - **unless-stopped**: If Docker service restarts, containers won't start automatically.
  - **on-failure**: Restart only if exited with non-zero code or on service restart.

## OCI (Open Container Initiative)

OCI is a set of standards describing how containers and images should be built.

**Three Main Specifications**:
- **Image Specs**: Defines the structure of container image files.
  - **Manifest**: A JSON file listing configs and layers.
  - **Layers**: Tarballs of actual filesystem changes.
  - **Configs**: A JSON file with environment variables and commands to run.
- **Runtime Specs**: Defines how containers are started and managed.
- **Distribution Specs**: Describes pushing and pulling images from registries like Docker Hub.

## OCI Workflow

1. `docker run nginx`: Docker Engine (daemon) finds the requested image via Docker CLI.
2. Docker tells containerd to handle the lifecycle; containerd pulls the OCI image and packs it into an OCI bundle (a folder on disk).
3. Containerd calls runc to initiate the container.
4. Runc reads `config.json` from the OCI bundle and makes syscalls to create namespaces and cgroups.

## Containerd

Containerd is a high-level runtime that takes abstracted commands from Docker (via Docker CLI) and converts them into OCI bundles for runc. It also manages and monitors running containers.

**Three Responsibilities**:
- **Image Management**: Handles push/pull, communicates with registries like Docker Hub, downloads layers, and stores them on disk.
- **Monitoring**: Manages the "Union Filesystem"—reads layers from the image (read-only), stacks them, and adds a writable layer for new or edited files.
- **Execute Runc**: Prepares layers, runs `runc`; once runc exits, containerd leaves a small shim process to watch the container and report crashes or errors.
- **Metadata**: Tracks running containers, their IDs, and associated images.

## Runc

Runc is a standalone CLI tool for running containers according to OCI runtime specs, using syscalls like `clone()`, `pivot_root()`, etc., to transform a standard process into an isolated container.

**Workflow**:
1. **Read Config File**: Parses `config.json` to determine requested namespaces (PID, Network, Mount, etc.).
2. **Create Namespaces**: Uses `unshare()` to run the program in new namespaces and `clone()` syscall to isolate the process (assigning PID 1).
3. **Setup Cgroups**: Writes the new PID into `cgroups.proc` file in created control blocks, effectively "handcuffing" the process to resource limits.
4. **Remove Permissions**: Strips down privileged commands or root powers.
5. **Exec**: Replaces itself with the actual command to execute.

It's possible to run `runc` directly without Docker or containerd for low-level operations.

## Cgroups

Cgroups (Control Groups) are a kernel feature for allocating resources to tasks, such as CPU, RAM, GPU, etc. They allow fine-grained control over resource usage by processes.

## Containerization

Containerization is the process of building, shipping, and running applications end-to-end:

1. Create the app and dependencies.
2. Write a Dockerfile to describe building and running the app.
3. Build into an image: `docker build <image-name> <build-context>`.
4. Run the container from the image.

### Dockerfile

A Dockerfile is a plain text file instructing Docker how to build an app into an image using instructions. It's best practice to place it in the build context (directory holding sources).

- **Filesystem Creators (Create Layers)**:
  - **FROM**: Pulls the specified image as the base layer.
  - **COPY**: Copies files from the host into the image.
  - **ADD**: Similar to COPY, but can add files from URLs or auto-extract .tar files.
  - **RUN**: Creates a temporary container to run commands, adding results to a new read-only layer.

- **Metadata Setters (Edit Image Config JSON at Runtime)**:
  - **WORKDIR**: Sets the specified directory as the current directory for subsequent RUN, COPY, ENTRYPOINT, etc.
  - **ENV**: Sets environment variables injected into the process environment.
  - **EXPOSE**: Documentation only; doesn't open ports but indicates expected ports.
  - **USER**: Changes permissions and UID before running processes, setting a default user.
  - **VOLUME**: Declares directories as mount points, marking them in the writable layer.

- **Execution Directives**:
  - **ENTRYPOINT**: The first binary runc executes; the process becomes PID 1.
  - **CMD**: Arguments for ENTRYPOINT.

## Multi-Container with Docker Compose

Deploying and managing multiple microservices with raw Docker requires extensive scripting and long commands. Docker Compose solves this with a single config file.

**Why Use Docker Compose?**
- Speeds up deployment.
- Handles dependencies (e.g., WordPress depends on MariaDB; Compose uses a dependency graph with `depends_on` to prevent crashes).
- Manages networking: Instead of manual `docker network create`, Compose handles virtual networks automatically.

### docker-compose.yaml

A config file specifying how to build and run services (a service may include multiple containers).

**Three Major Components**:
- **Services**: Each entry defines service configuration and runtime. Running `up` sends POST requests to the Docker Engine API to create isolated PID namespaces.
  - **build**: Instead of pulling pre-made images, specifies Dockerfile path and build context.
  - **container_name**: Assigns a name to the container.
  - **image**: Names the resulting image; Docker builds if it doesn't exist.
  - **restart**: Defines behavior on process exit (e.g., `always`).
  - **env_file**: Points to .env file; Docker injects passwords into environment namespaces.
  - **ports**: `<Host port>:<Container port>`.
  - **depends_on**: Defines execution order.
- **Networks**: Defines virtual connections between services.
  - **driver**: `<bridge>` creates a Linux bridge (virtual switch); containers get IPs in a private network.
  - **networks** (in services): Plugs services into specific networks, exposing only desired services via ports.
- **Volumes**: Links temporary filesystem to local VM disk.
  - **driver**: `<local>` uses local filesystem.
  - **driver_opts**:
    - **type**: `<none>` (no special filesystem like NFS).
    - **device**: Absolute path on VM host.
    - **o**: `<bind>` for bind mount, stapling VM host folder into container namespace.

**Docker Compose Commands**:
- `docker compose up`: Reads/parses YAML, builds images from Dockerfiles, starts containers.
- `docker compose stop`: Stops containers and networks without deleting (SIGTERM).
- `docker compose down`: Stops containers/networks and deletes them (like `make fclean`).

## Docker Volumes

Volumes are a persistence layer for storing data without losing it upon container removal. They are separate from containers.

- **Creation**: `docker volume create` (may need flags), or specify during `docker run` with `--mount source=<vol>,target=<path in container>`.

## Project Structure

```
Makefile
doc/
    answers.txt
    DEV_DOC.md
    README.md
    USER_DOC.md
secrets/
    credentials.txt
    db_password.txt
    db_root_password.txt
    root_wd_passwd.txt
    wordpress_passwd.txt
srcs/
    docker-compose.yaml
    requirements/
        mariadb/
            Dockerfile
            tools/
                50-server.cnf
                mariadb.sh
        nginx/
            Dockerfile
            tools/
                nginx.conf
                script.sh
        wordpress/
            Dockerfile
            tools/
                wd.sh
                www.conf
```

## Installation and Usage

1. Ensure Docker and Docker Compose are installed.
2. Clone the repository.
3. Navigate to `srcs/`.
4. Run `docker compose up --build` to start the services.
5. Access WordPress at `http://localhost` (adjust ports as needed).
6. Use `docker compose down` to stop and remove containers.

## Resources

- Docker Deep Dive: [Link](http://103.203.175.90:81/fdScript/RootOfEBooks/E%20Book%20collection%20-%202024%20-%20D/CSE%20%20IT%20AIDS%20ML/Docker%20Deep%20Dive.pdf)
- Container Unplugged: [Link](https://medium.com/@a.kanojiya2003/container-unplugged-how-docker-utilizes-linux-namespaces-and-chroot-2dd87d133a53)
- Docker in Action: [Link](https://pepa.holla.cz/wp-content/uploads/2016/10/Docker-in-Action.pdf)
- OCI Runtime Spec: [Link](https://opencontainers.org/posts/blog/2025-11-04-oci-runtime-spec-v1-3/)
- OCI Runtime Spec Repo: [Link](https://github.com/opencontainers/runtime-spec?tab=readme-ov-file)
- Containerd vs Docker: [Link](https://www.docker.com/blog/containerd-vs-docker/)
- Configure WordPress with Database: [Link](https://ubuntu.com/tutorials/install-and-configure-wordpress#1-overview)
- Nginx Guide: [Link](https://nginx.org/en/docs/beginners_guide.html)
