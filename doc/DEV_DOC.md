# Docker Developer Documentation

## Table of Contents
1. [Installation](#installation)
2. [Docker Basics](#docker-basics)
3. [Docker Compose](#docker-compose)
4. [Project Setup](#project-setup)

---

## Installation

### Linux (Ubuntu/Debian)

#### Using Official Docker Repository
```bash
# Update package index
sudo apt-get update

# Install dependencies
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up stable repository
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Verify installation
docker --version
docker run hello-world
```

#### Post-Installation (Run Docker without sudo)
```bash
# Create docker group
sudo groupadd docker

# Add your user to docker group
sudo usermod -aG docker $USER

# Activate group changes
newgrp docker

# Verify
docker run hello-world
```

### macOS

#### Using Docker Desktop
1. Download [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop)
2. Open the `.dmg` file and drag Docker to Applications
3. Launch Docker from Applications
4. Enter your password when prompted (required for privileged helper installation)
5. Verify installation:
```bash
docker --version
docker run hello-world
```

#### Using Homebrew
```bash
brew install --cask docker
# Or for Intel Macs:
brew install --cask docker

# Launch Docker Desktop and verify
docker --version
```

### Windows

#### Using Docker Desktop (Recommended)
1. Download [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop)
2. Run the installer and follow the setup wizard
3. **For Windows 10/11 Pro/Enterprise**: Hyper-V will be enabled automatically
4. **For Windows 10/11 Home**: WSL 2 (Windows Subsystem for Linux 2) will be installed
5. Restart your computer
6. Launch Docker Desktop
7. Verify installation (open PowerShell or CMD):
```powershell
docker --version
docker run hello-world
```

#### Install Docker Compose
Docker Desktop includes Docker Compose, but if needed separately:
```powershell
# Download and install via PowerShell (as Admin)
$url = "https://github.com/docker/compose/releases/download/v2.x.x/docker-compose-Windows-x86_64.exe"
Invoke-WebRequest -Uri $url -OutFile $env:ProgramFiles\Docker\docker-compose.exe
```

---

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

# Run with port mapping
docker run -d -p 8080:80 --name web nginx:latest
# Access at http://localhost:8080

# Run with volume mounting
docker run -it -v /host/path:/container/path ubuntu:20.04 /bin/bash

# Run with environment variables
docker run -d -e DATABASE_URL=postgres://db:5432 myapp:latest

# Run with resource limits
docker run -d --memory="512m" --cpus="1" myapp:latest
```

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
docker logs -f my-container

# View container details
docker inspect my-container

# View resource usage
docker stats my-container
```

#### Stopping a Container

```bash
# Graceful stop (sends SIGTERM)
docker stop my-container

# Force stop (sends SIGKILL)
docker kill my-container

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

# Tag image
docker tag ubuntu:20.04 myrepo/ubuntu:latest

# Push image to registry
docker push myrepo/ubuntu:latest
```

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
└── doc/                  # Documentation
```

### Using the Makefile

```bash
# Build and start all services
make up

# Stop services
make down

# View logs
make logs

# Rebuild specific service
make rebuild-wordpress

# Clean everything
make clean
```

### Debugging

```bash
# Check service logs
docker-compose logs wordpress

# Access service shell
docker-compose exec wordpress /bin/bash

# Check network connectivity
docker-compose exec wordpress ping mariadb

# Inspect volume contents
docker volume inspect <volume_name>

# View resource usage
docker stats
```

### Common Issues

#### Port Already in Use
```bash
# Find process using port
lsof -i :8080

# Change port in docker-compose.yaml
ports:
  - "8081:80"  # Changed from 8080
```

#### Container Won't Start
```bash
# Check logs for errors
docker-compose logs service_name

# Rebuild from scratch
docker-compose down -v
docker-compose up --build
```

#### Database Connection Issues
```bash
# Verify service is running
docker-compose ps

# Test connectivity
docker-compose exec web ping db

# Check environment variables
docker-compose exec web env | grep DATABASE
```

---

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Docker Hub](https://hub.docker.com/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)

