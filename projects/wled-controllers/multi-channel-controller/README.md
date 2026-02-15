# Multi-Channel WLED Controller

Professional-grade controller for managing 4-8 independent LED strips with synchronized or independent control. Perfect for architectural lighting, large installations, and commercial applications.

![Build Status](https://img.shields.io/badge/build-ready-brightgreen)
![WLED](https://img.shields.io/badge/WLED-v0.14.x-blue)
![Channels](https://img.shields.io/badge/Channels-4--8-orange)

## Overview

Control multiple LED strips independently from a single ESP32! This professional-grade controller is designed for large-scale installations where you need synchronized effects across multiple zones or completely independent control of different areas.

## Features

- 🎛️ **4-8 Independent Channels** - Control multiple strips separately
- 🔀 **Sync Modes** - Run same or different effects per channel
- 🎨 **Per-Channel Configuration** - Different LED counts, colors, effects
- 💪 **High Power** - Professional PSU integration with distribution
- 🔒 **Fused Outputs** - Protection for each channel
- 📊 **Power Monitoring** - Track current per channel (optional)
- 🏢 **Scalable Design** - Modular for easy expansion
- 🛡️ **Reliable** - WS2813/WS2815 with backup data lines
- 🌐 **Network Control** - WiFi + MQTT for automation
- 📱 **Mobile App** - Full WLED app support

## Use Cases

### Architectural Lighting
- Building outline with different zones
- Each side independently controlled
- Synchronized for shows
- Professional appearance

### Stage/Theater
- Multiple independent areas
- Synchronized effects during performances
- Independent house/stage control
- DMX integration possible

### Commercial Installations
- Restaurant/bar mood zones
- Retail display lighting
- Museum exhibits
- Hotel lobbies

### Large Residential
- Whole-home synchronized
- Room-by-room control
- Outdoor perimeter
- Pool + patio + landscaping

### Events/Weddings
- Multiple venue zones
- Dance floor + ambient + accent
- Independent or synchronized
- Professional control

## Hardware Requirements

### Bill of Materials

| Component | Specification | Quantity | Est. Price | Notes |
|-----------|--------------|----------|------------|-------|
| **Controller** | | | | |
| ESP32 DevKit | ESP32-WROOM-32 or S3 | 1 | $6-10 | S3 for 8 channels |
| Level Shifters | 74HCT125 (quad) | 2 | $1 | 3.3V → 5V |
| Resistors | 470Ω | 4-8 | $1 | Data line protection |
| PCB/Perfboard | Custom or universal | 1 | $5-10 | Mounting |
| Enclosure | Project box | 1 | $10-20 | Professional |
| **Power Distribution** | | | | |
| Power Supply | 5V 20-60A | 1 | $40-100 | Based on total LEDs |
| Fuse Holders | Blade fuse | 4-8 | $10 | Per channel |
| Fuses | 3A-5A blade | 4-8 | $5 | Match channel load |
| Terminal Blocks | 20A rated | 2-4 | $5-10 | Distribution |
| **LED Strips** | | | | |
| LED Strips | WS2813 or WS2815 | 4-8 | $40-200 | 5m ea recommended |
| Wire | 18 AWG | 50m | $20-30 | Power distribution |
| Wire | 22 AWG | 20m | $10 | Data lines |
| Connectors | JST or screw | 10+ | $10 | Modular connections |
| **Optional** | | | | |
| Power Monitor | INA219 (I2C) | 1-8 | $3-20 | Current sensing |
| Cooling Fan | 12V 40mm | 1 | $5 | For enclosure |
| Status LEDs | 3mm | 4-8 | $2 | Channel indicators |
| **Total** | | | **$200-400** | Based on scale |

### Recommended Configurations

#### 4-Channel System (Standard)
- 4× WS2813 strips (5m each, 300 LEDs)
- Total: 1200 LEDs
- Power: 5V 40A
- Use case: Home, small commercial

#### 6-Channel System (Medium)
- 6× WS2813 strips (5m each)
- Total: 1800 LEDs
- Power: 5V 60A
- Use case: Medium commercial, events

#### 8-Channel System (Advanced)
- 8× WS2815 strips (10m each, 12V)
- Total: 2400 LEDs
- Power: 12V 30A
- Use case: Architectural, large commercial
- Requires ESP32-S3 for 8 GPIO pins

### Pin Configuration

#### 4-Channel (ESP32)

| ESP32 Pin | Channel | Function | Notes |
|-----------|---------|----------|-------|
| GPIO2 | 1 | LED Data 1 | Primary channel |
| GPIO4 | 2 | LED Data 2 | |
| GPIO16 | 3 | LED Data 3 | |
| GPIO17 | 4 | LED Data 4 | |
| GPIO21 | - | I2C SDA | Optional sensors |
| GPIO22 | - | I2C SCL | Optional sensors |
| 3.3V | - | Logic Power | Shared |
| GND | - | Ground | Common ground |

**WARNING:** Do NOT use GPIO6-11 (flash), GPIO12 (boot voltage select),
or GPIO15 (boot strapping) for LED data outputs.

#### 8-Channel (ESP32-S3)

| ESP32-S3 Pin | Channel | Function |
|--------------|---------|----------|
| GPIO4 | 1 | LED Data 1 |
| GPIO5 | 2 | LED Data 2 |
| GPIO6 | 3 | LED Data 3 |
| GPIO7 | 4 | LED Data 4 |
| GPIO15 | 5 | LED Data 5 |
| GPIO16 | 6 | LED Data 6 |
| GPIO17 | 7 | LED Data 7 |
| GPIO18 | 8 | LED Data 8 |

**Note:** ESP32-S3 has different strapping pin behavior than ESP32.
GPIO15 is safe for general I/O on the S3 variant.

## System Architecture

```
Power Supply (5V 60A)
    │
    ├──[Main Fuse 60A]───┬─── Terminal Block (Distribution)
    │                    │
    │                    ├─[Fuse 5A]─→ Channel 1 LEDs (300 LEDs)
    │                    │
    │                    ├─[Fuse 5A]─→ Channel 2 LEDs (300 LEDs)
    │                    │
    │                    ├─[Fuse 5A]─→ Channel 3 LEDs (300 LEDs)
    │                    │
    │                    └─[Fuse 5A]─→ Channel 4 LEDs (300 LEDs)
    │
    └─── ESP32 Power

ESP32
  ├─ GPIO2 ─[470Ω]─[74HCT125]─→ Channel 1 Data
  ├─ GPIO4 ─[470Ω]─[74HCT125]─→ Channel 2 Data
  ├─ GPIO16─[470Ω]─[74HCT125]─→ Channel 3 Data
  └─ GPIO17─[470Ω]─[74HCT125]─→ Channel 4 Data

Common GND: PSU, ESP32, All LED Strips
```

## Wiring Diagram (4-Channel)

```
                    Power Supply (5V 60A)
                            │
                    [Main Terminal Block]
                            │
         ┌──────────────────┼──────────────────┐
         │                  │                  │
      [Fuse]            [Fuse]            [Fuse]
         │                  │                  │
    Channel 1          Channel 2          Channel 3
    LEDs 5V            LEDs 5V            LEDs 5V
         │                  │                  │
         └──────────────────┴──────────────────┴─── Common GND


ESP32                74HCT125 (Quad)              LED Strips
┌──────┐            ┌───────────┐
│      │            │           │
│ GPIO2├─[470Ω]────┤A1      Y1 ├────────────────→ Ch1 Data
│      │            │           │
│ GPIO4├─[470Ω]────┤A2      Y2 ├────────────────→ Ch2 Data
│      │            │           │
│GPIO16├─[470Ω]────┤A3      Y3 ├────────────────→ Ch3 Data
│      │            │           │
│GPIO17├─[470Ω]────┤A4      Y4 ├────────────────→ Ch4 Data
│      │            │           │
│  GND ├────────────┤GND        │
│      │            │           │
│  5V  ├────────────┤VCC    /OE ├──── GND
└──────┘            └───────────┘
```

## Software Setup

### Configuration

Edit `platformio.ini` before building:

```ini
# Number of outputs
-D WLED_MAX_BUSSES=4              # 4 for standard, 8 for advanced

# Pin configuration
-D DATA_PINS=2,4,16,17            # Match your wiring

# LED configuration per channel (edit as needed)
-D LEDPIN1=2
-D LEDCOUNT1=300                  # Channel 1: 300 LEDs

-D LEDPIN2=4
-D LEDCOUNT2=300                  # Channel 2: 300 LEDs

-D LEDPIN3=16
-D LEDCOUNT3=150                  # Channel 3: 150 LEDs (shorter run)

-D LEDPIN4=17
-D LEDCOUNT4=150                  # Channel 4: 150 LEDs
```

### Build & Flash

```bash
cd projects/wled-controllers/multi-channel-controller

# 4-channel build
./build.sh build multi_4ch
./build.sh flash multi_4ch /dev/ttyUSB0

# 8-channel build (ESP32-S3 only)
./build.sh build multi_8ch_s3
./build.sh flash multi_8ch_s3 /dev/ttyUSB0
```

### WLED Configuration

1. **Initial Setup**
   - Connect to WLED-AP
   - Configure WiFi
   - Access web interface

2. **LED Preferences** (Config → LED Preferences)
   - **Multi Strip:** Yes
   - Configure each output:
     ```
     Output 1:
     - GPIO: 2
     - Count: 300
     - Type: WS2813

     Output 2:
     - GPIO: 4
     - Count: 300
     - Type: WS2813

     Output 3:
     - GPIO: 16
     - Count: 150
     - Type: WS2813

     Output 4:
     - GPIO: 17
     - Count: 150
     - Type: WS2813
     ```

3. **Segments** (Main UI → Segments)
   - Create segment for each physical area
   - Can span multiple outputs or use single output
   - Example:
     ```
     Segment 1: "North Wall" - Output 1
     Segment 2: "South Wall" - Output 2
     Segment 3: "East Wall" - Output 3
     Segment 4: "West Wall" - Output 4
     ```

## Control Modes

### 1. Synchronized Mode

All channels show the same effect:

**Setup:**
- Create single segment spanning all outputs
- Apply one effect
- All channels mirror each other

**Use for:**
- Building outlines (all same color)
- Synchronized shows
- Unified appearance

### 2. Independent Mode

Each channel completely separate:

**Setup:**
- Create segment per channel
- Different effects per segment
- Independent colors

**Use for:**
- Different rooms
- Multiple zones
- Varied effects per area

### 3. Zone Mode

Groups of channels synchronized:

**Setup:**
- Group channels 1+2 (north side)
- Group channels 3+4 (south side)
- Different effects per group

**Use for:**
- Multi-zone buildings
- Stage (front, back, sides)
- Coordinated but varied

### 4. Sequential Mode

Effects cascade across channels:

**Setup:**
- Same effect on all
- Stagger timing
- Creates wave/chase effect

**Use for:**
- Dramatic reveals
- Attention-grabbing
- Dynamic installations

## Power Distribution

### Calculating Power Needs

**Per Channel:**
```
Channel with 300 WS2813 LEDs:
300 LEDs × 60mA = 18A max (full white)
300 LEDs × 30mA = 9A typical (colors/effects)

Fuse: 10A (safety margin above typical)
Wire: 16 AWG minimum (18 AWG for short runs)
```

**Total System:**
```
4 channels × 300 LEDs = 1200 LEDs total
1200 × 30mA = 36A typical
1200 × 60mA = 72A absolute maximum

Power Supply: 60A (allows margin)
Main Fuse: 60A
```

### Power Distribution Best Practices

1. **Central Distribution**
   - Single large PSU
   - Distribution terminal block
   - Individual fuses per channel
   - Heavy gauge from PSU to distribution (12-14 AWG)

2. **Power Injection**
   - Still needed on long runs
   - Inject at 150 LED intervals
   - Use same gauge as main feed
   - Both 5V and GND

3. **Fusing Strategy**
   ```
   Main PSU: 60A supply
   Main Fuse: 60A (protects PSU)

   Per Channel: 10A fuse
   - Protects wiring
   - Isolates faults
   - Allows troubleshooting
   ```

4. **Wire Management**
   - Label all wires
   - Color code: Red +5V, Black GND, Colors for data
   - Use ferrules on terminals
   - Strain relief everywhere
   - Cable management ties

## Assembly Guide

### Step 1: Planning

**Document Everything:**
- Draw wiring diagram specific to your installation
- Calculate power for each channel
- List exact LED counts
- Note wire lengths needed
- Plan enclosure layout

### Step 2: Enclosure Prep

**Professional Enclosure:**
1. Drill holes for:
   - Power input (cable gland)
   - 4-8 output cables (cable glands)
   - Ventilation (if needed)
   - Mounting holes

2. Mount components:
   - PSU (if internal)
   - Terminal blocks
   - Fuse holders
   - ESP32 on standoffs
   - Level shifters

3. Labels:
   - Input power
   - Each output channel
   - Voltage warnings
   - Wiring diagram inside lid

### Step 3: Power Distribution

1. **Main Power:**
   - Heavy wire (12-14 AWG) from PSU to distribution block
   - Solder or crimp connections
   - Heat shrink all connections

2. **Per-Channel Distribution:**
   - Fuse holder for each channel
   - Appropriate fuse (calculate from LED count)
   - 16-18 AWG to each output

3. **Ground:**
   - Star grounding from PSU
   - All grounds to single point
   - Same gauge as power wires

### Step 4: Data Lines

1. **Level Shifters:**
   - Mount securely
   - Short wires from ESP32 (minimize interference)
   - 470Ω resistor on each input
   - Twisted pair for long runs

2. **Output:**
   - 22-24 AWG data wire
   - Shielded if long runs (>5m)
   - Strain relief at connector

### Step 5: Testing

**Before Connecting All LEDs:**

1. **Power Test:**
   - Measure voltages with multimeter
   - Verify all fuses seated
   - Check polarity (CRITICAL!)

2. **Channel Test:**
   - Connect 1 LED to each channel
   - Flash firmware
   - Test each output independently
   - Verify all channels work

3. **Full Test:**
   - Connect all LED strips
   - Test at 50% brightness
   - Monitor temperatures
   - Verify no overheating
   - Check voltage at end of strips

## Professional Features

### Power Monitoring (Optional)

Add INA219 current sensors per channel:

```python
# Monitor each channel independently
Channel 1: 8.5A
Channel 2: 9.1A
Channel 3: 4.2A
Channel 4: 4.5A
Total: 26.3A
PSU Load: 44% (safe)
```

**Benefits:**
- Real-time monitoring
- Alert on overcurrent
- Optimization opportunities
- Preventive maintenance

### Status LEDs

Add indicator LED per channel:

```
Channel 1: Green (active, normal)
Channel 2: Green (active, normal)
Channel 3: Off (disabled)
Channel 4: Red (fault detected)
```

### Emergency Stop

Add kill switch for all outputs:

- Big red button
- Cuts power to all LED strips
- ESP32 stays powered
- For safety/emergencies

## Advanced Configurations

### DMX Integration

Add DMX input for professional control:

```
DMX → ESP32 → Multi-Channel WLED
```

**Use for:**
- Theater/stage integration
- Professional lighting systems
- Synchronized with other fixtures

### MQTT Control

Full automation integration:

```yaml
# Home Assistant Example
light:
  - platform: wled
    name: "North Wall"
    host: 192.168.1.100
    segments: [1]

  - platform: wled
    name: "South Wall"
    host: 192.168.1.100
    segments: [2]
```

### Scheduling

Different zones at different times:

```
6:00 AM - Channel 1 (East) sunrise simulation
7:00 PM - Channels 1-4 warm white
10:00 PM - Channel 1 night light, others off
```

## Troubleshooting

### Channel Not Working

**Check:**
1. Fuse for that channel
2. Voltage at LED strip (should be 5V)
3. Data signal (oscilloscope or test LED)
4. WLED configuration (correct GPIO, LED count)
5. Level shifter for that channel

**Debug:**
- Swap data line with working channel
- If problem moves: ESP32/level shifter issue
- If problem stays: Wiring/LED strip issue

### Intermittent Issues

**Common Causes:**
- Loose connection in terminal block
- Undersized wire (voltage drop under load)
- Failing fuse (replace)
- Overheating (add cooling)

### Power Supply Shutting Down

**Causes:**
- Overcurrent (too many LEDs)
- Overtemperature (poor ventilation)
- Short circuit (check wiring)

**Solutions:**
- Calculate actual current draw
- Limit WLED max current
- Improve cooling
- Upgrade PSU if needed

## Maintenance

### Monthly

- [ ] Check all terminal connections (tighten if needed)
- [ ] Verify fuses intact
- [ ] Test each channel independently
- [ ] Monitor temperatures
- [ ] Check for any dim LEDs

### Quarterly

- [ ] Full system test at maximum brightness
- [ ] Measure voltage at strip ends
- [ ] Clean enclosure/PSU (dust)
- [ ] Verify all labels intact
- [ ] Update firmware if needed

### Annually

- [ ] Replace fuses preventively
- [ ] Check wire insulation
- [ ] Re-tighten all screws
- [ ] Test emergency stop (if equipped)
- [ ] Document any changes

## Safety

⚠️ **High Current System:**
- 60A+ systems are dangerous
- Proper fusing CRITICAL
- Use correct wire gauges
- Ensure good connections
- Monitor temperatures

⚠️ **Installation:**
- Follow electrical codes
- Use strain relief
- Waterproof if outdoor
- Professional installation recommended for large systems

⚠️ **Fire Safety:**
- Don't exceed wire ratings
- Proper fusing
- Regular inspection
- Fire extinguisher nearby
- Never leave unattended during testing

## Example Installations

### Building Outline (4 Sides)

- Channel 1: North (300 LEDs, 5m)
- Channel 2: East (300 LEDs, 5m)
- Channel 3: South (300 LEDs, 5m)
- Channel 4: West (300 LEDs, 5m)

**Control:** Sync all or animate sequentially

### Restaurant Zones

- Channel 1: Bar area (RGB effects)
- Channel 2: Dining area (warm white)
- Channel 3: Entry (accent colors)
- Channel 4: Patio (cool white)

**Control:** Independent per zone, scheduled

### Stage Lighting

- Channel 1-2: Front stage (sync)
- Channel 3-4: Back stage (sync)
- Channel 5-6: Side wash
- Channel 7-8: Audience backlight

**Control:** Scenes for different performances

## Performance

**Refresh Rates:**
- 4 channels: 60 FPS all channels
- 8 channels: 30-60 FPS (depends on complexity)
- ESP32-S3: Better performance than ESP32

**Maximum LEDs:**
- ESP32: ~2000 LEDs total (all channels)
- ESP32-S3 with PSRAM: ~4000 LEDs

**Network:**
- WiFi for all control
- MQTT for automation
- E1.31 for professional (optional)

## Cost Breakdown

**4-Channel System (1200 LEDs):**
- Controller hardware: $50
- Power supply (60A): $80
- LED strips (4× 5m WS2813): $160
- Wire and connectors: $40
- Enclosure: $20
- **Total: ~$350**

**8-Channel System (2400 LEDs):**
- Controller hardware (S3): $80
- Power supply (100A): $150
- LED strips (8× 5m): $320
- Wire and distribution: $80
- Professional enclosure: $50
- **Total: ~$680**

## Changelog

- v1.0.0 - Initial multi-channel controller release

## Resources

- [WLED Multi-Output Guide](https://kno.wled.ge/features/multi-strip/)
- [WS2813 Datasheet](https://www.led-stuebchen.de/download/WS2813_V1.2_EN.pdf)
- [Power Supply Sizing](https://wled-calculator.github.io/)

## Credits

- WLED by Aircookie
- Multi-strip support by WLED contributors
- Community implementations

## License

MIT License (same as WLED)

---

**Professional-grade multi-channel LED control!** 🏢✨
