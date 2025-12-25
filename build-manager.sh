#!/bin/bash

# WLED Projects Build Manager
# Centralized build system for all projects

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
BUILD_DIR="build-output"
VERSION=$(date +%Y%m%d_%H%M%S)
PARALLEL_BUILDS=4

# Print functions
print_header() {
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
}

print_info() { echo -e "${CYAN}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }
print_building() { echo -e "${MAGENTA}[BUILD]${NC} $1"; }

# Check dependencies
check_dependencies() {
    print_info "Checking dependencies..."

    if ! command -v pio &> /dev/null; then
        print_error "PlatformIO not found!"
        echo "Install with: pip install platformio"
        exit 1
    fi

    print_success "PlatformIO found: $(pio --version)"
}

# List all projects
list_projects() {
    print_header "Available Projects"

    local projects=(
        "projects/wled-controllers/basic-esp32-controller:Basic ESP32 Controller"
        "projects/wled-controllers/sound-reactive-controller:Sound Reactive Controller"
        "projects/custom-builds/wled-rainmaker-combo:WLED-RainMaker Combo"
    )

    for i in "${!projects[@]}"; do
        IFS=':' read -r path name <<< "${projects[$i]}"
        if [ -d "$path" ]; then
            echo -e "${GREEN}[$((i+1))]${NC} $name"
            echo "    Path: $path"
        else
            echo -e "${YELLOW}[$((i+1))]${NC} $name ${YELLOW}(not found)${NC}"
        fi
    done
}

# Build single project
build_project() {
    local project_path=$1
    local env_name=${2:-""}

    if [ ! -d "$project_path" ]; then
        print_error "Project not found: $project_path"
        return 1
    fi

    print_building "Building: $project_path"

    cd "$project_path"

    if [ -n "$env_name" ]; then
        print_info "Environment: $env_name"
        pio run -e "$env_name"
    else
        print_info "Building all environments..."
        pio run
    fi

    cd - > /dev/null

    print_success "Build complete: $project_path"
}

# Build all projects
build_all() {
    print_header "Building All Projects"

    local projects=(
        "projects/wled-controllers/basic-esp32-controller"
    )

    local total=${#projects[@]}
    local current=0
    local failed=0

    for project in "${projects[@]}"; do
        ((current++))
        print_info "[$current/$total] Building $project..."

        if build_project "$project"; then
            print_success "[$current/$total] Success"
        else
            print_error "[$current/$total] Failed"
            ((failed++))
        fi
        echo ""
    done

    if [ $failed -eq 0 ]; then
        print_success "All builds completed successfully!"
    else
        print_warning "$failed build(s) failed"
    fi
}

# Clean builds
clean_builds() {
    print_info "Cleaning build artifacts..."

    find projects -type d -name ".pio" -exec rm -rf {} + 2>/dev/null || true
    find projects -type d -name "build" -exec rm -rf {} + 2>/dev/null || true
    rm -rf "$BUILD_DIR" 2>/dev/null || true

    print_success "Clean complete"
}

# Package firmware
package_firmware() {
    print_header "Packaging Firmware"

    mkdir -p "$BUILD_DIR/$VERSION"

    print_info "Collecting firmware binaries..."

    local count=0
    for firmware in projects/*/firmware.bin projects/*/*/firmware.bin projects/*/.pio/build/*/firmware.bin; do
        if [ -f "$firmware" ]; then
            local project_name=$(echo "$firmware" | cut -d'/' -f2)
            local env_name=$(basename $(dirname "$firmware"))

            local output_name="${project_name}_${env_name}_${VERSION}.bin"
            cp "$firmware" "$BUILD_DIR/$VERSION/$output_name"

            print_success "Packaged: $output_name"
            ((count++))
        fi
    done

    if [ $count -eq 0 ]; then
        print_warning "No firmware binaries found"
        return 1
    fi

    # Create checksums
    cd "$BUILD_DIR/$VERSION"
    md5sum *.bin > checksums.md5 2>/dev/null || true
    sha256sum *.bin > checksums.sha256 2>/dev/null || true
    cd - > /dev/null

    # Create archive
    cd "$BUILD_DIR"
    zip -r "firmware_${VERSION}.zip" "$VERSION/"
    cd - > /dev/null

    print_success "Packaged $count firmware file(s)"
    print_info "Location: $BUILD_DIR/$VERSION/"
    print_info "Archive: $BUILD_DIR/firmware_${VERSION}.zip"
}

# Flash firmware
flash_firmware() {
    local project_path=${1:-"projects/wled-controllers/basic-esp32-controller"}
    local port=${2:-"/dev/ttyUSB0"}
    local env=${3:-"esp32_basic"}

    print_header "Flashing Firmware"

    print_info "Project: $project_path"
    print_info "Port: $port"
    print_info "Environment: $env"

    if [ ! -d "$project_path" ]; then
        print_error "Project not found: $project_path"
        return 1
    fi

    cd "$project_path"

    if pio run -e "$env" -t upload --upload-port "$port"; then
        print_success "Flash complete!"

        read -p "Start serial monitor? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            pio device monitor -p "$port"
        fi
    else
        print_error "Flash failed!"
        return 1
    fi

    cd - > /dev/null
}

# Monitor serial
monitor_serial() {
    local port=${1:-"/dev/ttyUSB0"}
    local baud=${2:-115200}

    print_info "Monitoring $port at $baud baud"
    print_info "Press Ctrl+C to exit"
    echo ""

    pio device monitor -p "$port" -b "$baud"
}

# Interactive menu
interactive_menu() {
    print_header "WLED Projects Build Manager"

    echo ""
    echo "1) List all projects"
    echo "2) Build specific project"
    echo "3) Build all projects"
    echo "4) Clean all builds"
    echo "5) Package firmware"
    echo "6) Flash firmware"
    echo "7) Monitor serial"
    echo "8) Exit"
    echo ""

    read -p "Select option [1-8]: " choice

    case $choice in
        1)
            list_projects
            ;;
        2)
            read -p "Enter project path: " project_path
            read -p "Enter environment (or leave empty for all): " env_name
            build_project "$project_path" "$env_name"
            ;;
        3)
            build_all
            ;;
        4)
            clean_builds
            ;;
        5)
            package_firmware
            ;;
        6)
            read -p "Enter project path [projects/wled-controllers/basic-esp32-controller]: " project_path
            project_path=${project_path:-"projects/wled-controllers/basic-esp32-controller"}
            read -p "Enter port [/dev/ttyUSB0]: " port
            port=${port:-"/dev/ttyUSB0"}
            read -p "Enter environment [esp32_basic]: " env
            env=${env:-"esp32_basic"}
            flash_firmware "$project_path" "$port" "$env"
            ;;
        7)
            read -p "Enter port [/dev/ttyUSB0]: " port
            port=${port:-"/dev/ttyUSB0"}
            monitor_serial "$port"
            ;;
        8)
            print_info "Goodbye!"
            exit 0
            ;;
        *)
            print_error "Invalid option"
            ;;
    esac
}

