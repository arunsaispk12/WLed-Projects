# Level Shifter Guide

Comprehensive guide to using level shifters with WLED controllers, ensuring reliable data transmission from ESP32 (3.3V) to LED strips (5V).

## Table of Contents

1. [Why Level Shifting is Needed](#why-level-shifting-is-needed)
2. [Level Shifter Types](#level-shifter-types)
3. [74HCT125 - Recommended](#74hct125---recommended)
4. [74AHCT125 - High Speed](#74ahct125---high-speed)
5. [MOSFET Level Shifter](#mosfet-level-shifter)
6. [Bi-Directional Level Shifters](#bi-directional-level-shifters)
7. [No Level Shifter (Direct Connection)](#no-level-shifter-direct-connection)
8. [Troubleshooting](#troubleshooting)
9. [Best Practices](#best-practices)

---

## Why Level Shifting is Needed

### The Voltage Mismatch Problem

**ESP32 Output:**
- Logic HIGH: 3.3V
- Logic LOW: 0V

**WS2812B/WS2811 LED Input (5V powered):**
- Required HIGH: 0.7 × VDD = 3.5V minimum (when powered at 5V)
- Required LOW: 0.3 × VDD = 1.5V maximum

**The Issue:**
```
ESP32 outputs 3.3V HIGH
LED needs 3.5V HIGH minimum (at 5V power)
3.3V < 3.5V = Unreliable data transmission!
```

### Symptoms of Missing/Bad Level Shifter

❌ **Random Colors**: LEDs show incorrect colors
❌ **Flickering**: LEDs flicker randomly
❌ **No Response**: First few LEDs work, rest don't
❌ **Intermittent Operation**: Works sometimes, not others
❌ **Temperature Dependent**: Works when cold, fails when warm
❌ **Distance Dependent**: Works with short wires, fails with long

### When Level Shifting is Critical

**Definitely Needed:**
- LEDs powered at 5V
- Data wire > 6 inches (15cm)
- More than 50 LEDs
- Permanent installations
- Outdoor installations
- Professional projects

**Might Work Without (but not recommended):**
- Very short data wire (<3 inches)
- Few LEDs (<10)
- Temporary testing
- LEDs powered at 4.5V or lower

**Best Practice:** Always use level shifter for reliable operation!

---

## Level Shifter Types

### Quick Comparison

| Type | Speed | Reliability | Cost | Complexity | Recommended |
|------|-------|-------------|------|------------|-------------|
| **74HCT125** | Fast | ⭐⭐⭐⭐⭐ | $0.50 | Easy | ✅ Yes |
| **74AHCT125** | Faster | ⭐⭐⭐⭐⭐ | $0.60 | Easy | ✅ Yes |
| **SN74HCT245** | Fast | ⭐⭐⭐⭐⭐ | $0.70 | Easy | ✅ Yes |
| **BSS138 MOSFET** | Medium | ⭐⭐⭐⭐ | $0.30 | Medium | ⚠️ OK |
| **CD4050** | Slow | ⭐⭐⭐ | $0.40 | Easy | ⚠️ OK |
| **Bi-Directional** | Slow | ⭐⭐ | $2-5 | Easy | ❌ No |
| **Diode + Resistor** | Fast | ⭐⭐ | $0.10 | Easy | ⚠️ Hack only |

---

## 74HCT125 - Recommended

### Overview

**The Best Choice for WLED Projects**

- Quad buffer with 3-state outputs
- 3.3V input compatible
- 5V output capable
- Fast propagation delay (10ns)
- Very reliable
- Cheap and widely available

### Pinout Diagram

```
        74HCT125 (Top View)
     ┌────────────┐
 1/OE│1        14│ VCC (5V)
  1A │2        13│ 4/OE
  1Y │3        12│ 4A
 2/OE│4        11│ 4Y
  2A │5        10│ 3/OE
  2Y │6         9│ 3A
 GND │7         8│ 3Y
     └────────────┘

Pin Functions (active channel 1 shown):
- Pin 1 (1/OE): Output Enable for channel 1 (active LOW → tie to GND to enable)
- Pin 2 (1A):   Input for channel 1 (3.3V signal from ESP32)
- Pin 3 (1Y):   Output for channel 1 (5V signal to LEDs)
- Pin 7 (GND):  Ground
- Pin 14 (VCC): 5V power (MUST be 5V, NOT 3.3V)

All 4 channels follow same pattern:
- /OE pins: 1, 4, 10, 13 (active LOW — tie to GND to enable)
- Input (A) pins: 2, 5, 9, 12
- Output (Y) pins: 3, 6, 8, 11
```

### Basic Connection (Single LED Strip)

```
ESP32                74HCT125                   LED Strip
                   ┌────────────┐
                   │Pin1 (1/OE) │──── GND (enable output)
GPIO2 ─────────────│Pin2 (1A)   │              (Input)
                   │Pin3 (1Y)   │──────────── DI (Data In)
                   │            │
5V PSU ────────────│Pin14 (VCC) │              (MUST be 5V!)
GND ───────────────│Pin7  (GND) │
                   └────────────┘

5V PSU ────────────────────────────────── LED 5V
GND ───────────────────────────────────── LED GND
ESP32 GND, 74HCT125 GND, LED GND ─────── All connected together
```

### Detailed Wiring

**Step-by-Step:**

1. **Power the 74HCT125:**
   - Pin 14 (VCC) → **5V** power supply (MUST be 5V, NOT 3.3V!)
   - Pin 7 (GND) → Ground

2. **Enable the Output:**
   - Pin 1 (1/OE) → Ground (enables output 1Y, active LOW)

3. **Connect ESP32 to Input:**
   - ESP32 GPIO2 → Pin 2 (1A) — this is the data input
   - Can use any of 4 input channels: Pin 2 (1A), Pin 5 (2A), Pin 9 (3A), Pin 12 (4A)

4. **Connect Output to LED Strip:**
   - Pin 3 (1Y) → LED strip Data In (DI)

5. **Common Ground:**
   - ESP32 GND, 74HCT125 GND, LED GND → All connected together

### Multiple LED Outputs

**For Multi-Channel Controller:**

```
ESP32                74HCT125                  LED Strips
                   ┌──────────────────┐
GND ───────────────│Pin1  (1/OE)      │  (enable ch1)
GPIO2 ─────────────│Pin2  (1A)  Pin3  (1Y)│──── Strip 1 DI
GND ───────────────│Pin4  (2/OE)      │  (enable ch2)
GPIO4 ─────────────│Pin5  (2A)  Pin6  (2Y)│──── Strip 2 DI
                   │Pin7  (GND)       │
                   │Pin8  (3Y)────────│──── Strip 3 DI
GPIO16 ────────────│Pin9  (3A)        │
GND ───────────────│Pin10 (3/OE)      │  (enable ch3)
                   │Pin11 (4Y)────────│──── Strip 4 DI
GPIO17 ────────────│Pin12 (4A)        │
GND ───────────────│Pin13 (4/OE)      │  (enable ch4)
5V ────────────────│Pin14 (VCC)       │  (MUST be 5V!)
                   └──────────────────┘

/OE pins (1, 4, 10, 13) → all to GND (enable all outputs)
```

**Benefits:**
- One IC handles 4 LED strips
- Clean, simple design
- Very reliable

### With Current Limiting Resistor

**Recommended Setup:**

```
ESP32            74HCT125                    LED Strip
              ┌────────────┐
GPIO2 ─[470Ω]─│Pin2 (1A)  Pin3 (1Y)│────── DI
              │                      │
              │Pin1 (1/OE) → GND    │
              │Pin14 (VCC) → 5V     │
              │Pin7  (GND) → GND    │
              └────────────┘
```

**Resistor Placement: Between ESP32 GPIO and 74HCT125 input (Pin 2)**
- 220Ω - 470Ω typical
- Place on the INPUT side, NOT the output side
- Protects ESP32 GPIO pin from overcurrent
- Reduces signal reflections on the data line

**Why 470Ω?**
- Limits current if short circuit occurs
- Doesn't significantly slow signal
- Good balance of protection and performance
- 74HCT125 input is high-impedance, so 470Ω has no effect on signal level

### Decoupling Capacitor

**Important for Reliability:**

```
        74HCT125
      ┌────────────┐
5V────│VCC     GND│────GND
      └────────────┘
        │        │
       [0.1µF ceramic capacitor]
```

**Always add:**
- 0.1µF ceramic capacitor
- Between VCC and GND
- As close to IC as possible
- Reduces noise and improves reliability

### Complete Schematic

```
                                  LED Strip Power
                                       ↓
                                      5V
                                       │
                  ┌────────────┐       │
ESP32             │  74HCT125  │       │
  │               │            │       │
  │          ┌────│Pin1 (1/OE) │       │
  │          │    │            │       │
GPIO2 ─[470Ω]────│Pin2 (1A)   │       │
  │               │            │       │
  │          ┌────│Pin3 (1Y)───│───────DI
  │          │    │            │
  │    ┌─────│────│Pin14 (VCC) │
  │    │     │    │            │
  │    5V    │ ┌──│Pin7  (GND) │
  │          │ │  └────────────┘
  │          │ │       │
GND──────────┴─┴───────┴──────────────GND
                │
             [0.1µF] (between Pin14 VCC and Pin7 GND)

IMPORTANT: VCC (Pin 14) MUST connect to 5V, NOT 3.3V!
```

### PCB Layout Tips

**Trace Routing:**
1. Keep input traces short
2. Keep output traces short
3. Wide power traces (VCC, GND)
4. Decoupling cap close to VCC pin
5. Don't route signals under IC if possible

**Ground Plane:**
- Use solid ground plane
- Connect all grounds together
- Multiple vias for low impedance

---

## 74AHCT125 - High Speed

### When to Use

The 74AHCT125 is nearly identical to 74HCT125 but faster:

**Differences:**
- Faster propagation delay (7ns vs 10ns)
- Better for very long LED strips (500+)
- Better for high-speed protocols
- Slightly more expensive

**Use 74AHCT125 When:**
- More than 300 LEDs
- Data wire > 10 feet
- Using APA102/SK9822 (clock-based)
- Want maximum reliability

**Pinout:** Identical to 74HCT125
**Wiring:** Identical to 74HCT125

**Part Numbers:**
- 74AHCT125D (SO-14)
- 74AHCT125N (DIP-14)
- SN74AHCT125N (Texas Instruments)

---

## SN74HCT245 - Octal Buffer

### Overview

**For Multi-Channel Projects (8+ outputs):**

- 8-bit bus transceiver
- Can handle 8 LED strips with one IC
- 3.3V input compatible
- Fast and reliable

### Pinout

```
        SN74HCT245 (Top View)
     ┌────────────┐
 DIR │1        20│ VCC (5V)
  A1 │2        19│ B1
  A2 │3        18│ B2
  A3 │4        17│ B3
  A4 │5        16│ B4
  A5 │6        15│ B5
  A6 │7        14│ B6
  A7 │8        13│ B7
  A8 │9        12│ B8
 GND │10       11│ /OE
     └────────────┘

Pin Functions:
- A1-A8 (Pins 2-9):   Input side (3.3V from ESP32)
- B1-B8 (Pins 19-12): Output side (5V to LEDs)
- DIR (Pin 1):         Direction — HIGH = A→B, LOW = B→A
- /OE (Pin 11):        Output Enable (active LOW → tie to GND)
- VCC (Pin 20):        5V power (MUST be 5V!)
- GND (Pin 10):        Ground
```

### Connection for WLED

```
ESP32            SN74HCT245           LED Strips
              ┌────────────┐
GPIO2  ───────│A1 (Pin2)   B1 (Pin19)│──── Strip 1
GPIO4  ───────│A2 (Pin3)   B2 (Pin18)│──── Strip 2
GPIO16 ───────│A3 (Pin4)   B3 (Pin17)│──── Strip 3
GPIO17 ───────│A4 (Pin5)   B4 (Pin16)│──── Strip 4
GPIO25 ───────│A5 (Pin6)   B5 (Pin15)│──── Strip 5
GPIO26 ───────│A6 (Pin7)   B6 (Pin14)│──── Strip 6
GPIO27 ───────│A7 (Pin8)   B7 (Pin13)│──── Strip 7
GPIO32 ───────│A8 (Pin9)   B8 (Pin12)│──── Strip 8
              │                       │
5V ───────────│VCC (Pin20)            │
GND ──────────│GND (Pin10)            │
5V ───────────│DIR (Pin1)             │  ← MUST be HIGH for A→B!
GND ──────────│/OE (Pin11)            │  ← GND to enable outputs
              └────────────┘
```

**DIR Pin (Pin 1):** Direction control
- **HIGH (5V) = A→B** (ESP32 to LEDs) ← CORRECT for level shifting
- LOW (GND) = B→A (wrong direction!)

**/OE Pin (Pin 11):** Output Enable (active LOW)
- Tied to GND (always enabled)

---

## MOSFET Level Shifter

### BSS138 MOSFET Circuit

**Bidirectional Level Shifter using N-Channel MOSFET:**

```
          BSS138 N-MOSFET (Bidirectional Level Shifter)

3.3V ─[10kΩ]─┬───────────────┬─[10kΩ]─ 5V
              │               │
         Low Side         High Side
        (Source)          (Drain)
              │               │
              │   ┌───────┐   │
              └───│S     D│───┘
                  │ BSS138│
              ┌───│G      │
              │   └───────┘
             3.3V (Gate tied to LOW voltage rail)
```

### Complete Schematic

```
                    BSS138
3.3V ──[10kΩ]──┬──(Source)──────(Drain)──┬──[10kΩ]── 5V
               │                         │
ESP32 GPIO2 ───┘                         └─── LED Strip DI
                    │
               (Gate) ── 3.3V

Common GND: ESP32 GND ── LED Strip GND
```

### How It Works

The BSS138 is wired as a **bidirectional** open-drain level shifter.
The Gate is tied to the LOW voltage rail (3.3V).

1. **ESP32 drives LOW (0V):**
   - Source goes to 0V
   - VGS = 3.3V - 0V = 3.3V > Vth → MOSFET turns ON
   - Drain pulled LOW through MOSFET
   - Output = 0V (LOW) ✓

2. **ESP32 drives HIGH (3.3V):**
   - Source at 3.3V
   - VGS = 3.3V - 3.3V = 0V → MOSFET turns OFF
   - Drain pulled to 5V by 10kΩ pull-up
   - Output = 5V (HIGH) ✓

**Non-inverting!** LOW→LOW, HIGH→HIGH (with voltage translation)

### Pros and Cons

**Advantages:**
✅ Very cheap (~$0.20)
✅ Only 3 components
✅ Bi-directional (can be used for I2C)
✅ Easy to build

**Disadvantages:**
❌ Slower than 74HCT125 (100ns vs 10ns)
❌ Not suitable for very long LED strips
❌ Can be affected by noise
❌ More complex than 74HCT125

**When to Use:**
- Budget builds
- Short LED strips (<100 LEDs)
- Temporary/prototype setups
- Bi-directional signals needed (I2C, SPI)

**When NOT to Use:**
- Long LED strips (>150 LEDs)
- Professional installations
- Critical applications
- High-speed signals

### Component Selection

**BSS138 Alternatives:**
- 2N7002 (similar MOSFET)
- BSS138LT1G (surface mount)
- Any small-signal N-channel MOSFET

**Resistor Values:**
- Pull-up: 4.7kΩ - 10kΩ
- Pull-down: 10kΩ
- Can adjust for speed vs power consumption

---

## Bi-Directional Level Shifters

### Module-Based Level Shifters

**Common Modules:**
- SparkFun Level Shifter (BSS138-based)
- Adafruit Level Shifter
- Generic I2C level shifter modules

### Connection

```
ESP32              Level Shifter          LED
                   ┌──────────┐
3.3V ──────────────│LV    HV│────────── 5V
GPIO2 ─────────────│LV1  HV1│────────── DI
GND ───────────────│GND  GND│────────── GND
                   └──────────┘
```

### Issues with WLED

**Problems:**
❌ **Too Slow**: MOSFET-based, 100ns+ delay
❌ **Designed for I2C**: Not optimized for WS2812B timing
❌ **Expensive**: $2-5 vs $0.50 for 74HCT125
❌ **Can Cause Glitches**: Timing issues with fast protocols

**Recommendation:** ❌ **Do NOT use** for WLED data lines

**Better Use:**
- I2C devices (displays, sensors)
- SPI devices
- UART communication
- Anything that's truly bi-directional

---

## No Level Shifter (Direct Connection)

### When It Might Work

**Conditions that allow direct connection:**

1. **Very Short Data Wire** (<3 inches / 7cm)
2. **Few LEDs** (<10)
3. **Good Quality LEDs** (name brand)
4. **Lower LED Supply Voltage** (4.5V instead of 5V)
5. **Temporary Testing**

### Direct Connection Setup

```
ESP32                LED Strip
  │                     │
GPIO2 ────[470Ω]────── DI
  │                     │
GND ─────────────────── GND
  │
(No 3.3V connection to LED strip!)
```

**Important:**
- Still use 470Ω resistor for protection
- Keep data wire as short as possible
- Common ground is essential
- Don't power ESP32 from LED supply

### The "Diode Trick"

**Slight Improvement (Still a Hack):**

```
ESP32                           LED Strip
  │                                │
GPIO2 ────[470Ω]───┬──────────── DI
                   │
                 [1N4148 diode]
                 (anode to GPIO)
                   │
                  5V (LED power)
```

**How It Works:**
- Diode prevents 5V from LED backfeeding to ESP32
- Allows ESP32 to pull down
- 5V pull-up when ESP32 not driving
- Still not as good as proper level shifter

**Still Not Recommended** for permanent installations!

### Risks of No Level Shifter

**What Can Go Wrong:**

1. **Unreliable Data:**
   - Random colors
   - Flickering
   - Non-responsive LEDs

2. **Temperature Issues:**
   - Works when cold
   - Fails when warm
   - Inconsistent operation

3. **Distance Issues:**
   - Works with short wire
   - Fails with long wire
   - First few LEDs OK, rest fail

4. **ESP32 Damage (Rare):**
   - 5V backfeeding to 3.3V pin
   - Can damage ESP32 over time
   - More likely with cheap LED strips

**Best Practice:** Just use a proper level shifter! They cost $0.50 and prevent days of troubleshooting.

---

## Troubleshooting

### LEDs Don't Work At All

**Check List:**

1. **Power:**
   - [ ] 5V at LED strip (+4.8V to +5.2V)
   - [ ] 5V at level shifter VCC pin
   - [ ] 3.3V at ESP32

2. **Ground:**
   - [ ] ESP32 GND connected to level shifter GND
   - [ ] Level shifter GND connected to LED GND
   - [ ] All grounds are common (measure resistance = 0Ω)

3. **Connections:**
   - [ ] ESP32 GPIO to level shifter input
   - [ ] Level shifter output to LED DI (not DO!)
   - [ ] Output Enable (OE) tied to GND
   - [ ] No loose wires

4. **Level Shifter:**
   - [ ] Correct orientation (check pinout!)
   - [ ] VCC = 5V (not 3.3V!)
   - [ ] Not damaged (check for burns/smell)

### LEDs Show Random Colors

**Likely Causes:**

1. **Bad Level Shifting:**
   - Check voltage at level shifter output (should be 5V HIGH)
   - Measure with oscilloscope if available
   - Try different level shifter IC

2. **Noisy Power:**
   - Add 1000µF capacitor at LED power input
   - Add 0.1µF at level shifter VCC
   - Improve grounding

3. **Long Data Wire:**
   - Shorten data wire to <1 foot if testing
   - Add 220Ω-470Ω resistor in series with data
   - Twist data wire with ground wire

### First Few LEDs Work, Rest Don't

**Diagnosis:**

1. **Voltage Drop:**
   - Measure voltage at last LED (should be >4.5V)
   - Add power injection if below 4.5V
   - Use thicker power wires

2. **Data Signal Degradation:**
   - Data signal weakens over distance
   - Level shifter might be inadequate
   - Try faster level shifter (74AHCT125)
   - Shorten data wire run

3. **Dead LED:**
   - One bad LED can break chain (WS2812B/WS2811)
   - Test by bypassing suspected LED
   - Replace bad LED

### Flickering or Intermittent

**Common Causes:**

1. **Loose Connection:**
   - Check all solder joints
   - Verify connectors are secure
   - Look for broken wires

2. **Insufficient Power:**
   - PSU undersized
   - Too much voltage drop
   - Add power injection

3. **EMI/RFI Interference:**
   - Keep data wire away from power wires
   - Twist data wire with ground
   - Add ferrite bead on data line
   - Shield data cable

4. **Bad Level Shifter:**
   - IC damaged or counterfeit
   - Replace with known-good IC
   - Try different type (74HCT125 → 74AHCT125)

### Works Sometimes, Not Others

**Temperature Related:**

- Level shifter or LED strip sensitive to temperature
- IC not properly seated
- Solder joint has crack (intermittent contact)
- Breadboard connection poor

**Solution:**
- Solder all connections permanently
- Use IC socket for easy replacement
- Apply heat to find bad connection (careful!)

---

## Best Practices

### DO These Things

✅ **Always Use Level Shifter:**
- Even if direct connection "works"
- Prevents future issues
- More reliable long-term

✅ **Use 74HCT125 or 74AHCT125:**
- Proven, reliable, cheap
- Fast enough for all LED types
- Easy to use

✅ **Add Resistor:**
- 220Ω-470Ω between ESP32 and level shifter
- Protects GPIO pin
- Reduces reflections

✅ **Add Decoupling Capacitor:**
- 0.1µF ceramic at level shifter VCC
- As close to IC as possible
- Reduces noise

✅ **Common Ground:**
- Connect all grounds together
- ESP32, level shifter, LED strip, PSU
- Critical for reliable operation

✅ **Short Data Wire:**
- Keep as short as practical
- Use twisted pair (data + ground)
- Shield if in noisy environment

✅ **Test First:**
- Test with 1 LED before full strip
- Verify level shifter output voltage
- Check signal with oscilloscope if available

### DON'T Do These Things

❌ **Don't Skip Level Shifter:**
- "It works without it" - until it doesn't
- Intermittent issues are worse than no operation
- False economy

❌ **Don't Use Bi-Directional Module:**
- Too slow for LED data
- Designed for I2C, not WS2812B
- Often causes glitches

❌ **Don't Forget Decoupling Cap:**
- Causes random glitches
- Level shifter can oscillate
- Easy to forget, important to include

❌ **Don't Mix Voltages:**
- VCC of level shifter = 5V (not 3.3V!)
- Common mistake that breaks everything

❌ **Don't Use Long Breadboard Wires:**
- High impedance, picks up noise
- Make permanent soldered connections
- Use PCB for final build

### Recommended Parts List

**For Single Strip:**
- 1× 74HCT125N (DIP-14)
- 1× 470Ω resistor (1/4W)
- 1× 0.1µF ceramic capacitor
- 14-pin DIP socket (optional but helpful)

**For 4 Strips:**
- 1× 74HCT125N (DIP-14)
- 4× 470Ω resistors
- 1× 0.1µF ceramic capacitor
- 14-pin DIP socket (optional)

**For 8 Strips:**
- 1× SN74HCT245N (DIP-20)
- 8× 470Ω resistors
- 1× 0.1µF ceramic capacitor
- 20-pin DIP socket (optional)

**Where to Buy:**
- Digi-Key, Mouser: Genuine parts
- Amazon: Fast shipping, verify seller
- AliExpress: Cheap, verify part markings

---

## Connection Examples

### Example 1: Basic Single Strip

**Components:**
- ESP32 DevKit
- 74HCT125
- 60 WS2812B LEDs
- 5V 5A power supply

**Wiring:**
```
5V PSU:
  (+) ──┬─── 74HCT125 Pin 14 (VCC) — MUST be 5V!
        ├─── LED strip 5V
        └─── [1000µF cap] ─── GND

ESP32:
  GPIO2 ──[470Ω]─── 74HCT125 Pin 2 (1A)  — Data input
  GND ──────────┬── 74HCT125 Pin 7 (GND)
                ├── 74HCT125 Pin 1 (1/OE) — Enable output
                └── LED strip GND

74HCT125:
  Pin 3 (1Y) ────── LED strip DI           — Data output (5V level)

Capacitors:
  [0.1µF] between 74HCT125 Pin 14 and Pin 7
```

### Example 2: Multi-Channel (4 Strips)

**Components:**
- ESP32 DevKit
- 74HCT125
- 4× LED strips
- 5V 20A power supply

**Wiring:**
```
ESP32 → 74HCT125 (verify against datasheet!):
  GPIO2  ──[470Ω]── Pin 2  (1A) → Pin 3  (1Y) → Strip 1 DI
  GPIO4  ──[470Ω]── Pin 5  (2A) → Pin 6  (2Y) → Strip 2 DI
  GPIO16 ──[470Ω]── Pin 9  (3A) → Pin 8  (3Y) → Strip 3 DI
  GPIO17 ──[470Ω]── Pin 12 (4A) → Pin 11 (4Y) → Strip 4 DI

Enable all outputs (/OE pins are active LOW):
  GND ──── Pins 1, 4, 10, 13 (all /OE pins)

Power:
  5V ───── Pin 14 (VCC) — MUST be 5V for level shifting!
  GND ──── Pin 7 (GND) + all LED strips + ESP32
```

### Example 3: Long Distance (with Buffer)

**For Data Wire >10 feet:**

```
ESP32 → 74HCT125 #1 → [long wire] → 74HCT125 #2 → LEDs
         (buffer)                      (buffer)

First Buffer (near ESP32):
  ESP32 GPIO2 ──[470Ω]── 74HCT125 input
  Output → Long twisted pair wire

Second Buffer (near LEDs):
  Long wire → 74HCT125 input
  Output ──[220Ω]── LED strip DI
```

**Benefits:**
- Buffers signal for long distance
- Each buffer regenerates clean signal
- Very reliable even at 50+ feet

---

## Summary

### Key Takeaways

1. **Always use level shifter** - Don't skip this step!

2. **74HCT125 is the best choice** - Cheap, reliable, fast

3. **Add resistor and capacitor** - 470Ω + 0.1µF improves reliability

4. **Common ground is critical** - Connect all grounds together

5. **Keep data wire short** - Or use additional buffers for long runs

6. **Test before full installation** - Verify with single LED first

### Quick Reference

**Best Setup:**
```
ESP32 GPIO → [470Ω] → 74HCT125 Pin 2 (1A input)
74HCT125 Pin 3 (1Y output) → LED strip DI
74HCT125 Pin 14 (VCC) = 5V (MUST be 5V! + 0.1µF cap to GND)
74HCT125 Pin 1 (1/OE) = GND (enables output)
74HCT125 Pin 7 (GND) = GND
All grounds connected (ESP32, 74HCT125, LED strip, PSU)
```

**Part Numbers to Order:**
- **74HCT125N** (DIP, through-hole)
- **74HCT125D** (SO-14, surface mount)
- **74AHCT125N** (faster version)
- **SN74HCT245N** (8-channel version)

### Related Guides

- [Power Supply Selection Guide](POWER_SUPPLY_SELECTION_GUIDE.md)
- [LED Selection Guide](LED_SELECTION_GUIDE.md)
- [Wire Selection Guide](WIRE_SELECTION_GUIDE.md)
- [Hardware Development Guide](HARDWARE_GUIDE.md)

---

**Remember:** A $0.50 level shifter can save hours of troubleshooting. Always use one!
