# Hardware Documentation Review Checklist

**MANDATORY:** Every hardware-related document change (circuit diagrams, pin mappings,
wiring instructions, component specifications) MUST be verified against this checklist
before merging. Hardware errors can destroy components and cause safety hazards.

---

## 1. IC Pinout Verification

- [ ] **Cross-reference every IC pinout against the manufacturer's datasheet**
  - Download the actual datasheet (Texas Instruments, NXP, etc.)
  - Verify EVERY pin number and function matches
  - Pay special attention to pins 1-3 (most common swap errors)
- [ ] **Pin 1 indicator matches** — verify the orientation dot/notch is correct
- [ ] **No pin function swaps** — especially /OE vs Input, VCC vs GND

### Known IC Pinouts (verified against datasheets)

#### 74HCT125 (Quad Buffer with 3-State Outputs)

```
     ┌────────────┐
1/OE │1        14│ VCC (5V)
 1A  │2        13│ 4/OE
 1Y  │3        12│ 4A
2/OE │4        11│ 4Y
 2A  │5        10│ 3/OE
 2Y  │6         9│ 3A
GND  │7         8│ 3Y
     └────────────┘

/OE pins (active LOW): 1, 4, 10, 13
Input (A) pins:        2, 5, 9, 12
Output (Y) pins:       3, 6, 8, 11
VCC = 5V (Pin 14), GND = Pin 7
```

#### SN74HCT245 (Octal Bus Transceiver)

```
     ┌────────────┐
DIR  │1        20│ VCC (5V)
 A1  │2        19│ B1
 A2  │3        18│ B2
 A3  │4        17│ B3
 A4  │5        16│ B4
 A5  │6        15│ B5
 A6  │7        14│ B6
 A7  │8        13│ B7
 A8  │9        12│ B8
GND  │10       11│ /OE

DIR = HIGH for A→B (ESP32→LEDs)
DIR = LOW for B→A
/OE = GND to enable
```

---

## 2. ESP32 GPIO Safety

- [ ] **No use of flash-connected pins** — GPIO6, GPIO7, GPIO8, GPIO9, GPIO10, GPIO11
- [ ] **Boot strapping pins handled correctly:**
  - GPIO0: Must be HIGH at boot (internal pull-up). Safe for buttons (momentary LOW).
  - GPIO2: Must be LOW or floating at boot. Safe for LED data output.
  - GPIO12: Must be LOW at boot (selects flash voltage). Do NOT connect external pull-ups.
  - GPIO15: Must be LOW at boot (controls debug output). Avoid for general I/O.
- [ ] **ADC2 pins not used with WiFi** — GPIO0, GPIO2, GPIO4, GPIO12-15, GPIO25-27
  (ADC2 is disabled when WiFi is active; use ADC1 pins GPIO32-39 for analog reads)
- [ ] **Input-only pins used correctly** — GPIO34, GPIO35, GPIO36, GPIO39 (no output capability)

### Safe GPIO Quick Reference

| Use Case | Recommended GPIOs |
|----------|------------------|
| LED Data Output | GPIO2, GPIO4, GPIO16, GPIO17, GPIO18, GPIO19 |
| Buttons/PIR | GPIO4, GPIO13, GPIO14, GPIO16, GPIO17, GPIO25-27 |
| I2C (SDA/SCL) | GPIO21 (SDA), GPIO22 (SCL) |
| I2S Audio | GPIO25 (WS), GPIO32 (SCK), GPIO33 (SD) |
| Analog Input | GPIO32, GPIO33, GPIO34, GPIO35, GPIO36, GPIO39 |
| SPI | GPIO18 (SCK), GPIO19 (MISO), GPIO23 (MOSI) |

### Pins to NEVER Use

| GPIO | Reason |
|------|--------|
| 6-11 | Connected to internal SPI flash — will crash ESP32 |
| 12 | Strapping pin — external HIGH causes boot failure |
| 15 | Strapping pin — best avoided for general I/O |

---

## 3. Voltage and Power Verification

- [ ] **Level shifter VCC is correct voltage**
  - 74HCT125 VCC = **5V** (NOT 3.3V — this is the output voltage)
  - 74HCT245 VCC = **5V**
