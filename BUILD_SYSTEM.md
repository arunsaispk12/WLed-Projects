# Build System Documentation

Comprehensive guide to the WLED Projects build system for multi-configuration firmware development.

## Overview

This repository includes a sophisticated build system that supports:
- **Multiple projects** with independent configurations
- **Multiple build environments** per project (debug, release, different LED counts, etc.)
- **Automated builds** via GitHub Actions CI/CD
- **Centralized build management** with the build-manager script
- **Easy configuration** through JSON and INI files

## Quick Start

### Build a Project

```bash
# Using build manager (recommended)
./build-manager.sh build projects/wled-controllers/basic-esp32-controller

# Using project-specific script
cd projects/wled-controllers/basic-esp32-controller
./build.sh build

# Using PlatformIO directly
cd projects/wled-controllers/basic-esp32-controller
pio run -e esp32_basic
```

### Flash Firmware

```bash
# Using build manager
./build-manager.sh flash projects/wled-controllers/basic-esp32-controller /dev/ttyUSB0

# Using project script
cd projects/wled-controllers/basic-esp32-controller
./build.sh flash esp32_basic /dev/ttyUSB0
```

### Interactive Mode

```bash
./build-manager.sh
# Follow the menu prompts
```

## Build System Architecture

### Directory Structure

```
WLed-Projects/
├── build-manager.sh           # Centralized build system
├── build-config.json          # Multi-build configuration
├── .github/workflows/
│   ├── build-firmware.yml     # CI/CD for firmware builds
│   └── pages.yml              # Documentation deployment
│
├── projects/
│   ├── wled-controllers/
│   │   ├── basic-esp32-controller/
│   │   │   ├── platformio.ini     # PlatformIO configuration
│   │   │   ├── build.sh           # Project build script
│   │   │   ├── src/               # Source code
│   │   │   ├── config/            # WLED configurations
│   │   │   └── hardware/          # Hardware documentation
│   │   │
│   │   └── sound-reactive-controller/
│   │       └── ... (similar structure)
│   │
│   └── custom-builds/
│       └── wled-rainmaker-combo/
│           └── ... (similar structure)
│
└── templates/
    └── project-template/       # Template for new projects
```

### Build Tools

| Tool | Purpose | Usage |
|------|---------|-------|
| `build-manager.sh` | Centralized build management | All projects |
| `project/*/build.sh` | Project-specific builds | Single project |
| `build-config.json` | Build configuration | Configuration |
| GitHub Actions | Automated CI/CD | Push to main |

## Build Manager

### Features

- ✅ List all projects
- ✅ Build single or all projects
- ✅ Multiple environments per project
- ✅ Automated firmware packaging
- ✅ Flash to device
- ✅ Serial monitoring
- ✅ Clean builds
- ✅ Interactive menu
- ✅ Color-coded output

### Usage Examples

```bash
# List all projects
./build-manager.sh list

# Build basic controller (default environment)
./build-manager.sh build projects/wled-controllers/basic-esp32-controller

# Build specific environment
./build-manager.sh build projects/wled-controllers/basic-esp32-controller esp32_release

# Build all projects
./build-manager.sh build-all

# Clean all builds
./build-manager.sh clean

# Package firmware
./build-manager.sh package

# Flash firmware
./build-manager.sh flash projects/wled-controllers/basic-esp32-controller /dev/ttyUSB0 esp32_basic

# Monitor serial
./build-manager.sh monitor /dev/ttyUSB0

# Interactive mode
./build-manager.sh
```

### Environment Variables

```bash
# Set parallel build jobs
export PARALLEL_BUILDS=8

# Set custom build output directory
export BUILD_DIR=my-builds

# Use in command
PARALLEL_BUILDS=8 ./build-manager.sh build-all
```

## PlatformIO Configuration

### Environment Structure

Each project has a `platformio.ini` file defining multiple environments:

```ini
[platformio]
default_envs = esp32_basic

[common]
platform = espressif32@6.4.0
framework = arduino
# Common settings

[env:esp32_basic]
board = esp32dev
build_flags = ${common.build_flags}
# Environment-specific settings

[env:esp32_release]
board = esp32dev
build_flags =
    ${common.build_flags}
    -Os
    -D NDEBUG

[env:esp32_debug]
board = esp32dev
build_type = debug
build_flags =
    ${common.build_flags}
    -D CORE_DEBUG_LEVEL=5
```

### Available Environments

#### Basic ESP32 Controller

| Environment | Description | LED Count | Use Case |
|-------------|-------------|-----------|----------|
| `esp32_basic` | Standard build | 60 | Default setup |
| `esp32_release` | Optimized | 60 | Production |
| `esp32_debug` | Debug logging | 60 | Troubleshooting |
| `esp32_30led` | Lower power | 30 | USB-powered |
| `esp32_150led` | More LEDs | 150 | Large installations |
| `esp32_ota` | OTA updates | 60 | Remote updates |
| `esp32c3` | ESP32-C3 | 60 | Newer chip |
| `esp32s3` | ESP32-S3 + PSRAM | 300 | High performance |

