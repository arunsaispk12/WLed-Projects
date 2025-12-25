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
- [WLED-Rainmaker Integration Guide](integrations/rainmaker/INTEGRATION_GUIDE.md)
- [Hardware Development Guide](docs/guides/HARDWARE_GUIDE.md)
- [Project Setup Guide](docs/guides/PROJECT_SETUP.md)

### Resources
- [WLED Official Documentation](https://kno.wled.ge/)
- [ESP RainMaker Documentation](https://rainmaker.espressif.com/)
- [ESP32 Datasheet](hardware/datasheets/)

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