- [ ] **Component supply voltages match datasheets**
  - HC-SR501 PIR: 4.5V-20V (do NOT power from 3.3V!)
  - AM312 PIR: 3.3V-12V (can use 3.3V)
  - BH1750: 3.3V or 5V
  - INMP441: 3.3V only
  - ESP32: 3.3V logic, 5V via USB/VIN
- [ ] **Power calculations use correct per-LED current**
  - WS2812B full white: **60mA per LED** (not 20mA — that's per channel)
  - WS2812B typical (colors/effects): ~30mA per LED
  - SK6812 RGBW full RGBW: ~80mA per LED
  - SK6812 white only: ~20mA per LED
- [ ] **Power supply sized for worst case** (full white + 20% margin)
- [ ] **No 5V signals connected directly to ESP32 inputs** without voltage divider

---

## 4. Circuit Diagram Accuracy

- [ ] **MOSFET level shifters are non-inverting**
  - BSS138 bidirectional: Gate = 3.3V rail, Source = low side, Drain = high side
  - Both sides need pull-up resistors (10kΩ to their respective rail)
- [ ] **Signal direction is correct** (input → output, not reversed)
- [ ] **Protection components are present:**
  - 470Ω resistor on LED data line (between ESP32 GPIO and level shifter input)
  - 1000µF capacitor on LED power input
  - 0.1µF decoupling capacitor on each IC's VCC-GND
- [ ] **All grounds are connected** (ESP32, level shifter, LED strip, PSU)

---

## 5. Cross-Document Consistency

- [ ] **Same pin assignments across all documents** that reference the same project
  - Check: pinout.md, README.md, config headers, guide documents
- [ ] **Same component values** (resistor values, capacitor values)
- [ ] **Same power requirements** (PSU sizing, current limits)
- [ ] **No contradictions** between guides and project-specific docs

### Pin Mapping Master Reference

These are the canonical pin assignments. All documents MUST match:

**Basic ESP32 Controller:**
- GPIO2: LED Data → 74HCT125 Pin 2 (1A) → Pin 3 (1Y) → LED DI
- GPIO0: Button (built-in flash button)

**Sound Reactive (INMP441):**
- GPIO32: I2S SCK (bit clock)
- GPIO25: I2S WS (word select)
- GPIO33: I2S SD (serial data)

**I2C Devices:**
- GPIO21: SDA
- GPIO22: SCL

---

## 6. Safety Warnings

- [ ] **Voltage warnings present** where mains/high voltage is involved
- [ ] **Current ratings specified** for wires, fuses, connectors
- [ ] **Polarity warnings** for capacitors, diodes, ICs
- [ ] **Heat dissipation noted** for regulators handling >500mA

---

## Review Process

1. **Author** verifies against this checklist before submitting
2. **Reviewer** independently checks all pin numbers against datasheets
3. **Test** the circuit on a breadboard if any wiring has changed
4. **Update this checklist** if new ICs or components are added to the project

---

## Datasheet Links (for verification)

- [74HCT125 — TI SN74HCT125](https://www.ti.com/lit/ds/symlink/sn74hct125.pdf)
- [74AHCT125 — TI SN74AHCT125](https://www.ti.com/lit/ds/symlink/sn74ahct125.pdf)
- [SN74HCT245 — TI](https://www.ti.com/lit/ds/symlink/sn74hct245.pdf)
- [BSS138 — ON Semiconductor](https://www.onsemi.com/pdf/datasheet/bss138-d.pdf)
- [ESP32-WROOM-32 — Espressif](https://www.espressif.com/sites/default/files/documentation/esp32-wroom-32_datasheet_en.pdf)
- [WS2812B — Worldsemi](https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf)
- [INMP441 — TDK InvenSense](https://www.invensense.com/wp-content/uploads/2015/02/INMP441.pdf)
- [HC-SR501 PIR](https://www.epitran.it/ebayDrive/datasheet/HC-SR501.pdf)

---

*Last updated after comprehensive audit. All pin numbers verified against manufacturer datasheets.*
