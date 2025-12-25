# WLED Projects Overview

Complete collection of ready-to-build WLED controller projects.

## 🎯 Project Status

| Project | Status | Difficulty | Cost | Build Time |
|---------|--------|------------|------|------------|
| [Basic ESP32 Controller](#1-basic-esp32-controller) | ✅ Complete | ⭐ Beginner | $25 | 1-2 hours |
| [Sound Reactive Controller](#2-sound-reactive-controller) | ✅ Complete | ⭐⭐ Intermediate | $35 | 2-3 hours |
| [Moon/Ambient Lighting](#3-moonambient-lighting) | ✅ Complete | ⭐ Beginner | $40 | 2-3 hours |
| [Multi-Channel Controller](#4-multi-channel-controller) | ✅ Complete | ⭐⭐⭐ Advanced | $60 | 3-4 hours |

---

## 1. Basic ESP32 Controller

**Location:** `projects/wled-controllers/basic-esp32-controller/`

### Quick Facts
- **Purpose:** General-purpose WLED controller
- **LEDs:** 30-500 (depending on power)
- **Features:** Standard WLED, WiFi control, web interface
- **Best For:** Learning, home lighting, first project

### What's Included
✅ Complete README with BOM and wiring
✅ 8 build variants (basic, debug, release, 30/60/150 LEDs, OTA, ESP32-C3, ESP32-S3)
✅ Hardware documentation (pinout.md)
✅ 15 pre-configured presets
✅ Firmware deployment guide (FIRMWARE.md)
✅ Production-ready configuration (wled_config.h)
✅ Build automation script

### Components
- ESP32-WROOM-32
- WS2812B LED strip (60 LED/m)
- 5V 3-5A power supply
- 74HCT125 level shifter
- Basic components (resistors, capacitors)

### Use Cases
- Under-cabinet lighting
- Desk ambient lighting
- Room accent lighting
- Holiday decorations
- Learning WLED basics

---

## 2. Sound Reactive Controller

**Location:** `projects/wled-controllers/sound-reactive-controller/`

### Quick Facts
- **Purpose:** Music-synchronized LED visualization
- **LEDs:** 30-300
- **Features:** I2S microphone, FFT analysis, beat detection
- **Best For:** Parties, gaming setups, music rooms

### What's Included
✅ Complete README with setup guide
✅ INMP441 I2S microphone integration
✅ 9 build variants (standard, ESP32-S3, debug, high/low gain, party mode)
✅ Hardware wiring diagrams
✅ Calibration procedures
✅ 8+ audio-reactive effects explained
✅ Troubleshooting guide

### Components
- ESP32-WROOM-32 (or ESP32-S3 for better performance)
- INMP441 I2S MEMS microphone
- WS2812B LED strip
- 5V 5A power supply
- Jumper wires

### Features
- **Real-time FFT** - Frequency analysis
- **Beat detection** - Pulse on bass drops
- **Multiple modes** - VU meter, waterfall, ripples
- **Auto-gain** - Adapts to sound levels
- **Adjustable sensitivity** - Via web interface

### Use Cases
- Party lighting
- DJ booth visualization
- Gaming room
- Home theater ambient
- Desktop music visualizer
- YouTube/streaming background

### Performance
- Latency: <20ms
- FFT Size: 256 samples
- Refresh Rate: 30-60 FPS
- Frequency Range: 20Hz-20kHz

---

## 3. Moon/Ambient Lighting

**Location:** `projects/wled-controllers/moon-ambient-lighting/`

### Quick Facts
- **Purpose:** Soft ambient lighting with circadian rhythm
- **LEDs:** SK6812 RGBW (dedicated white LED)
- **Features:** Warm-to-cool white transitions, sunrise/sunset simulation
- **Best For:** Bedrooms, nurseries, mood lighting

### What's Included
✅ Complete README with RGBW setup guide
✅ SK6812 RGBW LED integration
✅ 10 build variants (basic, sensors, circadian, 30/60/180 LEDs, natural/warm white)
✅ Hardware wiring diagrams
✅ Circadian rhythm schedules
✅ Moon phase simulation effects
✅ PIR motion sensor integration (optional)
✅ BH1750 light sensor integration (optional)
✅ Power calculations for RGBW strips

### Features
- 🌙 **Moon phases** - Simulate lunar cycle
- ☀️ **Circadian rhythm** - Auto warm/cool based on time
- 🛏️ **Sleep mode** - Gradual dimming
- ⏰ **Wake-up light** - Simulated sunrise
- 🎨 **RGBW Control** - True white + colors
- 🔆 **Auto brightness** - Light sensor integration
- 🚶 **Motion activation** - PIR sensor support

### Components
- ESP32-WROOM-32 (or ESP32-S3 for 300 LEDs)
- SK6812 RGBW LED strip (true white)
- 5V 5-6A power supply
- Optional: BH1750 light sensor
- Optional: HC-SR501 PIR motion sensor
- 74HCT125 level shifter
- Basic components

### Use Cases
- Bedroom ceiling light
- Nursery night light
- Reading nook
- Meditation room
- Home office (productivity lighting)
- Sleep/wake routines
- Smart bathroom lighting

---

## 4. Multi-Channel Controller

**Location:** `projects/wled-controllers/multi-channel-controller/`

### Quick Facts
- **Purpose:** Control multiple LED strips independently
- **Channels:** 4-8 independent outputs
- **Features:** Synchronized or independent control
- **Best For:** Large installations, architectural lighting

### What's Included
✅ Complete README with professional installation guide
✅ 11 build variants (4ch, 6ch, 8ch, commercial, architectural)
✅ Multiple LED type support (WS2812B, WS2815)
✅ Power distribution schematics
✅ Fusing strategy per channel
✅ 74HCT125 level shifter integration
✅ Control modes (synchronized, independent, zone, sequential)
✅ Wiring diagrams for 4/6/8 channel setups
✅ Professional enclosure recommendations
✅ Safety warnings and best practices

### Features
- 🎛️ **4-8 Channels** - Independent LED outputs
- 🔀 **Sync modes** - Synchronized or independent
- 🎨 **Per-channel control** - Different effects per channel
- 💪 **High power** - 60-120A total capacity
- 🏢 **Professional** - Fused outputs, power distribution
- ⚡ **Scalable** - Up to 3200 LEDs total (ESP32-S3)
- 🔧 **Flexible** - Zone-based and sequential control

### Components
- ESP32-WROOM-32 or ESP32-S3 (recommended)
- 4-8× 74HCT125 level shifters
- WS2812B or WS2815 LED strips
- 5V 60A+ power supply with distribution board
- Automotive blade fuses (5A per channel)
- Fuse holders
- Terminal blocks
- Professional enclosure (IP65 rated)
- Heavy gauge wire (14-16 AWG)

### Use Cases
- Building outline lighting (4 sides)
- Stage/theater lighting
- Restaurant/bar installations
- Multiple room synchronization
- Large home installations
- Commercial displays
- Architectural accent lighting
- Event venue lighting
- Retail storefront displays

---

## Project Comparison

### By Difficulty

**Beginner (⭐):**
- Basic ESP32 Controller
- Moon/Ambient Lighting

**Intermediate (⭐⭐):**
- Sound Reactive Controller

**Advanced (⭐⭐⭐):**
- Multi-Channel Controller

### By Cost

**Budget (<$30):**
- Basic ESP32 Controller (30 LEDs)

**Standard ($30-50):**
- Basic ESP32 Controller (60 LEDs)
- Sound Reactive Controller

**Premium ($50-100):**
- Moon/Ambient Lighting (RGBW)
- Multi-Channel Controller

### By Use Case

**Learning:**
→ Basic ESP32 Controller

**Entertainment:**
→ Sound Reactive Controller

**Relaxation/Sleep:**
→ Moon/Ambient Lighting

**Professional:**
→ Multi-Channel Controller

**All-Purpose:**
→ Basic ESP32 Controller

---

## Quick Start by Project

### Start Here: Basic Controller
```bash
cd projects/wled-controllers/basic-esp32-controller
./build.sh build esp32_basic
./build.sh flash esp32_basic /dev/ttyUSB0
```

### Sound Reactive
```bash
cd projects/wled-controllers/sound-reactive-controller
./build.sh build sound_reactive
./build.sh flash sound_reactive /dev/ttyUSB0
```

### Moon/Ambient Lighting
```bash
cd projects/wled-controllers/moon-ambient-lighting
./build.sh build moon_basic
./build.sh flash moon_basic /dev/ttyUSB0
```

### Multi-Channel Controller
```bash
cd projects/wled-controllers/multi-channel-controller
./build.sh build multi_4ch
./build.sh flash multi_4ch /dev/ttyUSB0
```

### Use Build Manager (All Projects)
```bash
# Interactive menu
./build-manager.sh

# Or specific project
./build-manager.sh build projects/wled-controllers/basic-esp32-controller
```

---

## Build System Features

All projects support:

✅ **Multiple Build Configurations**
- Debug builds with verbose logging
- Release builds (optimized)
- Different LED counts (30/60/150/300)
- Board variants (ESP32, ESP32-C3, ESP32-S3)
- OTA updates

✅ **One-Command Operations**
- Build firmware
- Flash to device
- Monitor serial output
- Package releases

✅ **Automated CI/CD**
- GitHub Actions builds all projects
- Automatic firmware artifacts
- Release packaging with checksums

✅ **Documentation**
- Complete README for each project
- Hardware diagrams
- BOMs with pricing
- Troubleshooting guides

---

## Common Components

Many projects share components - buy in bulk to save!

### Reusable Across Projects

| Component | Used In | Bulk Price |
|-----------|---------|------------|
| ESP32-WROOM-32 | All | $5-6 each |
| WS2812B Strip | Basic, Sound | $6-8/meter |
| SK6812 RGBW | Moon/Ambient | $10-12/meter |
| 5V Power Supply | All | $8-15 |
| Jumper Wires | All | $3-5/pack |
| 74HCT125 | Basic | $0.50 each |
| INMP441 Mic | Sound Only | $3-5 |

### Recommended Starter Kit

For building multiple projects:

- 3× ESP32-WROOM-32 boards
- 5m WS2812B LED strip (cut as needed)
- 2m SK6812 RGBW strip
- 5V 10A power supply
- Breadboard and jumper wire kit
- Basic electronics kit (resistors, capacitors, etc.)
- Soldering iron and supplies
- Multimeter

**Total:** ~$80-100
**Can Build:** All beginner and intermediate projects

---

## Project Roadmap

### ✅ Completed
- [x] Basic ESP32 Controller
- [x] Sound Reactive Controller
- [x] Moon/Ambient Lighting
- [x] Multi-Channel Controller
- [x] Build system infrastructure
- [x] Documentation suite
- [x] Wire selection guide
- [x] LED selection guide
- [x] Reliability & maintenance guide

### 📋 Planned Future Projects
- [ ] Outdoor Permanent Installation
- [ ] Portable Battery-Powered
- [ ] Smart Home Integration (full Home Assistant)
- [ ] Matrix Display (2D effects)
- [ ] POV (Persistence of Vision) Display
- [ ] RainMaker Integration Example
- [ ] Staircase Lighting
- [ ] PC Case RGB
- [ ] Car Interior Lighting

---

## Getting Help

### For Specific Projects
- Check project README first
- Review troubleshooting section
- Search [Common Issues Guide](docs/troubleshooting/COMMON_ISSUES.md)

### General Questions
- [WLED Documentation](https://kno.wled.ge/)
- [WLED Discord](https://discord.gg/QAh7wJHrRM)
- [GitHub Issues](https://github.com/arunsaispk12/WLed-Projects/issues)

### Community
- r/WLED on Reddit
- WLED Discourse forum
- This repository discussions

---

## Contributing

Want to add a project?

1. Use `templates/project-template/` as starting point
2. Follow the structure of existing projects
3. Include:
   - Complete README
   - platformio.ini with multiple environments
   - Hardware documentation
   - Build script
   - Example configurations
4. Submit pull request

---

## Project Showcase

Share your builds!

- Post photos in GitHub discussions
- Tag @arunsaispk12
- Include:
  - Which project you built
  - Any modifications
  - Photos/videos
  - Tips for others

---

## License

All projects based on WLED - MIT License

Individual hardware designs and documentation: MIT License

See individual project READMEs for specific attributions.

---

**Happy Building!** 🎨💡✨

For questions, issues, or contributions:
- **Repository:** https://github.com/arunsaispk12/WLed-Projects
- **Website:** https://arunsaispk12.github.io/WLed-Projects/
