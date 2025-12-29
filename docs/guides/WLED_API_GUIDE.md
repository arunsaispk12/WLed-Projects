# WLED API Guide

Comprehensive guide to controlling WLED using various API methods including REST, JSON, MQTT, WebSocket, and UDP protocols.

## Table of Contents

1. [API Overview](#api-overview)
2. [REST API](#rest-api)
3. [JSON API](#json-api)
4. [WebSocket API](#websocket-api)
5. [MQTT Integration](#mqtt-integration)
6. [UDP Protocols](#udp-protocols)
7. [Authentication](#authentication)
8. [Integration Examples](#integration-examples)
9. [Advanced Features](#advanced-features)

---

## API Overview

### Available APIs

WLED provides multiple API interfaces for different use cases:

| API | Use Case | Pros | Cons |
|-----|----------|------|------|
| **REST API** | Simple HTTP requests | Easy to use, widely supported | Less efficient for rapid updates |
| **JSON API** | Complex control, automation | Powerful, comprehensive | Requires JSON parsing |
| **WebSocket** | Real-time bidirectional | Fast, low latency | More complex |
| **MQTT** | Home automation | Standard protocol, async | Requires MQTT broker |
| **UDP** | Fast control, sync | Very fast, no overhead | No confirmation |

### API Endpoints

**Default WLED Access:**
```
HTTP:  http://[WLED-IP]/
API:   http://[WLED-IP]/json
State: http://[WLED-IP]/json/state
Info:  http://[WLED-IP]/json/info
```

### Quick Start Example

**Turn on LEDs:**
```bash
# Simple HTTP GET
curl "http://192.168.1.100/win&T=1"

# JSON API POST
curl -X POST "http://192.168.1.100/json/state" \
  -H "Content-Type: application/json" \
  -d '{"on":true}'
```

---

## REST API

### HTTP GET Parameters

**Base URL:** `http://[WLED-IP]/win`

### Basic Control

#### Power

```bash
# Turn ON
http://[WLED-IP]/win&T=1

# Turn OFF
http://[WLED-IP]/win&T=0

# Toggle
http://[WLED-IP]/win&T=2
```

#### Brightness

```bash
# Set brightness (0-255)
http://[WLED-IP]/win&A=128

# Brightness percentage (0-100)
# Brightness = 255 * (percentage / 100)
http://[WLED-IP]/win&A=128  # 50%
```

#### Colors

**Primary Color:**
```bash
# RGB format (hex)
http://[WLED-IP]/win&CL=hFF0000  # Red
http://[WLED-IP]/win&CL=h00FF00  # Green
http://[WLED-IP]/win&CL=h0000FF  # Blue

# RGB format (decimal)
http://[WLED-IP]/win&R=255&G=0&B=0  # Red

# Individual color channels
http://[WLED-IP]/win&R=255  # Set red channel
http://[WLED-IP]/win&G=128  # Set green channel
http://[WLED-IP]/win&B=64   # Set blue channel
```

**Secondary Color:**
```bash
http://[WLED-IP]/win&C2=hFF00FF  # Magenta
```

**Tertiary Color:**
```bash
http://[WLED-IP]/win&C3=h00FFFF  # Cyan
```

**White Channel (RGBW):**
```bash
http://[WLED-IP]/win&W=255  # White at full brightness
```

#### Effects

```bash
# Set effect by ID (0-118+)
http://[WLED-IP]/win&FX=0   # Solid color
http://[WLED-IP]/win&FX=1   # Blink
http://[WLED-IP]/win&FX=10  # Rainbow
http://[WLED-IP]/win&FX=12  # Theater Chase

# Set effect speed (0-255)
http://[WLED-IP]/win&SX=128

# Set effect intensity (0-255)
http://[WLED-IP]/win&IX=200
```

**Common Effect IDs:**
- 0: Solid
- 1: Blink
- 2: Breathe
- 9: Colorloop
- 10: Rainbow
- 11: Scan
- 12: Theater Chase
- 46: Fire
- 75: Fireworks

#### Palettes

```bash
# Set palette by ID (0-50+)
http://[WLED-IP]/win&FP=0   # Default
http://[WLED-IP]/win&FP=1   # Random Cycle
http://[WLED-IP]/win&FP=10  # Rainbow
http://[WLED-IP]/win&FP=11  # Rainbow Bands
```

### Segments

```bash
# Select segment (0-15)
http://[WLED-IP]/win&SM=0  # Main segment
http://[WLED-IP]/win&SM=1  # Segment 1

# Set segment brightness
http://[WLED-IP]/win&SM=0&A=128

# Set segment color
http://[WLED-IP]/win&SM=1&CL=hFF0000
```

### Presets

```bash
# Load preset (1-250)
http://[WLED-IP]/win&PL=1

# Save current state to preset
http://[WLED-IP]/win&PS=1

# Cycle through presets
http://[WLED-IP]/win&P1=1&P2=10&PT=5  # Cycle 1-10 every 5 seconds
```

### Nightlight

```bash
# Enable nightlight (minutes)
http://[WLED-IP]/win&ND&NL=10  # 10 minutes

# Nightlight brightness
http://[WLED-IP]/win&NT=5  # Target brightness

# Nightlight fade
http://[WLED-IP]/win&NF=1  # Fade enabled
```

### Multiple Parameters

**Combine multiple parameters:**
```bash
# Turn on, set color red, brightness 128, effect rainbow
http://[WLED-IP]/win&T=1&CL=hFF0000&A=128&FX=10
```

### REST API Examples

**Python:**
```python
import requests

WLED_IP = "192.168.1.100"

# Turn on
requests.get(f"http://{WLED_IP}/win&T=1")

# Set red color
requests.get(f"http://{WLED_IP}/win&CL=hFF0000")

# Set brightness
requests.get(f"http://{WLED_IP}/win&A=200")

# Apply effect
requests.get(f"http://{WLED_IP}/win&FX=10")
```

**JavaScript:**
```javascript
const WLED_IP = "192.168.1.100";

// Turn on
fetch(`http://${WLED_IP}/win&T=1`);

// Set color and brightness
fetch(`http://${WLED_IP}/win&CL=h00FF00&A=150`);
```

**Bash/cURL:**
```bash
WLED_IP="192.168.1.100"

# Turn on
curl "http://${WLED_IP}/win&T=1"

# Rainbow effect
curl "http://${WLED_IP}/win&FX=10&SX=128"
```

---

## JSON API

### JSON State API

**Endpoint:** `http://[WLED-IP]/json/state`

**Methods:**
- **GET**: Retrieve current state
- **POST**: Update state

### Get Current State

```bash
curl http://192.168.1.100/json/state
```

**Response:**
```json
{
  "on": true,
  "bri": 128,
  "transition": 7,
  "ps": -1,
  "pl": -1,
  "nl": {
    "on": false,
    "dur": 60,
    "fade": true,
    "mode": 1,
    "tbri": 0
  },
  "udpn": {
    "send": false,
    "recv": true
  },
  "seg": [
    {
      "id": 0,
      "start": 0,
      "stop": 60,
      "len": 60,
      "grp": 1,
      "spc": 0,
      "on": true,
      "bri": 255,
      "col": [[255, 160, 0], [0, 0, 0], [0, 0, 0]],
      "fx": 0,
      "sx": 128,
      "ix": 128,
      "pal": 0,
      "sel": true,
      "rev": false,
      "mi": false
    }
  ]
}
```

### Set State

**Turn On:**
```bash
curl -X POST http://192.168.1.100/json/state \
  -H "Content-Type: application/json" \
  -d '{"on":true}'
```

**Set Brightness:**
```bash
curl -X POST http://192.168.1.100/json/state \
  -H "Content-Type: application/json" \
  -d '{"bri":200}'
```

**Set Color:**
```bash
curl -X POST http://192.168.1.100/json/state \
  -H "Content-Type: application/json" \
  -d '{"seg":[{"col":[[255,0,0]]}]}'
```

**Multiple Settings:**
```bash
curl -X POST http://192.168.1.100/json/state \
  -H "Content-Type: application/json" \
  -d '{
    "on": true,
    "bri": 180,
    "seg": [{
      "col": [[0, 255, 0]],
      "fx": 10,
      "sx": 150
    }]
  }'
```

### JSON State Parameters

**Main Object:**
```json
{
  "on": true,              // Power state
  "bri": 128,              // Master brightness (0-255)
  "transition": 7,         // Transition time (deciseconds)
  "ps": 1,                 // Preset to load (-1 = none)
  "pl": -1,                // Playlist (-1 = none)
  "nl": {},                // Nightlight object
  "udpn": {},              // UDP sync object
  "v": true,               // Verbose response
  "seg": []                // Segments array
}
```

**Segment Object:**
```json
{
  "id": 0,                 // Segment ID
  "start": 0,              // Start LED
  "stop": 60,              // Stop LED (exclusive)
  "grp": 1,                // Grouping (1 = no grouping)
  "spc": 0,                // Spacing
  "on": true,              // Segment on/off
  "bri": 255,              // Segment brightness
  "col": [                 // Colors array
    [255, 0, 0],          // Primary color [R, G, B]
    [0, 255, 0],          // Secondary color
    [0, 0, 255]           // Tertiary color
  ],
  "fx": 0,                 // Effect ID
  "sx": 128,               // Effect speed
  "ix": 128,               // Effect intensity
  "pal": 0,                // Palette ID
  "sel": true,             // Selected
  "rev": false,            // Reverse direction
  "mi": false              // Mirror effect
}
```

### JSON Info API

**Endpoint:** `http://[WLED-IP]/json/info`

**Get Device Info:**
```bash
curl http://192.168.1.100/json/info
```

**Response:**
```json
{
  "ver": "0.14.0",
  "vid": 2312080,
  "leds": {
    "count": 60,
    "rgbw": false,
    "wv": false,
    "pin": [2],
    "pwr": 850,
    "fps": 42,
    "maxpwr": 850,
    "maxseg": 16
  },
  "name": "WLED-Light",
  "udpport": 21324,
  "live": false,
  "fxcount": 118,
  "palcount": 51,
  "wifi": {
    "bssid": "AA:BB:CC:DD:EE:FF",
    "rssi": -54,
    "signal": 92,
    "channel": 11
  },
  "arch": "esp32",
  "core": "3.3.5",
  "lwip": 2,
  "freeheap": 142536,
  "uptime": 3456,
  "opt": 127,
  "brand": "WLED",
  "product": "FOSS",
  "mac": "aabbccddeeff",
  "ip": "192.168.1.100"
}
```

### JSON Examples

**Python with JSON:**
```python
import requests
import json

WLED_IP = "192.168.1.100"
url = f"http://{WLED_IP}/json/state"

# Get current state
response = requests.get(url)
state = response.json()
print(f"Current brightness: {state['bri']}")

# Set new state
new_state = {
    "on": True,
    "bri": 200,
    "seg": [{
        "col": [[255, 100, 0]],  # Orange
        "fx": 10,                # Rainbow
        "sx": 150                # Speed
    }]
}

requests.post(url, json=new_state)
```

**Node.js:**
```javascript
const axios = require('axios');

const WLED_IP = '192.168.1.100';
const url = `http://${WLED_IP}/json/state`;

// Get state
axios.get(url)
  .then(response => {
    console.log('Current state:', response.data);
  });

// Set state
const newState = {
  on: true,
  bri: 180,
  seg: [{
    col: [[0, 0, 255]],  // Blue
    fx: 0                // Solid
  }]
};

axios.post(url, newState)
  .then(response => {
    console.log('Updated!');
  });
```

---

## WebSocket API

### WebSocket Connection

**Endpoint:** `ws://[WLED-IP]/ws`

**Features:**
- Real-time bidirectional communication
- Live updates from WLED
- Low latency
- Efficient for continuous control

### JavaScript WebSocket Example

```javascript
const ws = new WebSocket('ws://192.168.1.100/ws');

// Connection opened
ws.addEventListener('open', function (event) {
    console.log('Connected to WLED');

    // Send state update
    ws.send(JSON.stringify({
        on: true,
        bri: 200,
        seg: [{col: [[255, 0, 0]]}]
    }));
});

// Listen for messages
ws.addEventListener('message', function (event) {
    const data = JSON.parse(event.data);
    console.log('Received:', data);

    // Update UI with WLED state
    updateUI(data);
});

// Connection closed
ws.addEventListener('close', function (event) {
    console.log('Disconnected from WLED');
});

// Error handling
ws.addEventListener('error', function (event) {
    console.error('WebSocket error:', event);
});

// Send updates
function setBrightness(value) {
    ws.send(JSON.stringify({bri: value}));
}

function setColor(r, g, b) {
    ws.send(JSON.stringify({
        seg: [{col: [[r, g, b]]}]
    }));
}
```

### Python WebSocket Example

```python
import asyncio
import websockets
import json

async def control_wled():
    uri = "ws://192.168.1.100/ws"

    async with websockets.connect(uri) as websocket:
        # Send command
        await websocket.send(json.dumps({
            "on": True,
            "bri": 200,
            "seg": [{"col": [[255, 0, 0]]}]
        }))

        # Receive updates
        while True:
            message = await websocket.recv()
            data = json.loads(message)
            print(f"State update: {data}")

asyncio.run(control_wled())
```

---

## MQTT Integration

### Enable MQTT in WLED

**Settings → Sync Interfaces → MQTT:**
- Broker: Your MQTT broker IP
- Port: 1883 (default)
- Username: (optional)
- Password: (optional)
- Client ID: WLED-[device-name]
- Device Topic: wled/[device-name]
- Group Topic: wled/all (optional)

### MQTT Topics

**Command Topics:**
```
wled/[device-name]/api          # JSON API commands
wled/[device-name]/col          # Set primary color (hex)
wled/[device-name]/api          # Full JSON state
```

**State Topics:**
```
wled/[device-name]/v            # Published on state change
wled/[device-name]/status       # Online/offline status
```

### MQTT Commands

**Power Control:**
```bash
# Mosquitto client examples
mosquitto_pub -h broker.local -t "wled/light1/api" -m "ON"
mosquitto_pub -h broker.local -t "wled/light1/api" -m "OFF"
mosquitto_pub -h broker.local -t "wled/light1/api" -m "T"  # Toggle
```

**Brightness:**
```bash
# Set brightness (0-255)
mosquitto_pub -h broker.local -t "wled/light1/api" -m "A=200"
```

**Color:**
```bash
# Set color (hex)
mosquitto_pub -h broker.local -t "wled/light1/col" -m "#FF0000"

# RGB (via API)
mosquitto_pub -h broker.local -t "wled/light1/api" -m "R=255&G=0&B=0"
```

**Effect:**
```bash
# Set effect by ID
mosquitto_pub -h broker.local -t "wled/light1/api" -m "FX=10"
```

**JSON State:**
```bash
mosquitto_pub -h broker.local -t "wled/light1/api" \
  -m '{"on":true,"bri":200,"seg":[{"col":[[255,0,0]]}]}'
```

### Home Assistant MQTT

**configuration.yaml:**
```yaml
light:
  - platform: mqtt
    name: "WLED Light"
    state_topic: "wled/light1/v"
    command_topic: "wled/light1/api"
    brightness_state_topic: "wled/light1/v"
    brightness_command_topic: "wled/light1/api"
    rgb_state_topic: "wled/light1/c"
    rgb_command_topic: "wled/light1/col"
    effect_state_topic: "wled/light1/v"
    effect_command_topic: "wled/light1/api"
    availability_topic: "wled/light1/status"
    payload_on: "ON"
    payload_off: "OFF"
    payload_available: "online"
    payload_not_available: "offline"
    brightness_scale: 255
    rgb_command_template: "{{ '#%02x%02x%02x' | format(red, green, blue) }}"
    effect_list:
      - "Solid"
      - "Blink"
      - "Rainbow"
      - "Theater Chase"
```

### Python MQTT Example

```python
import paho.mqtt.client as mqtt
import json

BROKER = "192.168.1.50"
TOPIC = "wled/light1/api"

client = mqtt.Client()
client.connect(BROKER, 1883, 60)

# Turn on
client.publish(TOPIC, "ON")

# Set brightness
client.publish(TOPIC, "A=200")

# Set color via JSON
state = {"on": True, "bri": 200, "seg": [{"col": [[0, 255, 0]]}]}
client.publish(TOPIC, json.dumps(state))

client.disconnect()
```

---

## UDP Protocols

### WLED UDP Sync

**Enable in WLED:**
Settings → Sync Interfaces → UDP Port: 21324

### Send UDP Commands

**Python UDP:**
```python
import socket

WLED_IP = "192.168.1.100"
UDP_PORT = 21324

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# WARLS protocol (simple)
# Format: [mode][brightness][R][G][B]
message = bytes([1, 200, 255, 0, 0])  # Mode 1, brightness 200, red
sock.sendto(message, (WLED_IP, UDP_PORT))

sock.close()
```

### DRGB Protocol

**Format:** `DRGB[R][G][B]`

```python
import socket

def send_drgb(ip, r, g, b):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    message = bytes([1, 1, r, g, b])  # DRGB header + RGB
    sock.sendto(message, (ip, 21324))
    sock.close()

send_drgb("192.168.1.100", 255, 100, 0)  # Orange
```

### DDP Protocol (Advanced)

**Distributed Display Protocol:**
- More efficient for many LEDs
- Used by xLights, Falcon Player
- Supports multiple universes

---

## Authentication

### Enable Authentication

**Settings → Security:**
- Enable: Yes
- Username: admin (default)
- Password: [your-password]
- Require password for OTA: Yes

### Authenticated Requests

**Basic Authentication:**

**cURL:**
```bash
curl -u admin:password http://192.168.1.100/win&T=1
```

**Python:**
```python
import requests
from requests.auth import HTTPBasicAuth

response = requests.get(
    "http://192.168.1.100/win&T=1",
    auth=HTTPBasicAuth('admin', 'password')
)
```

**JavaScript:**
```javascript
const username = 'admin';
const password = 'password';
const credentials = btoa(`${username}:${password}`);

fetch('http://192.168.1.100/win&T=1', {
    headers: {
        'Authorization': `Basic ${credentials}`
    }
});
```

---

## Integration Examples

### Home Assistant

**REST Integration:**

```yaml
# configuration.yaml
light:
  - platform: rest
    name: WLED Light
    resource: http://192.168.1.100/json/state
    state_resource: http://192.168.1.100/json/state
    method: POST
    body_on: '{"on":true}'
    body_off: '{"on":false}'
    is_on_template: '{{ value_json.on }}'
    brightness_command_topic: http://192.168.1.100/json/state
    brightness_command_template: '{"bri":{{ brightness }}}'
```

**Better: Use WLED Integration (Built-in):**
```yaml
# Just add WLED in Integrations UI
# Auto-discovers WLED devices
```

### Node-RED

**HTTP Request Node:**
```json
{
    "method": "POST",
    "url": "http://192.168.1.100/json/state",
    "headers": {
        "Content-Type": "application/json"
    },
    "payload": {
        "on": true,
        "bri": 200
    }
}
```

### Python Automation Script

```python
#!/usr/bin/env python3
import requests
import time

WLED_IP = "192.168.1.100"
API_URL = f"http://{WLED_IP}/json/state"

def set_state(on=None, bri=None, color=None, effect=None):
    """Universal WLED control function"""
    state = {}

    if on is not None:
        state["on"] = on
    if bri is not None:
        state["bri"] = bri
    if color is not None:
        state["seg"] = [{"col": [color]}]
    if effect is not None:
        state["seg"] = [{"fx": effect}]

    requests.post(API_URL, json=state)

# Examples
set_state(on=True, bri=200)
set_state(color=[255, 0, 0])  # Red
set_state(effect=10)  # Rainbow
time.sleep(5)
set_state(on=False)
```

### Bash Script with cURL

```bash
#!/bin/bash

WLED_IP="192.168.1.100"
API_URL="http://${WLED_IP}/json/state"

function wled_on() {
    curl -s -X POST "$API_URL" \
        -H "Content-Type: application/json" \
        -d '{"on":true}'
}

function wled_off() {
    curl -s -X POST "$API_URL" \
        -H "Content-Type: application/json" \
        -d '{"on":false}'
}

function wled_brightness() {
    curl -s -X POST "$API_URL" \
        -H "Content-Type: application/json" \
        -d "{\"bri\":$1}"
}

function wled_color() {
    curl -s -X POST "$API_URL" \
        -H "Content-Type: application/json" \
        -d "{\"seg\":[{\"col\":[[$1,$2,$3]]}]}"
}

# Usage
wled_on
wled_brightness 200
wled_color 255 100 0  # Orange
sleep 5
wled_off
```

---

## Advanced Features

### Macros

**Define Macros in WLED:**
Settings → Macros

**Examples:**
- Macro 0: Boot preset
- Macro 1: Button short press
- Macro 2: Button long press
- Macro 15: Alexa On
- Macro 16: Alexa Off

**Trigger Macro via API:**
```bash
curl http://192.168.1.100/win&M=1  # Trigger macro 1
```

### Presets via API

**List Presets:**
```bash
curl http://192.168.1.100/presets.json
```

**Load Preset:**
```bash
curl -X POST http://192.168.1.100/json/state -d '{"ps":1}'
```

**Save Preset:**
```bash
curl -X POST http://192.168.1.100/json/state -d '{"psave":1}'
```

### Playlist Control

**Start Playlist:**
```bash
curl -X POST http://192.168.1.100/json/state -d '{"pl":1}'
```

**Stop Playlist:**
```bash
curl -X POST http://192.168.1.100/json/state -d '{"pl":-1}'
```

### Live LED Control

**Realtime UDP (High Speed):**
```python
import socket

WLED_IP = "192.168.1.100"
UDP_PORT = 19446  # Realtime port

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# WARLS protocol: Send LED data
# Header: [2][timeout][startLED][R][G][B]...
header = bytes([2, 1, 0])  # WARLS, 1sec timeout, start LED 0
led_data = bytes([255, 0, 0] * 60)  # 60 red LEDs

sock.sendto(header + led_data, (WLED_IP, UDP_PORT))
sock.close()
```

### Notifications

**Push Notification:**
```bash
curl -X POST http://192.168.1.100/json/state \
  -d '{"v":true,"notify":true}'
```

---

## Quick Reference

### Common API Calls

```bash
# Power
ON:  curl "http://[IP]/win&T=1"
OFF: curl "http://[IP]/win&T=0"

# Brightness
curl "http://[IP]/win&A=200"

# Color (Red)
curl "http://[IP]/win&CL=hFF0000"

# Effect (Rainbow)
curl "http://[IP]/win&FX=10"

# JSON - Turn on with color
curl -X POST "http://[IP]/json/state" \
  -H "Content-Type: application/json" \
  -d '{"on":true,"seg":[{"col":[[255,0,0]]}]}'

# MQTT
mosquitto_pub -t "wled/light1/api" -m "ON"
```

### HTTP Response Codes

- **200 OK**: Success
- **400 Bad Request**: Invalid parameters
- **401 Unauthorized**: Authentication required
- **404 Not Found**: Invalid endpoint

### Rate Limiting

**Recommendations:**
- REST API: Max 10 requests/second
- JSON API: Max 20 requests/second
- WebSocket: No limit (preferred for rapid updates)
- UDP: No limit

---

## Troubleshooting

### API Not Responding

**Check:**
1. WLED is powered on and connected to WiFi
2. IP address is correct
3. Firewall not blocking
4. Authentication credentials correct

### JSON Parse Errors

**Ensure:**
- Valid JSON format
- Proper quotes (double quotes, not single)
- No trailing commas
- Content-Type header set

### MQTT Not Working

**Verify:**
1. MQTT broker is running
2. Broker IP/port correct in WLED settings
3. MQTT enabled in WLED
4. Topic names correct
5. No authentication issues

### UDP Sync Issues

**Check:**
1. UDP port (21324) not blocked by firewall
2. Devices on same subnet
3. UDP sync enabled in settings

---

## Related Guides

- [Firmware Development Guide](FIRMWARE_DEVELOPMENT_GUIDE.md)
- [Home Assistant Integration](WLED_HOME_ASSISTANT.md)
- [Sensor Integration Guide](SENSOR_INTEGRATION_GUIDE.md)

---

## Resources

- [WLED Official API Documentation](https://kno.wled.ge/interfaces/http-api/)
- [WLED JSON API](https://kno.wled.ge/interfaces/json-api/)
- [WLED GitHub](https://github.com/Aircoookie/WLED)

---

Happy API Integration! 🚀💡
