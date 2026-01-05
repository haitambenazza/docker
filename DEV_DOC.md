*This project has been created as part of the 42 curriculum by hbenazza*

## Installation

#### Using Official Docker Repository
```bash

# Install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Verify installation
docker --version
docker run hello-world
```

## Docker Basics

### Key Concepts
- **Image**: A blueprint/template for containers (like a class)
- **Container**: A running instance of an image (like an object)
- **Registry**: Storage for images (Docker Hub, private registries)
- **Dockerfile**: Instructions to build an image

### Essential Commands

#### Pulling an Image
```bash
# Pull from Docker Hub (default)
docker pull ubuntu:20.04

# Pull from specific registry
docker pull myregistry.com/myimage:tag

# List local images
docker images
```

#### Starting a Container

```bash
# Run a container (creates new container each time)
docker run -it ubuntu:20.04 /bin/bash

# Run with name
docker run --name my-container -it ubuntu:20.04 /bin/bash

# Run in background (detached)
docker run -d --name web nginx:latest

#### Executing Commands in a Container

```bash
# Execute command in running container
docker exec -it my-container /bin/bash

# Execute command and get output
docker exec my-container ls -la

# Execute as specific user
docker exec -u root my-container apt-get update
```

#### Viewing Container Status

```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# View container logs
docker logs my-container

# Follow logs in real-time
docker logs my-container

# View container details
docker inspect my-container

# View resource usage
docker stats my-container
```

#### Stopping a Container

```bash

# Stop all running containers
docker stop $(docker ps -q)
```

#### Removing a Container

```bash
# Remove stopped container
docker rm my-container

# Force remove running container
docker rm -f my-container

# Remove all stopped containers
docker container prune

# Remove container and its volumes
docker rm -v my-container
```

#### Managing Images

```bash
# Remove image
docker rmi ubuntu:20.04

# Remove unused images
docker image prune

---

## Docker Compose

Docker Compose allows you to define and run multi-container applications.

### Basic Commands

```bash
# Start services defined in docker-compose.yaml
docker-compose up

# Start in background
docker-compose up -d

# View running services
docker-compose ps

# View logs
docker-compose logs

# Follow logs for specific service
docker-compose logs -f wordpress

# Stop services
docker-compose stop

# Stop and remove containers, networks
docker-compose down

# Rebuild images
docker-compose up --build

# Execute command in service
docker-compose exec wordpress wp plugin list
```

### Docker Compose File Structure

```yaml
version: '3.8'

services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./html:/usr/share/nginx/html
    depends_on:
      - app

  app:
    build:
      context: .
      dockerfile: Dockerfile
    environment:
      - DATABASE_URL=postgres://db:5432/mydb
    volumes:
      - ./app:/app

  db:
    image: postgres:13
    environment:
      - POSTGRES_PASSWORD=secret
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data:

networks:
  default:
    name: myapp_network
```

---

## Project Setup

### Initial Setup

```bash
# Clone the project
git clone <repository-url>
cd docker

# Build all images
docker-compose build

# Start all services
docker-compose up -d

# Verify services are running
docker-compose ps

# Check logs for errors
docker-compose logs
```

### Project Structure

```
.
├── Makefile              # Build automation
├── srcs/
│   ├── docker-compose.yaml
│   └── requirements/
│       ├── nginx/        # Web server
│       ├── wordpress/    # CMS
│       └── mariadb/      # Database
├── secrets/              # Credentials (git-ignored)

### Using the Makefile

```bash
# Build and start all services
make up

# Stop services
make stop

# View logs
make status

# Jump into a running container
make <container_name>

# Clean everything
make down

# Remove all images
make rmi

# Rebuild the project
make re

# Restart the containers
make restart
```

### Monitoring with additional tools
lazydocker