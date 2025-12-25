# WLED to ESP RainMaker Integration Guide

Complete guide for integrating a standalone WLED controller with ESP RainMaker for cloud connectivity and remote control.

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Architecture](#architecture)
4. [Hardware Setup](#hardware-setup)
5. [Firmware Configuration](#firmware-configuration)
6. [RainMaker Setup](#rainmaker-setup)
7. [Integration Methods](#integration-methods)
8. [Testing & Validation](#testing--validation)
9. [Troubleshooting](#troubleshooting)

## Overview

This guide demonstrates how to integrate WLED (WiFi LED controller) with ESP RainMaker to enable:
- Cloud-based remote control
- Voice assistant integration (Alexa, Google Home)
- Mobile app control via RainMaker app
- Automation and scheduling
- Multi-device management

### Integration Approach
There are two primary methods:
1. **Parallel Integration**: Run WLED and RainMaker side-by-side (recommended)
2. **Embedded Integration**: Embed WLED as a library within RainMaker firmware

## Prerequisites

### Hardware Requirements
- ESP32 development board (ESP32-WROOM, ESP32-WROVER, or similar)
- WS2812B/SK6812 LED strip or compatible addressable LEDs
- 5V power supply (adequate for LED strip - typically 60mA per LED)
- Level shifter (optional but recommended for data line)
- Capacitor (1000µF, 6.3V or higher) for LED strip
- Resistor (300-500Ω) for data line

### Software Requirements
- ESP-IDF v4.4 or later
- Arduino IDE with ESP32 support OR PlatformIO
- WLED firmware (latest stable release)
- ESP RainMaker libraries
- Git for version control

### Knowledge Requirements
- Basic ESP32 programming
- Understanding of MQTT/HTTP protocols
- Familiarity with WLED configuration
- ESP RainMaker basics

## Architecture

### System Architecture

```
┌─────────────────┐
│  RainMaker App  │
│   (Mobile/Web)  │
└────────┬────────┘
         │
         │ MQTT/HTTP
         ▼
┌─────────────────┐
│  RainMaker      │
│  Cloud Service  │
└────────┬────────┘
         │
         │ MQTT
         ▼
┌─────────────────┐         ┌──────────────┐
│   ESP32 with    │◄────────┤  WLED WebUI  │
│   RainMaker +   │  HTTP   │  (Local)     │
│   WLED          │         └──────────────┘
└────────┬────────┘
         │
         │ GPIO/SPI
         ▼
┌─────────────────┐
│   LED Strip     │
│   (WS2812B)     │
└─────────────────┘
```

### Communication Flow
1. User sends command via RainMaker app
2. RainMaker cloud forwards to ESP32 via MQTT
3. ESP32 RainMaker callback updates WLED state
4. WLED controls LED strip
5. Status updates sent back to RainMaker cloud

## Hardware Setup

### Pin Configuration

```
ESP32 Pin    │ Connection
─────────────┼──────────────────────
GPIO 2       │ LED Strip Data (via level shifter)
5V           │ LED Strip VCC
GND          │ LED Strip GND
GPIO 0       │ Boot/Flash button (optional)
GPIO 21      │ SDA (for sensors - optional)
GPIO 22      │ SCL (for sensors - optional)
```

### Wiring Diagram

```
                    ┌──────────────┐
                    │   ESP32      │
                    │              │
                    │  GPIO2  ──────┐
                    │              │
5V Power Supply ────┤  5V          │
                    │              │
                 ┌──┤  GND         │
                 │  └──────────────┘
                 │
                 │  ┌───────────┐
                 │  │  Level    │
                 │  │  Shifter  │
                 │  │  (optional│
                 │  └─────┬─────┘
                 │        │
                 │        │
        ┌────────▼────────▼─────────┐
        │                           │
        │  Capacitor   Data   5V    │
        │   1000µF      │     │     │
        └────────┬──────┼─────┼─────┘
                 │      │     │
                GND     │     │
              ┌─────────┴─────┴──────┐
              │   LED Strip          │
              │   WS2812B            │
              └──────────────────────┘
```

### Hardware Assembly Steps

1. **Connect Power**
   - Connect 5V and GND from power supply to LED strip
   - Add 1000µF capacitor across 5V and GND at LED strip

2. **Connect Data Line**
   - Add 300-500Ω resistor between ESP32 GPIO2 and LED strip data
   - Optionally use level shifter for 3.3V to 5V conversion

3. **ESP32 Power**
   - Power ESP32 via USB or separate 3.3V regulator
   - Ensure common ground between ESP32 and LED power supply

4. **Safety Check**
   - Verify all connections before powering on
   - Check voltage levels with multimeter
   - Ensure no shorts between power rails

## Firmware Configuration

### Method 1: Parallel Integration (Recommended)

This method runs WLED and RainMaker simultaneously with a communication bridge.

#### Step 1: Install Base Firmware

```bash
# Clone WLED repository
git clone https://github.com/Aircoookie/WLED.git
cd WLED

# Configure for your ESP32 board
# Edit platformio.ini or use Arduino IDE
```

#### Step 2: Add RainMaker to WLED

Create a new file `wled00/rainmaker_integration.h`:

```cpp
#ifndef RAINMAKER_INTEGRATION_H
#define RAINMAKER_INTEGRATION_H

#include <RMaker.h>
#include <WiFi.h>
#include <WiFiProv.h>

// RainMaker credentials
#define RAINMAKER_DEVICE_NAME "WLED Controller"
#define RAINMAKER_SERVICE_NAME "PROV_WLED"

// Device parameters
static Device *wled_device = NULL;
static LightBulb *wled_light = NULL;

// Callback for RainMaker commands
void rainmakerCallback(Device *device, Param *param, const param_val_t val, void *priv_data, write_ctx_t *ctx) {
    const char *param_name = param->getParamName();

    if (strcmp(param_name, "Power") == 0) {
        bool power = val.val.b;
        if (power) {
            // Turn on WLED
            bri = briLast;
        } else {
            // Turn off WLED
            briLast = bri;
            bri = 0;
        }
        stateUpdated(CALL_MODE_DIRECT_CHANGE);
    }
    else if (strcmp(param_name, "Brightness") == 0) {
        bri = map(val.val.i, 0, 100, 0, 255);
        stateUpdated(CALL_MODE_DIRECT_CHANGE);
    }
    else if (strcmp(param_name, "Hue") == 0) {
        // Update WLED color from HSV
        // Implementation depends on WLED version
    }
}

// Initialize RainMaker
void initRainMaker() {
    Node my_node = RMaker.initNode(RAINMAKER_DEVICE_NAME);

    // Create light device
    wled_light = new LightBulb("WLED Light", NULL);
    wled_light->addCb(rainmakerCallback);

    // Add parameters
    wled_light->addBrightnessParam(100);
    wled_light->addHueParam(0);
    wled_light->addSaturationParam(0);

    // Add device to node
    my_node.addDevice(*wled_light);

    // Start RainMaker
    RMaker.enableOTA(OTA_USING_PARAMS);
    RMaker.enableTZService();
    RMaker.enableSchedule();
    RMaker.start();

    // Start WiFi provisioning
    WiFiProv.beginProvision(WIFI_PROV_SCHEME_BLE, WIFI_PROV_SCHEME_HANDLER_FREE_BTDM,
                            WIFI_PROV_SECURITY_1, "abcd1234", RAINMAKER_SERVICE_NAME);
}

// Update RainMaker state from WLED
void updateRainMakerState() {
    if (wled_light) {
        wled_light->updateAndReportParam("Power", bri > 0);
        wled_light->updateAndReportParam("Brightness", map(bri, 0, 255, 0, 100));
    }
}

#endif
```

#### Step 3: Integrate into WLED Main Loop

Edit `wled00/wled.cpp` to include RainMaker:

```cpp
#ifdef ENABLE_RAINMAKER
#include "rainmaker_integration.h"
#endif

void setup() {
    // Existing WLED setup code...

    #ifdef ENABLE_RAINMAKER
    initRainMaker();
    #endif
}

void loop() {
    // Existing WLED loop code...

    #ifdef ENABLE_RAINMAKER
    static unsigned long lastUpdate = 0;
    if (millis() - lastUpdate > 1000) {
        updateRainMakerState();
        lastUpdate = millis();
    }
    #endif
}
```

#### Step 4: Configure Build

Add to `platformio.ini`:

```ini
[env:esp32_rainmaker]
platform = espressif32
board = esp32dev
framework = arduino
build_flags =
    -D ENABLE_RAINMAKER
    -D WLED_ENABLE_MQTT
lib_deps =
    ${common.lib_deps}
    ESP RainMaker
```

### Method 2: Custom RainMaker Firmware with WLED Library

Create standalone RainMaker firmware that uses WLED as a library.

#### Project Structure

```
rainmaker-wled/
├── main/
│   ├── app_main.cpp
│   ├── wled_wrapper.cpp
│   └── wled_wrapper.h
├── components/
│   └── wled/
├── CMakeLists.txt
└── sdkconfig
```

#### Sample Code

`main/app_main.cpp`:

```cpp
#include <esp_log.h>
#include <esp_rmaker_core.h>
#include <esp_rmaker_standard_types.h>
#include <esp_rmaker_standard_params.h>
#include "wled_wrapper.h"

static const char *TAG = "WLED_RAINMAKER";

// RainMaker write callback
static esp_err_t write_cb(const esp_rmaker_device_t *device,
                          const esp_rmaker_param_t *param,
                          const esp_rmaker_param_val_t val,
                          void *priv_data,
                          esp_rmaker_write_ctx_t *ctx) {
    const char *param_name = esp_rmaker_param_get_name(param);

    if (strcmp(param_name, ESP_RMAKER_DEF_POWER_NAME) == 0) {
        wled_set_power(val.val.b);
    } else if (strcmp(param_name, ESP_RMAKER_DEF_BRIGHTNESS_NAME) == 0) {
        wled_set_brightness(val.val.i);
    } else if (strcmp(param_name, ESP_RMAKER_DEF_HUE_NAME) == 0) {
        wled_set_hue(val.val.i);
    }

    esp_rmaker_param_update_and_report(param, val);
    return ESP_OK;
}

extern "C" void app_main() {
    // Initialize NVS
    esp_err_t err = nvs_flash_init();

    // Initialize WiFi
    esp_rmaker_wifi_init();

    // Initialize RainMaker
    esp_rmaker_config_t rainmaker_cfg = {
        .enable_time_sync = true,
    };
    esp_rmaker_node_t *node = esp_rmaker_node_init(&rainmaker_cfg, "WLED Controller", "Lightbulb");

    // Create light device
    esp_rmaker_device_t *light_device = esp_rmaker_lightbulb_device_create("WLED", NULL, true);
    esp_rmaker_device_add_cb(light_device, write_cb, NULL);

    // Add parameters
    esp_rmaker_device_add_brightness_param(light_device, "Brightness", 50);
    esp_rmaker_device_add_hue_param(light_device, "Hue", 0);
    esp_rmaker_device_add_saturation_param(light_device, "Saturation", 0);

    // Add device to node
    esp_rmaker_node_add_device(node, light_device);

    // Enable OTA
    esp_rmaker_ota_enable_default();

    // Start RainMaker
    esp_rmaker_start();

    // Initialize WLED
    wled_init();

    ESP_LOGI(TAG, "WLED-RainMaker integration started");
}
```

## RainMaker Setup

### Step 1: Create RainMaker Account

1. Download ESP RainMaker app (iOS/Android)
2. Create account or sign in
3. Keep the app ready for device provisioning

### Step 2: Flash Firmware

```bash
# Using PlatformIO
pio run -e esp32_rainmaker -t upload

# Using ESP-IDF
idf.py build flash monitor

# Using Arduino IDE
# Select board: ESP32 Dev Module
# Upload firmware
```

### Step 3: Provision Device

1. Power on ESP32
2. Open RainMaker app
3. Tap "Add Device"
4. Scan QR code or enter proof of possession (default: "abcd1234")
5. Select WiFi network and enter credentials
6. Wait for provisioning to complete

### Step 4: Verify Connection

1. Device should appear in RainMaker app
2. Test power on/off
3. Test brightness control
4. Verify LED strip responds

## Integration Methods

### HTTP API Bridge

For existing WLED installations, create a bridge service:

```python
# rainmaker_bridge.py
import requests
import paho.mqtt.client as mqtt
import json

WLED_IP = "192.168.1.100"
WLED_API = f"http://{WLED_IP}/json/state"

def on_rainmaker_message(client, userdata, message):
    payload = json.loads(message.payload)

    # Convert RainMaker command to WLED API call
    wled_state = {
        "on": payload.get("power", True),
        "bri": int(payload.get("brightness", 128) * 2.55),
    }

    # Send to WLED
    requests.post(WLED_API, json=wled_state)

# Connect to RainMaker MQTT
client = mqtt.Client()
client.on_message = on_rainmaker_message
client.connect("rainmaker.espressif.com", 1883)
client.subscribe("node/+/params/+")
client.loop_forever()
```

### MQTT Integration

Configure WLED MQTT settings:
- Broker: Your MQTT broker IP
- Port: 1883
- Topic: wled/device1

Then bridge with RainMaker MQTT topics.

## Testing & Validation

### Test Checklist

- [ ] Power on/off from RainMaker app
- [ ] Brightness control (0-100%)
- [ ] Color control (if implemented)
- [ ] WLED WebUI still accessible
- [ ] RainMaker app shows correct state
- [ ] State synchronization works both ways
- [ ] WiFi reconnection after power loss
- [ ] OTA updates work
- [ ] Multiple devices can be added

### Debugging

Enable verbose logging:

```cpp
// In Arduino IDE
#define CORE_DEBUG_LEVEL 5

// In ESP-IDF
idf.py menuconfig
# Component config -> Log output -> Default log verbosity -> Verbose
```

Monitor serial output:
```bash
pio device monitor -b 115200
# or
idf.py monitor
```

## Troubleshooting

### Device Won't Provision
- Check BLE is enabled on phone
- Verify proof of possession matches
- Ensure ESP32 is in provisioning mode (LED blinking)
- Try resetting device and reprovisioning

### LEDs Don't Respond
- Verify GPIO pin configuration
- Check power supply voltage
- Test WLED standalone (disable RainMaker temporarily)
- Check for pin conflicts

### State Not Syncing
- Verify MQTT connection
- Check callback functions are registered
- Enable debug logging
- Monitor serial output for errors

### WiFi Connection Issues
- Check WiFi credentials
- Verify 2.4GHz network (ESP32 doesn't support 5GHz)
- Check signal strength
- Disable AP isolation in router

### High Memory Usage
- Reduce WLED segment count
- Disable unused features
- Use PSRAM if available
- Monitor heap with `ESP.getFreeHeap()`

## Advanced Configuration

### Voice Control

After RainMaker setup, enable voice assistants:

1. **Alexa**
   - Open Alexa app
   - Go to Skills & Games
   - Search "ESP RainMaker"
   - Enable skill and link account

2. **Google Home**
   - Open Google Home app
   - Tap "+" to add device
   - Select "Works with Google"
   - Search "ESP RainMaker"
   - Link account

### Scheduling & Automation

Use RainMaker app to create:
- Time-based schedules
- Sunrise/sunset triggers
- Custom automation rules

### Multi-Device Setup

For multiple WLED controllers:
1. Provision each device separately
2. Give unique names
3. Create groups in RainMaker app
4. Control individually or as group

## Performance Optimization

### Memory Management
- Use WLED presets instead of storing colors in RainMaker
- Minimize JSON payload sizes
- Use efficient data structures

### Power Management
- Implement deep sleep for battery-powered projects
- Use light sleep between updates
- Monitor current consumption

### Network Optimization
- Batch state updates
- Use QoS levels appropriately
- Implement connection retry logic with exponential backoff

## Security Considerations

- Change default proof of possession
- Use strong WiFi passwords
- Enable HTTPS for WLED (if using remote access)
- Keep firmware updated
- Disable unused features to reduce attack surface

## Additional Resources

- [WLED GitHub](https://github.com/Aircoookie/WLED)
- [ESP RainMaker GitHub](https://github.com/espressif/esp-rainmaker)
- [ESP32 Documentation](https://docs.espressif.com/projects/esp-idf/)
- Project examples in `../../projects/wled-controllers/`

## Support

For issues specific to:
- WLED: Check WLED Discord or GitHub issues
- RainMaker: ESP RainMaker forum
- Integration: Document in `../../docs/troubleshooting/`

## Changelog

- v1.0.0 - Initial integration guide
- Document your changes here as you modify the integration