### Build Flags

Common build flags used across projects:

```ini
# LED Configuration
-D LEDPIN=2                    # LED data pin
-D DEFAULT_LED_COUNT=60        # Number of LEDs
-D DEFAULT_LED_TYPE=TYPE_WS2812_RGB

# WiFi
-D WLED_AP_SSID="WLED-AP"
-D WLED_AP_PASS="wled1234"

# Features
-D WLED_ENABLE_WEBSOCKETS      # WebSocket support
-D WLED_ENABLE_MQTT            # MQTT protocol
-D WLED_ENABLE_ADALIGHT        # Adalight protocol

# Optimization
-D WLED_DISABLE_HUESYNC        # Disable if not needed
-D WLED_DISABLE_INFRARED       # Disable IR remote
-D WLED_MAX_BUSSES=1           # Limit to 1 LED output

# Debug
-D CORE_DEBUG_LEVEL=5          # Verbose logging
-D DEBUG_ESP_PORT=Serial       # Debug output to serial
-D WLED_DEBUG                  # WLED debug messages
```

## Build Configuration File

### Structure

The `build-config.json` file provides centralized configuration:

```json
{
  "version": "1.0.0",
  "builds": {
    "project-name": {
      "name": "Display Name",
      "path": "projects/path/to/project",
      "environments": [...],
      "features": [...]
    }
  },
  "global_settings": {...},
  "build_profiles": {...},
  "hardware_configs": {...},
  "led_types": {...},
  "recommended_builds": [...]
}
```

### Build Profiles

Reusable build configurations:

```json
{
  "build_profiles": {
    "development": {
      "flags": ["-D CORE_DEBUG_LEVEL=5"]
    },
    "release": {
      "flags": ["-Os", "-D NDEBUG"]
    },
    "minimal": {
      "flags": ["-D WLED_DISABLE_HUESYNC"]
    }
  }
}
```

### Hardware Configs

Predefined LED configurations:

```json
{
  "hardware_configs": {
    "60_leds": {
      "led_count": 60,
      "max_current": 3000,
      "default_brightness": 128
    }
  }
}
```

## Project-Specific Build Scripts

Each project includes a `build.sh` script for project-specific operations.

### Features

- Build specific environments
- Build all environments
- Flash firmware
- Monitor serial
- Clean builds
- Package releases
- Interactive menu

### Usage

```bash
cd projects/wled-controllers/basic-esp32-controller

# Show help
./build.sh help

# Build default
./build.sh build

# Build specific environment
./build.sh build esp32_release

# Build all
./build.sh build-all

# Flash
./build.sh flash esp32_basic /dev/ttyUSB0

# Monitor
./build.sh monitor /dev/ttyUSB0

# Package
./build.sh package

# Interactive
./build.sh
```

## GitHub Actions CI/CD

### Automated Builds

Every push to `main` or pull request triggers automated builds:

1. **Build firmware** for all environments
2. **Create artifacts** for each build
3. **Generate checksums** (MD5, SHA256)
4. **Package releases** in ZIP archives
5. **Upload artifacts** (30-day retention)

### Workflow File

`.github/workflows/build-firmware.yml`

```yaml
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
```

### Viewing Build Results

1. Go to repository on GitHub
2. Click "Actions" tab
3. Select workflow run
4. Download artifacts

### Manual Trigger

```bash
# Via GitHub web interface:
Actions → Build Firmware → Run workflow

# Or using GitHub CLI:
gh workflow run build-firmware.yml
```

## Creating New Projects

### From Template

```bash
# 1. Copy template
cp -r templates/project-template projects/wled-controllers/my-new-project

# 2. Navigate to project
cd projects/wled-controllers/my-new-project

# 3. Edit files
# - README.md: Project description
# - platformio.ini: Build configuration
# - src/main.cpp: Source code
# - hardware/pinout.md: Pin assignments

# 4. Build
./build.sh build

# 5. Flash and test
./build.sh flash esp32_basic /dev/ttyUSB0
```

### Project Structure

Every project should include:

```
my-project/
├── README.md              # Documentation
├── CHANGELOG.md           # Version history
├── platformio.ini         # Build config
├── build.sh              # Build script
├── src/
│   └── main.cpp          # Source code
├── config/
│   └── wled_presets.json # WLED presets
├── hardware/
│   ├── pinout.md         # Pin assignments
│   └── schematic.pdf     # Circuit diagram (optional)
└── docs/
    └── images/           # Photos, diagrams
```

## Build Outputs

### Directory Structure

```
project/
├── .pio/
│   └── build/
│       ├── esp32_basic/
│       │   ├── firmware.bin
│       │   ├── firmware.elf
│       │   └── partitions.bin
│       └── esp32_release/
│           └── ...
│
└── build/                # Cleaned builds
    └── releases/
        └── 20241225/
            ├── firmware_esp32_basic.bin
            ├── firmware_esp32_release.bin
            └── checksums.md5
```

### Build Artifacts

