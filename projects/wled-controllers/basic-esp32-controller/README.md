# Basic ESP32 WLED Controller

A simple, beginner-friendly WLED controller using an ESP32 DevKit and WS2812B LED strip.

![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![WLED](https://img.shields.io/badge/WLED-v0.14.x-blue)

## Overview

This is a basic WLED controller project perfect for beginners. It uses readily available components and requires minimal soldering. Great for learning WLED basics before moving to more advanced projects.

## Features

- Standard WLED firmware (v0.14.x compatible)
- Single LED output (up to 500 LEDs)
- WiFi configuration
- Web interface control
- Mobile app support
- Simple push-button control
- Low cost (~$10-15)

## Hardware Requirements

### Bill of Materials

| Component | Specification | Quantity | Est. Price | Link |
|-----------|--------------|----------|------------|------|
| ESP32 DevKit | ESP32-WROOM-32 | 1 | $5-7 | [Example](https://example.com) |
| LED Strip | WS2812B, 60 LED/m | 1m | $8-10 | [Example](https://example.com) |
| Power Supply | 5V 3A | 1 | $5-8 | [Example](https://example.com) |
| Level Shifter | 74HCT125 | 1 | $0.50 | [Example](https://example.com) |
| Resistor | 470Ω 1/4W | 1 | $0.10 | [Example](https://example.com) |
| Capacitor | 1000µF 10V | 1 | $0.50 | [Example](https://example.com) |
| Breadboard | Half-size | 1 | $2-3 | [Example](https://example.com) |
| Jumper Wires | Male-Male | 10 | $2 | [Example](https://example.com) |
| **Total** | | | **$23-31** | |

### Pin Configuration

See [hardware/pinout.md](hardware/pinout.md) for detailed pin assignments.

| ESP32 Pin | Function | Connected To |
|-----------|----------|--------------|
| GPIO2 | LED Data | 74HCT125 → LED Strip |
| GPIO0 | Button | Flash Button (built-in) |
| 5V | Power | Power Supply + |
| GND | Ground | Common Ground |

## Wiring Diagram

```
Power Supply (5V 3A)
    │
    ├─── [1000µF Cap] ─── GND
    │
    ├─── LED Strip 5V
    │
    └─── ESP32 5V (via USB or Vin)

ESP32 GPIO2 ──[470Ω]── 74HCT125 ──── LED Strip Data

Common GND: Power Supply, ESP32, LED Strip, 74HCT125
```

Detailed schematic: [hardware/schematic.pdf](hardware/)

## Software Setup

### Method 1: Web Installer (Easiest)

1. Visit [WLED Web Installer](https://install.wled.me/)
2. Connect ESP32 via USB
3. Click "Install" and select version
4. Wait for installation to complete
5. Configure WiFi when prompted

### Method 2: PlatformIO (For Custom Builds)

1. Install PlatformIO
   ```bash
   pip install platformio
   ```

2. Clone this project
   ```bash
   git clone https://github.com/arunsaispk12/WLed-Projects.git
   cd WLed-Projects/projects/wled-controllers/basic-esp32-controller/
   ```

3. Build and upload
   ```bash
   pio run -t upload
   ```

4. Monitor serial output
   ```bash
   pio device monitor
   ```

### Method 3: Arduino IDE

1. Install [Arduino IDE](https://www.arduino.cc/en/software)
2. Add ESP32 board support:
   - File → Preferences
   - Additional Board Manager URLs: `https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json`
   - Tools → Board → Boards Manager → Search "ESP32" → Install

3. Install WLED:
   - Download latest WLED release
   - Extract and open in Arduino IDE
   - Tools → Board → ESP32 Dev Module
   - Tools → Upload Speed → 460800
   - Sketch → Upload

## Configuration

### Initial WiFi Setup

1. Power on ESP32
2. Look for WiFi network "WLED-AP"
3. Connect (password: `wled1234`)
4. Browser opens to http://4.3.2.1
5. Enter your WiFi credentials
6. Device restarts and connects

### WLED Configuration

1. Access WLED at `http://wled-[deviceID].local` or device IP
2. Go to Config → LED Preferences:
   - Length: `60` (or your LED count)
   - GPIO: `2`
   - Color Order: `GRB` (test if colors wrong)
   - Maximum Current: `2000` mA

3. Go to Config → WiFi Setup:
   - Set device name (optional)
   - Configure static IP (optional)

4. Go to Config → Time & Macros:
   - Set timezone
   - Enable NTP if desired

### Importing Presets

1. Download presets: [config/wled_presets.json](config/wled_presets.json)
2. Config → Security & Updates → Backup & Restore
3. Choose preset file
4. Click "Restore Presets"

## Usage

### Web Interface

- **Power**: Toggle on/off
- **Brightness**: Slider 0-255
- **Effects**: Choose from 100+ effects
- **Colors**: Select colors, palettes
- **Presets**: Quick access saved configurations

### Mobile App

Download WLED app:
- iOS: [WLED App](https://apps.apple.com/app/wled/id1475695033)
- Android: [WLED App](https://play.google.com/store/apps/details?id=com.aircoookie.WLED)

### Physical Button

- **Short press**: Toggle on/off
- **Long press**: Cycle presets
- **Double press**: Random effect

## Building & Assembly

### Step 1: Prepare Components

1. Gather all components from BOM
2. Test ESP32 by connecting via USB
3. Upload test sketch to verify working

### Step 2: Wire on Breadboard

1. Insert ESP32 into breadboard
2. Insert 74HCT125 level shifter
3. Connect power rails (red = 5V, blue = GND)
4. Wire according to schematic

### Step 3: Add Protection

1. Connect 1000µF capacitor across LED power (+/-)
2. Add 470Ω resistor on data line
3. Verify all connections with multimeter

### Step 4: First Power-On

1. Connect 5V power supply (NOT to ESP32 yet)
2. Verify voltage with multimeter
3. Connect ESP32 via USB
4. Upload WLED firmware

### Step 5: Test LEDs

1. Set LED count to 1 in WLED config
2. Test all colors (R, G, B, W)
3. If colors wrong, change color order
4. Gradually increase LED count
5. Test effects and brightness

## Troubleshooting

### LEDs Don't Light Up

**Check:**
- [ ] Power supply connected and ON
- [ ] 5V at LED strip (measure with multimeter)
- [ ] Data line connected to DI not DO
- [ ] GPIO pin set to 2 in config
- [ ] LED count configured correctly

**Solution:**
1. Test with single LED first
2. Verify 5V at strip
3. Check data line continuity
4. Try different GPIO in config

### Wrong Colors

**Check:**
- [ ] Color order in config (GRB vs RGB vs BGR)

**Solution:**
Go to Config → LED Preferences → Color Order, try:
- GRB (most common for WS2812B)
- RGB
- BGR

### WiFi Won't Connect

**Check:**
- [ ] 2.4GHz network (ESP32 doesn't support 5GHz)
- [ ] Correct password
- [ ] No special characters causing issues
- [ ] Router not blocking device

**Solution:**
1. Reset WiFi: Hold button 10 seconds
2. Reconnect to WLED-AP
3. Reconfigure WiFi

### ESP32 Keeps Resetting

**Check:**
- [ ] Power supply adequate (3A minimum for 60 LEDs)
- [ ] Capacitor installed
- [ ] No shorts in wiring

**Solution:**
1. Add larger capacitor (1000µF → 2200µF)
2. Reduce LED count temporarily
3. Use higher current PSU
4. Check serial monitor for error messages

### LEDs Flicker

**Check:**
- [ ] Data line resistor (470Ω)
- [ ] Capacitor at LED power input
- [ ] Ground connections solid

**Solution:**
1. Add/increase capacitor
2. Shorten data line
3. Reduce brightness
4. Check all ground connections

## Advanced Features

### Sound Reactive (Optional Upgrade)

Add INMP441 microphone:
- Connect I2S pins (see sound-reactive project)
- Enable sound reactive usermod
- Reflash firmware

### Multi-Strip (Optional Upgrade)

Control multiple strips:
- Use additional GPIO pins
- Configure in LED preferences
- See multi-channel project example

### Home Assistant Integration

Add to Home Assistant:
- Configuration → Integrations
- Add WLED integration
- Auto-discovers device
- Full control via HA

## Performance

- **LED Count**: Up to 500 (tested)
- **Refresh Rate**: 60 FPS
- **Effects**: 100+ built-in
- **Power Draw**: ~80mA (ESP32) + 60mA per LED (max)
- **WiFi Range**: 30-50m typical

## Upgrades & Modifications

### Enclosure

Design files for 3D printed enclosure (coming soon)

### PCB Version

Permanent PCB version (see hardware/pcb-designs/)

### Battery Power

Add 18650 battery with charging circuit for portable use

## Safety Notes

⚠️ **Important Safety Information**

- Use appropriate gauge wire for current
- Don't exceed component ratings
- Insulate all exposed connections
- Use fused power supply
- Keep away from water unless waterproofed
- Monitor temperature during first runs

## Photos

![Assembled Project](docs/assembled.jpg)
![Breadboard Layout](docs/breadboard.jpg)
![Running Effect](docs/effect-demo.gif)

(Add your photos to docs/ folder)

## Changelog

See [CHANGELOG.md](CHANGELOG.md)

## Credits

- [WLED](https://github.com/Aircoookie/WLED) by Aircookie
- Community contributions

## License

MIT License (same as WLED)

## Support

- WLED Knowledge Base: https://kno.wled.ge/
- WLED Discord: https://discord.gg/QAh7wJHrRM
- Project Issues: [GitHub Issues](https://github.com/arunsaispk12/WLed-Projects/issues)

## Next Steps

1. Build and test this basic controller
2. Try different effects and configurations
3. Move to advanced projects:
   - [Sound Reactive Controller](../sound-reactive-controller/)
   - [WLED + RainMaker](../../custom-builds/wled-rainmaker-combo/)
   - [Multi-Channel Controller](../multi-channel-controller/)
