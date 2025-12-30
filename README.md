# ARM Bare-Metal Platform – Docker Build & Run Environment

## Overview

This repository provides a **Docker-based build and execution environment** for an  
**ARM Cortex-A bare-metal project**, specifically the repository:

- **arm-baremetal-qemu-lab**

The Docker image created from this repository:

- Clones the required GitHub repository
- Builds **ARM bare-metal executables inside Docker**
- Runs the generated ELF on **QEMU**
- Eliminates the need for local toolchain installation
- Is fully **CI/CD-ready**

This repository acts as a **platform / integration layer**, not an application repository.

---

## Why This Repository Exists

In real embedded systems projects:

- Toolchains are heavy and OS-dependent
- Multiple repositories are involved
- Reproducibility is critical
- CI must produce the *same binaries* as developers

This repository makes Docker the **single source of truth** for:
- Build environment
- Toolchain versions
- Executable generation
- Runtime testing using QEMU

---

## Architecture Overview

```
Host / CI
   |
   |  docker build
   v
Docker Image
   |
   |-- clones arm-baremetal-qemu-lab
   |-- builds ARM bare-metal executables
   |-- packages build artifacts
   |-- runs QEMU
```

---

## Repositories Used

| Repository | Purpose |
|----------|--------|
| arm-baremetal-qemu-lab | ARM Cortex-A bare-metal application |

Additional repositories (shared libraries, schedulers, tools) can be added later without changing this architecture.

---

## Repository Structure (This Repo)

```
arm-platform-docker/
├── Dockerfile
├── .dockerignore
├── README.md
└── entrypoint/
    └── entrypoint.sh   (optional)
```

This repository contains **no application source code**.

---

## Directory Structure (Inside Docker Image)

After the Docker image is built, the container filesystem looks like:

```
/opt/arm-platform/
├── app/
│   ├── build/
│   │   └── kernel.elf
│   ├── scripts/
│   ├── tools/
│   ├── src/
│   ├── linker/
│   └── include/
```

- `kernel.elf` is **built inside Docker**
- No compilation happens on the host system

---

## How to Build, Run and Test the docker repository

### Step 1: Docker Build Strategy
-------------------------------------------
This project uses a **multi-stage Docker build**.
   ### Stage 1 – Builder
      - Installs ARM bare-metal toolchain
      - Clones `arm-baremetal-qemu-lab`
      - Executes `make`
      - Produces `kernel.elf`
   ### Stage 2 – Runtime
      - Installs QEMU and Python
      - Copies only required executables and scripts
      - Keeps the image clean and minimal

This mirrors **professional BSP / SDK build pipelines**.

### Step 2: Build the Docker Image
-------------------------------------------
From the root of this repository:
   ```bash
   docker build -t arm-baremetal-qemu .
   ```
   This step:
      - Clones the application repository
      - Builds the ARM bare-metal executable
      - Packages the result into the image

### Step 3:  Run the Container
-------------------------------------------
1. Once the docker image is built, Run the container with the below instruction/command

   ```bash
   docker run --rm -it arm-baremetal-qemu
   ```
2. Once the container is running you will see a linux command prompt. Navaigte as below
   and run the run_qemu.sh as below:
   
   Inside the container:
      ```bash
      cd /opt/arm-platform/app
      ./scripts/run_qemu.sh
      ```
   UART output from QEMU in the terminal.

      <img width="1201" height="107" alt="image" src="https://github.com/user-attachments/assets/1efebbc7-1955-465e-b581-316b84790c4a" />

 4. Running the Python UART Simulator
       - To run the python script you need to get into the running docker shell. To get into the specific docker contianer shell use the docker ID
       - To view the docker id, run the below command in a split window of a vs code

               docker ps

         This will display as below:
         
               CONTAINER ID   IMAGE                COMMAND       CREATED         STATUS         PORTS     NAMES
               ec0f56c056b6   arm-baremetal-qemu   "/bin/bash"   6 minutes ago   Up 6 minutes             upbeat_wiles
         
       - To get into the specific docker contianer shell run the below command using the docker id from above:

               docker exec -it ec0f56c056b6 /bin/bash
         
       - Once entered, run the below command to execute the python script

               python tools/uart_sim.py   

   Output
   
   <img width="1058" height="185" alt="image" src="https://github.com/user-attachments/assets/c63eb487-1444-4952-981f-e035b29b91e8" />

   This script:
   
      - Sends characters to the QEMU UART
      - Receives echoed data
      - Displays the UART traffic on the console

## Export Built Executables (Optional)
   To copy the built ELF file to the host:
   
      ```bash
      docker run --rm \
        -v $(pwd)/out:/out \
        arm-baremetal-qemu \
        cp /opt/arm-platform/app/build/kernel.elf /out/
      ```

Result on the host:

      ```
      out/kernel.elf
      ```
Useful for:

      - CI artifacts
      - Binary inspection
      - Debugging
---
## Host Requirements

Only **Docker** is required on the host.

      - Docker Engine (Linux / macOS / Windows)
      - No ARM toolchain
      - No QEMU installation
      - No Python installation

Everything runs inside the container.

---

## CI/CD Usage
This repository is directly usable in CI systems such as:

      - GitHub Actions
      - GitLab CI
      - Jenkins

Example (GitHub Actions):

   ```yaml
   jobs:
     build:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - run: docker build -t arm-baremetal-qemu .
   ```
