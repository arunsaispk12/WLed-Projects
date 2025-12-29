# WLED Firmware Development Guide

Comprehensive guide to compiling, customizing, and developing WLED firmware including custom builds, usermods, and effect creation.

## Table of Contents

1. [Development Environment Setup](#development-environment-setup)
2. [Compiling WLED](#compiling-wled)
3. [Custom Builds](#custom-builds)
4. [Usermods](#usermods)
5. [Creating Custom Effects](#creating-custom-effects)
6. [Firmware Configuration](#firmware-configuration)
7. [OTA Updates](#ota-updates)
8. [Debugging](#debugging)
9. [Build Optimization](#build-optimization)

---

## Development Environment Setup

### Install PlatformIO

**Recommended: VS Code + PlatformIO Extension**

#### Option 1: VS Code (Easiest)

1. **Install Visual Studio Code:**
   - Download from https://code.visualstudio.com/

2. **Install PlatformIO Extension:**
   - Open VS Code
   - Go to Extensions (Ctrl+Shift+X)
   - Search "PlatformIO IDE"
   - Click Install
   - Restart VS Code

#### Option 2: PlatformIO Core (CLI)

**Linux/Mac:**
```bash
# Install Python3 and pip first
python3 -m pip install --upgrade platformio

# Verify installation
pio --version
```

**Windows:**
```powershell
# Install Python3 from python.org first
python -m pip install --upgrade platformio

# Verify
pio --version
```

### Clone WLED Repository

```bash
# Clone official WLED
git clone https://github.com/Aircoookie/WLED.git
cd WLED

# Or clone a specific version
git clone --branch v0.14.0 https://github.com/Aircoookie/WLED.git
```

### Open in VS Code

```bash
# From WLED directory
code .
```

**Wait for PlatformIO to:**
- Auto-detect project
- Download dependencies
- Index project files

---

## Compiling WLED

### Understanding platformio.ini

**Main configuration file:**

```ini
[platformio]
default_envs = esp32dev  # Default build environment

[env:esp32dev]
board = esp32dev
platform = espressif32@5.3.0
framework = arduino
build_flags =
    -D WLED_DEBUG
    -D WLED_MAX_USERMODS=6
lib_deps =
    https://github.com/Aircoookie/FastLED.git
    NeoPixelBus
```

### Build Environments

**Common Environments:**
- `esp32dev`: Generic ESP32
- `esp32-c3-devkitm-1`: ESP32-C3
- `esp32s3dev_8MB`: ESP32-S3 with 8MB flash
- `esp8266_4M`: ESP8266 with 4MB flash
- `esp01_1m_full`: ESP-01 with 1MB

**List all environments:**
```bash
pio run --list-targets
```

### First Build

#### VS Code Method

1. **Open PlatformIO:**
   - Click PlatformIO icon in sidebar
   - Or press Ctrl+Alt+P

2. **Select Environment:**
   - PROJECT TASKS → esp32dev → General → Build

3. **Wait for compilation**
   - Downloads dependencies first time
   - Compiles firmware
   - ~5-10 minutes first time, ~30s after

#### CLI Method

```bash
# Build specific environment
pio run -e esp32dev

# Build all environments (takes long!)
pio run

# Clean build
pio run -t clean
pio run -e esp32dev
```

### Upload Firmware

#### USB Upload

**VS Code:**
- PROJECT TASKS → esp32dev → General → Upload

**CLI:**
```bash
# Auto-detect port
pio run -e esp32dev -t upload

# Specify port
pio run -e esp32dev -t upload --upload-port /dev/ttyUSB0

# Windows
pio run -e esp32dev -t upload --upload-port COM3
```

#### OTA Upload (Over-The-Air)

**After first USB flash:**

```bash
# Upload via OTA
pio run -e esp32dev -t upload --upload-port 192.168.1.100
```

**platformio.ini addition:**
```ini
upload_protocol = espota
upload_port = 192.168.1.100
upload_flags =
    --auth=wledota  # OTA password
```

---

## Custom Builds

### Custom Build Configurations

**Create `platformio_override.ini`:**

```ini
# This file overrides settings in platformio.ini
# Git-ignored, safe for personal customizations

[env:my_custom_esp32]
board = esp32dev
platform = espressif32@5.3.0
build_flags =
    ${env:esp32dev.build_flags}
    -D LEDPIN=2
    -D DEFAULT_LED_COUNT=300
    -D WLED_USE_MY_CONFIG
    -D USERMOD_ROTARY_ENCODER_UI
    -D USERMOD_FOUR_LINE_DISPLAY
```

### my_config.h (Custom Defaults)

**Create `wled00/my_config.h`:**

```cpp
#ifndef MY_CONFIG_H
#define MY_CONFIG_H

// Pin Definitions
#define LEDPIN 2
#define BTNPIN 0
#define IRPIN -1  // IR disabled

// LED Configuration
#define DEFAULT_LED_COUNT 300
#define DEFAULT_LED_TYPE TYPE_WS2812_RGB
#define DEFAULT_COLOR_ORDER COL_ORDER_GRB

// Network
#define CLIENT_SSID "YourWiFi"
#define CLIENT_PASS "YourPassword"

// Device Name
#define WLED_AP_SSID "WLED-Custom"

// Hardware
#define ABL_MILLIAMPS_DEFAULT 5000  // Current limit
#define WLED_MAX_BUTTONS 2

// Features
#define WLED_ENABLE_MQTT
#define WLED_ENABLE_ADALIGHT
#define WLED_ENABLE_DMX

// Disable features (save space)
#undef WLED_ENABLE_LOXONE
#undef WLED_ENABLE_WEBSOCKETS

#endif
```

### Build-Time Feature Flags

**Common flags in platformio.ini:**

```ini
build_flags =
    # Hardware
    -D LEDPIN=2
    -D BTNPIN=0
    -D IRPIN=-1

    # LED Configuration
    -D DEFAULT_LED_COUNT=300
    -D DEFAULT_LED_TYPE=TYPE_WS2812_RGB

    # Features
    -D WLED_ENABLE_MQTT
    -D WLED_DISABLE_2D  # Disable 2D effects (save memory)
    -D WLED_DISABLE_INFRARED

    # Memory Optimization
    -D WLED_MAX_USERMODS=4
    -D MAX_NUM_SEGMENTS=16

    # Debugging
    -D WLED_DEBUG
    -D WLED_DEBUG_HOST="192.168.1.10"
```

### Multi-Environment Build

**platformio_override.ini:**

```ini
[platformio]
default_envs = my_basic, my_advanced, my_staircase

# Basic LED strip controller
[env:my_basic]
extends = env:esp32dev
build_flags =
    ${env:esp32dev.build_flags}
    -D LEDPIN=2
    -D DEFAULT_LED_COUNT=150

# Advanced with sensors
[env:my_advanced]
extends = env:esp32dev
build_flags =
    ${env:esp32dev.build_flags}
    -D LEDPIN=2
    -D DEFAULT_LED_COUNT=300
    -D USERMOD_ROTARY_ENCODER_UI
    -D USERMOD_FOUR_LINE_DISPLAY
    -D USERMOD_PIR_SENSOR_SWITCH

# Staircase controller
[env:my_staircase]
extends = env:esp32dev
build_flags =
    ${env:esp32dev.build_flags}
    -D USERMOD_STAIRWAY_WLED
    -D LEDPIN=2
    -D DEFAULT_LED_COUNT=840  # 14 steps × 60 LEDs
```

**Build all custom environments:**
```bash
pio run
```

---

## Usermods

### What are Usermods?

**Usermods** extend WLED functionality:
- Add sensor support
- Add display support
- Add custom controls
- Add new features

### Installing a Usermod

**Method 1: Build-Time Compilation**

1. **Copy usermod to `usermods/` folder**

2. **Enable in platformio_override.ini:**
```ini
build_flags =
    -D USERMOD_ROTARY_ENCODER_UI
    -D USERMOD_FOUR_LINE_DISPLAY
```

3. **Rebuild firmware**

**Method 2: Automatic (Some Usermods)**

Some usermods auto-compile when source file present.

### Popular Usermods

#### Rotary Encoder

**Enable:**
```ini
-D USERMOD_ROTARY_ENCODER_UI
```

**Pins:**
- CLK: GPIO16
- DT: GPIO17
- SW: GPIO5

#### OLED Display (4-Line Display)

**Enable:**
```ini
-D USERMOD_FOUR_LINE_DISPLAY
```

**I2C Pins:**
- SDA: GPIO21
- SCL: GPIO22

#### PIR Sensor Switch

**Enable:**
```ini
-D USERMOD_PIR_SENSOR_SWITCH
```

**Configuration:**
- PIR pin defined in usermod settings

#### Stairway WLED

**Enable:**
```ini
-D USERMOD_STAIRWAY_WLED
```

**Features:**
- Automatic direction detection
- PIR sensor support
- Segment-based control

#### Multi Relay

**Enable:**
```ini
-D USERMOD_MULTI_RELAY
```

**Control external devices via relays**

### Creating a Custom Usermod

**Basic Usermod Structure:**

**Create `usermods/my_usermod/my_usermod.h`:**

```cpp
#pragma once

#include "wled.h"

class MyUsermod : public Usermod {
  private:
    bool enabled = true;
    unsigned long lastTime = 0;
    int myValue = 0;

    // Called when mod is loaded
    void setup() {
        // Initialize hardware
        pinMode(SENSOR_PIN, INPUT);
    }

    // Called every frame
    void loop() {
        if (millis() - lastTime < 1000) return;
        lastTime = millis();

        // Read sensor
        myValue = analogRead(SENSOR_PIN);

        // Update WLED based on sensor
        if (myValue > 512) {
            strip.setBrightness(255);
        } else {
            strip.setBrightness(128);
        }
    }

    // Web UI settings
    void addToConfig(JsonObject& root) {
        JsonObject top = root.createNestedObject("MyUsermod");
        top["enabled"] = enabled;
    }

    // Read settings from JSON
    bool readFromConfig(JsonObject& root) {
        JsonObject top = root["MyUsermod"];
        if (top.isNull()) return false;

        enabled = top["enabled"] | enabled;
        return true;
    }

    // Usermod ID
    uint16_t getId() {
        return USERMOD_ID_MY_USERMOD;  // Define in const.h
    }
};
```

**Register in `usermods_list.cpp`:**

```cpp
#include "../usermods/my_usermod/my_usermod.h"

void registerUsermods() {
    // ... existing usermods
    usermods.add(new MyUsermod());
}
```

---

## Creating Custom Effects

### Effect System Overview

Effects are stored in `wled00/FX.cpp` and defined in `wled00/FX.h`.

### Basic Custom Effect

**Add to `FX.cpp`:**

```cpp
/*
 * My Custom Effect
 * Alternates between two colors
 */
uint16_t mode_my_effect(void) {
    WS2812FX::Segment& seg = strip.getSegment(strip.getCurrSegmentId());

    uint32_t color1 = seg.colors[0];
    uint32_t color2 = seg.colors[1];

    // Get effect speed (0-255)
    uint8_t speed = seg.speed;

    // Calculate timing
    uint32_t cycleTime = 1000 + (255 - speed) * 10;
    uint32_t pos = (millis() % cycleTime) / (cycleTime / 2);

    uint32_t color = (pos == 0) ? color1 : color2;

    // Set all LEDs to color
    for (int i = seg.start; i < seg.stop; i++) {
        strip.setPixelColor(i, color);
    }

    return seg.speed;  // Frame delay
}
```

**Register effect in `FX.h`:**

```cpp
// In mode definitions array
#define MODE_MY_EFFECT 250  // Unique ID

// In mode_ptr array (FX.cpp)
&mode_my_effect,

// In mode names array (FX.cpp)
"My Effect@Speed;Color 1,Color 2;!",
```

### Advanced Effect Example

**Bouncing Ball Effect:**

```cpp
/*
 * Bouncing Balls
 * Multiple balls bouncing with physics
 */
uint16_t mode_bouncing_balls(void) {
    WS2812FX::Segment& seg = strip.getSegment(strip.getCurrSegmentId());

    // Effect parameters
    uint8_t numBalls = seg.intensity >> 5;  // 1-8 balls
    if (numBalls < 1) numBalls = 1;

    uint16_t len = seg.virtualLength();

    static float pos[8];
    static float vel[8];
    static uint32_t lastTime = 0;

    // Initialize on first run
    if (lastTime == 0) {
        for (int i = 0; i < 8; i++) {
            pos[i] = random(0, len);
            vel[i] = random(-5, 5);
        }
        lastTime = millis();
    }

    // Physics simulation
    uint32_t dt = millis() - lastTime;
    if (dt > 50) dt = 50;  // Limit delta time
    lastTime = millis();

    float gravity = 9.8 * (seg.speed / 255.0);

    // Clear strip
    seg.fill(SEGCOLOR(1));

    // Update and draw balls
    for (int i = 0; i < numBalls; i++) {
        // Apply gravity
        vel[i] += gravity * dt / 1000.0;

        // Update position
        pos[i] += vel[i];

        // Bounce off floor and ceiling
        if (pos[i] < 0) {
            pos[i] = 0;
            vel[i] = -vel[i] * 0.9;  // Energy loss
        }
        if (pos[i] >= len) {
            pos[i] = len - 1;
            vel[i] = -vel[i] * 0.9;
        }

        // Draw ball (3 pixel diameter)
        uint32_t color = color_wheel(i * 32);
        int pixPos = (int)pos[i];
        if (pixPos >= 0 && pixPos < len) {
            seg.setPixelColor(pixPos, color);
            if (pixPos > 0) seg.setPixelColor(pixPos - 1, color_blend(color, BLACK, 128));
            if (pixPos < len - 1) seg.setPixelColor(pixPos + 1, color_blend(color, BLACK, 128));
        }
    }

    return FRAMETIME;
}
```

### Effect Parameters

**Effect Signature:**
```cpp
uint16_t mode_effect_name(void)
```

**Access Segment Data:**
```cpp
WS2812FX::Segment& seg = strip.getSegment(strip.getCurrSegmentId());

// Segment properties
seg.speed;           // Effect speed (0-255)
seg.intensity;       // Effect intensity (0-255)
seg.colors[0];       // Primary color
seg.colors[1];       // Secondary color
seg.colors[2];       // Tertiary color
seg.start;           // Start LED index
seg.stop;            // Stop LED index (exclusive)
seg.virtualLength(); // Segment length
```

**Set Pixel Colors:**
```cpp
// Direct index
strip.setPixelColor(index, color);
strip.setPixelColor(index, r, g, b);

// Segment-relative index
seg.setPixelColor(relativeIndex, color);

// Fill segment
seg.fill(color);
```

**Utilities:**
```cpp
// Color wheel (0-255 → rainbow)
uint32_t color_wheel(uint8_t pos);

// Color blending
uint32_t color_blend(uint32_t color1, uint32_t color2, uint8_t blend);

// Get color from segment
uint32_t seg.color_from_palette(index, brightness, mapping, wrap);
```

---

## Firmware Configuration

### const.h Configuration

**Key configuration file:** `wled00/const.h`

**Important defines:**

```cpp
// Version
#define WLED_VERSION_CODE 2403060

// Memory
#define MAX_NUM_SEGMENTS 16
#define WLED_MAX_COLOR_ORDER_MAPPINGS 5
#define WLED_MAX_BUSSES 10

// Features
#define WLED_ENABLE_MQTT
#define WLED_ENABLE_ADALIGHT
#define WLED_ENABLE_WEBSOCKETS

// Hardware
#define WLED_USE_ANALOG_LEDS  // Enable analog LED support
#define SERVERNAME "wled"

// OTA
#define WLED_ENABLE_FS_EDITOR  // File system editor
```

### Reducing Firmware Size

**Disable unused features:**

```cpp
// In platformio_override.ini
build_flags =
    # Disable features
    -D WLED_DISABLE_2D
    -D WLED_DISABLE_INFRARED
    -D WLED_DISABLE_ALEXA
    -D WLED_DISABLE_BLYNK
    -D WLED_DISABLE_HUESYNC
    -D WLED_DISABLE_LOXONE

    # Reduce memory usage
    -D WLED_MAX_USERMODS=2
    -D MAX_NUM_SEGMENTS=8
    -D WLED_MAX_BUTTONS=1
```

**Result:** Significant flash and RAM savings

---

## OTA Updates

### Enable OTA in Code

**Already enabled by default in WLED**

### OTA Password

**Set in Settings → Security:**
- OTA Password: wledota (default)
- Or custom password

### Upload via OTA

**PlatformIO CLI:**
```bash
pio run -e esp32dev -t upload --upload-port 192.168.1.100
```

**VS Code:**
1. Set upload_port in platformio_override.ini
2. PROJECT TASKS → Upload

### Web-Based OTA

1. **Build firmware:**
   ```bash
   pio run -e esp32dev
   ```

2. **Locate binary:**
   ```
   .pio/build/esp32dev/firmware.bin
   ```

3. **Upload via web UI:**
   - Open http://[WLED-IP]/update
   - Select firmware.bin
   - Click Update

### HTTP OTA (Advanced)

**Python script:**
```python
import requests

WLED_IP = "192.168.1.100"
FIRMWARE_PATH = ".pio/build/esp32dev/firmware.bin"

url = f"http://{WLED_IP}/update"

with open(FIRMWARE_PATH, 'rb') as f:
    files = {'update': f}
    r = requests.post(url, files=files)
    print(r.text)
```

---

## Debugging

### Serial Debug Output

**Enable debugging:**

```ini
# platformio_override.ini
build_flags =
    -D WLED_DEBUG
    -D WLED_DEBUG_HOST="192.168.1.10"  # Optional: UDP debug target
```

**View serial output:**

**VS Code:**
- PROJECT TASKS → esp32dev → Monitor

**CLI:**
```bash
pio device monitor -b 115200
```

**Filter output:**
```bash
pio device monitor -b 115200 | grep "ERROR"
```

### Debug Prints in Code

```cpp
#ifdef WLED_DEBUG
    Serial.println("Debug message");
    Serial.printf("Value: %d\n", myValue);
#endif

// Or use DEBUG_PRINTLN macro
DEBUG_PRINTLN("This only prints if WLED_DEBUG defined");
DEBUG_PRINTF("Value: %d\n", myValue);
```

### Remote UDP Debug

**Send debug output to remote PC:**

1. **Enable in build:**
   ```ini
   -D WLED_DEBUG_HOST="192.168.1.10"
   ```

2. **Receive on PC:**
   ```bash
   nc -ul 7868
   ```

### Memory Debugging

**Check free heap:**
```cpp
Serial.printf("Free heap: %d bytes\n", ESP.getFreeHeap());
```

**Monitor in web UI:**
- Open http://[WLED-IP]/json/info
- Look for `freeheap` value

### Crash Analysis

**Enable core dumps:**
```ini
build_flags =
    -D EXCEPTION_DEBUG
```

**Analyze crash:**
- Serial output shows stack trace
- Use ESP Exception Decoder in PlatformIO

---

## Build Optimization

### Compiler Optimization Levels

**platformio.ini:**
```ini
build_flags =
    -O2  # Standard optimization (default)
    -Os  # Optimize for size
    -O3  # Maximum optimization (faster, larger)
```

### Partition Schemes

**Increase app space:**

```ini
board_build.partitions = tools/WLED_ESP32_4MB_1MB_FS.csv
```

**Custom partitions:**

Create `my_partitions.csv`:
```
# Name,   Type, SubType, Offset,   Size,    Flags
nvs,      data, nvs,     0x9000,   0x5000,
otadata,  data, ota,     0xe000,   0x2000,
app0,     app,  ota_0,   0x10000,  0x200000,
app1,     app,  ota_1,   0x210000, 0x200000,
spiffs,   data, spiffs,  0x410000, 0xF0000,
```

### Build Time Optimization

**Parallel builds:**
```bash
# Use multiple cores
pio run -e esp32dev -j 4
```

**Incremental builds:**
- Only changed files recompile
- Clean only when necessary

**ccache (Advanced):**
```bash
# Install ccache
sudo apt install ccache

# Enable in platformio.ini
[env]
build_flags =
    -DUSE_CCACHE
```

---

## CI/CD Integration

### GitHub Actions

**`.github/workflows/build.yml`:**

```yaml
name: Build WLED

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.x'

    - name: Install PlatformIO
      run: |
        python -m pip install --upgrade pip
        pip install --upgrade platformio

    - name: Build firmware
      run: pio run -e esp32dev

    - name: Upload artifact
      uses: actions/upload-artifact@v3
      with:
        name: firmware
        path: .pio/build/esp32dev/firmware.bin
```

---

## Summary

### Quick Build Commands

```bash
# List environments
pio run --list-targets

# Build specific environment
pio run -e esp32dev

# Clean build
pio run -t clean && pio run -e esp32dev

# Upload via USB
pio run -e esp32dev -t upload

# Upload via OTA
pio run -e esp32dev -t upload --upload-port 192.168.1.100

# Monitor serial
pio device monitor -b 115200

# Build and upload
pio run -e esp32dev -t upload && pio device monitor
```

### Development Checklist

- [ ] PlatformIO installed
- [ ] WLED repository cloned
- [ ] VS Code configured
- [ ] Custom build environment created
- [ ] Test build successful
- [ ] USB upload working
- [ ] Serial monitor accessible
- [ ] OTA update tested
- [ ] Custom config tested

### Related Guides

- [WLED API Guide](WLED_API_GUIDE.md)
- [Hardware Development Guide](HARDWARE_GUIDE.md)
- [Sensor Integration Guide](SENSOR_INTEGRATION_GUIDE.md)

---

## Resources

- [WLED GitHub Repository](https://github.com/Aircoookie/WLED)
- [WLED Knowledge Base](https://kno.wled.ge/)
- [PlatformIO Documentation](https://docs.platformio.org/)
- [ESP32 Arduino Core](https://github.com/espressif/arduino-esp32)

---

Happy Firmware Development! 🔧💻💡
