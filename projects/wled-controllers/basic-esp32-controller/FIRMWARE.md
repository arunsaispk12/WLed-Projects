# Firmware Guide - Basic ESP32 Controller

Production-ready firmware configuration and deployment guide.

## Overview

This project uses WLED firmware with custom hardware configuration. The firmware is production-ready and includes:

✅ Hardware-specific pin configuration
✅ Power management and safety features
✅ Multiple build variants
✅ Pre-configured presets
✅ Optimized for reliability

## Firmware Variants

### Available Builds

| Variant | LEDs | Current Limit | Use Case | Flash Command |
|---------|------|---------------|----------|---------------|
| **esp32_basic** | 60 | 3A | Standard setup | `./build.sh flash esp32_basic` |
| **esp32_30led** | 30 | 2A | USB-powered, beginner | `./build.sh flash esp32_30led` |
| **esp32_150led** | 150 | 6A | Large installations | `./build.sh flash esp32_150led` |
| **esp32_release** | 60 | 3A | Production-optimized | `./build.sh flash esp32_release` |
| **esp32_debug** | 60 | 3A | Troubleshooting | `./build.sh flash esp32_debug` |
| **esp32_ota** | 60 | 3A | Remote updates | Upload via web |
| **esp32c3** | 60 | 3A | ESP32-C3 chip | `./build.sh flash esp32c3` |
| **esp32s3** | 300 | 12A | High-performance | `./build.sh flash esp32s3` |

## Quick Start

### 1. First Time Setup

```bash
# Navigate to project
cd projects/wled-controllers/basic-esp32-controller

# Flash firmware (standard setup)
./build.sh flash esp32_basic /dev/ttyUSB0

# Or for beginners (30 LEDs)
./build.sh flash esp32_30led /dev/ttyUSB0
```

### 2. WiFi Configuration

After flashing:

1. Power on ESP32
2. Connect to WiFi network "WLED-AP" (password: `wled1234`)
3. Browser opens to http://4.3.2.1
4. Enter your WiFi credentials
5. Device restarts and connects

### 3. Initial Configuration

Access WLED at http://wled.local or device IP:

**LED Settings** (Config → LED Preferences):
- **Length**: Set to your LED count
- **GPIO**: 2 (already set)
- **Color Order**: GRB (or test RGB/BGR if colors wrong)
- **Maximum Current**: Based on your power supply
  - 30 LEDs: 2000mA
  - 60 LEDs: 3000mA
  - 150 LEDs: 6000mA

