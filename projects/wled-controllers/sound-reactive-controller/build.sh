#!/bin/bash

# WLED Sound Reactive Controller Build Script
# Automates building firmware for various configurations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project info
PROJECT_NAME="Sound Reactive WLED Controller"
VERSION=$(date +%Y%m%d)

echo -e "${BLUE}=======================================${NC}"
echo -e "${BLUE}  ${PROJECT_NAME}${NC}"
echo -e "${BLUE}  Build Script v${VERSION}${NC}"
echo -e "${BLUE}=======================================${NC}"
echo ""

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if PlatformIO is installed
if ! command -v pio &> /dev/null; then
    print_error "PlatformIO is not installed!"
    echo "Install with: pip install platformio"
    exit 1
fi

print_success "PlatformIO found"

# Clean previous builds
clean_build() {
    print_info "Cleaning previous builds..."
    rm -rf build/ .pio/build/
    print_success "Clean complete"
}

# Build single environment
build_env() {
    local env_name=$1
    print_info "Building environment: ${env_name}"

    if pio run -e ${env_name}; then
        print_success "Build successful: ${env_name}"
        return 0
    else
        print_error "Build failed: ${env_name}"
        return 1
    fi
}

# Build all environments
build_all() {
    print_info "Building all environments..."

    local envs=(
        "sound_reactive"
        "sound_reactive_s3"
        "sound_high_gain"
        "sound_party"
        "sound_30led"
        "sound_150led"
    )

    local failed=0
    for env in "${envs[@]}"; do
        if ! build_env ${env}; then
            ((failed++))
        fi
    done

    if [ ${failed} -eq 0 ]; then
        print_success "All builds successful!"
    else
        print_warning "${failed} build(s) failed"
    fi
}

# Copy firmware to releases folder
package_firmware() {
    print_info "Packaging firmware..."

    local release_dir="releases/${VERSION}"
    mkdir -p ${release_dir}

    # Copy firmware binaries
    for env in .pio/build/*/firmware.bin; do
        if [ -f "$env" ]; then
            local env_name=$(basename $(dirname $env))
            cp "$env" "${release_dir}/${PROJECT_NAME// /_}_${env_name}_${VERSION}.bin"
            print_info "Packaged: ${env_name}"
        fi
    done

    # Create MD5 checksums
    cd ${release_dir}
    md5sum *.bin > checksums.md5
    cd - > /dev/null

    print_success "Firmware packaged in: ${release_dir}"
}

# Flash firmware
flash_firmware() {
    local env_name=${1:-sound_reactive}
    local port=${2:-/dev/ttyUSB0}

    print_info "Flashing ${env_name} to ${port}..."

    if pio run -e ${env_name} -t upload --upload-port ${port}; then
        print_success "Flash successful!"
    else
        print_error "Flash failed!"
        return 1
    fi
}

# Monitor serial output
monitor_serial() {
    local port=${1:-/dev/ttyUSB0}
    print_info "Starting serial monitor on ${port}"
    print_info "Press Ctrl+C to exit"
    pio device monitor -p ${port}
}

# Show help
show_help() {
    cat << EOF
Usage: ./build.sh [COMMAND] [OPTIONS]

Commands:
    build [ENV]         Build specific environment (default: sound_reactive)
    build-all          Build all environments
    clean              Clean build files
    flash [ENV] [PORT] Flash firmware to device
    monitor [PORT]     Monitor serial output
    package            Package firmware for release
    help               Show this help message

Environments:
    sound_reactive     Standard sound reactive build
    sound_reactive_s3  ESP32-S3 with PSRAM
    sound_debug        Debug build with audio visualization
    sound_high_gain    High gain for quiet environments
    sound_party        Party mode for loud music
    sound_30led        USB-powered 30 LED setup
    sound_150led       Large 150 LED installation
    sound_ota          OTA update build
    mic_test           Microphone testing only

Examples:
    ./build.sh build                    # Build standard configuration
    ./build.sh build sound_party        # Build party mode
    ./build.sh build-all                # Build all configurations
    ./build.sh flash sound_reactive /dev/ttyUSB0
    ./build.sh monitor /dev/ttyUSB0
    ./build.sh package                  # Create release package

EOF
}

# Main script logic
case "${1}" in
    build)
        if [ -n "${2}" ]; then
            build_env ${2}
        else
            build_env sound_reactive
        fi
        ;;
    build-all)
        build_all
        ;;
    clean)
        clean_build
        ;;
    flash)
        flash_firmware ${2} ${3}
        ;;
    monitor)
        monitor_serial ${2}
        ;;
    package)
        package_firmware
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        if [ -z "${1}" ]; then
            # No arguments - interactive mode
            echo "Select operation:"
            echo "1) Build standard configuration"
            echo "2) Build all configurations"
            echo "3) Flash firmware"
            echo "4) Monitor serial"
            echo "5) Clean builds"
            echo "6) Package release"
            read -p "Enter choice [1-6]: " choice

            case ${choice} in
                1) build_env sound_reactive ;;
                2) build_all ;;
                3)
                    echo "Available environments:"
                    echo "  sound_reactive, sound_party, sound_high_gain, sound_30led, etc."
                    read -p "Enter environment [sound_reactive]: " env
                    env=${env:-sound_reactive}
                    read -p "Enter port [/dev/ttyUSB0]: " port
                    port=${port:-/dev/ttyUSB0}
                    flash_firmware ${env} ${port}
                    ;;
                4)
                    read -p "Enter port [/dev/ttyUSB0]: " port
                    port=${port:-/dev/ttyUSB0}
                    monitor_serial ${port}
                    ;;
                5) clean_build ;;
                6) package_firmware ;;
                *) print_error "Invalid choice" ;;
            esac
        else
            print_error "Unknown command: ${1}"
            show_help
            exit 1
        fi
        ;;
esac

echo ""
print_info "Done!"
