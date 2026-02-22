# Build container environment configuration
# Source this file to set environment variables

export BUILD_CONTAINER_IMAGE="build-container"
export BUILD_CONTAINER_TAG="latest"

# Common build flags
export CFLAGS="-O2 -g -fPIC"
export CXXFLAGS="-O2 -g -fPIC"
export LDFLAGS=""

# Sanitizer presets (uncomment to use)
# export CFLAGS="-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer"
# export CXXFLAGS="-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer"
# export LDFLAGS="-fsanitize=address,undefined"
