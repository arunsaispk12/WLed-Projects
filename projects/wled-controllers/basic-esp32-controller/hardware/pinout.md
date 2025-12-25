# Basic ESP32 Controller - Pinout

## Pin Assignments

### Primary Connections

| ESP32 Pin | GPIO# | Function | Connected To | Notes |
|-----------|-------|----------|--------------|-------|
| 3V3 | - | Power Output | Level Shifter VCC (Low) | Max 500mA |
| GND | - | Ground | Common Ground | Multiple GND pins available |
| 5V/Vin | - | Power Input | USB or External 5V | For ESP32 power |
| GPIO2 | 2 | LED Data Output | Via 470Ω → 74HCT125 → LED Data | Built-in LED also on GPIO2 |
| GPIO0 | 0 | Button Input | Built-in Flash Button | Pull-up to 3.3V, active LOW |

### Available for Future Use

| ESP32 Pin | GPIO# | Function | Notes |
|-----------|-------|----------|-------|
| GPIO4 | 4 | Digital I/O | Available for second button or sensor |
| GPIO16 | 16 | Digital I/O | Good for rotary encoder CLK |
| GPIO17 | 17 | Digital I/O | Good for rotary encoder DT |
| GPIO21 | 21 | I2C SDA | For OLED display or sensors |
| GPIO22 | 22 | I2C SCL | For OLED display or sensors |
| GPIO25 | 25 | I2S/DAC | For sound reactive (I2S WS) |
| GPIO32 | 32 | ADC/I2S | For sound reactive (I2S SCK) |
| GPIO33 | 33 | ADC/I2S | For sound reactive (I2S SD) |

### Do NOT Use (Reserved/Problem Pins)

| ESP32 Pin | GPIO# | Reason |
|-----------|-------|--------|
| GPIO6-11 | 6-11 | Connected to flash memory |
| GPIO12 | 12 | Boot config (must be LOW during boot) |
| GPIO15 | 15 | Boot config |

## Level Shifter Connections (74HCT125)

| 74HCT125 Pin | Pin Name | Connected To |
|--------------|----------|--------------|
| 1 | /OE (Enable) | GND (always enabled) |
| 2 | A1 (Input 1) | ESP32 GPIO2 via 470Ω resistor |
| 3 | Y1 (Output 1) | LED Strip Data Line |
| 7 | GND | Common Ground |
| 14 | VCC | 5V Power |

## Power Distribution

```
5V Power Supply (3A)
    │
    ├─── [1000µF Capacitor] ─── GND
    │
    ├─── LED Strip 5V Input
    │
    ├─── 74HCT125 Pin 14 (VCC)
    │
    └─── ESP32 5V/Vin (or use separate USB power)

Common GND:
- Power Supply GND
- LED Strip GND
- 74HCT125 Pin 7
- ESP32 GND
```

## Signal Path

```
ESP32 GPIO2
    │
    └─── [470Ω Resistor]
              │
              └─── 74HCT125 Pin 2 (Input)
                        │
                   74HCT125 Pin 3 (Output)
                        │
                        └─── LED Strip Data Input (DIN)
```

## Component Values

| Component | Value | Location | Purpose |
|-----------|-------|----------|---------|
| Resistor | 470Ω 1/4W | Data Line | GPIO protection, signal conditioning |
| Capacitor | 1000µF 10V+ | LED Power Input | Voltage spike protection |
| Level Shifter | 74HCT125 | Between ESP32 and LEDs | 3.3V to 5V conversion |

## Breadboard Layout

```
                    ESP32 DevKit
     ┌─────────────────────────────────────┐
     │  [   ][ ][ ][ ][ ][ ][ ][ ][ ][ ]   │
     │  [ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][  ] │
     └─────────────────────────────────────┘
          │  │                       │  │
       GPIO2 GND                    3V3 5V
          │  │                       │  │
          │  │                       │  │
     [470Ω]  │                       │  │
          │  │                       │  │
     ┌────┴──┴───────────────────────┴──┴─┐
     │                                     │
     │         74HCT125                    │
     │  Pin2  Pin7        Pin14  Pin3      │
     └────┬────┬─────────────┬────┬────────┘
          │    │             │    │
          │    └─────GND─────┘    │
          │                       │
    Data Input              To LED Strip Data
```

## Wire Gauge Recommendations

| Connection | Wire Gauge | Max Length |
|------------|------------|------------|
| 5V Power to LEDs | 18-20 AWG | 2m |
| LED Data | 22-24 AWG | 3m max |
| ESP32 Power | 22-24 AWG | 1m |
| Ground | Same as power | Any |

## Current Calculations

```
LED Current (60 LEDs):
- Per LED maximum: 60mA (full white)
- Per LED typical: 30mA (colors/effects)
- Total max: 60 × 60mA = 3.6A
- Total typical: 60 × 30mA = 1.8A
- Recommended PSU: 5V 3A minimum

ESP32 Current:
- Idle: ~80mA
- WiFi active: ~160mA
- Peak: ~240mA

Total System:
- Maximum: 3.6A + 0.24A = 3.84A
- Recommended: 5V 5A power supply for safety margin
```

## Testing Points

For troubleshooting, measure voltage at these points:

| Test Point | Expected Voltage | Condition |
|------------|------------------|-----------|
| PSU Output | 5.0V ±0.1V | Always |
| LED Strip 5V Input | 4.9-5.1V | Under load |
| ESP32 3.3V Pin | 3.2-3.4V | Always |
| GPIO2 (HIGH) | 3.3V | When data active |
| 74HCT125 Output (HIGH) | 5.0V | When data active |

## Safety Notes

⚠️ **Before Powering On:**
1. Verify all connections with continuity tester
2. Check no shorts between 5V and GND
3. Confirm correct polarity on capacitor
4. Verify level shifter orientation

⚠️ **During Operation:**
1. Monitor component temperature
2. Check for loose connections
3. Verify LED strip doesn't exceed current rating

## Modifications

### Adding a Second Button (GPIO4)

```
GPIO4 ──┬── [Push Button] ── GND
        │
        └── [10kΩ] ── 3.3V
```

### Adding I2C Display

```
GPIO21 (SDA) ──── Display SDA
GPIO22 (SCL) ──── Display SCL
3.3V ───────────── Display VCC
GND ────────────── Display GND
```

### Adding Rotary Encoder

```
GPIO16 ──── Encoder CLK
GPIO17 ──── Encoder DT
GPIO5 ───── Encoder SW (button)
3.3V ───── Encoder +
GND ────── Encoder GND
```

## Revision History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2024-XX-XX | Initial pinout for basic controller |
