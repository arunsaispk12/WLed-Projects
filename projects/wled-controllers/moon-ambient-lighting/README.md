# Moon & Ambient Lighting Controller

Intelligent ambient lighting with SK6812 RGBW LEDs, featuring circadian rhythm support, sunrise/sunset simulation, and moon phase effects.

![Build Status](https://img.shields.io/badge/build-ready-brightgreen)
![WLED](https://img.shields.io/badge/WLED-v0.14.x-blue)
![RGBW](https://img.shields.io/badge/LEDs-RGBW-orange)

## Overview

Create the perfect ambiance for any time of day with intelligent lighting that adapts to your circadian rhythm. This project uses SK6812 RGBW LEDs to provide both vibrant colors AND true white light, perfect for dual-purpose lighting that's both functional and beautiful.

## Features

- 🌙 **Moon Phase Simulation** - Display current or custom moon phases
- ☀️ **Circadian Rhythm** - Auto-adjust color temperature by time of day
- 🌅 **Sunrise Simulation** - Gentle wake-up with gradual brightening
- 🌆 **Sunset Mode** - Wind down with warm dimming
- 💡 **True White Light** - Dedicated white LED for reading/tasks
- 🎨 **Color Modes** - Full RGB color control when desired
- 📱 **Smart Control** - Voice assistants, schedules, automation
- 🔍 **Motion Sensing** - Optional PIR sensor integration
- 📊 **Light Sensor** - Auto-brightness based on ambient light
- 💤 **Sleep Timer** - Gradual fade to off

## Why RGBW?

Unlike RGB-only strips that mix red, green, and blue to make "white":

| Feature | RGB White | RGBW White |
|---------|-----------|------------|
| **Color Quality** | Greenish/pinkish tint | Pure white |
| **CRI (Color Rendering)** | 60-70 | 80-90 |
| **Efficiency** | 3 LEDs on | 1 LED on |
| **Power** | Higher | Lower (for white) |
| **Use for Reading** | Poor | Excellent |
| **Mood Lighting** | Excellent | Excellent |

**RGBW = Best of both worlds!**

## Hardware Requirements

### Bill of Materials

| Component | Specification | Quantity | Est. Price | Notes |
|-----------|--------------|----------|------------|-------|
| ESP32 DevKit | ESP32-WROOM-32 | 1 | $6-8 | Main controller |
| LED Strip | SK6812 RGBW 60 LED/m | 2-5m | $12-30/m | True white + RGB |
| Power Supply | 5V 5-10A | 1 | $12-20 | Based on LED count |
| Level Shifter | 74HCT125 | 1 | $0.50 | 3.3V → 5V |
| Resistor | 470Ω | 1 | $0.10 | Data line |
| Capacitor | 1000µF 10V | 1 | $0.50 | Power filtering |
| **Optional Components** | | | | |
| PIR Sensor | HC-SR501 | 1 | $2-3 | Motion detection |
| Light Sensor | BH1750 (I2C) | 1 | $3-4 | Auto-brightness |
| Enclosure | Project box | 1 | $5-10 | Housing |
| **Total** | | | **$40-75** | Depends on length |

### Recommended LED Strip Specs

**SK6812 RGBW:**
- **Density:** 60 LED/m (recommended)
- **White Temperature:**
  - Natural White (4000-4500K) - Most versatile
  - Warm White (3000K) - Cozy/evening
  - Cool White (6000K) - Energizing/daytime
- **IP Rating:** IP20 (indoor) or IP65 (bathroom/humid areas)
- **PCB Color:** White (better light output) or Black (looks better)

### Pin Configuration

| ESP32 Pin | Function | Connected To | Notes |
|-----------|----------|--------------|-------|
| GPIO2 | LED Data | SK6812 Data via level shifter | Main output |
| GPIO4 | PIR Sensor | HC-SR501 OUT (optional) | Motion detect |
| GPIO21 | I2C SDA | BH1750 SDA (optional) | Light sensor |
| GPIO22 | I2C SCL | BH1750 SCL (optional) | Light sensor |
| 5V | PIR Power | HC-SR501 VCC | HC-SR501 needs 4.5V-20V! |
| 3.3V | Sensor Power | BH1750 VCC | I2C sensor power |
| GND | Ground | Common GND | All grounds |
| 5V | LED Power | SK6812 5V | Via power supply |

**WARNING:** HC-SR501 PIR sensor requires **4.5V minimum** — do NOT power from 3.3V!
If using AM312 mini PIR instead, 3.3V is acceptable (AM312 range: 3.3V-12V).

## Wiring Diagram

### Basic Setup (No Sensors)

```
Power Supply (5V 5A)
    │
    ├─── [1000µF Cap] ─── GND
    │
    ├─── SK6812 RGBW Strip 5V
    │
    └─── ESP32 5V (or separate USB)

ESP32                    74HCT125              SK6812 RGBW
┌──────────┐            ┌─────────┐           ┌──────────┐
│          │            │         │           │          │
│  GPIO2  ─┼─[470Ω]────┼─A1   Y1─┼───────────┼─ DI      │
│          │            │         │           │          │
│  GND    ─┼────────────┼─GND     │           │          │
│          │            │         │           │          │
│  5V     ─┼────────────┼─VCC     │           │          │
└──────────┘            └─────────┘           └──────────┘
                            │
                          /OE (Pin 1) to GND

All GND connected: PSU GND, ESP32 GND, LED GND, 74HCT125 GND
```

### Full Setup (With Sensors)

```
ESP32
┌──────────────┐
│              │
│  GPIO2      ─┼───[470Ω]───→ 74HCT125 ───→ LED Data
│              │
│  GPIO4      ─┼───────────→ PIR Sensor OUT
│              │
│  GPIO21 (SDA)┼───────────→ BH1750 SDA (with 4.7kΩ pull-up to 3.3V)
│              │
│  GPIO22 (SCL)┼───────────→ BH1750 SCL (with 4.7kΩ pull-up to 3.3V)
│              │
│  5V         ─┼───────────→ PIR VCC (HC-SR501 needs 4.5V+!)
│  3.3V       ─┼───────────→ BH1750 VCC
│              │
│  GND        ─┼─────Common Ground to all
└──────────────┘
```

## Software Setup

### Option 1: Flash Pre-Built Firmware (Recommended)

```bash
cd projects/wled-controllers/moon-ambient-lighting

# Flash standard build
./build.sh flash moon_basic /dev/ttyUSB0

# Or with sensors
./build.sh flash moon_sensors /dev/ttyUSB0
```

### Option 2: Build from Source

```bash
# Build specific configuration
./build.sh build moon_basic        # Basic RGBW
./build.sh build moon_sensors      # With PIR and light sensor
./build.sh build moon_circadian    # Circadian rhythm optimized

# Flash
./build.sh flash moon_basic /dev/ttyUSB0
```

### Initial Configuration

1. **WiFi Setup**
   - Connect to "WLED-AP" (password: `wled1234`)
   - Configure your WiFi
   - Device restarts

2. **LED Configuration** (Config → LED Preferences)
   - **Length:** Your LED count (e.g., 120 for 2m @ 60 LED/m)
   - **GPIO:** 2
   - **LED Type:** SK6812 RGBW
   - **Color Order:** GRBW (most common, test if wrong)
   - **Maximum Current:** Based on strip length
     - 60 LEDs: 3000mA
     - 120 LEDs: 6000mA
     - 180 LEDs: 9000mA

3. **Time Configuration** (Config → Time & Macros)
   - **Set Timezone:** Your timezone
   - **Enable NTP:** Yes
   - **Latitude/Longitude:** For accurate sunrise/sunset (optional)

4. **Usermod Configuration** (if enabled)
   - **Circadian Rhythm:** Enable auto color temperature
   - **PIR Sensor:** Set GPIO4, timeout duration
   - **Light Sensor:** Set I2C address (0x23 for BH1750)

## Moon Modes & Effects

### 1. Moon Phase Display

Shows current or specific moon phase:

**Phases:**
- 🌑 New Moon - All off or very dim
- 🌒 Waxing Crescent - Partial glow
- 🌓 First Quarter - Half brightness
- 🌔 Waxing Gibbous - Mostly bright
- 🌕 Full Moon - Maximum white
- 🌖 Waning Gibbous - Decreasing
- 🌗 Last Quarter - Half brightness
- 🌘 Waning Crescent - Dim crescent

**Setup:**
```
Preset 1: "Current Moon Phase"
- Effect: Solid
- Color: White only (RGB off)
- Brightness: Auto-calculated based on actual moon phase
- Updates: Daily
```

### 2. Circadian Rhythm Mode

Auto-adjusts color temperature throughout the day:

**Schedule:**
```
6:00 AM  - Warm white (3000K) - Wake up gently
8:00 AM  - Natural white (4000K) - Morning energy
12:00 PM - Cool white (5000K) - Midday focus
4:00 PM  - Natural white (4000K) - Afternoon
7:00 PM  - Warm white (3500K) - Evening wind-down
9:00 PM  - Very warm (2700K) - Relaxation
10:00 PM - Dim warm (2500K) - Sleep prep
```

**Color Temperature Guide:**
- **2500-3000K:** Candlelight, very warm, sleepy
- **3000-3500K:** Warm white, cozy, evening
- **3500-4500K:** Natural white, comfortable, general use
- **4500-5500K:** Cool white, energizing, productivity
- **5500-6500K:** Daylight, alerting, task lighting

### 3. Sunrise Simulation

Gradual brightening to wake naturally:

**30-Minute Sunrise:**
```
Start: Off (0%)
+10min: Dim red-orange (10%) - Deep sunrise
+15min: Orange (25%) - Horizon
+20min: Warm white (50%) - Early morning
+25min: Natural white (75%) - Sunrise
+30min: Bright natural white (100%) - Daytime
```

**Setup:**
- Config → Time & Macros
- Create preset for each stage
- Schedule with 5-minute intervals
- Or use WLED's built-in sunrise feature

### 4. Sunset/Sleep Mode

Wind down for sleep:

**20-Minute Sunset:**
```
Start: Natural white (100%)
+5min: Warm white (75%)
+10min: Very warm (50%)
+15min: Amber (25%)
+20min: Off (0%)
```

### 5. Reading/Task Light

Pure white for functional lighting:

```
Effect: Solid
RGB: 0, 0, 0 (off)
White: 255 (maximum)
Brightness: 80-100%
Temperature: Natural (4000K) or Cool (5000K)
```

### 6. Movie/Gaming Ambient

Subtle backlighting:

```
Effect: Solid or slow color change
RGB: Enabled for colors
White: 0 or 20% for subtle base
Brightness: 20-40%
Colors: Blues, purples, teals
```

## Presets Configuration

### Recommended Presets

**Preset 1: Morning**
```json
{
  "on": true,
  "bri": 180,
  "seg": [{
    "col": [[0,0,0,200]],  // RGB off, white at 200
    "fx": 0
  }]
}
```

**Preset 2: Reading**
```json
{
  "on": true,
  "bri": 230,
  "seg": [{
    "col": [[0,0,0,255]],  // Maximum white
    "fx": 0
  }]
}
```

**Preset 3: Evening Relax**
```json
{
  "on": true,
  "bri": 100,
  "seg": [{
    "col": [[255,100,0,50]],  // Warm orange + dim white
    "fx": 0
  }]
}
```

**Preset 4: Sleep**
```json
{
  "on": true,
  "bri": 20,
  "seg": [{
    "col": [[255,50,0,10]],  // Very warm, very dim
    "fx": 0
  }]
}
```

**Preset 5: Colorful Mood**
```json
{
  "on": true,
  "bri": 150,
  "seg": [{
    "col": [[100,50,200,0]],  // Purple, no white
    "fx": 11,  // Rainbow cycle
    "sx": 50
  }]
}
```

**Preset 6: Full Moon**
```json
{
  "on": true,
  "bri": 255,
  "seg": [{
    "col": [[0,0,0,255]],  // Pure white maximum
    "fx": 0
  }]
}
```

## Assembly Guide

### Step 1: Test Components

**Test ESP32 and Basic WLED:**
```bash
./build.sh flash moon_basic /dev/ttyUSB0
./build.sh monitor
```

**Test SK6812 RGBW Strip:**
- Connect small section (10 LEDs)
- Test each channel:
  - Red (R=255, G=0, B=0, W=0)
  - Green (R=0, G=255, B=0, W=0)
  - Blue (R=0, G=0, B=255, W=0)
  - White (R=0, G=0, B=0, W=255)
- Verify color order (should be GRBW)

### Step 2: Install LED Strip

**Ceiling Cove Lighting:**
1. Clean mounting surface
2. Plan power injection points (every 120 LEDs)
3. Mount aluminum channel (optional but recommended)
4. Install LED strip in channel
5. Add diffuser for smooth light

**Under-Bed Lighting:**
1. Mount strips under bed frame
2. Face LEDs downward for glow effect
3. Secure with clips or adhesive
4. Cable management along frame

**Behind Monitor/TV:**
1. Mount on back of display
2. Follow edges for uniform backlight
3. Leave gap at bottom for cables
4. Secure with strong adhesive

### Step 3: Add Sensors (Optional)

**PIR Motion Sensor:**
1. Mount in location with good view of room
2. Connect VCC to **5V** (HC-SR501 requires 4.5V-20V, do NOT use 3.3V!)
3. Connect OUT to GPIO4 (HC-SR501 output is 3.3V, safe for ESP32)
4. Connect GND to ESP32 GND
5. Adjust sensitivity potentiometer
6. Test detection range

**BH1750 Light Sensor:**
1. Mount where it receives ambient light
2. Connect via I2C (SDA to GPIO21, SCL to GPIO22)
3. Add 4.7kΩ pull-up resistors on both lines
4. Power from 3.3V
5. Test with different light levels

### Step 4: Enclosure

**DIY Enclosure:**
1. Small project box
2. Mount ESP32 with standoffs
3. Drill cable glands for:
   - Power input
   - LED data output
   - Sensor wires (if used)
4. Label all connections
5. Ventilation holes for ESP32

**Placement:**
- Near LED strip start point
- Access to WiFi
- Easy to access for adjustments
- Not visible if possible
- Good ventilation

## Usage Examples

### Bedroom Lighting

**Morning Routine:**
```
6:30 AM - Sunrise starts (automated)
7:00 AM - Full brightness natural white
Evening: Manual control or automated
10:00 PM - Auto-dim to warm white
10:30 PM - Sleep timer starts
```

**Night Light:**
- Very dim warm white (5-10%)
- Motion-activated via PIR
- Auto-off after 5 minutes

### Living Room

**Daytime:**
- Natural white at 60-80%
- Functional lighting

**Movie Time:**
- RGB ambient behind TV
- 20-30% brightness
- Cool blues/purples

**Evening:**
- Warm white gradually dimming
- Follows circadian schedule

### Home Office

**Work Hours:**
- Cool white (5000K) at 80-90%
- Maximizes alertness and focus
- Light sensor auto-adjusts

**Break Time:**
- Natural white at 50%
- Less intense

### Nursery

**Daytime:**
- Soft natural white at 40-60%

**Feeding Time:**
- Warm white at 20%
- Motion-activated

**Sleep:**
- Very dim warm amber
- Or moon phase simulation

## Advanced Features

### Voice Control

**Alexa:**
```
"Alexa, turn on bedroom lights"
"Alexa, set bedroom to 50%"
"Alexa, bedroom warm white"
"Alexa, bedroom sleep mode"
```

**Google Home:**
```
"Hey Google, bedroom reading mode"
"Hey Google, dim bedroom to 30%"
```

### Home Assistant Integration

```yaml
light:
  - platform: wled
    host: 192.168.1.100

automation:
  - alias: "Morning Wake Up"
    trigger:
      platform: time
      at: "06:30:00"
    action:
      service: light.turn_on
      entity_id: light.bedroom_wled
      data:
        brightness: 255
        transition: 1800  # 30 minutes

  - alias: "Evening Wind Down"
    trigger:
      platform: sun
      event: sunset
    action:
      service: light.turn_on
      entity_id: light.bedroom_wled
      data:
        brightness: 100
        kelvin: 2700
```

### Schedules

Create automated daily routines:

**Example Daily Schedule:**
```
06:00 - Preset "Sunrise" (gradual on)
08:00 - Preset "Morning" (natural white 80%)
18:00 - Preset "Evening" (warm white 60%)
22:00 - Preset "Sleep Prep" (warm dim 20%)
23:00 - Off
```

## Troubleshooting

### White Channel Issues

**White doesn't work:**
- Verify LED type set to SK6812 RGBW (not RGB)
- Check color order includes W (GRBW)
- Test with W=255, RGB=0,0,0
- Measure voltage on white LED

**Wrong white temperature:**
- Can't change after purchase (built into LED)
- Buy correct temperature initially:
  - 3000K = Warm
  - 4000K = Natural
  - 6000K = Cool

### Color Order Wrong

**If colors are swapped:**
Try these in order until correct:
- GRBW (most common)
- RGBW
- BRGW
- Other combinations

Test with pure colors to identify.

### Sensors Not Working

**PIR Sensor:**
- Check 3.3V on VCC (measure with multimeter)
- Verify GPIO4 configured
- Adjust sensitivity trimmer
- Test detection range
- Check timeout setting

**Light Sensor:**
- Verify I2C address (0x23 for BH1750)
- Check pull-up resistors (4.7kΩ)
- Test with I2C scanner sketch
- Cover/uncover to test response

### RGBW vs RGB Confusion

**Symptom:** Only 3 of 4 colors work

**Fix:**
1. Config → LED Preferences
2. LED Type: **SK6812 RGBW** (not WS2812B)
3. Color Order: **GRBW**
4. Save & Reboot

## Performance & Power

### Power Consumption

**SK6812 RGBW:**
- RGB at full: ~60mA per LED
- White at full: ~20mA per LED
- RGB + White: ~80mA per LED (don't do this long-term!)

**Examples:**
```
60 LEDs:
- White only: 60 × 20mA = 1.2A
- RGB colors: 60 × 60mA = 3.6A
- Mixed: Calculate based on usage

120 LEDs:
- White only: 2.4A
- RGB colors: 7.2A (need power injection!)
```

**Recommendation:**
- For white lighting: Size for 25mA/LED
- For color effects: Size for 60mA/LED
- Mixed use: Size for 40mA/LED average

### Efficiency

**White Light:**
- RGBW: 20mA (1 LED)
- RGB white: 60mA (3 LEDs)
- **RGBW is 3× more efficient for white!**

## Comparison with RGB-Only

| Feature | SK6812 RGBW | WS2812B RGB |
|---------|-------------|-------------|
| **White Quality** | Excellent | Poor (tinted) |
| **Reading Light** | Yes | No |
| **Task Lighting** | Yes | Limited |
| **Power (white)** | Lower | Higher |
| **Color Effects** | Same | Same |
| **Cost** | +30% | Baseline |
| **Use Case** | Lighting + effects | Effects only |

**When to use RGBW:**
- Need functional white light
- Bedroom/office/kitchen
- Reading areas
- Dual-purpose (task + mood)

**When RGB is OK:**
- Decorative only
- Behind TV/monitor
- Party lights
- Never used as main light

## Safety Notes

⚠️ **LED Brightness:**
- Don't stare directly at full-brightness LEDs
- Use diffuser for comfortable viewing
- Follow 20-20-20 rule if using as desk lamp

⚠️ **Circadian Rhythm:**
- Warm white (2700-3000K) before sleep
- Avoid cool white (>5000K) after 8 PM
- May affect sleep quality

⚠️ **Power:**
- Same safety as other LED projects
- Calculate power correctly
- Use adequate power supply
- Fuse recommended

## Recommended Products

**SK6812 RGBW Strips:**
- BTF-Lighting (Amazon) - Excellent quality
- Alitove - Good quality
- Choose white temperature carefully!

**Sensors:**
- HC-SR501 PIR - Most common, works well
- BH1750 Light Sensor - I2C, accurate
- AM312 PIR - Smaller alternative

**Power Supplies:**
- Mean Well LRS-series
- Alitove branded
- Any quality 5V supply

## Changelog

- v1.0.0 - Initial moon/ambient controller release

## Resources

- [SK6812 RGBW Datasheet](https://cdn-shop.adafruit.com/product-files/2757/p2757_SK6812RGBW_REV01.pdf)
- [BH1750 Light Sensor Library](https://github.com/claws/BH1750)
- [Circadian Rhythm Research](https://www.sleepfoundation.org/bedroom-environment/see-the-light)

## Credits

- WLED by Aircookie
- WLED Usermods by community
- PIR Sensor usermod
- Circadian rhythm automation

## License

MIT License (same as WLED)

---

**Create the perfect ambiance for every moment!** 🌙✨
