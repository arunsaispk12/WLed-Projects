# Hardware Pinout

> **IMPORTANT:** Before modifying this file, review the
> [Hardware Review Checklist](../../../docs/HARDWARE_REVIEW_CHECKLIST.md).
> All pin numbers and voltages MUST be verified against manufacturer datasheets.

## ESP32 Pin Assignments

### Primary Connections

| ESP32 Pin | GPIO# | Function | Connected To | Notes |
|-----------|-------|----------|--------------|-------|
| 3V3 | - | Power | Sensors, Pull-ups | Max 500mA |
| GND | - | Ground | Common Ground | Multiple GND pins available |
| 5V | - | Power In | USB or Vin | For powering ESP32 |
| GPIO2 | 2 | LED Data | WS2812B Data In | Via level shifter & resistor |
| GPIO0 | 0 | Button/Boot | Flash Button | Pull-up to 3.3V |

### Optional Connections

| ESP32 Pin | GPIO# | Function | Connected To | Notes |
|-----------|-------|----------|--------------|-------|
| GPIO4 | 4 | Button | Mode Button | Optional control |
| GPIO16 | 16 | Encoder CLK | Rotary Encoder | If using encoder |
| GPIO17 | 17 | Encoder DT | Rotary Encoder | If using encoder |
| GPIO5 | 5 | Encoder SW | Rotary Encoder | Button press |
| GPIO21 | 21 | I2C SDA | Display/Sensors | Pull-up to 3.3V |
| GPIO22 | 22 | I2C SCL | Display/Sensors | Pull-up to 3.3V |
| GPIO25 | 25 | I2S WS | INMP441 Mic | For sound reactive |
| GPIO32 | 32 | I2S SCK | INMP441 Mic | For sound reactive |
| GPIO33 | 33 | I2S SD | INMP441 Mic | For sound reactive |

### Multi-Output Configuration

For controlling multiple LED strips:

| ESP32 Pin | GPIO# | Function | LED Strip | Max LEDs |
|-----------|-------|----------|-----------|----------|
| GPIO2 | 2 | LED Data 1 | Strip 1 | 500 |
| GPIO4 | 4 | LED Data 2 | Strip 2 | 500 |
| GPIO16 | 16 | LED Data 3 | Strip 3 | 500 |
| GPIO17 | 17 | LED Data 4 | Strip 4 | 500 |

**Do NOT use:** GPIO6-11 (flash), GPIO12 (boot), GPIO15 (boot strapping)

## Power Distribution

### Power Connections

```
Power Supply (5V, XA)
    │
    ├─── ESP32 5V/Vin (or use USB)
    │    └─── 3.3V Regulator Internal
    │         └─── ESP32 VCC (3.3V)
    │
    └─── LED Strip 5V
         └─── Capacitor (1000µF) to GND
```

### Current Calculations

```
LED Current:
- Per LED at full white: ~60mA
- Per LED typical: ~20-40mA
- Total = Number of LEDs × Current per LED

Example for 60 LEDs:
- Maximum: 60 × 60mA = 3600mA = 3.6A
- Typical: 60 × 30mA = 1800mA = 1.8A
- Recommended PSU: 5V 5A (with headroom)

ESP32 Current:
- Idle: ~80mA
- Active WiFi: ~160mA
- Peak: ~240mA
```

## Wiring Guidelines

### Cable Specifications

| Connection | Wire Gauge | Max Length | Notes |
|------------|------------|------------|-------|
| 5V Power to LEDs | 18 AWG | 2m | Use thicker for longer runs |
| LED Data | 22-24 AWG | 3m | Keep as short as possible |
| Signal/Control | 24-26 AWG | 1m | Fine for low current |
| Ground | 18 AWG | Any | Same as power wire |

### Best Practices

1. **Power Injection**
   - For >150 LEDs, inject power at multiple points
   - Every 150-200 LEDs recommended
   - Always inject 5V and GND together

2. **Data Line**
   - Keep data wire short (<3m if possible)
   - Use twisted pair with ground for long runs
   - Add 220-470Ω resistor close to ESP32

3. **Ground**
   - Single common ground for all components
   - Heavy gauge wire for main ground
   - Star grounding from PSU

## Protection Components

### Required

| Component | Value | Location | Purpose |
|-----------|-------|----------|---------|
| Capacitor | 1000µF 10V | LED Power Input | Voltage stabilization |
| Resistor | 470Ω | Data Line | GPIO protection |
| Capacitor | 100µF | ESP32 Power | ESP32 stabilization |

### Recommended

| Component | Value | Location | Purpose |
|-----------|-------|----------|---------|
| Diode | 1N5819 | Power Input | Reverse polarity protection |
| Capacitor | 0.1µF | Each IC VCC | Decoupling |
| TVS Diode | 5V | Power Rails | Surge protection |
| Fuse | Rated Current | Power Input | Overcurrent protection |

## Level Shifter Configuration

### Using 74HCT125

```
ESP32 GPIO2 ──[470Ω]── 74HCT125 Pin 2 (A1)
                           │
                    Pin 1 (/OE) ── GND
                    Pin 3 (Y1) ────── LED Data
                    Pin 14 (VCC) ─── 5V
                    Pin 7 (GND) ──── GND
```

| 74HCT125 Pin | Connection | Notes |
|--------------|------------|-------|
| 1 (/OE) | GND | Always enabled |
| 2 (A1) | ESP32 GPIO2 via 470Ω | Input |
| 3 (Y1) | LED Strip Data | Output |
| 7 (GND) | Common GND | - |
| 14 (VCC) | 5V | Power |

### Alternative: MOSFET Level Shifter (BSS138 Bidirectional)

```
Component List:
- BSS138 N-Channel MOSFET
- 10kΩ resistors (2x)

Connections (bidirectional, non-inverting):
3.3V ──[10kΩ]──┬────────────────┬──[10kΩ]── 5V
               │                │
          (Source)          (Drain)
               │   ┌───────┐   │
               └───│S     D│───┘
                   │ BSS138│
               ┌───│G      │
               │   └───────┘
              3.3V (Gate = LOW voltage rail)
               │                │
ESP32 GPIO2 ───┘                └── LED Data

Gate = 3.3V, Source = low-voltage side, Drain = high-voltage side
```

## Testing Points

For troubleshooting, measure at these points:

| Test Point | Expected Value | Notes |
|------------|----------------|-------|
| PSU Output | 5.0V ±0.1V | At power supply |
| LED 5V | 4.8-5.2V | At LED strip input |
| ESP32 3.3V | 3.2-3.4V | At ESP32 VCC |
| GPIO Output | 3.3V (HIGH) | At ESP32 pin |
| Level Shift Out | 5.0V (HIGH) | After level shifter |
| LED Current | Calculated | Use current meter |

## Safety Notes

1. **Before Powering On**
   - Verify all connections
   - Check for shorts with multimeter
   - Confirm correct voltage levels
   - Double-check polarity

2. **During Operation**
   - Monitor temperature of components
   - Check for unusual sounds/smells
   - Verify LED behavior is correct

3. **Modifications**
   - Disconnect power before changes
   - Document any changes to this pinout
   - Test thoroughly after modifications

## Schematic Reference

See `schematic.pdf` for complete circuit diagram.

## PCB Layout

If using custom PCB, see main hardware documentation:
- `../../hardware/pcb-designs/`
- `../../hardware/schematics/`

## Revision History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | YYYY-MM-DD | Initial pinout | Your Name |
| | | | |
