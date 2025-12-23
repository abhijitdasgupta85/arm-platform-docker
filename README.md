# ARM Bare-Metal Platform – Docker Build & Run Environment
============================================================
**Overview**
-----------------------------
This repository provides a Docker-based build and execution environment for an ARM Cortex-A bare-metal project, specifically:
  arm-baremetal-qemu-lab (application repo)

The Docker image:
  - Clones the required GitHub repositories 
  - Builds the bare-metal executables inside Docker
  - Runs the resulting ELF on QEMU
  - Eliminates the need for local toolchain installation
  - Is fully CI/CD-ready
  - This repository acts as an integration / platform layer, not an application repo.

**Architecture Overview**
-----------------------------
Host / CI
   |
   |  docker build
   v
Docker Image
   |
   |-- clones application repo(s)
   |-- builds ARM bare-metal executables
   |-- packages artifacts
   |-- runs QEMU

**Repositories Used**
 ---------------------------------------
    | Repository               | Purpose                             |
    | ------------------------ | ----------------------------------- |
    | `arm-baremetal-qemu-lab` | ARM Cortex-A bare-metal application |

**Directory Structure (This Repo)**
--------------------------------------
  arm-platform-docker/
  ├── Dockerfile
  ├── .dockerignore
  ├── README.md
  └── entrypoint/
      └── entrypoint.sh   (optional)

**Directory Structure (Inside Docker Image)** 
------------------------------------------------
After build, the container filesystem looks like:

  /opt/arm-platform/
  ├── app/
  │   ├── build/
  │   │   └── kernel.elf
  │   ├── scripts/
  │   └── tools/

**Build the Docker Image**
------------------------------------------------
docker build -t arm-baremetal-qemu .

**Run the Container**
------------------------------------------------
docker run --rm -it arm-baremetal-qemu

Inside the container:
  cd /opt/arm-platform/app
  ./scripts/run_qemu.sh

**Export Built Executables (Optional)**
-----------------------------------------
To extract the built ELF file to the host:
    docker run --rm -v $(pwd)/out:/out arm-baremetal-qemu cp /opt/arm-platform/app/build/kernel.elf /out/