# Show help
show_help() {
    cat << EOF
WLED Projects Build Manager

Usage: ./build-manager.sh [COMMAND] [OPTIONS]

Commands:
    list                List all available projects
    build PROJECT [ENV] Build specific project
    build-all          Build all projects
    clean              Clean all build artifacts
    package            Package all firmware binaries
    flash PROJECT PORT [ENV]
                       Flash firmware to device
    monitor [PORT]     Monitor serial output
    help               Show this help

Examples:
    # List projects
    ./build-manager.sh list

    # Build basic controller
    ./build-manager.sh build projects/wled-controllers/basic-esp32-controller

    # Build specific environment
    ./build-manager.sh build projects/wled-controllers/basic-esp32-controller esp32_release

    # Build all
    ./build-manager.sh build-all

    # Package firmware
    ./build-manager.sh package

    # Flash firmware
    ./build-manager.sh flash projects/wled-controllers/basic-esp32-controller /dev/ttyUSB0

    # Monitor serial
    ./build-manager.sh monitor /dev/ttyUSB0

    # Interactive mode (no arguments)
    ./build-manager.sh

Environment Variables:
    PARALLEL_BUILDS    Number of parallel builds (default: 4)
    BUILD_DIR          Output directory (default: build-output)

EOF
}

# Main script
main() {
    check_dependencies

    if [ $# -eq 0 ]; then
        # Interactive mode
        while true; do
            interactive_menu
            echo ""
            read -p "Press Enter to continue..."
            clear
        done
    fi

    case "$1" in
        list)
            list_projects
            ;;
        build)
            if [ -z "$2" ]; then
                print_error "Project path required"
                echo "Usage: $0 build PROJECT [ENV]"
                exit 1
            fi
            build_project "$2" "$3"
            ;;
        build-all)
            build_all
            ;;
        clean)
            clean_builds
            ;;
        package)
            package_firmware
            ;;
        flash)
            if [ -z "$2" ] || [ -z "$3" ]; then
                print_error "Project and port required"
                echo "Usage: $0 flash PROJECT PORT [ENV]"
                exit 1
            fi
            flash_firmware "$2" "$3" "$4"
            ;;
        monitor)
            monitor_serial "$2" "$3"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main
main "$@"