| File | Description |
|------|-------------|
| `firmware.bin` | Main firmware binary |
| `firmware.elf` | ELF executable (with symbols) |
| `partitions.bin` | Partition table |
| `bootloader.bin` | ESP32 bootloader |
| `checksums.md5` | MD5 checksums |
| `checksums.sha256` | SHA256 checksums |

## Flashing Firmware

### Methods

#### 1. Using Build Scripts

```bash
# Project script
cd projects/wled-controllers/basic-esp32-controller
./build.sh flash esp32_basic /dev/ttyUSB0

# Build manager
./build-manager.sh flash projects/wled-controllers/basic-esp32-controller /dev/ttyUSB0
```

#### 2. Using PlatformIO Directly

```bash
cd projects/wled-controllers/basic-esp32-controller
pio run -e esp32_basic -t upload --upload-port /dev/ttyUSB0
```

#### 3. Using esptool

```bash
esptool.py --port /dev/ttyUSB0 write_flash 0x0 firmware.bin
```

#### 4. OTA (Over-The-Air)

```bash
# Build OTA firmware
pio run -e esp32_ota

# Flash via network
pio run -e esp32_ota -t upload --upload-port wled-controller.local
```

### Common Issues

**Port not found:**
```bash
# Linux
ls /dev/ttyUSB*
sudo chmod 666 /dev/ttyUSB0

# Mac
ls /dev/cu.*

# Windows
# Check Device Manager for COM port
```

**Permission denied:**
```bash
sudo usermod -a -G dialout $USER
# Log out and back in
```

**Flash fails:**
- Hold BOOT button during upload
- Try lower baud rate: `upload_speed = 115200`
- Check USB cable (data cable, not charge-only)

## Debugging

### Serial Monitor

```bash
# Using build scripts
./build.sh monitor /dev/ttyUSB0

# Using build manager
./build-manager.sh monitor /dev/ttyUSB0

# Using PlatformIO
pio device monitor -p /dev/ttyUSB0 -b 115200

# With exception decoder
pio device monitor --filter esp32_exception_decoder
```

### Debug Build

```bash
# Build debug version
pio run -e esp32_debug

# Flash and monitor
pio run -e esp32_debug -t upload -t monitor
```

### Common Debug Flags

```ini
build_flags =
    -D CORE_DEBUG_LEVEL=5          # Verbose
    -D DEBUG_ESP_PORT=Serial
    -D WLED_DEBUG
    -D DEBUG_ESP_HTTP_SERVER
    -D DEBUG_ESP_WIFI
```

## Advanced Topics

### Custom Bootloader

```ini
board_build.bootloader = custom_bootloader.bin
board_build.partitions = custom_partitions.csv
```

### Multiple LED Outputs

```ini
build_flags =
    -D WLED_MAX_BUSSES=4
    -D DATA_PINS=2,4,15,16
```

### PSRAM Support

```ini
[env:esp32s3]
board = esp32-s3-devkitc-1
board_build.arduino.memory_type = qio_opi
build_flags =
    -D BOARD_HAS_PSRAM
    -D DEFAULT_LED_COUNT=500
```

### Custom Libraries

```ini
lib_deps =
    ${common.lib_deps}
    username/library-name@^1.0.0
    https://github.com/user/repo.git#branch
```

## Best Practices

### Version Control

```bash
# Tag releases
git tag -a v1.0.0 -m "Release 1.0.0"
git push origin v1.0.0

# Create release branch
git checkout -b release/1.0
```

### Documentation

- Keep README.md updated
- Document pin changes in hardware/pinout.md
- Update CHANGELOG.md for each version
- Include build instructions
- Add troubleshooting section

### Testing

- Test on actual hardware before release
- Verify all environments build
- Check power consumption
- Test WiFi connectivity
- Validate effects performance

### Security

- Don't commit WiFi credentials
- Use `.gitignore` for secrets
- Sanitize config files
- Use environment variables for sensitive data

## Troubleshooting

See [docs/troubleshooting/COMMON_ISSUES.md](docs/troubleshooting/COMMON_ISSUES.md) for comprehensive troubleshooting guide.

### Quick Fixes

**Build fails:**
```bash
# Clean and rebuild
pio run -t clean
pio run
```

**Out of memory:**
```ini
# Reduce features
-D WLED_DISABLE_HUESYNC
-D WLED_MAX_USERMODS=0
```

**Slow builds:**
```bash
# Enable ccache
export PLATFORMIO_BUILD_CACHE_DIR=~/.pio-cache
```

## Resources

- [PlatformIO Documentation](https://docs.platformio.org/)
- [ESP-IDF Programming Guide](https://docs.espressif.com/projects/esp-idf/)
- [WLED Knowledge Base](https://kno.wled.ge/)
- [Project Examples](projects/)

## Support

- GitHub Issues: [Issues](https://github.com/arunsaispk12/WLed-Projects/issues)
- WLED Discord: https://discord.gg/QAh7wJHrRM
- Documentation: [GitHub Pages](https://arunsaispk12.github.io/WLed-Projects/)
