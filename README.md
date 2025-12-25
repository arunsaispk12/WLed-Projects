# WLED Projects & Hardware Development

A comprehensive workspace for WLED controller projects, custom hardware development, and ESP RainMaker integration.

## Directory Structure

```
WLed/
├── projects/               # WLED project implementations
│   ├── wled-controllers/  # Standard WLED controller builds
│   ├── custom-builds/     # Custom firmware modifications
│   └── experimental/      # Experimental features and prototypes
│
├── hardware/              # Hardware design files
│   ├── schematics/       # Circuit schematics
│   ├── pcb-designs/      # PCB layout files
│   ├── bom/              # Bill of Materials
│   └── datasheets/       # Component datasheets
│
├── docs/                  # Documentation
│   ├── guides/           # Step-by-step guides
│   ├── api/              # API documentation
│   └── troubleshooting/  # Common issues and solutions
│
├── firmware/              # Firmware development
│   └── libraries/        # Custom libraries
│
├── integrations/          # Third-party integrations
│   └── rainmaker/        # ESP RainMaker integration
│
└── resources/            # Additional resources
    ├── images/           # Images and diagrams
    ├── videos/           # Video tutorials
    └── references/       # Reference materials
```

## Quick Start

### 1. WLED Projects
Navigate to `projects/` to find or create WLED controller projects:
- **wled-controllers/**: Production-ready controller implementations
- **custom-builds/**: Modified WLED firmware with custom features
- **experimental/**: Testing new features and concepts

### 2. Hardware Development
All hardware-related files are in `hardware/`:
- Design schematics in `schematics/`
- PCB layouts in `pcb-designs/`
- Component lists in `bom/`
- Reference datasheets in `datasheets/`

### 3. Rainmaker Integration
See `integrations/rainmaker/` for the complete guide on integrating WLED with ESP RainMaker.

## Documentation

### Essential Guides

**Getting Started:**
- [Quick Start Guide](QUICK_START.md) - Get started quickly
- [Build System Guide](BUILD_SYSTEM.md) - Multi-configuration build system
- [Project Setup Guide](docs/guides/PROJECT_SETUP.md) - Organize your projects

**Hardware & Components:**
- [Wire Selection Guide](docs/guides/WIRE_SELECTION_GUIDE.md) - Choose the right wire for your project
- [LED Type Selection Guide](docs/guides/LED_SELECTION_GUIDE.md) - Compare and select LED types
- [Hardware Development Guide](docs/guides/HARDWARE_GUIDE.md) - Design custom controllers

**Integration & Advanced:**
- [WLED-Rainmaker Integration Guide](integrations/rainmaker/INTEGRATION_GUIDE.md) - Cloud connectivity
- [Reliability & Maintenance](docs/guides/RELIABILITY_MAINTENANCE.md) - Long-term operation

**Troubleshooting:**
- [Common Issues Guide](docs/troubleshooting/COMMON_ISSUES.md) - Solve problems quickly

### Resources
- [WLED Official Documentation](https://kno.wled.ge/)
- [ESP RainMaker Documentation](https://rainmaker.espressif.com/)
- [ESP32 Datasheet](hardware/datasheets/)

## Build System

This repository includes a sophisticated build system for easy multi-configuration development:

### Quick Build

```bash
# Build a project
./build-manager.sh build projects/wled-controllers/basic-esp32-controller

# Flash to device
./build-manager.sh flash projects/wled-controllers/basic-esp32-controller /dev/ttyUSB0

# Interactive mode
./build-manager.sh
```

### Features

- ✅ Multiple build configurations per project
- ✅ Automated CI/CD with GitHub Actions
- ✅ One-command building and flashing
- ✅ Project templates for quick starts
- ✅ Centralized configuration management

See [BUILD_SYSTEM.md](BUILD_SYSTEM.md) for complete documentation.

## Example Projects

See [PROJECTS_OVERVIEW.md](PROJECTS_OVERVIEW.md) for complete project catalog.

### 1. Basic ESP32 Controller ✅
**Location:** `projects/wled-controllers/basic-esp32-controller/`

- Standard WLED setup for ESP32
- Supports 30-500 LEDs
- 8 build configurations
- Complete documentation

**Quick start:**
```bash
cd projects/wled-controllers/basic-esp32-controller
./build.sh build
./build.sh flash esp32_basic /dev/ttyUSB0
```

### 2. Sound Reactive Controller ✅
**Location:** `projects/wled-controllers/sound-reactive-controller/`

- Music-synchronized LED visualization
- I2S digital microphone (INMP441)
- FFT analysis and beat detection
- 9 build variants

**Quick start:**
```bash
cd projects/wled-controllers/sound-reactive-controller
./build.sh build sound_reactive
./build.sh flash sound_reactive /dev/ttyUSB0
```

### 3. Moon/Ambient Lighting 🚧
**Location:** `projects/wled-controllers/moon-ambient-lighting/`

- RGBW for true white light
- Circadian rhythm support
- Sunrise/sunset simulation
- Coming soon!

### 4. Multi-Channel Controller 📋
**Location:** `projects/wled-controllers/multi-channel-controller/`

- 4-8 independent LED outputs
- Professional installations
- Planned for future release

---

See [PROJECTS_OVERVIEW.md](PROJECTS_OVERVIEW.md) for detailed comparison and selection guide.

## Getting Started

1. Review the documentation in `docs/guides/`
2. Check existing projects in `projects/` for examples
3. For Rainmaker integration, follow the dedicated guide in `integrations/rainmaker/`
4. Hardware designs can be found in `hardware/`

## Project Management

Each project should include:
- README.md with project description
- Source code or firmware files
- Configuration files
- Testing documentation
- Hardware requirements (if applicable)

## Contributing

When adding new projects:
1. Create a new directory in the appropriate `projects/` subdirectory
2. Include comprehensive README.md
3. Document hardware requirements
4. Add schematics to `hardware/` if custom PCB is involved
5. Update this main README if needed

## Notes

- Keep firmware libraries organized in `firmware/libraries/`
- Store all images and media in `resources/`
- Document troubleshooting steps in `docs/troubleshooting/`
