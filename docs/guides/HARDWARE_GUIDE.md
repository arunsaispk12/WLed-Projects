# WLED Hardware Development Guide

Complete guide for designing and building custom WLED controller hardware.

## Table of Contents
1. [Introduction](#introduction)
2. [Design Considerations](#design-considerations)
3. [Component Selection](#component-selection)
4. [Circuit Design](#circuit-design)
5. [PCB Layout](#pcb-layout)
6. [Assembly Guide](#assembly-guide)
7. [Testing & Validation](#testing--validation)
8. [Common Designs](#common-designs)

## Introduction

This guide covers everything needed to design custom WLED controller hardware, from simple breadboard prototypes to production PCBs.

### What You'll Learn
- ESP32 microcontroller selection and configuration
- LED strip interfacing and power management
- PCB design best practices
- Safety and reliability considerations
- Manufacturing and assembly

### Skill Requirements
- Basic electronics knowledge
- Soldering skills (for assembly)
- PCB design software familiarity (optional for custom PCBs)

## Design Considerations

### Power Requirements

Calculate total power needed:

```
Total Power (W) = Number of LEDs × Power per LED
Power per LED = ~0.06W (20mA × 3V per color channel at full white)

Example:
60 LEDs × 0.06W = 3.6W minimum
Add 20% safety margin = 4.32W
At 5V: 4.32W / 5V = 0.864A

Recommendation: Use 2A+ power supply for 60 LEDs
```

### Power Supply Selection

| LED Count | Recommended Supply | Notes |
|-----------|-------------------|-------|
| 1-30 | 5V 1A | USB power acceptable |
| 30-100 | 5V 3A | Dedicated power supply |
| 100-300 | 5V 5-10A | Injection recommended |
| 300+ | 5V 10A+ | Multiple injection points |

### LED Strip Specifications

Common types:
- **WS2812B**: Most common, 5V, integrated controller
- **SK6812**: Similar to WS2812B, better color accuracy
- **WS2813**: Backup data line for reliability
- **APA102**: Uses separate clock line, higher refresh rates

### Environmental Factors

- **Indoor**: Standard components, basic protection
- **Outdoor**: Weatherproof enclosure, conformal coating
- **High Temperature**: Use industrial-grade components
- **High Humidity**: Silicone conformal coating

## Component Selection

### Microcontroller Options

#### ESP32 (Recommended)
**Advantages:**
- WiFi + Bluetooth
- Dual-core
- Abundant GPIO
- Large community

**Models:**
- **ESP32-WROOM-32**: General purpose, most common
- **ESP32-WROVER**: Extra PSRAM for effects
- **ESP32-C3**: Newer, RISC-V, lower cost
- **ESP32-S3**: Latest, best performance

#### ESP8266
**Advantages:**
- Lower cost
- Smaller footprint
- Sufficient for basic WLED

**Limitations:**
- Single core
- Limited GPIO
- Less memory

### Essential Components

#### 1. Voltage Regulator

For powering ESP32 from 5V:

**Option A: Linear Regulator (Simple)**
- AMS1117-3.3: Cheap, common, gets hot
- Maximum current: 1A
- Requires heatsink for >500mA

**Option B: Buck Converter (Efficient)**
- MP1584: Efficient, stays cool
- Maximum current: 3A
- Better for high power applications

#### 2. Level Shifter

Convert 3.3V GPIO to 5V for LEDs:

**Option A: 74HCT125** (Recommended)
- Fast, reliable
- ~1ns propagation delay
- Handles high-speed data

**Option B: 74AHCT125**
- Similar to HCT, slightly faster
- Good for very long strips

**Option C: BSS138 MOSFET**
- Bidirectional
- Simple circuit
- Slower than 74HCT125

#### 3. Capacitors

**Power Filtering:**
- 1000µF electrolytic at LED power input
- 100µF electrolytic at ESP32 power
- 0.1µF ceramic near each IC

**Why:**
- Reduces voltage spikes
- Stabilizes power delivery
- Prevents brownouts

#### 4. Resistors

**Data Line:**
- 220-470Ω between ESP32 and LED data
- Protects GPIO pin
- Reduces reflections

**Pull-up/Pull-down:**
- 10kΩ for enable pins
- 10kΩ for boot mode selection

#### 5. Protection Components

**Diode (Power):**
- 1N5819 Schottky diode for reverse polarity protection
- Rated for expected current

**TVS Diode (Optional):**
- Protects against voltage spikes
- Place on power rails

### Optional Components

#### 1. User Interface
- Push button for controls
- Rotary encoder for brightness
- OLED display for status

#### 2. Sensors
- Microphone for sound reactive effects
- PIR sensor for motion detection
- Light sensor for auto-brightness

#### 3. Expansion
- Terminal blocks for easy connections
- JST connectors for modular design
- Pin headers for accessories

## Circuit Design

### Basic WLED Controller Schematic

```
                    Power Supply (5V)
                           │
                           ├──────────────┐
                           │              │
                      1000µF Cap       [TVS Diode]
                           │              │
                           ├──────────────┴────────── To LED Strip 5V
                           │
                    [Buck Converter]
                       3.3V Out
                           │
                      100µF Cap
                           │
        ┌──────────────────┴──────────────────┐
        │                                     │
        │            ESP32-WROOM-32           │
        │                                     │
        │  GPIO2  ────[470Ω]───[74HCT125]────┼──── To LED Strip Data
        │                                     │
        │  EN     ────[10kΩ]──── 3.3V        │
        │  GPIO0  ────[Button]── GND          │
        │                                     │
        │  GND    ───────────────────────────┼──── Common GND
        │                                     │
        └─────────────────────────────────────┘
```

### Detailed Component Connections

#### ESP32 Power Supply

```
5V Input ──┬── [Diode 1N5819] ──┬── [100µF] ── GND
           │                     │
           └─ [AMS1117-3.3] ──┬──┴── [0.1µF] ── GND
                  │           │
                  │        3.3V Out
                  │           │
                 GND      ┌───┴────┐
                          │ ESP32  │
                          │ VCC    │
                          └────────┘
```

#### Level Shifter Circuit (74HCT125)

```
ESP32 GPIO2 ──[470Ω]── 74HCT125 Pin 2 (A1)
                           │
                    Pin 1 (/OE) ── GND (always enabled)
                    Pin 3 (Y1) ────── To LED Strip Data
                    Pin 14 (VCC) ─── 5V
                    Pin 7 (GND) ──── GND
```

#### Alternative: MOSFET Level Shifter

```
ESP32 GPIO2 ──[10kΩ]──┬──── 5V
                      │
                   [BSS138]
                  G   D   S
                  │   │   │
                  │   │   └──── GND
                  │   │
                  │   └──────── To LED Strip Data
                  └───[10kΩ]─── GND
```

### Full Featured Controller

Add these for a complete controller:

#### Button Controls

```
GPIO0 ──┬──[Button]── GND
        │
        └──[10kΩ]──── 3.3V

GPIO4 ──┬──[Button]── GND  (Mode button)
        │
        └──[10kΩ]──── 3.3V
```

#### Rotary Encoder

```
GPIO16 ──── Encoder CLK
GPIO17 ──── Encoder DT
GPIO5  ──── Encoder SW (button)
```

#### Microphone (Sound Reactive)

```
                    INMP441 (I2S Microphone)
                         │
GPIO25 ────────────── WS (Word Select)
GPIO32 ────────────── SCK (Clock)
GPIO33 ────────────── SD (Data)
```

## PCB Layout

### Design Rules

#### General Guidelines
- Minimum trace width: 0.25mm for signals, 0.5mm+ for power
- Minimum clearance: 0.2mm
- Via size: 0.3mm drill, 0.6mm pad

#### Power Traces
- Calculate based on current:
  - 1A: 0.5mm minimum
  - 2A: 1.0mm minimum
  - 3A+: 1.5mm+ or use copper pour

#### Ground Plane
- Use copper pour for GND on both layers
- Ensure good thermal relief for soldering
- Multiple vias for low impedance

### Layer Stack (2-Layer PCB)

```
Top Layer:
- Component placement
- Signal traces
- Power distribution
- Ground pour (fill)

Bottom Layer:
- Ground plane (priority)
- Return paths
- Additional routing
```

### Layout Best Practices

#### 1. Component Placement
```
[Power Input] → [Protection] → [Regulator] → [ESP32] → [Level Shifter] → [LED Output]
```

#### 2. Decoupling Capacitors
- Place 0.1µF ceramic cap close to each IC VCC pin
- Place bulk caps (100µF+) at power input
- Keep traces short

#### 3. Crystal/Oscillator
- Keep traces to ESP32 short and equal length
- Surround with ground pour
- No traces underneath

#### 4. Data Line
- Keep LED data line short and direct
- Avoid right angles (use 45° or curved)
- Route away from noisy signals

### Example PCB Layout

```
┌─────────────────────────────────────────┐
│  [Power In]                    [LED Out]│
│   ○ ○ ○                         ○ ○ ○   │
│   │ │ │                         │ │ │   │
│   V G D                         V G D   │
│                                         │
│  ┌─────┐  ┌──────────┐  ┌──────┐       │
│  │ Reg │  │  ESP32   │  │Level │       │
│  │3.3V │  │  Module  │  │Shift │       │
│  └─────┘  └──────────┘  └──────┘       │
│                                         │
│  [Button]  [Button]           ┌─────┐  │
│    ○         ○                │ Mic │  │
│                                └─────┘  │
│                                         │
│  [USB Program]  Ground Plane (Bottom)  │
│    ○ ○ ○ ○                              │
└─────────────────────────────────────────┘
```

### KiCad Design Files Structure

```
hardware/pcb-designs/project-name/
├── project-name.kicad_pro    # Project file
├── project-name.kicad_sch    # Schematic
├── project-name.kicad_pcb    # PCB layout
├── fp-lib-table              # Footprint libraries
├── sym-lib-table             # Symbol libraries
├── gerbers/                  # Manufacturing files
│   ├── F_Cu.gbr
│   ├── B_Cu.gbr
│   ├── F_Mask.gbr
│   └── ...
└── bom/
    └── bill_of_materials.csv
```

## Assembly Guide

### Tools Required

**Essential:**
- Soldering iron (temperature controlled)
- Solder (0.8mm, leaded or lead-free)
- Flush cutters
- Tweezers
- Multimeter

**Helpful:**
- Soldering flux
- Desoldering pump/wick
- Magnifying glass/microscope
- Hot air rework station (for SMD)

### Assembly Steps

#### 1. Prepare PCB
- Clean with isopropyl alcohol
- Inspect for defects
- Check for shorts with multimeter

#### 2. Solder Order

**Start with low-profile components:**
1. SMD resistors and capacitors (if any)
2. Voltage regulator IC
3. ESP32 module (or socket)
4. Level shifter IC
5. Electrolytic capacitors
6. Terminal blocks/connectors
7. Buttons and switches
8. Pin headers

#### 3. SMD Soldering Tips
- Use flux generously
- Tack one pin first
- Check alignment
- Solder remaining pins
- Inspect with magnifier

#### 4. Through-Hole Soldering
- Insert component
- Bend leads slightly to hold
- Solder from bottom
- Clip excess leads

#### 5. Inspection
- Check all solder joints
- Look for bridges
- Verify component orientation
- Test for shorts between power rails

### First Power-On Checklist

**BEFORE applying power:**
- [ ] Visual inspection complete
- [ ] No solder bridges
- [ ] Correct component polarity
- [ ] All connections solid
- [ ] Measure resistance between VCC and GND (should be >1kΩ)

**Initial power-up:**
1. Set power supply to 5V with current limit (500mA)
2. Connect power
3. Check current draw (<100mA without LEDs)
4. Measure 3.3V at ESP32 VCC
5. Check for excessive heat
6. Connect USB and test programming

## Testing & Validation

### Hardware Tests

#### 1. Power Supply Test
```
Test Points:
- 5V input: Should be 4.9-5.1V
- 3.3V rail: Should be 3.2-3.4V
- Current draw (idle): 50-100mA
- Current draw (with LEDs): Calculate based on LED count
```

#### 2. GPIO Test
```cpp
// Upload test sketch
void setup() {
    pinMode(2, OUTPUT);  // LED data pin
}

void loop() {
    digitalWrite(2, HIGH);
    delay(500);
    digitalWrite(2, LOW);
    delay(500);
}
```

Measure with multimeter:
- HIGH should be ~3.3V
- After level shifter: ~5V

#### 3. LED Strip Test
```
1. Connect single LED first
2. Upload WLED firmware
3. Set LED count to 1
4. Test colors: Red, Green, Blue, White
5. Gradually increase LED count
```

### Troubleshooting

#### ESP32 Won't Program
- Check USB connection
- Hold BOOT button during upload
- Verify CH340/CP2102 drivers installed
- Check EN is pulled high

#### LEDs Don't Light Up
- Verify 5V at LED strip
- Check GND connection
- Measure data line voltage (~5V after level shifter)
- Try different GPIO pin
- Check LED strip polarity (DI not DO)

#### LEDs Flicker or Random Colors
- Add/increase capacitor at LED power
- Check data line resistor (220-470Ω)
- Reduce LED brightness in WLED
- Improve power supply
- Shorten data line

#### ESP32 Resets Randomly
- Insufficient power supply
- Add bulk capacitor (1000µF)
- Check GND connections
- Reduce LED count/brightness

### Performance Testing

#### 1. Thermal Test
- Run all LEDs at full white for 10 minutes
- Check regulator temperature (<80°C)
- Verify no component overheating
- Improve heatsinking if needed

#### 2. Stress Test
- Run intensive effects for extended period
- Monitor WiFi stability
- Check for memory leaks (serial monitor)
- Verify no brownouts or resets

#### 3. Range Test
- Test WiFi range at installation location
- Verify signal strength >-70dBm
- Test through walls/obstacles
- Consider external antenna if needed

## Common Designs

### Design 1: Minimal Controller

**Components:**
- ESP32 DevKit (pre-made module)
- 74HCT125 level shifter
- 470Ω resistor
- 1000µF capacitor
- Terminal blocks

**Use Case:**
- Quick prototypes
- Testing
- Temporary installations

**Files:** `hardware/schematics/minimal-controller/`

### Design 2: Standard Controller

**Components:**
- ESP32-WROOM-32 module
- AMS1117-3.3 regulator
- 74HCT125 level shifter
- Full component set
- PCB designed

**Use Case:**
- Permanent installations
- Single LED strip
- Indoor use

**Files:** `hardware/schematics/standard-controller/`

### Design 3: Multi-Channel Controller

**Components:**
- ESP32-WROOM-32
- Multiple 74HCT125 ICs
- Robust power supply
- 4-8 output channels
- Fused outputs

**Use Case:**
- Multiple LED strips
- Large installations
- Professional projects

**Files:** `hardware/schematics/multi-channel-controller/`

### Design 4: Sound Reactive Controller

**Components:**
- ESP32-WROOM-32
- INMP441 I2S microphone
- Standard WLED components
- Microphone mounting

**Use Case:**
- Music visualization
- Ambient installations
- Party lighting

**Files:** `hardware/schematics/sound-reactive-controller/`

## Safety Guidelines

### Electrical Safety

1. **Always disconnect power** before working on circuit
2. **Use appropriate current rating** for all components
3. **Fuse protection** recommended for high-power installations
4. **Insulate exposed connections** with heat shrink
5. **Proper wire gauge** for current requirements

### Fire Prevention

1. **Don't exceed component ratings**
2. **Provide adequate ventilation**
3. **Use UL-listed power supplies**
4. **Secure all connections**
5. **Regular inspection** of installations

### Wire Gauge Selection

| Current | Wire Gauge | Diameter |
|---------|------------|----------|
| 1A | 22 AWG | 0.64mm |
| 2A | 20 AWG | 0.81mm |
| 3A | 18 AWG | 1.02mm |
| 5A | 16 AWG | 1.29mm |
| 10A | 14 AWG | 1.63mm |

## Manufacturing

### PCB Fabrication

#### Recommended Manufacturers
- JLCPCB: Low cost, fast shipping
- PCBWay: Good quality, competitive pricing
- OSH Park: USA-based, high quality

#### Standard Specifications
```
Layers: 2
Material: FR-4
Thickness: 1.6mm
Copper Weight: 1oz (35µm)
Surface Finish: HASL or ENIG
Silkscreen: White
Soldermask: Green
```

#### Gerber Export
1. Generate Gerber files from KiCad/Eagle
2. Include drill file
3. Create zip archive
4. Upload to manufacturer
5. Review before ordering

### Assembly Services

For SMD or large quantities:
- JLCPCB Assembly
- PCBWay Assembly
- Local assembly house

### Bill of Materials

Template: `hardware/bom/bom-template.csv`

Include:
- Component designators
- Values
- Package/footprint
- Manufacturer part number
- Supplier (Digi-Key, Mouser, etc.)
- Quantity
- Unit price
- Total price

## Additional Resources

### Software Tools
- **KiCad**: Free, open-source PCB design
- **EasyEDA**: Online PCB design
- **Fritzing**: Great for beginners
- **LTSpice**: Circuit simulation

### Component Sources
- Digi-Key: Vast selection, fast shipping
- Mouser: Similar to Digi-Key
- LCSC: Budget components
- AliExpress: Cheap, slow shipping

### Learning Resources
- SparkFun tutorials
- Adafruit learning system
- EEVblog videos
- r/AskElectronics community

### Design Examples
- Example projects in `../../projects/`
- Community shared designs
- WLED discourse hardware section

## Revision History

- v1.0.0 - Initial hardware guide
- Document your hardware revisions here
