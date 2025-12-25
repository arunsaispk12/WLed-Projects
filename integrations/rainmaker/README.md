# ESP RainMaker Integration

This directory contains everything needed to integrate WLED controllers with ESP RainMaker for cloud connectivity and smart home integration.

## What is ESP RainMaker?

ESP RainMaker is a platform by Espressif that enables:
- Cloud-based device control
- Mobile app integration (iOS/Android)
- Voice assistant support (Alexa, Google Home)
- Automation and scheduling
- OTA firmware updates
- Multi-device management

## Quick Start

1. **Read the Integration Guide**
   - Complete guide: [INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md)
   - Hardware setup
   - Firmware configuration
   - Cloud setup

2. **Choose Integration Method**
   - **Parallel Mode**: Run WLED and RainMaker side-by-side (recommended)
   - **Custom Firmware**: Build from scratch with both integrated

3. **Setup RainMaker Account**
   - Download ESP RainMaker app
   - Create account
   - Provision your device

## Directory Contents

```
rainmaker/
├── README.md              # This file
├── INTEGRATION_GUIDE.md   # Complete integration guide
├── examples/              # Example code and configurations
├── firmware/              # Custom firmware builds
└── docs/                  # Additional documentation
```

## Features

When WLED is integrated with RainMaker, you can:

- **Remote Control**: Access your WLED from anywhere
- **Voice Control**: "Alexa, turn on living room lights"
- **Schedules**: Automate based on time or sunrise/sunset
- **Scenes**: Quick preset recall from mobile app
- **Monitoring**: Track device status and connectivity
- **Updates**: Push firmware updates remotely

## Prerequisites

Before starting:
- ESP32-based WLED controller (working)
- ESP RainMaker app installed
- WiFi network (2.4GHz)
- Basic understanding of WLED configuration

## Integration Options

### Option 1: Using Pre-built Firmware
Easiest method - flash pre-configured firmware with both WLED and RainMaker.

**Pros:**
- Quick setup
- Tested and stable
- No coding required

**Cons:**
- Less customization
- May not have latest WLED features

### Option 2: DIY Integration
Add RainMaker to your existing WLED installation.

**Pros:**
- Latest WLED features
- Full customization
- Learn the integration

**Cons:**
- Requires coding
- More complex setup
- Need to maintain updates

### Option 3: HTTP Bridge
Run WLED normally and use a separate bridge service.

**Pros:**
- No firmware changes
- Easy to update WLED
- Flexible

**Cons:**
- Requires additional hardware/server
- More components to manage

## Getting Help

- **Integration Guide**: See [INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md)
- **WLED Support**: https://kno.wled.ge/
- **RainMaker Support**: https://rainmaker.espressif.com/
- **Community**: WLED Discord, ESP32 Forum

## Examples

Check the `examples/` directory for:
- Complete integration code
- Configuration files
- Build scripts
- Testing procedures

## Contributing

Found a better way to integrate? Share it!
- Submit improvements
- Add examples
- Update documentation

## Resources

- [ESP RainMaker Documentation](https://rainmaker.espressif.com/docs/get-started.html)
- [WLED GitHub](https://github.com/Aircoookie/WLED)
- [ESP-IDF Programming Guide](https://docs.espressif.com/projects/esp-idf/)

## License

Integration code follows WLED's MIT License and RainMaker's Apache 2.0 License.
