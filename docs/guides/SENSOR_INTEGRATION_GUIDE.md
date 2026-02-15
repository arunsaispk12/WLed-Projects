# Sensor Integration Guide

Comprehensive guide to integrating various sensors with WLED controllers for reactive lighting, automation, and advanced features.

## Table of Contents

1. [PIR Motion Sensors](#pir-motion-sensors)
2. [Microwave Radar Sensors](#microwave-radar-sensors)
3. [Light Sensors](#light-sensors)
4. [Microphones](#microphones)
5. [Temperature & Humidity Sensors](#temperature--humidity-sensors)
6. [Distance Sensors](#distance-sensors)
7. [Rotary Encoders](#rotary-encoders)
8. [Multi-Sensor Projects](#multi-sensor-projects)
9. [Troubleshooting](#troubleshooting)

---

## PIR Motion Sensors

### Overview

**PIR = Passive Infrared**
- Detects motion by sensing infrared radiation (body heat)
- No emission, purely passive
- Common for automatic lighting
- Inexpensive and reliable

### Common PIR Modules

#### HC-SR501 (Most Popular)

**Specifications:**
- Voltage: 4.5V - 20V (works with 5V)
- Current: <50µA idle, 3mA active
- Range: 3-7 meters adjustable
- Angle: 110° cone
- Output: 3.3V HIGH when triggered

**Features:**
- Adjustable sensitivity (distance)
- Adjustable time delay (5s - 300s)
- Two trigger modes: L (non-repeatable), H (repeatable)
- Fresnel lens for wider detection

**Pinout:**
```
HC-SR501
┌─────────┐
│    [Lens]│
│         │
│ [Sensitivity]  [Time Delay]
│  Pot            Pot
│                     │
│  VCC  OUT  GND  │
└────────────────┘
```

#### AM312 (Mini PIR)

**Specifications:**
- Voltage: 3.3V - 12V
- Current: <15µA idle
- Range: 3-5 meters
- Angle: 100°
- Size: 15mm × 17mm (tiny!)

**Advantages:**
✅ Very small
✅ Lower power consumption
✅ No adjustments needed
✅ Cleaner looking

**Disadvantages:**
❌ Fixed sensitivity
❌ Fixed delay (~2 seconds)
❌ Shorter range

### Basic PIR Connection

```
PIR Sensor          ESP32
┌─────────┐
│  VCC    │────────── 5V
│  OUT    │────────── GPIO13
│  GND    │────────── GND
└─────────┘
```

**Important Notes:**
- PIR output is usually 3.3V (safe for ESP32)
- Some PIRs output 5V - check datasheet!
- If 5V output, add voltage divider or use level shifter

### PIR Configuration for WLED

**In WLED Settings:**

1. **Enable PIR Sensor:**
   - Settings → LED Preferences → Button 0 GPIO: 13
   - Or use dedicated PIR GPIO in usermod

2. **Usermod Recommendations:**
   - Multi Relay Usermod (can trigger on motion)
   - Stairway Wled Usermod (designed for PIR)
   - Create custom usermod for advanced features

### Advanced PIR Setup

#### Multiple PIR Sensors

**For Multiple Detection Zones:**

```
ESP32
  │
  ├─ GPIO13 ──── PIR 1 (entrance)
  ├─ GPIO14 ──── PIR 2 (hallway)
  └─ GPIO27 ──── PIR 3 (room)
```

**WARNING:** Do NOT use GPIO15 for sensors — it is a boot strapping
pin (must be LOW at boot). GPIO6-11 are also reserved (flash memory).
See "Avoid These Pins" section below for full list.

**Use Case:**
- Stairway lighting (top and bottom sensors)
- Large room coverage
- Directional detection

#### PIR with Relay

**For High-Power Switching:**

```
PIR OUT ──── ESP32 GPIO13 ──── Relay IN ──── Main Lights
                │
            [WLED Logic]
```

### PIR Best Practices

**Mounting:**
- Height: 2-2.5 meters for room coverage
- Angle: Slight downward tilt
- Avoid: Direct sunlight, heaters, AC vents
- Position: Corner gives widest coverage

**Sensitivity Adjustment (HC-SR501):**
- Turn clockwise = more sensitive (longer range)
- Turn counter-clockwise = less sensitive
- Start low, increase until desired range

**Time Delay Adjustment (HC-SR501):**
- Minimum: ~5 seconds
- Maximum: ~5 minutes
- For WLED: Set to minimum, control timing in software

**Trigger Mode Jumper:**
- **L (Non-Repeatable):** Output goes LOW after delay, even if motion continues
  - Use for: Entry detection, single trigger events
- **H (Repeatable):** Output stays HIGH while motion detected
  - Use for: Continuous presence, occupancy detection

### PIR Wiring Diagram (Complete)

```
                5V Power Supply
                      │
                      ├──────────── PIR VCC
                      ├──────────── ESP32 5V
                      │
HC-SR501              │              ESP32
┌─────────┐           │           ┌─────────┐
│  VCC    │───────────┤           │         │
│         │                       │         │
│  OUT    │───────────────────────│ GPIO13  │
│         │                       │         │
│  GND    │───────┬───────────────│ GND     │
└─────────┘       │               └─────────┘
                  │
                 GND
```

---

## Microwave Radar Sensors

### RCWL-0516 Doppler Radar Sensor

**Advantages over PIR:**
✅ Detects through walls/glass/plastic
✅ Not affected by temperature
✅ More sensitive to movement
✅ No warm-up time

**Disadvantages:**
❌ Can trigger through walls (too sensitive)
❌ More expensive than PIR
❌ Can interfere with WiFi

**Specifications:**
- Voltage: 4-28V
- Detection Range: 5-7 meters
- Angle: 360°
- Output: 3.3V for 2-3 seconds

### Pinout

```
RCWL-0516
┌───────────┐
│   VIN     │──── 5V
│   OUT     │──── ESP32 GPIO13
│   GND     │──── GND
│   CDS     │──── LDR (optional, light sensing)
└───────────┘
```

### Connection

**Basic Setup:**
```
RCWL-0516         ESP32
  VIN ────────── 5V
  OUT ────────── GPIO13
  GND ────────── GND
```

**With Light Sensing (CDS pin):**
```
RCWL-0516         LDR (Light Dependent Resistor)
  CDS ──────┬──── LDR ──── GND
            │
          [10kΩ to VIN]

Function: Only triggers in darkness
```

### Use Cases

**Better Than PIR For:**
- Behind-wall detection
- Through-cabinet lighting
- Under-desk lighting
- Detecting in very cold environments

**Worse Than PIR For:**
- Close-range detection
- Precise area control
- RF-sensitive environments
- Multi-unit installations (interference)

---

## Light Sensors

### LDR (Light Dependent Resistor)

**Simplest Light Sensor:**

#### Circuit

```
ESP32
  │
  │        ┌── VCC (3.3V)
  │        │
GPIO34 ────┤
(ADC)      │
  │      [LDR]
  │        │
  │      [10kΩ]
  │        │
 GND ──────┴
```

**How It Works:**
- LDR resistance decreases with light
- Voltage divider creates variable voltage
- ESP32 ADC reads voltage (0-3.3V)
- Software interprets as light level

**Reading in Code:**
```cpp
int lightLevel = analogRead(34);  // 0-4095
int brightness = map(lightLevel, 0, 4095, 0, 255);
```

**Use Cases:**
- Auto-brightness adjustment
- Day/night detection
- Sunrise/sunset triggers

### BH1750 Digital Light Sensor

**I2C Digital Sensor:**

**Advantages over LDR:**
✅ Accurate lux measurement
✅ I2C communication (no ADC needed)
✅ Wide range (1-65535 lux)
✅ Calibrated
✅ Low power

**Specifications:**
- Voltage: 3.3V or 5V
- Interface: I2C
- Range: 1 - 65,535 lux
- Accuracy: ±20%

#### Pinout

```
BH1750
┌─────────┐
│  VCC    │──── 3.3V or 5V
│  GND    │──── GND
│  SCL    │──── ESP32 GPIO22 (I2C Clock)
│  SDA    │──── ESP32 GPIO21 (I2C Data)
│  ADDR   │──── GND (I2C address 0x23) or VCC (0x5C)
└─────────┘
```

#### Connection

```
BH1750            ESP32
  VCC ────────── 3.3V
  GND ────────── GND
  SCL ────────── GPIO22
  SDA ────────── GPIO21
```

**I2C Pull-ups:**
- Some modules have built-in pull-ups
- If not, add 4.7kΩ pull-ups to SDA and SCL

#### Code Example

```cpp
#include <BH1750.h>
#include <Wire.h>

BH1750 lightMeter;

void setup() {
  Wire.begin(21, 22); // SDA, SCL
  lightMeter.begin();
}

void loop() {
  float lux = lightMeter.readLightLevel();
  // Adjust WLED brightness based on lux
}
```

### TSL2561 (Alternative)

**Similar to BH1750:**
- I2C interface
- More expensive
- Better IR rejection
- 0.1 to 40,000 lux

---

## Microphones

### Analog Microphone (MAX4466, MAX9814)

**For Sound Reactive Lighting:**

#### MAX4466 (Simple)

```
MAX4466           ESP32
  VCC ────────── 3.3V
  GND ────────── GND
  OUT ────────── GPIO36 (ADC)
```

**Reading:**
```cpp
int soundLevel = analogRead(36);  // 0-4095
// Process for beat detection, VU meter, etc.
```

**Gain Adjustment:**
- Potentiometer on module
- Turn clockwise = more sensitive
- Adjust for room volume

### I2S Digital Microphone (INMP441, ICS-43434)

**Professional Sound Reactive:**

**Advantages:**
✅ Digital signal (no noise)
✅ Better quality
✅ 24-bit audio
✅ No gain adjustment needed
✅ Designed for WLED sound reactive

#### INMP441 Pinout

```
INMP441           ESP32
  VDD ────────── 3.3V
  GND ────────── GND
  SCK ────────── GPIO32 (I2S Bit Clock)
  WS  ────────── GPIO25 (I2S Word Select)
  SD  ────────── GPIO33 (I2S Serial Data)
  L/R ────────── GND (left channel)
```

**WARNING:** Do NOT use GPIO14/GPIO15 for I2S — GPIO15 is a boot
strapping pin and can cause boot failures. The pin assignments above
match the sound-reactive-controller project and HARDWARE_GUIDE.md.

#### Complete Connection

```
INMP441                ESP32
┌─────────┐         ┌─────────┐
│  VDD    │─────────│ 3.3V    │
│  GND    │─────────│ GND     │
│  SCK    │─────────│ GPIO32  │
│  WS     │─────────│ GPIO25  │
│  SD     │─────────│ GPIO33  │
│  L/R    │─────────│ GND     │
└─────────┘         └─────────┘
```

**L/R Pin:**
- GND = Left channel
- VCC = Right channel
- Use Left (GND) for mono

#### WLED Configuration

**For Sound Reactive WLED:**

1. Flash sound-reactive firmware
2. Settings → Sound Settings:
   - I2S SD: GPIO33
   - I2S WS: GPIO25
   - I2S SCK: GPIO32
   - Microphone Type: INMP441

3. Effects → Enable sound-reactive effects

### Microphone Placement

**Best Results:**
- Away from ESP32/LED strip (EMI noise)
- Facing sound source
- Enclosed in small box (reduces noise)
- 1-2 meters from speaker for music
- Close to person for voice activation

---

## Temperature & Humidity Sensors

### DHT22 (AM2302)

**Common Digital Sensor:**

**Specifications:**
- Temperature: -40°C to +80°C (±0.5°C)
- Humidity: 0-100% (±2%)
- Interface: 1-Wire (not I2C!)
- Voltage: 3.3V - 5V

#### Pinout (4-pin version)

```
DHT22
┌─────────┐
│  VCC    │──── 3.3V or 5V
│  DATA   │──── ESP32 GPIO4
│  NULL   │──── (not connected)
│  GND    │──── GND
└─────────┘
```

#### Connection

```
DHT22             ESP32
  VCC ────────── 3.3V
  DATA ──┬────── GPIO4
         │
      [10kΩ pull-up to VCC]
         │
  GND ────────── GND
```

**Pull-up Resistor:**
- 10kΩ between DATA and VCC
- Some modules have built-in pull-up
- Check module documentation

#### Code Example

```cpp
#include <DHT.h>

#define DHTPIN 4
#define DHTTYPE DHT22

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  dht.begin();
}

void loop() {
  float temp = dht.readTemperature();  // Celsius
  float humidity = dht.readHumidity();

  // Use for color changes, fan control, etc.
}
```

### BME280 (I2C Temperature/Humidity/Pressure)

**Premium Sensor:**

**Advantages:**
✅ More accurate than DHT22
✅ Faster response
✅ I2C interface (standard)
✅ Also measures pressure
✅ Lower power

**Specifications:**
- Temperature: -40°C to +85°C (±1°C)
- Humidity: 0-100% (±3%)
- Pressure: 300-1100 hPa
- Interface: I2C or SPI

#### Pinout

```
BME280
┌─────────┐
│  VCC    │──── 3.3V
│  GND    │──── GND
│  SCL    │──── ESP32 GPIO22
│  SDA    │──── ESP32 GPIO21
└─────────┘
```

#### Connection

```
BME280            ESP32
  VCC ────────── 3.3V
  GND ────────── GND
  SCL ────────── GPIO22 (I2C SCL)
  SDA ────────── GPIO21 (I2C SDA)
```

### DS18B20 (1-Wire Digital Temperature)

**Waterproof Probe Available:**

**Specifications:**
- Temperature: -55°C to +125°C (±0.5°C)
- Interface: 1-Wire
- Waterproof versions available
- Multiple sensors on one wire!

#### Pinout

```
DS18B20
┌─────────┐
│  VCC    │──── 3.3V or 5V
│  DATA   │──── ESP32 GPIO4
│  GND    │──── GND
└─────────┘
```

#### Connection

```
DS18B20           ESP32
  VCC ────────── 3.3V
  DATA ──┬────── GPIO4
         │
      [4.7kΩ pull-up to VCC]
         │
  GND ────────── GND
```

**Multiple Sensors:**
```
ESP32 GPIO4 ──┬── DS18B20 #1 DATA
              ├── DS18B20 #2 DATA
              ├── DS18B20 #3 DATA
              └── [4.7kΩ to VCC]

All VCC together
All GND together
```

### Use Cases for Temperature Sensors

**WLED Integration:**
- Color shifts based on temperature
- Fan control triggers
- Overheat protection
- Seasonal effects (cooler colors in summer)
- Data logging

---

## Distance Sensors

### HC-SR04 Ultrasonic Sensor

**Common Distance Sensor:**

**Specifications:**
- Range: 2cm - 400cm
- Accuracy: ±3mm
- Voltage: 5V
- Trigger: 10µs pulse
- Echo: Returns distance as pulse width

#### Pinout

```
HC-SR04
┌───────────┐
│   VCC     │──── 5V
│   TRIG    │──── ESP32 GPIO5
│   ECHO    │──── ESP32 GPIO18 (through voltage divider!)
│   GND     │──── GND
└───────────┘
```

#### Connection with Voltage Divider

```
HC-SR04           Voltage Divider        ESP32
  VCC ────────── 5V
  TRIG ─────────────────────────────── GPIO5

  ECHO ────┬──────────────────────────── GPIO18
           │
         [1kΩ]
           │
           ├───────────────────────────── GPIO18
           │
         [2kΩ]
           │
          GND

  GND ────────── GND
```

**Why Voltage Divider:**
- HC-SR04 ECHO outputs 5V
- ESP32 max input = 3.3V
- 1kΩ + 2kΩ divider = 3.3V output
- Protects ESP32

#### Simpler Alternative: VL53L0X (I2C)

**Advantages:**
✅ I2C interface (no voltage divider)
✅ More accurate
✅ Smaller
✅ 3.3V compatible

```
VL53L0X           ESP32
  VCC ────────── 3.3V
  GND ────────── GND
  SCL ────────── GPIO22
  SDA ────────── GPIO21
```

### Use Cases

**WLED Applications:**
- Hand gesture control (wave to change)
- Proximity-based brightness
- Interactive installations
- People counting
- Parking sensors with LED feedback

---

## Rotary Encoders

### KY-040 Rotary Encoder

**For Manual Control:**

**Features:**
- Rotation detection (clockwise/counter-clockwise)
- Push button
- Infinite rotation

#### Pinout

```
KY-040
┌─────────┐
│  CLK    │──── ESP32 GPIO16 (A phase)
│  DT     │──── ESP32 GPIO17 (B phase)
│  SW     │──── ESP32 GPIO5  (switch)
│  +      │──── 3.3V
│  GND    │──── GND
└─────────┘
```

#### Connection

```
KY-040            ESP32
  CLK ────────── GPIO16
  DT  ────────── GPIO17
  SW  ───┬────── GPIO5
         │
      [10kΩ pull-up to 3.3V]
         │
  +   ────────── 3.3V
  GND ────────── GND
```

**Debouncing:**
- Add 0.1µF capacitor across CLK and GND
- Add 0.1µF capacitor across DT and GND
- Reduces false triggers

### WLED Integration

**Use For:**
- Brightness adjustment
- Effect selection
- Speed control
- Manual override

**Wiring for WLED:**
- Use Button GPIO for encoder pins
- Requires custom usermod or code
- Very useful for non-WiFi control

---

## Multi-Sensor Projects

### Example: Complete Smart Lighting

**Sensors Used:**
- PIR (motion detection)
- BH1750 (ambient light)
- DHT22 (temperature)
- Rotary encoder (manual control)

#### Wiring Diagram

```
ESP32 GPIO Map:
  GPIO13 ── PIR Motion OUT
  GPIO21 ── I2C SDA (BH1750, DHT22 if I2C version)
  GPIO22 ── I2C SCL (BH1750, DHT22 if I2C version)
  GPIO4  ── DHT22 DATA (if 1-wire version)
  GPIO16 ── Rotary Encoder CLK
  GPIO17 ── Rotary Encoder DT
  GPIO5  ── Rotary Encoder SW
  GPIO2  ── LED Data (through level shifter)
```

#### Logic Flow

```
1. BH1750 detects ambient light level
   ↓
2. If dark + PIR triggered
   ↓
3. Turn on LEDs with brightness based on:
   - Time of day (from RTC or NTP)
   - Temperature (cooler = blue, warmer = orange)
   - Manual override (rotary encoder)
   ↓
4. Maintain until:
   - No motion for X minutes
   - Light level increases (daylight)
   - Manual off (encoder button)
```

---

## Troubleshooting

### Sensor Not Detected

**Check:**
1. **Power:**
   - Measure voltage at sensor VCC pin
   - Should match sensor requirement (3.3V or 5V)

2. **Connections:**
   - Verify wiring matches pinout
   - Check for loose wires
   - Measure continuity

3. **I2C Sensors:**
   - Scan I2C bus (use I2C scanner sketch)
   - Check pull-up resistors (4.7kΩ on SDA and SCL)
   - Try different I2C address if configurable

4. **Pin Conflicts:**
   - Ensure GPIO not used by other function
   - Avoid using boot/strapping pins

### Erratic Sensor Readings

**Causes:**

1. **Noise:**
   - Add 0.1µF bypass capacitor at sensor VCC
   - Keep sensor wires away from LED data/power wires
   - Use twisted pair or shielded cable

2. **Power Issues:**
   - Sensor shares power with noisy loads
   - Add separate regulator for sensors
   - Increase power supply capacitance

3. **Interference:**
   - EMI from WiFi/LED strip affects sensor
   - Shield sensor or relocate
   - Add ferrite bead on sensor power

### PIR False Triggers

**Solutions:**

1. **Reduce Sensitivity:**
   - Turn sensitivity pot counter-clockwise
   - Reduce detection range

2. **Improve Placement:**
   - Avoid heat sources (heaters, AC, sunlight)
   - Mount higher (2-2.5m)
   - Angle away from windows

3. **Add Delay:**
   - Increase time delay on HC-SR501
   - Implement software debouncing
   - Require multiple triggers before action

### Microphone No Sound Detection

**Check:**

1. **Gain Setting:**
   - Increase gain (turn pot clockwise)
   - Test with loud sound nearby

2. **Wiring:**
   - Verify ADC pin (GPIO36, 39, 34, 35 on ESP32)
   - Check ground connection

3. **Code:**
   - Verify analogRead() on correct pin
   - Check sampling rate
   - Test with serial output of values

4. **Placement:**
   - Move away from ESP32 (EMI)
   - Face toward sound source
   - Reduce distance to sound

---

## Best Practices

### Power Management

✅ **Separate Power for Sensors:**
- Use dedicated 3.3V regulator
- Reduces noise from LED switching
- More stable readings

✅ **Bypass Capacitors:**
- 0.1µF ceramic at each sensor VCC
- Close to sensor
- Reduces voltage spikes

### Wiring

✅ **Keep Sensor Wires Short:**
- Minimize noise pickup
- Better signal integrity
- Especially important for analog sensors

✅ **Twist Pairs:**
- Twist VCC and GND together
- Twist signal and GND for single-ended signals
- Reduces EMI

✅ **Shield When Needed:**
- Long wire runs (>1 meter)
- Noisy environments
- Analog sensors

### Software

✅ **Debouncing:**
- Implement software debouncing for switches
- Filter sensor readings (moving average)
- Ignore rapid changes

✅ **Validation:**
- Check sensor readings for plausibility
- Reject out-of-range values
- Implement timeouts for unresponsive sensors

✅ **Fallback:**
- Continue operation if sensor fails
- Use last-known-good value
- Alert user to sensor failure

---

## Summary

### Sensor Selection Guide

| Application | Recommended Sensor | Alternative |
|-------------|-------------------|-------------|
| **Motion Detection** | HC-SR501 PIR | RCWL-0516 Radar |
| **Light Level** | BH1750 I2C | LDR + resistor |
| **Sound Reactive** | INMP441 I2S | MAX4466 analog |
| **Temperature** | DS18B20 1-Wire | DHT22, BME280 |
| **Humidity** | BME280 I2C | DHT22 |
| **Distance** | VL53L0X I2C | HC-SR04 ultrasonic |
| **Manual Control** | Rotary Encoder | Buttons |

### Quick Reference: Common Pins

**ESP32 Standard Pins:**
- **I2C:** GPIO21 (SDA), GPIO22 (SCL)
- **ADC:** GPIO36, GPIO39, GPIO34, GPIO35
- **Digital Input:** Any GPIO except strapping pins
- **PIR:** GPIO13 (recommended)
- **Encoder:** GPIO16, GPIO17

**Avoid These Pins (Strapping/Reserved):**
- GPIO0: Boot button (strapping pin)
- GPIO2: Often used for LED data (strapping pin, must be LOW or floating at boot)
- GPIO6-11: Connected to internal flash (DO NOT USE — will crash ESP32)
- GPIO12: Boot fail if pulled HIGH (strapping pin — selects flash voltage)
- GPIO15: Boot strapping pin (must be LOW at boot, controls debug output)

**Safe GPIO for sensors:** GPIO4, GPIO13, GPIO14, GPIO16, GPIO17, GPIO25-27, GPIO32-35

### Related Guides

- [Staircase Lighting Guide](STAIRCASE_LIGHTING_GUIDE.md) - PIR for stairs
- [Optional Components Guide](OPTIONAL_COMPONENTS_GUIDE.md) - Buttons, displays
- [Level Shifter Guide](LEVEL_SHIFTER_GUIDE.md) - 5V sensor interfacing

---

Happy sensing! 🔍💡
