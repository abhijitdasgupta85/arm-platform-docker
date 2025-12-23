# =========================================================
# ARM Cortex-A Platform - Multi Repo Docker Image
# =========================================================

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# ---------------------------------------------------------
# 1. Install toolchain & runtime
# ---------------------------------------------------------
RUN apt-get update && apt-get install -y \
    gcc-arm-none-eabi \
    binutils-arm-none-eabi \
    qemu-system-arm \
    gdb-multiarch \
    make \
    python3 \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------
# 2. Create platform root
# ---------------------------------------------------------
WORKDIR /opt/arm-platform

# ---------------------------------------------------------
# 3. Clone your ARM bare-metal repo
# ---------------------------------------------------------
RUN git clone https://github.com/abhijitdasgupta85/arm-baremetal-qemu-lab.git app

# ---------------------------------------------------------
# 4. (Optional) Clone future repos
# ---------------------------------------------------------
# RUN git clone https://github.com/<your-username>/arm-shared-libs.git libs
# RUN git clone https://github.com/<your-username>/arm-tools.git tools

# ---------------------------------------------------------
# 5. Build the bare-metal project
# ---------------------------------------------------------
WORKDIR /opt/arm-platform/app
RUN make clean && make

# ---------------------------------------------------------
# 6. Default shell
# ---------------------------------------------------------
CMD ["/bin/bash"]
