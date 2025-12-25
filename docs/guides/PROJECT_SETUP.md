# Project Setup Guide

Guide for creating and organizing new WLED projects.

## Table of Contents
1. [Creating a New Project](#creating-a-new-project)
2. [Project Structure](#project-structure)
3. [Documentation Standards](#documentation-standards)
4. [Version Control](#version-control)
5. [Build Configuration](#build-configuration)

## Creating a New Project

### Step 1: Choose Project Type

Determine which category your project fits:

- **wled-controllers**: Standard WLED implementations for specific hardware
- **custom-builds**: Modified WLED firmware with custom features
- **experimental**: Testing new concepts and features

### Step 2: Create Project Directory

```bash
# Navigate to appropriate directory
cd projects/wled-controllers/  # or custom-builds/ or experimental/

# Create project directory
mkdir my-project-name
cd my-project-name

# Copy template files
cp ../../templates/project-template/* .
```

### Step 3: Initialize Project

Edit the `README.md` with your project details:
- Project name and description
- Hardware requirements
- Features
- Setup instructions

## Project Structure

### Standard Project Layout

```
my-project-name/
├── README.md              # Project documentation
├── platformio.ini         # Build configuration (if using PlatformIO)
├── config/                # Configuration files
│   ├── wled_presets.json # WLED presets
│   └── usermod_config.h  # Usermod configuration
├── src/                   # Source code
│   ├── main.cpp          # Main application (if custom)
│   └── usermods/         # Custom WLED usermods
├── hardware/              # Hardware-specific files
│   ├── schematic.pdf     # Circuit diagram
│   ├── pinout.md         # Pin assignments
│   └── bom.csv           # Bill of materials
├── images/                # Documentation images
│   ├── assembled.jpg
│   └── wiring.png
└── CHANGELOG.md           # Version history
```

### File Descriptions

#### README.md
Main project documentation. Should include:
- Overview
- Features
- Hardware requirements
- Wiring diagram
- Installation instructions
- Configuration
- Troubleshooting
- Credits

#### platformio.ini
Build configuration for PlatformIO projects:
```ini
[platformio]
default_envs = esp32dev

[common]
platform = espressif32
framework = arduino
board_build.partitions = min_spiffs.csv
monitor_speed = 115200

[env:esp32dev]
board = esp32dev
build_flags =
    -D WLED_ENABLE_MQTT
    -D USERMOD_MY_FEATURE
lib_deps =
    fastled/FastLED@^3.5.0
```

#### config/
Store configuration files:
- WLED presets
- Custom settings
- Usermod configurations

#### src/
Source code for custom builds:
- Modified WLED code
- Custom usermods
- Integration code

#### hardware/
Hardware documentation:
- Schematics
- PCB designs (reference to main hardware folder)
- Pin assignments
- BOM specific to this project

## Documentation Standards

### README.md Template

```markdown
# Project Name

Brief description of what this project does.

![Project Image](images/assembled.jpg)

## Features

- Feature 1
- Feature 2
- Feature 3

## Hardware Requirements

### Components
- ESP32 DevKit
- WS2812B LED strip (specify length/count)
- 5V power supply (specify amperage)
- Additional components...

### Pin Assignments
| ESP32 Pin | Function |
|-----------|----------|
| GPIO2     | LED Data |
| GPIO4     | Button   |
| ...       | ...      |

## Wiring Diagram

![Wiring Diagram](images/wiring.png)

[Detailed wiring instructions]

## Software Setup

### Prerequisites
- Arduino IDE with ESP32 support OR PlatformIO
- WLED repository cloned

### Installation

1. Clone this project
2. Configure platformio.ini or Arduino IDE
3. Upload firmware
4. Configure WLED via web interface

### Configuration

[Specific configuration steps]

## Usage

[How to use the project after setup]

## Troubleshooting

### Issue 1
**Symptom:** Description
**Solution:** How to fix

### Issue 2
...

## Future Improvements

- [ ] Planned feature 1
- [ ] Planned feature 2

## Credits

- Based on [WLED](https://github.com/Aircoookie/WLED)
- Additional credits...

## License

Follows WLED's MIT License
```

### CHANGELOG.md Template

```markdown
# Changelog

## [Unreleased]
### Added
- New features in development

### Changed
- Modifications to existing features

### Fixed
- Bug fixes

## [1.0.0] - 2024-XX-XX
### Added
- Initial release
- Feature list
```

## Version Control

### Git Setup

#### Initialize Repository

```bash
# In project directory
git init

# Create .gitignore
cat > .gitignore << 'EOF'
# Build artifacts
.pio/
build/
*.o
*.elf
*.bin

# IDE files
.vscode/
.idea/

# OS files
.DS_Store
Thumbs.db

# Secrets
secrets.h
credentials.h
EOF

# Initial commit
git add .
git commit -m "Initial project setup"
```

#### Branching Strategy

- `main`: Stable releases
- `develop`: Active development
- `feature/name`: New features
- `fix/name`: Bug fixes

### Commit Message Guidelines

Format:
```
<type>: <subject>

<body>

<footer>
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance

Example:
```
feat: Add sound reactive mode with INMP441 mic

- Integrate I2S microphone driver
- Add FFT analysis for frequency detection
- Create beat detection algorithm
- Add 5 sound-reactive effects

Closes #12
```

## Build Configuration

### PlatformIO Configuration

#### Basic Configuration

```ini
[platformio]
default_envs = esp32dev

[common]
platform = espressif32
framework = arduino
board_build.partitions = min_spiffs.csv
monitor_speed = 115200
upload_speed = 460800

build_flags =
    -D ARDUINO_ARCH_ESP32
    -D CONFIG_ASYNC_TCP_RUNNING_CORE=1

lib_deps =
    https://github.com/Aircoookie/WLED.git#v0.14.0
    fastled/FastLED@^3.5.0

[env:esp32dev]
board = esp32dev
build_flags =
    ${common.build_flags}
    -D LEDPIN=2
    -D BTNPIN=0
```

#### Advanced Configuration

```ini
[env:esp32_4mb]
board = esp32dev
board_build.flash_mode = dio
board_build.f_flash = 40000000L
board_build.partitions = default.csv

build_flags =
    ${common.build_flags}
    -D WLED_ENABLE_MQTT
    -D WLED_ENABLE_ADALIGHT
    -D WLED_ENABLE_HUB75MATRIX
    -D USERMOD_ROTARY_ENCODER_UI
    -D USERMOD_FOUR_LINE_DISPLAY

lib_deps =
    ${common.lib_deps}
    Wire
    SPI
```

### Arduino IDE Configuration

#### boards.txt (Custom Board Definition)

For custom hardware, create board definition:

```
wled_custom.name=WLED Custom Board
wled_custom.upload.tool=esptool_py
wled_custom.upload.maximum_size=1310720
wled_custom.upload.maximum_data_size=327680
wled_custom.upload.wait_for_upload_port=true
wled_custom.serial.disableDTR=true
wled_custom.serial.disableRTS=true
wled_custom.build.mcu=esp32
wled_custom.build.core=esp32
wled_custom.build.variant=esp32
wled_custom.build.board=ESP32_DEV
wled_custom.build.f_cpu=240000000L
wled_custom.build.flash_mode=dio
wled_custom.build.flash_freq=40m
wled_custom.build.flash_size=4MB
```

### Build Scripts

#### Automated Build Script

`build.sh`:
```bash
#!/bin/bash

set -e

echo "Building WLED project..."

# Clean previous builds
rm -rf build/

# Build with PlatformIO
pio run

# Copy firmware to releases
mkdir -p releases/
cp .pio/build/esp32dev/firmware.bin releases/firmware_$(date +%Y%m%d).bin

echo "Build complete! Firmware in releases/"
```

#### Flash Script

`flash.sh`:
```bash
#!/bin/bash

set -e

PORT=${1:-/dev/ttyUSB0}

echo "Flashing to $PORT..."

pio run -t upload --upload-port $PORT

echo "Flash complete! Opening monitor..."
pio device monitor -p $PORT
```

Make executable:
```bash
chmod +x build.sh flash.sh
```

## Testing Procedures

### Hardware Testing Checklist

- [ ] Power supply voltage correct
- [ ] Current draw within limits
- [ ] All LEDs light up
- [ ] No flickering or artifacts
- [ ] WiFi connection stable
- [ ] Web interface accessible
- [ ] All effects work
- [ ] Buttons respond correctly

### Software Testing

#### Unit Testing

Create `test/test_main.cpp`:
```cpp
#include <unity.h>

void test_led_initialization() {
    // Test LED initialization
    TEST_ASSERT_EQUAL(60, NUM_LEDS);
}

void test_brightness_range() {
    // Test brightness limits
    setBrightness(150);
    TEST_ASSERT_EQUAL(150, getBrightness());
}

void setup() {
    UNITY_BEGIN();
    RUN_TEST(test_led_initialization);
    RUN_TEST(test_brightness_range);
    UNITY_END();
}

void loop() {
    // Nothing
}
```

Run tests:
```bash
pio test
```

## Deployment

### Release Checklist

Before releasing:

- [ ] All features tested
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version number incremented
- [ ] Build artifacts generated
- [ ] Tag created in git
- [ ] Release notes written

### Creating a Release

```bash
# Update version
vim src/version.h  # or platformio.ini

# Commit changes
git add .
git commit -m "chore: Bump version to 1.0.0"

# Create tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Build release
./build.sh

# Push to remote
git push origin main --tags
```

## Sharing Your Project

### Documentation for Sharing

Ensure you have:
1. Clear README with all setup steps
2. Wiring diagrams and photos
3. Complete BOM with links
4. Configuration files
5. Troubleshooting section

### Platforms to Share

- GitHub/GitLab repositories
- WLED Discourse community
- Reddit r/WLED
- Hackster.io
- Instructables

### License Considerations

WLED uses MIT License. Your derivative work should:
- Include original WLED license
- Credit WLED project
- Use compatible license

## Project Maintenance

### Regular Tasks

**Weekly:**
- Test functionality
- Check for WLED updates
- Review issues/questions

**Monthly:**
- Update dependencies
- Review and merge improvements
- Update documentation

**Per Release:**
- Full testing
- Documentation review
- Changelog update
- Version tagging

### Handling Issues

When users report issues:

1. **Reproduce**: Try to recreate the problem
2. **Document**: Add to troubleshooting section
3. **Fix**: Implement solution
4. **Test**: Verify fix works
5. **Release**: Update project version

## Resources

### Templates Location
- Project template: `../../templates/project-template/`
- Documentation templates: This guide
- Build configurations: Examples above

### Additional Reading
- [WLED Wiki](https://kno.wled.ge/)
- [PlatformIO Documentation](https://docs.platformio.org/)
- [ESP32 Documentation](https://docs.espressif.com/projects/esp-idf/)

## Support

For project-specific help:
- Check main WLed documentation: `../../README.md`
- Review troubleshooting: `../troubleshooting/`
- WLED community resources
