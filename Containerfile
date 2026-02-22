FROM docker.io/library/ubuntu:25.10

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    # GCC toolchain
    gcc g++ gfortran gcc-multilib g++-multilib \
    # Clang/LLVM toolchain
    clang clang-tools lld lldb clang-format clang-tidy \
    # Build systems
    cmake meson ninja-build make autoconf automake libtool pkg-config \
    # Debugging & profiling
    gdb valgrind strace ltrace linux-tools-generic \
    # Development libraries & headers
    libc6-dev libstdc++-13-dev \
    # Debug symbol packages
    libc6-dbg libstdc++6-13-dbg \
    # Utilities
    git curl wget ca-certificates \
    python3 python3-pip python3-venv \
    rustc cargo \
    nodejs npm  \
    # vcpkg dependencies
    zip unzip tar \
    sudo less \
    && rm -rf /var/lib/apt/lists/*




RUN echo 'ubuntu   ALL=(ALL:ALL) NOPASSWD:ALL' >>  /etc/sudoers

# Install Rust (stable + nightly)
ENV RUSTUP_HOME=/opt/rustup
ENV CARGO_HOME=/opt/cargo
ENV PATH="${CARGO_HOME}/bin:${PATH}"

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y --default-toolchain stable --profile default && \
    rustup toolchain install nightly && \
    rustup component add rust-src rustfmt clippy && \
    rustup component add rust-src rustfmt clippy --toolchain nightly

# Install conan
RUN pip3 install --break-system-packages conan

# Install vcpkg
ENV VCPKG_ROOT=/opt/vcpkg
RUN git clone https://github.com/microsoft/vcpkg.git ${VCPKG_ROOT} && \
    ${VCPKG_ROOT}/bootstrap-vcpkg.sh -disableMetrics && \
    ln -s ${VCPKG_ROOT}/vcpkg /usr/local/bin/vcpkg

# Create output directory
RUN mkdir -p /output

# Set working directory
WORKDIR /workspace

# Default shell with better defaults
SHELL ["/bin/bash", "-c"]

CMD ["/bin/bash"]
