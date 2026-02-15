# Staircase Lighting Guide

Comprehensive guide to implementing WLED-based staircase lighting with PIR sensors, directional detection, and multiple staircase support.

## Table of Contents

1. [Introduction](#introduction)
2. [Basic Single Staircase](#basic-single-staircase)
3. [Directional Detection](#directional-detection)
4. [Multiple Staircases](#multiple-staircases)
5. [Hardware Setup](#hardware-setup)
6. [Software Configuration](#software-configuration)
7. [LED Installation](#led-installation)
8. [Advanced Features](#advanced-features)
9. [Troubleshooting](#troubleshooting)

---

## Introduction

### Why Staircase Lighting?

**Benefits:**
✅ **Safety:** Illuminates stairs automatically when needed
✅ **Energy Efficient:** Only on when detecting motion
✅ **Aesthetic:** Beautiful cascading light effects
✅ **Convenience:** No switches to find in the dark
✅ **Accessibility:** Helps elderly and children
✅ **Smart Home:** Integrates with home automation

### Common Configurations

**1. Basic Auto-On:**
- Motion at top or bottom turns on all steps
- Timer-based auto-off
- Simplest implementation

**2. Directional Cascade:**
- Detects direction of travel (up vs down)
- Steps light up sequentially in direction of travel
- Most impressive visual effect

**3. Segmented:**
- Only lights steps near person
- Follows movement up/down stairs
- Most energy efficient

**4. Multiple Staircases:**
- Independent control of multiple stairways
- Shared controller
- Zone-based operation

---

## Basic Single Staircase

### Overview

**Components Needed:**
- 1× ESP32 controller
- 1-2× PIR sensors (HC-SR501 or AM312)
- LED strip (enough for all steps)
- Power supply (5V or 12V)
- Level shifter (74HCT125)
- Fuses and wiring

### Single PIR Setup (Simplest)

**Configuration:**
- One PIR at bottom of stairs
- Triggers all steps to light
- Timer auto-off after motion stops

#### Wiring Diagram

```
                     5V Power Supply
                           │
                           ├────── ESP32 VIN
                           ├────── PIR VCC
                           ├────── LED Strip 5V
                           │
HC-SR501 PIR              ESP32
┌─────────┐            ┌─────────┐
│  VCC    │────────────│ VIN(5V) │
│  OUT    │────────────│ GPIO13  │
│  GND    │────────────│ GND     │
└─────────┘            └─────────┘
                            │
                       GPIO2 → [Level Shifter] → LED Data
```

#### WLED Configuration

1. **LED Setup:**
   - Total LEDs: Count for all steps
   - LED Type: WS2812B (or your type)
   - GPIO: 2

2. **Button/PIR Setup:**
   - Settings → LED Preferences → Button 0 GPIO: 13
   - Button Type: PIR Sensor
   - Or use Stairway WLED Usermod

3. **Timing:**
   - Auto-off time: 30-60 seconds
   - Adjust based on staircase length

#### LED Layout

```
Staircase View:

Top Landing    [═══════════]  ← 1 meter LED strip
Step 14        [═══════════]  ← 1 meter per step
Step 13        [═══════════]
Step 12        [═══════════]
...
Step 3         [═══════════]
Step 2         [═══════════]
Step 1         [═══════════]
Bottom Landing [═══════════]

Total: 16 segments × 60 LEDs/m = 960 LEDs
```

### Dual PIR Setup (Top + Bottom)

**Configuration:**
- PIR at top of stairs
- PIR at bottom of stairs
- Either sensor triggers lights
- Better coverage

#### Wiring Diagram

```
PIR Bottom                 ESP32
┌─────────┐            ┌─────────┐
│  VCC    │────────────│ 5V      │
│  OUT    │────────────│ GPIO13  │
│  GND    │────────────│ GND     │
└─────────┘            └─────────┘

PIR Top
┌─────────┐
│  VCC    │────────────│ 5V      │
│  OUT    │────────────│ GPIO14  │ ← Different GPIO!
│  GND    │────────────│ GND     │
└─────────┘            └─────────┘
```

#### Logic (Software)

```cpp
// Pseudo-code
if (pirBottom || pirTop) {
    turnOnAllSteps();
    startTimer(60 seconds);
}

if (timerExpired && noPirActive) {
    turnOffAllSteps();
}
```

---

## Directional Detection

### How It Works

**Concept:**
- Two PIR sensors (top and bottom)
- Detect which sensor triggers first
- Light steps in direction of travel
- More engaging and natural

### Timing Logic

```
Scenario: Person at bottom, walking up

t=0s:  Bottom PIR triggers
       → Start lighting from bottom to top (cascade up)
       → LEDs 1, 2, 3... sequential

t=5s:  Top PIR triggers (person reached top)
       → Confirms upward direction
       → Start timer

t=35s: Timer expires (30s after reaching top)
       → Turn off from bottom to top
       Or: Turn off from top to bottom
```

### Wiring (Same as Dual PIR)

```
PIR Bottom ── GPIO13
PIR Top ── GPIO14

Both connected to 5V and GND
```

### WLED Usermod: Stairway WLED

**Features:**
✅ Automatic direction detection
✅ Configurable cascade speed
✅ Configurable on/off time
✅ Segment-based (one segment per step)
✅ Web UI configuration

**Installation:**

1. **Flash Firmware:**
   - Use WLED with Stairway Usermod compiled in
   - Or compile yourself with usermod enabled

2. **Configure Segments:**
   - Segment 0: Step 1 (LEDs 0-59)
   - Segment 1: Step 2 (LEDs 60-119)
   - Segment 2: Step 3 (LEDs 120-179)
   - ... and so on

3. **Usermod Settings:**
   ```
   Stairway Settings:
   - PIR Bottom: GPIO13
   - PIR Top: GPIO14
   - Cascade Time: 2000ms (2 seconds total)
   - On Time: 30000ms (30 seconds)
   - Off Time: 2000ms (cascade off in 2s)
   ```

### Software Logic (Detailed)

```cpp
State: IDLE, WALKING_UP, WALKING_DOWN, ON, TURNING_OFF

IDLE State:
  if (pirBottom triggered):
    state = WALKING_UP
    cascade lights bottom→top
  if (pirTop triggered):
    state = WALKING_DOWN
    cascade lights top→bottom

WALKING_UP State:
  Continue cascade
  if (pirTop triggered):
    state = ON  (confirmed top reached)
    start timer
  if (timeout 10s):  // Never reached top
    state = TURNING_OFF

ON State:
  if (timer expired):
    state = TURNING_OFF
    cascade off

TURNING_OFF State:
  Cascade lights off
  when complete:
    state = IDLE
```

### Cascade Patterns

**Option 1: Sequential (Classic)**
```
Step 1: █████
Step 2: ░░░░░ → █████
Step 3: ░░░░░ → ░░░░░ → █████
...

Each step lights after delay (e.g., 150ms)
```

**Option 2: Wave (Smooth)**
```
All steps brighten in sequence
Looks like wave traveling up stairs
Smooth gradient effect
```

**Option 3: Fill (Progressive)**
```
Step 1: █████
Step 2: █████ ← stays on
Step 3: █████ ← stays on
...

Progressive fill from bottom to top
```

**Option 4: Center Out (Dramatic)**
```
Middle steps light first
Then expand outward
Works best for longer staircases
```

---

## Multiple Staircases

### Two Independent Staircases

**Scenario:**
- Main stairs (ground to 2nd floor)
- Basement stairs (ground to basement)
- Separate detection and control
- Single ESP32 controller

#### Hardware Setup

```
ESP32 GPIO Allocation:

Main Stairs:
- GPIO13: PIR Bottom
- GPIO14: PIR Top
- GPIO2:  LED Data Output 1

Basement Stairs:
- GPIO27: PIR Bottom
- GPIO26: PIR Top
- GPIO4:  LED Data Output 2

NOTE: Do NOT use GPIO15 — it is a boot strapping pin on ESP32.

Both through separate level shifters
```

#### Wiring Diagram

```
                     ESP32
                  ┌─────────┐
Main PIR Bottom ──│ GPIO13  │
Main PIR Top ─────│ GPIO14  │
Main LED Data ────│ GPIO2   │→ Level Shifter 1 → Main Stairs LEDs
                  │         │
Bsmt PIR Bottom ──│ GPIO27  │
Bsmt PIR Top ─────│ GPIO26  │
Bsmt LED Data ────│ GPIO4   │→ Level Shifter 2 → Basement LEDs
                  └─────────┘
```

#### WLED Configuration

**Segments:**
```
Main Stairs:
- Segment 0-13: Main staircase steps (14 steps)

Basement Stairs:
- Segment 14-24: Basement stairs (11 steps)
```

**Custom Usermod:**
- Modify Stairway WLED usermod
- Add second set of PIR inputs
- Add second staircase configuration
- Independent state machines for each stair

### Three or More Staircases

**Limitation:**
- ESP32 has limited GPIO
- Each staircase needs:
  - 2× GPIO for PIRs
  - 1× GPIO for LED data

**Solutions:**

**Option 1: Multiple ESP32 Controllers**
```
ESP32 #1: Main stairs
ESP32 #2: Basement stairs
ESP32 #3: Attic stairs

Pros:
✅ Simple software
✅ Independent operation
✅ Fault isolation

Cons:
❌ More hardware cost
❌ Multiple WiFi connections
❌ Harder to synchronize
```

**Option 2: GPIO Expander (MCP23017)**
```
ESP32 ← I2C → MCP23017 (16 GPIO)
                  ↓
            PIR sensors

Pros:
✅ One ESP32
✅ Many staircases possible

Cons:
❌ More complex software
❌ Slightly slower response
❌ Single point of failure
```

**Option 3: Multiplexing**
```
Use analog multiplexer (CD4051)
Share GPIO, select which staircase is active

Pros:
✅ Saves GPIO

Cons:
❌ Complex
❌ Can miss quick triggers
❌ Not recommended for this application
```

**Recommendation:** For 3+ staircases, use multiple ESP32 controllers (Option 1)

---

## Hardware Setup

### PIR Sensor Placement

#### Optimal Height

**Bottom PIR:**
- Height: 10-20cm above floor
- Position: 30-50cm from first step
- Angle: Aimed up at 45° toward stairs

**Top PIR:**
- Height: 10-20cm below ceiling
- Position: 30-50cm from last step
- Angle: Aimed down at 45° toward stairs

#### Coverage Pattern

```
Side View:

Ceiling ─────────────────────────
                    ┌─ PIR Top (aimed down)
                    │     ◢◣  Detection cone
                    │       ◥
┌─────────────┐ ←Top step
│             │
│  Staircase  │
│             │
│             │
└─────────────┘ ←Bottom step
     ◤            ↑
   ◢  ◣           │
  PIR Bottom      │
(aimed up) ───────┘

Floor ───────────────────────────
```

#### Mounting

**Bottom PIR:**
- Mount to wall beside stairs
- Or mount under first step (hidden)
- Ensure not blocked by furniture

**Top PIR:**
- Mount to ceiling above landing
- Or mount under railing at top
- Ensure clear line of sight

**Avoid:**
❌ Direct sunlight exposure
❌ Near heat sources (radiators)
❌ Near air vents (false triggers)
❌ Behind furniture or plants
❌ Too far from stairs (no detection)

### LED Installation

#### Per-Step Mounting

**Recommended: Aluminum Channel**

**Benefits:**
✅ Professional appearance
✅ Acts as heatsink
✅ Protects LEDs
✅ Diffuses light
✅ Easy to clean

**Installation:**
```
Cross-Section of Step:

Step Tread
════════════════════
        │
    [Aluminum Channel with LED strip]
        │
        ↓
   (Light shines down on next step)

Riser
║
║
```

**Placement Options:**

**Option 1: Under Nosing (Front Edge)**
```
Step ══════╗
           ║ Nosing
       [LED]║
           ║
     Next Step
```
- Most common
- Lights up riser below
- Dramatic effect

**Option 2: Under Tread (Bottom)**
```
Step ══════════
    [LED strip underneath]
Next Step ─────
```
- Hidden installation
- Lights next step tread
- More subtle

**Option 3: Side Mount (Walls)**
```
Wall ║          ║ Wall
     ║ [LED]    ║
     ║   Step   ║
     ║          ║
```
- LEDs on both walls
- Wider coverage
- Uses more LEDs

#### Wiring Between Steps

**Method 1: Continuous Strip**
```
Bottom → Step 1 → Step 2 → Step 3 → ... → Top

Pros:
✅ Simple wiring
✅ One continuous data line

Cons:
❌ Long strip (voltage drop)
❌ One break affects all
❌ Hard to service individual step
```

**Method 2: Individual Segments with Jumpers**
```
Controller → Segment 1
          ↓
        [Jump Wire] → Segment 2
                   ↓
                [Jump Wire] → Segment 3

Pros:
✅ Can replace individual segments
✅ Easier power injection
✅ Better voltage management

Cons:
❌ More connections
❌ More potential failure points
```

**Recommended:**
- Continuous strip for <14 steps
- Individual segments for >14 steps or fancy installation

### Power Injection

**For Long Staircases (>10 steps):**

```
Power Supply
    │
    ├─────[Fuse]─── Bottom of stairs (+ and -)
    │
    └─────[Fuse]─── Middle of stairs (+ and -, data continues)
    │
    └─────[Fuse]─── Top of stairs (+ and -, data continues)
```

**Injection Points:**
- Every 100-150 LEDs (5V)
- Every 200-300 LEDs (12V)
- Measure voltage at last LED (should be >4.5V for 5V LEDs)

---

## Software Configuration

### WLED Settings

#### LED Preferences

```
Settings → LED Preferences:

- LED Count: [Total LEDs across all steps]
- LED Type: WS2812B (or your type)
- GPIO: 2
- Color Order: GRB (test and verify)
- Turn on after power: ON (for reliability)
```

#### Segments (Per-Step Control)

**Example: 14 Steps, 60 LEDs per step**

```
Segment 1:  Start LED 0, Stop LED 59    (Step 1)
Segment 2:  Start LED 60, Stop LED 119  (Step 2)
Segment 3:  Start LED 120, Stop LED 179 (Step 3)
...
Segment 14: Start LED 780, Stop LED 839 (Step 14)
```

**Grouping:**
- Each step = one segment
- Allows individual step control
- Required for cascade effects

#### Button Configuration (Basic PIR)

```
Settings → LED Preferences → Button 0:

- GPIO: 13
- Button Type: PIR sensor (if supported)
- Or use "Button" and configure in code
```

### Stairway WLED Usermod

**GitHub:** https://github.com/Aircoookie/WLED/tree/master/usermods/stairway_wled

**Features:**
- Automatic direction detection
- Configurable cascade timing
- Web UI configuration
- Works with standard WLED

**Compilation:**

1. **Download WLED Source:**
   ```bash
   git clone https://github.com/Aircoookie/WLED.git
   cd WLED
   ```

2. **Enable Usermod:**
   Edit `platformio.ini`:
   ```ini
   build_flags =
       -D USERMOD_STAIRWAY_WLED
   ```

3. **Or Use platformio_override.ini:**
   ```ini
   [env:esp32_stairway]
   board = esp32dev
   build_flags =
       ${env:esp32dev.build_flags}
       -D USERMOD_STAIRWAY_WLED
   ```

4. **Compile and Flash:**
   ```bash
   pio run -e esp32_stairway -t upload
   ```

**Configuration (Web UI):**
```
Settings → Stairway:

- PIR Sensor Bottom: GPIO 13
- PIR Sensor Top: GPIO 14
- Number of Steps: 14
- Cascade On Time: 2000ms
- On Time: 30000ms
- Cascade Off Time: 2000ms
- Enable Usermod: ON
```

### Custom Code (Alternative)

**For Advanced Control:**

```cpp
// Example custom sketch
#include <Adafruit_NeoPixel.h>

#define LED_PIN 2
#define LED_COUNT 840  // 14 steps × 60 LEDs
#define PIR_BOTTOM 13
#define PIR_TOP 14

Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);

enum State {
    IDLE,
    CASCADE_UP,
    CASCADE_DOWN,
    ON,
    CASCADE_OFF
};

State currentState = IDLE;
unsigned long stateTimer = 0;
int currentStep = 0;

void setup() {
    pinMode(PIR_BOTTOM, INPUT);
    pinMode(PIR_TOP, INPUT);
    strip.begin();
    strip.show(); // Initialize all pixels to 'off'
}

void loop() {
    switch (currentState) {
        case IDLE:
            if (digitalRead(PIR_BOTTOM)) {
                currentState = CASCADE_UP;
                currentStep = 0;
                stateTimer = millis();
            } else if (digitalRead(PIR_TOP)) {
                currentState = CASCADE_DOWN;
                currentStep = 13;
                stateTimer = millis();
            }
            break;

        case CASCADE_UP:
            if (millis() - stateTimer > 150) {  // 150ms per step
                lightStep(currentStep, strip.Color(255, 255, 255));
                strip.show();
                currentStep++;
                stateTimer = millis();

                if (currentStep >= 14) {
                    currentState = ON;
                    stateTimer = millis();
                }
            }
            break;

        case CASCADE_DOWN:
            if (millis() - stateTimer > 150) {
                lightStep(currentStep, strip.Color(255, 255, 255));
                strip.show();
                currentStep--;
                stateTimer = millis();

                if (currentStep < 0) {
                    currentState = ON;
                    stateTimer = millis();
                }
            }
            break;

        case ON:
            if (millis() - stateTimer > 30000) {  // 30 seconds on
                currentState = CASCADE_OFF;
                currentStep = 0;
                stateTimer = millis();
            }
            break;

        case CASCADE_OFF:
            if (millis() - stateTimer > 150) {
                lightStep(currentStep, strip.Color(0, 0, 0));
                strip.show();
                currentStep++;
                stateTimer = millis();

                if (currentStep >= 14) {
                    currentState = IDLE;
                }
            }
            break;
    }
}

void lightStep(int step, uint32_t color) {
    int startLED = step * 60;
    for (int i = 0; i < 60; i++) {
        strip.setPixelColor(startLED + i, color);
    }
}
```

---

## Advanced Features

### Light Sensor Integration

**Auto-Enable Only in Darkness:**

```
BH1750 Light Sensor → ESP32 I2C

Logic:
if (lightLevel < 10 lux && PIR triggered) {
    Enable stairway lights
} else {
    Disable (daytime, don't waste power)
}
```

**Benefits:**
✅ Energy savings
✅ Only operates when needed
✅ No manual control required

### Time-Based Behavior

**Different Brightness by Time:**

```cpp
int getBrightnessForTime() {
    int hour = getHour();  // From NTP or RTC

    if (hour >= 22 || hour < 6) {  // 10pm - 6am
        return 50;  // Dim (night mode)
    } else if (hour >= 6 && hour < 8) {  // 6am - 8am
        return 150; // Medium (morning)
    } else {
        return 255; // Full brightness
    }
}
```

### Color Temperature Shift

**Warm White at Night:**

```cpp
uint32_t getColorForTime() {
    int hour = getHour();

    if (hour >= 22 || hour < 6) {
        // Warm white (orange-ish) for night
        return strip.Color(255, 147, 41);  // 2700K
    } else {
        // Cool white for day
        return strip.Color(255, 255, 255);  // 6500K
    }
}
```

### Home Assistant Integration

**MQTT Control:**

```yaml
# configuration.yaml
light:
  - platform: mqtt
    name: "Staircase Lights"
    state_topic: "wled/staircase/status"
    command_topic: "wled/staircase/set"
    brightness_state_topic: "wled/staircase/brightness"
    brightness_command_topic: "wled/staircase/brightness/set"
```

**Automation Example:**

```yaml
automation:
  - alias: "Stairs Auto Night Mode"
    trigger:
      - platform: time
        at: "22:00:00"
    action:
      - service: light.turn_on
        target:
          entity_id: light.staircase_lights
        data:
          brightness: 50
          rgb_color: [255, 147, 41]
```

### Manual Override

**Wall Switch Integration:**

```
Physical Switch (GPIO5) ← Pullup to 3.3V
                        ← Normally Open button
                        ← To GND when pressed

Code:
if (buttonPressed) {
    toggleManualMode();
    if (manualMode) {
        turnOnAllSteps(fullBrightness);
    } else {
        resumeAutoMode();
    }
}
```

---

## Troubleshooting

### PIR Not Triggering

**Check:**
1. **Power:**
   - Measure 5V at PIR VCC pin
   - Verify ground connection

2. **Sensitivity:**
   - Adjust sensitivity pot (HC-SR501)
   - Start with maximum sensitivity
   - Reduce if too many false triggers

3. **Placement:**
   - Ensure PIR has clear view of stairs
   - Not blocked by furniture
   - Correct height and angle

4. **Wiring:**
   - Verify GPIO number matches code
   - Check for loose connections
   - Measure PIR output (should be 3.3V when triggered)

5. **Warm-Up:**
   - PIR sensors need 30-60 seconds to stabilize after power-on
   - Wait before testing

### Wrong Direction Detection

**Symptoms:**
- Cascade goes wrong way
- Random direction

**Fixes:**

1. **Timing Too Tight:**
   - Increase detection window
   - Person might trigger both PIRs nearly simultaneously
   - Add hysteresis (delay before accepting second trigger)

2. **PIR Placement:**
   - PIRs too close to stairs (detect too early)
   - Move PIRs farther from first/last step
   - Aim more toward stairs, less toward landing

3. **Code Logic:**
   - Add debouncing
   - Require clear first trigger before second
   - Example: First trigger must be alone for 500ms before second trigger considered

### Cascade Too Fast/Slow

**Adjust Timing:**

```cpp
// Make cascade slower:
#define CASCADE_STEP_DELAY 200  // milliseconds (was 150)

// Make cascade faster:
#define CASCADE_STEP_DELAY 100
```

**Finding Right Speed:**
- Match to walking speed
- Slower for elderly/children
- Faster for running (but discourage running on stairs!)

### Some Steps Don't Light

**Troubleshooting:**

1. **LED Count Wrong:**
   - Verify actual LED count per step
   - Recalculate segment boundaries
   - Test with white on all to verify

2. **Segment Configuration:**
   - Check segment start/stop indices
   - Verify no gaps or overlaps
   - Test each segment individually

3. **Power Issue:**
   - Voltage drop on long run
   - Add power injection
   - Measure voltage at problem steps

4. **Dead LEDs:**
   - One dead LED can break chain (WS2812B)
   - Test by jumping data around suspected dead LED
   - Replace dead LED

### Lights Stay On

**Possible Causes:**

1. **PIR Stuck Active:**
   - PIR sensitivity too high
   - Detecting air flow, pets, etc.
   - Reduce sensitivity
   - Change PIR location

2. **Timer Not Working:**
   - Check timer code
   - Verify timer reset on trigger end
   - Add logging to debug

3. **Continuous Motion:**
   - PIR actually detecting motion (pet, curtain, etc.)
   - Adjust PIR angle
   - Reduce sensitivity

---

## Summary

### Quick Setup Checklist

**Planning:**
- [ ] Count steps
- [ ] Measure step width
- [ ] Calculate total LEDs needed
- [ ] Determine power requirements
- [ ] Plan PIR placement
- [ ] Choose directional vs simple mode

**Hardware:**
- [ ] ESP32 controller
- [ ] PIR sensors (1-2)
- [ ] LED strips (correct length)
- [ ] Power supply (correctly sized)
- [ ] Level shifter
- [ ] Fuses
- [ ] Aluminum channels (optional)
- [ ] Mounting hardware

**Installation:**
- [ ] Mount LEDs under steps
- [ ] Wire data line continuously
- [ ] Add power injection if needed
- [ ] Mount PIR sensors (correct height/angle)
- [ ] Connect all grounds together
- [ ] Test before permanent installation

**Software:**
- [ ] Flash WLED (with Stairway usermod if desired)
- [ ] Configure LED count and type
- [ ] Set up segments (one per step)
- [ ] Configure PIR GPIOs
- [ ] Test basic on/off
- [ ] Fine-tune cascade timing
- [ ] Set auto-off time
- [ ] Test direction detection

**Testing:**
- [ ] Walk up stairs - lights cascade up
- [ ] Walk down stairs - lights cascade down
- [ ] Verify all steps light
- [ ] Check brightness/color
- [ ] Verify auto-off works
- [ ] Test at night (darkness)
- [ ] Verify no false triggers

### Recommended Parts List

**For 14-Step Staircase:**

| Item | Specification | Quantity | Price |
|------|--------------|----------|-------|
| ESP32 DevKit | Standard | 1 | $6 |
| LED Strip | WS2812B 60/m, 16m total | 1 roll | $50 |
| PIR Sensor | HC-SR501 | 2 | $4 |
| Power Supply | 5V 30A | 1 | $25 |
| Level Shifter | 74HCT125 | 1 | $0.50 |
| Aluminum Channel | 1m sections | 16 | $80 |
| Wire | 18 AWG, red/black | 50ft | $15 |
| Fuses | 15A blade fuses | 5 | $2 |
| Fuse Holders | Inline automotive | 2 | $2 |
| Misc | Connectors, mounting hardware | - | $10 |
| **TOTAL** | | | **~$195** |

### Related Guides

- [PIR Sensor Integration](SENSOR_INTEGRATION_GUIDE.md)
- [LED Selection Guide](LED_SELECTION_GUIDE.md)
- [Power Supply Selection](POWER_SUPPLY_SELECTION_GUIDE.md)
- [Level Shifter Guide](LEVEL_SHIFTER_GUIDE.md)

---

**Happy Safe Stair Lighting!** 🪜💡✨
