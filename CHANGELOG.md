# Changelog

All notable changes to the WLed Projects documentation and resources will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2024-12-29

### Added

#### New Comprehensive Guides (6 Major Additions)

**Power Supply Selection Guide**
- Complete coverage of all PSU types (SMPS, linear, USB, ATX, battery)
- Voltage selection guide (5V, 12V, 24V) with detailed comparisons
- Sizing calculations with formulas and safety margins
- Mean Well product recommendations (LRS, HLG, RSP series)
- Power injection strategies for long LED runs
- Protection and fusing requirements
- Quick reference tables for 50-1000+ LEDs
- Special cases: outdoor, portable, multi-voltage

**Level Shifter Guide**
- Complete explanation of 3.3V to 5V level shifting necessity
- 74HCT125/74AHCT125 detailed pinouts and wiring diagrams
- MOSFET-based level shifter circuits (BSS138)
- Multi-channel configurations (SN74HCT245 for 8 outputs)
- Bi-directional level shifters (why not to use for LED data)
- Direct connection risks and "diode trick" alternatives
- Troubleshooting unreliable data signals
- Best practices and component recommendations

**Fuse Selection Guide**
- Safety-first comprehensive fusing guide
- Fuse types: automotive blade, glass tube, cartridge, resettable (PTC)
- Sizing formula: Current = LEDs × 0.06A × 0.8 × 1.25
- Wire gauge protection (fuse must protect the weakest link)
- Quick reference tables for different LED counts and voltages
- Installation methods: inline, panel mount, fuse blocks
- Placement rules and best practices
- Circuit breakers vs fuses comparison
- Special cases: inrush current, outdoor, multiple PSUs
- Troubleshooting blown fuses

**Sensor Integration Guide**
- PIR motion sensors: HC-SR501 and AM312 with complete wiring
- Microwave radar sensors: RCWL-0516 for through-wall detection
- Light sensors: LDR analog circuits and BH1750 I2C digital
- Microphones: MAX4466 analog and INMP441 I2S for sound-reactive
- Temperature/humidity: DHT22, BME280, DS18B20 with examples
- Distance sensors: HC-SR04 ultrasonic and VL53L0X I2C
- Rotary encoders: KY-040 for manual control
- Multi-sensor project examples
- Troubleshooting sensor issues

**Staircase Lighting Guide**
- Basic single staircase with 1-2 PIR sensors
- Directional detection (detecting up vs down movement)
- Multiple independent staircases from one ESP32
- PIR sensor placement strategies (height, angle, coverage)
- LED installation methods (under nosing, under tread, side mount)
- Power injection for long staircases
- WLED Stairway Usermod configuration
- Custom code examples with state machines
- Cascade patterns and timing
- Advanced features: light sensor integration, time-based behavior
- Home Assistant integration examples
- Complete parts list and cost breakdown

**Optional Components Interface Guide**
- Push buttons: wiring, debouncing (hardware and software)
- Rotary encoders: KY-040 pinout, interrupt-based code
- OLED displays: SSD1306 I2C with status and menu systems
- TFT displays: ST7789 color displays with graphics
- Infrared remotes: VS1838B receiver, learning codes
- Relay modules: switching high power, multi-channel
- Status LEDs: simple indicators, RGB LEDs
- Sound modules: DFPlayer Mini MP3 player
- Real-time clocks: DS3231 for time-based automation
- Complete control panel design examples

#### LED Selection Guide Enhancements

- **WS2811 Coverage**: Comprehensive section on WS2811 (5V and 12V versions)
  - External IC design (1 IC controls 3 LEDs)
  - 12mm bullet pixels for outdoor displays
  - LED modules and strip forms
  - Power advantage calculations showing 12V benefits
  - Outdoor pixel display use cases
  - Important voltage verification warnings

- **Additional LED Types**:
  - WS2801 (older clock-based)
  - LPD8806 (legacy clock-based)
  - UCS1903 (WS2811 alternative)
  - TM1814 (RGBW alternative)
  - P9823/PL9823 (WS2812B clones)

- **New Use Case**: Outdoor holiday display with pixel lights
- Updated comparison tables with WS2811
- Enhanced decision chart
- Updated recommendations for different project types

### Changed

**Documentation Structure**
- Reorganized README.md with clear guide categories:
  - Hardware & Components
  - Sensors & Integration
  - Application-Specific
  - Integration & Advanced
- Updated QUICK_START.md with categorized guide listings
- All guides now cross-reference related documentation

**Guide Organization**
- Consistent structure across all guides
- Table of contents in every guide
- "Related Guides" section at end of each guide
- Quick reference tables and decision charts
- Troubleshooting sections standardized

### Documentation Statistics

- **New Guides**: 6 comprehensive guides
- **Total Content**: ~25,000+ words of technical documentation
- **Diagrams**: 100+ ASCII diagrams and wiring schematics
- **Code Examples**: Dozens of copy-paste ready code snippets
- **Tables**: 50+ quick reference tables
- **Safety Warnings**: Comprehensive coverage throughout

### Features

✅ Production-ready documentation
✅ Beginner to advanced coverage
✅ Safety-first approach with warnings
✅ Practical wiring diagrams for every component
✅ Real-world examples and use cases
✅ Troubleshooting for common issues
✅ Parts lists with specific model numbers
✅ Cost estimates where applicable
✅ Best practices and recommendations

### Coverage

**Hardware Components**:
- Power supplies (all types, all voltages)
- Level shifters (all common types)
- Fuses and circuit protection
- All common LED types (WS2811, WS2812B, WS2813, WS2815, SK6812, APA102)

**Sensors & Integration**:
- Motion detection (PIR, radar)
- Light sensing (analog and digital)
- Sound (analog and I2S microphones)
- Temperature and humidity
- Distance measurement
- User input (buttons, encoders, displays)

**Applications**:
- Staircase automation with smart detection
- Multi-sensor smart lighting systems
- User control panels and interfaces
- Time-based automation
- Home automation integration

---

## [1.0.0] - 2024-12-26

### Added

**Initial Repository Structure**
- Project organization system
- Build system with multi-configuration support
- GitHub Actions CI/CD
- Template system for new projects

**Example Projects**
- Basic ESP32 Controller (8 configurations)
- Sound Reactive Controller (9 configurations)
- Moon/Ambient Lighting (10 configurations)
- Multi-Channel Controller (11 configurations)

**Initial Documentation**
- Hardware Development Guide
- Wire Selection Guide
- LED Selection Guide (basic)
- Reliability & Maintenance Guide
- Project Setup Guide
- Rainmaker Integration Guide
- Common Issues Troubleshooting

**Build System**
- Automated build manager
- Multi-configuration support
- Interactive CLI interface
- GitHub Actions workflows

---

## Version Numbering

**Major.Minor.Patch**

- **Major** (X.0.0): Breaking changes, major restructuring, new major features
- **Minor** (0.X.0): New guides, significant enhancements, new projects
- **Patch** (0.0.X): Bug fixes, minor updates, corrections

---

## Links

- [Repository](https://github.com/arunsaispk12/WLed-Projects)
- [Documentation](./README.md)
- [Quick Start](./QUICK_START.md)

---

**Note**: This changelog tracks documentation and resource updates. For project-specific changes, see individual project CHANGELOG files.