**WiFi Settings** (Config → WiFi Setup):
- **mDNS Name**: wled (access via http://wled.local)
- **Device Name**: WLED-Controller

**Save & Reboot**

## Configuration File

### wled_config.h

The `src/wled_config.h` file contains hardware-specific settings:

```cpp
// LED Configuration
#define LEDPIN 2                    // LED data pin
#define DEFAULT_LED_COUNT 60        // Number of LEDs
#define DEFAULT_LED_TYPE TYPE_WS2812_RGB

// Power Configuration
#define WLED_MAX_CURRENT 3000       // 3A limit
#define WLED_DEFAULT_BRIGHTNESS 128 // 50% default

// Features
#define WLED_ENABLE_WEBSOCKETS      // WebSocket support
#define WLED_ENABLE_MQTT            // MQTT protocol
#define WLED_DISABLE_HUESYNC        // Disable if not needed
```

### Customization

Edit `wled_config.h` before building for:

**Different LED Count:**
```cpp
#define DEFAULT_LED_COUNT 100  // Change to your count
#define WLED_MAX_CURRENT 5000  // Adjust power limit
```

**Different Pin:**
```cpp
#define LEDPIN 4              // Use GPIO4 instead
```

**Different LED Type:**
```cpp
#define DEFAULT_LED_TYPE TYPE_SK6812_RGBW  // For RGBW LEDs
```

Then rebuild:
```bash
./build.sh build esp32_basic
./build.sh flash esp32_basic /dev/ttyUSB0
```

## Presets

15 pre-configured presets included:

| ID | Name | Description |
|----|------|-------------|
| 0 | Default | Warm orange |
| 1 | Warm White | Cozy white light |
| 2 | Cool White | Bright daylight |
| 3 | Rainbow | Moving rainbow |
| 4 | Fire | Fire effect |
| 5 | Ocean | Blue waves |
| 6 | Evening | Dim warm light |
| 7 | Party | Fast colors |
| 8 | Purple | Calming purple |
| 9 | Christmas | Red/green |
| 10 | Night Light | Very dim |
| 11 | Police | Red/blue flash |
| 12 | Sunrise | Warm sunrise |
| 13 | Aurora | Aurora effect |
| 14 | Reading | Bright white |
| 15 | Meteor | Meteor shower |

### Importing Presets

1. Config → Security & Updates → Backup & Restore
2. Choose `config/wled_presets.json`
3. Click "Restore Presets"

## Build Variants Explained

### esp32_basic (Standard)

**Configuration:**
- 60 LEDs
- 3A current limit
- All features enabled
- Recommended for most users

**Use When:**
- Standard 1-meter WS2812B strip
- 5V 3-5A power supply
- First-time builds

### esp32_30led (Beginner)

**Configuration:**
- 30 LEDs
- 2A current limit
- USB-powered capable
- Lower brightness default

**Use When:**
- Learning WLED
- USB-powered projects
- Lower power needs
- Testing

### esp32_150led (Large)

**Configuration:**
- 150 LEDs
- 6A current limit
- Power injection recommended
- Optimized for larger strips

**Use When:**
- 2+ meter LED strips
- 5V 10A+ power supply
- Power injection at midpoint
- Larger installations

### esp32_release (Production)

**Configuration:**
- Optimized code size
- Minimal debug output
- Production features only
- Best performance

**Use When:**
- Final deployment
- Need smallest firmware
- Maximum performance
- Production installations

### esp32_debug (Troubleshooting)

**Configuration:**
- Verbose logging
- All debug features
- Serial monitor output
- Development tools

**Use When:**
- Debugging issues
- Development
- Finding problems
- Testing new features

### esp32_ota (Remote Updates)

**Configuration:**
- OTA update support
- Network flashing
- No USB needed
- Remote deployment

**Use When:**
- Device installed remotely
- No physical access
- Frequent updates
- Multiple devices

**Upload via:**
1. Build: `./build.sh build esp32_ota`
2. Config → Security & Updates → Manual OTA Update
3. Choose `.pio/build/esp32_ota/firmware.bin`
4. Upload

### esp32c3 (ESP32-C3)

**Configuration:**
- ESP32-C3 RISC-V chip
- Lower cost
- Same features
- USB-C native

**Use When:**
- Using ESP32-C3 board
- Cost-sensitive projects
- USB-C preferred

### esp32s3 (High Performance)

**Configuration:**
- ESP32-S3 chip
- PSRAM support
- Up to 300 LEDs
- Higher performance
- More effects possible

**Use When:**
- Need >200 LEDs
- Complex effects
- Multiple segments
- Maximum performance

## Power Configuration

### Current Limiting

WLED includes automatic brightness limiting based on power.

**Set Maximum Current:**

Config → LED Preferences → More Settings:
- **Maximum Current**: Based on your PSU
- Enable **Auto-calculate**

**Recommendations:**

| Power Supply | Max Current Setting | Max LEDs (safe) |
|--------------|---------------------|-----------------|
| USB 5V 0.5A | 400mA | 6 |
| USB 5V 1A | 800mA | 13 |
| 5V 2A | 1600mA | 26 |
| 5V 3A | 2400mA | 40 |
| 5V 5A | 4000mA | 66 |
| 5V 10A | 8000mA | 133 |
| 5V 20A | 16000mA | 266 |

*Based on 60mA per LED at full white. Set to 80% of PSU capacity.*

### Safety Features

**Auto Brightness Limiter (ABL):**
- Automatically reduces brightness if current exceeds limit
- Prevents power supply overload
- Enabled by default in all variants

**Watchdog Timer:**
- Resets ESP32 if firmware hangs
- 8-second timeout
- Prevents permanent freezing

**Brownout Protection:**
- ESP32 resets if voltage drops too low
- Prevents corruption
- Built-in hardware feature

## Updating Firmware

### Via USB

```bash
# Build new version
./build.sh build esp32_release

# Flash
./build.sh flash esp32_release /dev/ttyUSB0
```

### Via OTA (Over-The-Air)

**Method 1: Web Interface**

1. Config → Security & Updates
2. Manual OTA Update
3. Choose firmware.bin file
4. Upload (takes 1-2 minutes)

**Method 2: Network Upload**

```bash
# Build OTA firmware
./build.sh build esp32_ota

# Upload via network
pio run -e esp32_ota -t upload --upload-port wled.local
```

### Via Web Installer

Visit [WLED Web Installer](https://install.wled.me/) for official WLED firmware.

## Factory Reset

### Method 1: Button

1. Hold BOOT button for 10 seconds
2. Release when WiFi resets
3. Reconnect to WLED-AP

### Method 2: Web Interface

Config → Security & Updates → Factory Reset

### Method 3: Full Flash Erase

```bash
# Erase everything
pio run -t erase

# Re-flash firmware
./build.sh flash esp32_basic /dev/ttyUSB0
```

## Backup & Restore

### Backup Configuration

Config → Security & Updates → Backup & Restore:

**Backup:**
- Click "Backup Configuration"
- Saves `cfg.json` file
- Contains all settings

**Restore:**
- Choose `cfg.json` file
- Click "Restore Configuration"
- Device reboots with settings

### Backup Files

Important files to backup:
- `cfg.json` - Main configuration
- `presets.json` - Your presets
- `platformio.ini` - Build configuration
- `wled_config.h` - Hardware configuration

## Advanced Configuration

### MQTT Setup

For Home Assistant, Node-RED, etc:

Config → Sync Interfaces → MQTT:
- **Broker**: Your MQTT broker IP
- **Port**: 1883
- **Username/Password**: If required
- **Device Topic**: wled/controller
- **Group Topic**: wled/all

### E1.31/Art-Net (LED Software)

For Jinx!, LedFx, xLights:

Config → Sync Interfaces → Network:
- **DMX Mode**: E1.31 or Art-Net
- **Universe**: 1
- **Start Channel**: 1

### Alexa Integration

Config → Sync Interfaces → Voice Assistants:
- **Emulate Alexa device**: Enabled
- Discover in Alexa app

### Google Home

Use WLED app to expose to Google Home via IFTTT or direct integration.

## Troubleshooting

### Won't Flash

```bash
# Hold BOOT button during upload
./build.sh flash esp32_basic /dev/ttyUSB0
# Hold BOOT until upload starts
```

### Wrong Colors

Config → LED Preferences → Color Order:
- Try: GRB, RGB, BGR, BRG

### Crashes/Resets

1. **Check Power:**
   - Use adequate power supply
   - Measure voltage under load
   - Should be 4.9-5.2V

2. **Reduce Load:**
   - Lower LED count
   - Reduce brightness
   - Disable effects

3. **Use Debug Build:**
   ```bash
   ./build.sh flash esp32_debug /dev/ttyUSB0
   ./build.sh monitor /dev/ttyUSB0
   # Check error messages
   ```

### Memory Errors

1. **Reduce Features:**
   Edit `wled_config.h`:
   ```cpp
   #define WLED_DISABLE_HUESYNC
   #define WLED_DISABLE_ALEXA
   #define WLED_MAX_SEGMENTS 5
   ```

2. **Use ESP32-S3:**
   ```bash
   ./build.sh flash esp32s3 /dev/ttyUSB0
   ```

## Performance Optimization

### For Smooth Effects

Config → LED Preferences:
- **FPS**: 40-60 (higher for faster effects)
- **Skip First LEDs**: 0
- **Disable WiFi Sleep**: Enabled (for responsiveness)

### For More LEDs

Use ESP32-S3 variant:
- Has PSRAM
- Supports 300+ LEDs
- Better performance

### For Battery Life

1. Lower brightness
2. Use static colors (not effects)
3. Reduce LED count
4. Enable WiFi sleep

## Production Checklist

Before deploying:

- [ ] Correct LED count configured
- [ ] Appropriate power limit set
- [ ] WiFi credentials configured
- [ ] Device name set
- [ ] Tested all LEDs work
- [ ] Tested power consumption
- [ ] Enclosure provided (if needed)
- [ ] Documentation provided
- [ ] Backup configuration saved
- [ ] User instructed on operation

## File Locations

```
basic-esp32-controller/
├── src/
│   ├── main.cpp              # Main firmware (if custom)
│   └── wled_config.h         # Hardware configuration ⭐
├── config/
│   └── wled_presets.json     # 15 presets ⭐
├── platformio.ini            # Build configurations ⭐
├── .pio/build/
│   ├── esp32_basic/
│   │   └── firmware.bin      # Built firmware ⭐
│   └── esp32_release/
│       └── firmware.bin      # Optimized firmware ⭐
└── FIRMWARE.md               # This file
```

## Support

- **WLED Documentation**: https://kno.wled.ge/
- **WLED Discord**: https://discord.gg/QAh7wJHrRM
- **Project Issues**: https://github.com/arunsaispk12/WLed-Projects/issues
- **Troubleshooting**: See `../../docs/troubleshooting/COMMON_ISSUES.md`

## Version Information

- **WLED Version**: v0.14.x compatible
- **Platform**: ESP32 (all variants)
- **Framework**: Arduino
- **Build System**: PlatformIO

## License

Based on WLED by Aircookie - MIT License
