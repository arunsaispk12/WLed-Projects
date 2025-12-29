# Power Supply Selection Guide

Comprehensive guide to selecting the right power supply for your WLED project, ensuring safety, reliability, and optimal performance.

## Table of Contents

1. [Understanding Power Requirements](#understanding-power-requirements)
2. [Power Supply Types](#power-supply-types)
3. [Voltage Selection](#voltage-selection)
4. [Sizing Your Power Supply](#sizing-your-power-supply)
5. [Quality & Safety](#quality--safety)
6. [Recommended Power Supplies](#recommended-power-supplies)
7. [Power Injection](#power-injection)
8. [Protection & Fusing](#protection--fusing)
9. [Special Considerations](#special-considerations)
10. [Common Mistakes](#common-mistakes)
11. [Buying Guide](#buying-guide)

---

## Understanding Power Requirements

### LED Power Consumption

Different LED types consume different amounts of power:

| LED Type | Voltage | Current per LED (Full White) | Power per LED |
|----------|---------|------------------------------|---------------|
| WS2811 (5V) | 5V | 60mA | 0.3W |
| WS2812B | 5V | 60mA | 0.3W |
| WS2813 | 5V | 60mA | 0.3W |
| SK6812 RGB | 5V | 60mA | 0.3W |
| SK6812 RGBW | 5V | 70mA | 0.35W |
| WS2811 (12V) | 12V | 60mA | 0.72W |
| WS2815 | 12V | 15mA | 0.18W |
| APA102 | 5V | 60mA | 0.3W |

**Note:** WS2811 comes in both 5V and 12V versions - the 12V version draws the same current per LED but at higher voltage (more total power).

### Power Calculation Formula

```
Step 1: Calculate maximum LED power
Max LED Power (W) = Number of LEDs × Power per LED × 0.8

Step 2: Add controller power
Controller Power = 1-2W (ESP32 + accessories)

Step 3: Total power
Total Power (W) = LED Power + Controller Power

Step 4: Add safety margin
Recommended PSU Wattage = Total Power × 1.25

Step 5: Calculate current
Required Current (A) = Recommended PSU Wattage / Voltage
```

**Why 0.8 multiplier?**
- Most effects don't use full white on all LEDs
- Typical usage is 50-80% of maximum
- Using 80% gives realistic power requirements

**Example Calculation:**

```
300 WS2812B LEDs at 5V:

1. Max LED Power = 300 × 0.3W × 0.8 = 72W
2. Controller Power = 2W
3. Total Power = 72W + 2W = 74W
4. With safety margin = 74W × 1.25 = 92.5W
5. Current needed = 92.5W / 5V = 18.5A

Recommendation: 5V 20A power supply (100W)
```

### Quick Reference Table

| Number of LEDs | WS2812B (5V) | WS2815 (12V) | SK6812 RGBW (5V) |
|----------------|--------------|--------------|------------------|
| 50 | 5V 3A | 12V 1A | 5V 3A |
| 100 | 5V 5A | 12V 2A | 5V 6A |
| 150 | 5V 8A | 12V 3A | 5V 10A |
| 200 | 5V 10A | 12V 3A | 5V 12A |
| 300 | 5V 20A | 12V 5A | 5V 20A |
| 500 | 5V 30A | 12V 8A | 5V 35A |
| 1000 | 5V 60A* | 12V 15A | 5V 70A* |

*Requires multiple power supplies with injection

---

## Power Supply Types

### 1. Switching Power Supply (SMPS) - Recommended

**Description:**
- Modern, efficient design
- Converts AC mains to DC
- Regulated output voltage
- Most common for LED projects

**Advantages:**
✅ Very efficient (85-95%)
✅ Stays cool (less heat)
✅ Compact size
✅ Wide input voltage (110V-240V AC)
✅ Regulated output (stable voltage)
✅ Available in high wattages
✅ Affordable

**Disadvantages:**
❌ Can produce electrical noise (usually not an issue)
❌ Cheap models may have poor filtering
❌ Quality varies widely

**Best For:**
- 95% of WLED projects
- Permanent installations
- High power requirements
- Indoor and outdoor use

**Form Factors:**

**Enclosed/Metal Case:**
```
┌─────────────────────┐
│  Power Supply       │
│  5V 20A             │
│  ┌──┐      ┌──┐    │
│  │AC│      │DC│    │
│  └──┘      └──┘    │
└─────────────────────┘
```
- Fully enclosed metal case
- Screw terminals for AC and DC
- Fan cooled (larger models)
- Industrial appearance
- Best for permanent installations

**Open Frame:**
```
┌─────────────┐
│ ┌─────────┐ │
│ │Components│ │
│ └─────────┘ │
└─────────────┘
```
- Exposed PCB and components
- Lighter and smaller
- Requires external enclosure
- Cheaper
- Good for custom builds

**LED Driver Style:**
```
┌──────────────────────┐
│ Waterproof LED Driver│
│ IP67  12V 5A         │
└──────────────────────┘
```
- Potted/waterproof construction
- Designed for LED applications
- Often IP67 rated
- More expensive
- Perfect for outdoor installations

---

### 2. Linear Power Supply

**Description:**
- Old-school transformer + regulator design
- Simple, reliable technology
- Heavy and inefficient

**Advantages:**
✅ Very clean power (no switching noise)
✅ Extremely reliable
✅ Long lifespan
✅ No EMI/RFI noise

**Disadvantages:**
❌ Very inefficient (50-60%)
❌ Generates lots of heat
❌ Heavy and bulky
❌ Expensive
❌ Limited to lower wattages

**Best For:**
- Audio/sensitive applications
- Low power projects (<50W)
- When noise is critical
- (Rarely needed for WLED)

---

### 3. USB Power Supply/Adapter

**Description:**
- Standard phone/tablet chargers
- 5V output via USB port
- Limited current (typically 1-3A)

**Advantages:**
✅ Readily available
✅ Very portable
✅ Safe (5V only)
✅ Built-in cable
✅ Compact

**Disadvantages:**
❌ Limited power (5-15W typical)
❌ May not be regulated
❌ Cheap ones can be dangerous
❌ Only 5V

**Best For:**
- Very small projects (<50 LEDs)
- Prototyping
- Portable/temporary setups
- Testing

**Safety Warning:**
⚠️ Only use UL/CE certified USB adapters. Cheap no-name adapters can be fire hazards!

---

### 4. Computer PSU (ATX)

**Description:**
- Standard desktop computer power supply
- Multiple voltage rails (3.3V, 5V, 12V)
- High power capacity

**Advantages:**
✅ Very affordable (used/surplus)
✅ Multiple voltages available
✅ High current on 5V and 12V
✅ Built-in fan cooling
✅ Reliable (if quality brand)

**Disadvantages:**
❌ Requires ATX power-on trick
❌ Bulky and heavy
❌ Overkill for most projects
❌ Wasted features (unused voltages)
❌ Fan can be noisy

**How to Use:**
```
1. Short the green wire to any black wire to turn ON
2. Use yellow wires for 12V
3. Use red wires for 5V
4. Use black wires for ground
```

**Best For:**
- Large installations (500+ LEDs)
- Multi-voltage projects
- Budget builds
- When you have one available

**Popular Models:**
- EVGA 500W+
- Corsair 450W+
- Seasonic 500W+

---

### 5. Battery/Portable Power

**Description:**
- Rechargeable battery packs
- Power banks
- LiPo/Li-ion batteries

**Advantages:**
✅ Completely portable
✅ No AC power needed
✅ Great for wearables
✅ Safe (DC only)

**Disadvantages:**
❌ Limited runtime
❌ Requires recharging
❌ Lower power capacity
❌ More expensive
❌ Battery degradation over time

**Types:**

**USB Power Bank:**
- Output: 5V, 2-3A typical
- Capacity: 10,000-30,000 mAh
- Good for small strips (<100 LEDs)
- Easy to use

**LiPo Battery:**
- Voltage: 3.7V (1S), 7.4V (2S), 11.1V (3S)
- Requires voltage regulator/buck converter
- High power density
- Needs proper charging circuit
- More dangerous (can catch fire if damaged)

**Best For:**
- Wearable projects
- Portable displays
- Temporary outdoor setups
- Events/parties

**Runtime Calculation:**
```
Runtime (hours) = Battery Capacity (Wh) / Power Draw (W)

Example:
10,000mAh power bank at 5V = 50Wh
50 WS2812B LEDs at 80% brightness = ~12W
Runtime = 50Wh / 12W = 4.2 hours
```

---

### 6. Mean Well Power Supplies (Premium)

**Description:**
- Professional-grade brand
- Industrial quality
- Excellent reliability
- Higher cost

**Popular Series:**

**LRS Series (Enclosed):**
- Budget-friendly Mean Well
- Good quality/price ratio
- Excellent for WLED projects
- Available: LRS-50, LRS-100, LRS-150, LRS-350

**RS Series (Enclosed):**
- Step up from LRS
- Better efficiency
- More features (remote on/off)
- Very reliable

**HLG Series (LED Driver):**
- Designed for LED lighting
- IP67 waterproof
- Constant voltage or constant current
- Perfect for outdoor

**SE Series (Open Frame):**
- Cost-effective
- Open frame design
- Need enclosure
- Good for DIY projects

**Best For:**
- Professional installations
- Commercial projects
- When reliability is critical
- Outdoor installations (HLG)

---

## Voltage Selection

### 5V Power Supplies

**LED Types:** WS2812B, WS2813, SK6812, APA102, WS2811 (5V version)

**Advantages:**
✅ Most common LED type
✅ Can use USB power for small projects
✅ Same voltage as ESP32 logic (simpler)
✅ Widest selection of power supplies
✅ Easy to find

**Disadvantages:**
❌ Voltage drop over distance
❌ Requires power injection for long runs
❌ Higher current = thicker wires needed
❌ Limited to ~150 LEDs per injection point

**Voltage Drop:**
```
5V at start → 4.5V at 100 LEDs → 4.0V at 150 LEDs (too low!)
```

**Best For:**
- Projects with <150 LEDs
- Single strip installations
- Indoor use
- Prototypes
- USB-powered projects

**Recommended Power Supplies:**
- Small (1-50 LEDs): 5V 3A
- Medium (50-100 LEDs): 5V 5-10A
- Large (100-300 LEDs): 5V 20A+ with injection
- Very Large (300+ LEDs): Multiple 5V 20A supplies

---

### 12V Power Supplies

**LED Types:** WS2815, WS2811 (12V version)

**Advantages:**
✅ Much less voltage drop
✅ Longer runs without injection (300+ LEDs)
✅ Lower current = thinner wires
✅ Better for long-distance runs
✅ More efficient power distribution

**Disadvantages:**
❌ Fewer LED type options
❌ Can't use USB power
❌ More expensive LEDs
❌ Need 12V-safe components
❌ Can't mix with 5V LEDs

**Voltage Drop:**
```
12V at start → 11.5V at 300 LEDs → 11.0V at 400 LEDs (still good!)
```

**Best For:**
- Long LED runs (>5 meters)
- Architectural lighting
- Outdoor installations
- Professional projects
- Minimizing power injection points

**Recommended Power Supplies:**
- Small (1-100 LEDs): 12V 3A
- Medium (100-300 LEDs): 12V 5A
- Large (300-500 LEDs): 12V 10A
- Very Large (500+ LEDs): 12V 20A+

---

### 24V Power Supplies

**LED Types:** Some WS2815, specialized addressable LEDs

**Advantages:**
✅ Even less voltage drop than 12V
✅ Very long runs possible
✅ Lower current requirements
✅ Professional installations

**Disadvantages:**
❌ Very limited LED selection
❌ Not common for addressable LEDs
❌ Higher voltage = more dangerous
❌ Expensive

**Best For:**
- Extremely long runs (architectural)
- Rarely needed for typical WLED
- Professional/commercial only

**Note:** Most WLED users don't need 24V. Stick with 5V or 12V.

---

## Sizing Your Power Supply

### Calculate vs. Measure Approach

**Calculate (Recommended for Planning):**
1. Count your LEDs
2. Multiply by power per LED
3. Apply 0.8 usage factor
4. Add 25% safety margin
5. Round up to next available size

**Measure (For Optimization):**
1. Set LEDs to full white
2. Measure actual current draw
3. Add 20% safety margin
4. This gives minimum size

### Common Sizing Mistakes

❌ **Too Small:**
- Power supply overheats
- Voltage sags under load
- LEDs flicker or dim
- Shortened PSU lifespan
- Potential fire hazard

❌ **Too Large:**
- Wasted money
- Less efficient (PSU efficiency drops at low load)
- Unnecessarily bulky
- Not a safety issue, just wasteful

✅ **Just Right:**
- Operating at 60-80% of rated capacity
- Good efficiency
- Room for expansion
- Long PSU lifespan
- Optimal cost/performance

### Safety Margins

**Minimum Margin: 20%**
- Bare minimum
- No room for expansion
- PSU runs hot
- Not recommended

**Recommended Margin: 25-30%**
- Safe operating range
- Room for brightness adjustments
- PSU stays cool
- Good for most projects

**Conservative Margin: 50%**
- Very safe
- Plenty of expansion room
- Maximum PSU lifespan
- Good for critical applications

### Example Sizing

**Project:** 200 WS2812B LEDs at 5V

```
Calculation:
1. LED Power: 200 × 0.3W × 0.8 = 48W
2. Controller: 2W
3. Total: 50W
4. Safety margin (25%): 50W × 1.25 = 62.5W
5. Current: 62.5W / 5V = 12.5A

Options:
- Minimum: 5V 12A (60W) - tight fit
- Recommended: 5V 15A (75W) - comfortable
- Conservative: 5V 20A (100W) - plenty of headroom
```

---

## Quality & Safety

### Quality Indicators

#### High-Quality Power Supply

✅ **Brand name** (Mean Well, TDK-Lambda, Delta, etc.)
✅ **Safety certifications** (UL, CE, FCC, RoHS)
✅ **Detailed specifications** (ripple, efficiency, etc.)
✅ **Regulated output** (±5% or better)
✅ **Overload protection** (current limiting, auto-restart)
✅ **Good documentation** (datasheet available)
✅ **Thermal protection** (automatic shutdown if too hot)
✅ **Low ripple** (<100mV)
✅ **Solid construction** (no loose parts when shaken)
✅ **Proper ventilation** (cooling holes, fan if needed)

#### Low-Quality/Dangerous Power Supply

❌ No brand name or unknown brand
❌ No certifications
❌ Vague specifications ("12V adapter")
❌ Poor regulation (voltage varies widely)
❌ No protection circuits
❌ Extremely cheap price
❌ Lightweight/flimsy construction
❌ Strange smell when operating
❌ Gets very hot during use
❌ Found on sketchy websites

### Safety Certifications

**UL (Underwriters Laboratories) - USA:**
- Independent safety testing
- Strict standards
- Look for "UL Listed" mark
- Preferred in North America

**CE (Conformité Européenne) - Europe:**
- EU safety standards
- Required for sale in Europe
- Look for CE mark
- Note: Fake CE marks exist (look for "China Export")

**FCC (Federal Communications Commission) - USA:**
- Electromagnetic interference standards
- Reduces electrical noise
- Important for sensitive electronics

**RoHS (Restriction of Hazardous Substances):**
- Environmental compliance
- No lead, mercury, cadmium
- Safe for disposal

**ETL (Intertek):**
- Alternative to UL
- Similar standards
- Also widely accepted

**TÜV (Technischer Überwachungsverein) - Germany:**
- German safety certification
- Very strict standards
- Indicates high quality

### Testing Your Power Supply

**Before First Use:**

1. **Visual Inspection:**
   - Check for damage
   - Look for certification marks
   - Verify voltage/current rating
   - Check wire connections

2. **No-Load Voltage Test:**
   - Measure output with multimeter
   - Should be within ±5% of rated voltage
   - 5V supply: 4.75V - 5.25V acceptable
   - 12V supply: 11.4V - 12.6V acceptable

3. **Load Test:**
   - Connect LEDs
   - Measure voltage under load
   - Should remain stable within ±5%
   - Check for excessive heat

4. **Thermal Test:**
   - Run at 80% load for 30 minutes
   - PSU should not be too hot to touch
   - If too hot, reduce load or upgrade PSU

5. **Ripple Test (Advanced):**
   - Use oscilloscope to measure AC ripple
   - Should be <100mV peak-to-peak
   - Excessive ripple can cause LED flickering

### Failure Modes

**Power Supply Failures:**

**Overcurrent (Overload):**
- Symptom: PSU shuts down or restarts
- Cause: Too many LEDs for PSU rating
- Fix: Reduce load or upgrade PSU

**Overheat:**
- Symptom: PSU gets very hot, may shut down
- Cause: Poor ventilation, high ambient temp
- Fix: Improve cooling, reduce load

**Voltage Sag:**
- Symptom: LEDs dim, wrong colors at end of strip
- Cause: Undersized PSU or voltage drop
- Fix: Power injection or larger PSU

**Complete Failure:**
- Symptom: No output voltage
- Cause: Component failure, short circuit
- Fix: Replace PSU (don't attempt repair unless qualified)

**Intermittent:**
- Symptom: Random shutdowns, flickering
- Cause: Loose connection, failing PSU
- Fix: Check connections, replace PSU if needed

---

## Recommended Power Supplies

### Budget Tier ($10-30)

**For Small Projects (1-100 LEDs):**

**5V 10A (50W) Enclosed:**
- Generic switching PSU
- Widely available on Amazon
- Adequate for hobby use
- Look for UL/CE certification
- Price: ~$12-15

**12V 5A (60W) Enclosed:**
- Generic switching PSU
- Good for WS2815 projects
- Price: ~$12-15

**Where to Buy:**
- Amazon
- eBay
- AliExpress (longer shipping)

**Caution:** Verify certifications even on budget models!

---

### Mid-Range Tier ($30-60)

**For Medium Projects (100-300 LEDs):**

**Mean Well LRS-100-5:**
- Output: 5V 20A (100W)
- Excellent quality/price ratio
- UL/CE/TUV certified
- Reliable and efficient
- Price: ~$25-30
- **Highly Recommended**

**Mean Well LRS-150-5:**
- Output: 5V 30A (150W)
- Similar to LRS-100
- More headroom
- Price: ~$35-40

**Mean Well LRS-100-12:**
- Output: 12V 8.5A (102W)
- For 12V LED strips
- Price: ~$25-30

**Where to Buy:**
- Digi-Key
- Mouser
- Amazon
- Newark

---

### Professional Tier ($60-150+)

**For Large/Critical Installations:**

**Mean Well RSP-320-5:**
- Output: 5V 60A (300W)
- High power density
- Excellent efficiency (91%)
- Built-in fan
- Price: ~$70-80

**Mean Well HLG-240H-5:**
- Output: 5V 40A (200W)
- IP67 waterproof
- Designed for LED lighting
- Outdoor rated
- Price: ~$80-100
- **Best for Outdoor**

**Mean Well HLG-240H-12:**
- Output: 12V 16A (192W)
- IP67 waterproof
- For 12V strips
- Price: ~$80-100

**Mean Well SE-600-5:**
- Output: 5V 100A (500W)
- Open frame design
- Extremely high current
- Requires enclosure
- Price: ~$90-110

**TDK-Lambda LS-Series:**
- Premium industrial PSUs
- Extremely reliable
- High cost
- Overkill for most hobby projects
- Price: $100-200+

---

### USB Power (Micro Projects)

**For <50 LEDs:**

**Anker USB Charger:**
- Output: 5V 2-3A
- UL certified
- Reliable brand
- Price: ~$10-15
- Good for testing/small strips

**RAVPower USB Charger:**
- Similar to Anker
- Multiple ports available
- Price: ~$12-18

**Official Raspberry Pi Power Supply:**
- Output: 5V 3A
- High quality
- Good for small WLED projects
- Price: ~$8-10

---

### Computer PSU (Budget Large Projects)

**For 500+ LEDs on a Budget:**

**EVGA 500 W1:**
- 5V rail: ~20A
- 12V rail: ~35A
- Price: ~$30-40 (new)
- Price: ~$10-20 (used/surplus)

**Corsair CX450:**
- Quality brand
- Quiet operation
- Price: ~$40-50

**Seasonic S12III:**
- Excellent quality
- Very reliable
- Price: ~$50-60

**How to Use:**
1. Short green wire to black (power on)
2. Use multiple yellow wires for 12V (or red for 5V)
3. Use multiple black wires for ground
4. Stay within rated current for each rail

---

## Power Injection

### What is Power Injection?

**Problem:**
- LEDs far from power source get dim
- Colors appear incorrect
- Voltage drops over distance

**Solution:**
- Inject power at multiple points along the strip
- Maintains voltage throughout strip
- Allows longer runs

### When Do You Need It?

**5V LEDs:**
- Definitely needed: >150 LEDs in sequence
- Consider at: >100 LEDs
- Optional: <100 LEDs (but can improve performance)

**12V LEDs:**
- Definitely needed: >300 LEDs in sequence
- Consider at: >200 LEDs
- Optional: <200 LEDs

**Signs You Need Injection:**
- LEDs at end of strip are dimmer
- White appears yellow/orange at strip end
- Inconsistent colors
- Animations lag at strip end

### Injection Methods

#### Method 1: Parallel Power Only (Recommended)

```
Power Supply (+/-)
    │
    ├──────────────┬──────────────┬──────────── Power Lines
    │              │              │
[LED 1-100]   [LED 101-200]  [LED 201-300]
    │
    └──────────────────────────────────────── Data Line (no breaks!)
```

**How:**
1. Run power wires alongside LED strip
2. Connect power (+/-) every 100-150 LEDs (5V) or 200-300 LEDs (12V)
3. Data line remains unbroken
4. All injections from same power supply

**Advantages:**
- Maintains data signal integrity
- Simple to implement
- Most common method

#### Method 2: Multiple Power Supplies

```
PSU 1 (+/-)          PSU 2 (+/-)          PSU 3 (+/-)
    │                    │                    │
[LED 1-100]         [LED 101-200]        [LED 201-300]
    │                    │                    │
    └────── Data ────────┴────── Data ────────┘

  (All PSU grounds MUST be connected together!)
```

**CRITICAL:** All power supply grounds must be connected together!

**How:**
1. Use separate PSU for each section
2. Connect all PSU grounds together
3. Connect each PSU output to its section
4. Data line remains continuous

**Advantages:**
- Distributes load
- Can use smaller PSUs
- Each section independently powered

**Disadvantages:**
- More complex
- More expensive
- MUST connect grounds (easy to forget!)

### Injection Wire Sizing

Use appropriate wire gauge for injection runs:

**Short runs (<3 feet):**
- 5V, 10A: 18 AWG minimum
- 5V, 20A: 16 AWG minimum
- 12V, 10A: 20 AWG minimum

**Medium runs (3-10 feet):**
- 5V, 10A: 16 AWG
- 5V, 20A: 14 AWG
- 12V, 10A: 18 AWG

**Long runs (>10 feet):**
- Increase wire gauge by 2 sizes
- Or inject more frequently

See [Wire Selection Guide](WIRE_SELECTION_GUIDE.md) for details.

---

## Protection & Fusing

### Why Protect?

1. **Prevent Fire:** Overloaded wires can start fires
2. **Protect Equipment:** Shorts can damage expensive components
3. **Safety:** Protects users from electrical hazards
4. **Code Compliance:** May be required by electrical code

### Fusing

**Where to Fuse:**
```
AC Mains → [Fuse/Breaker] → Power Supply → [Fuse] → LEDs
```

**DC Side Fusing (Recommended):**

**Inline Fuse:**
- Place fuse on positive (+) wire
- Between PSU and LEDs
- Size fuse to 125% of expected current
- Use automotive blade fuses (cheap, available)

**Fuse Sizing:**
```
Expected Current × 1.25 = Fuse Rating

Example: 15A draw → Use 20A fuse
```

**Fuse Types:**

**Fast-Blow:**
- Reacts quickly to overcurrent
- Good for electronics
- Preferred for WLED projects

**Slow-Blow:**
- Tolerates brief surges
- Good for inductive loads (motors)
- Can use for LEDs but fast-blow is better

**Automotive Blade Fuses:**
- Standard: 5A, 10A, 15A, 20A, 25A, 30A
- Available everywhere (auto parts stores)
- Very cheap
- Easy to replace
- Recommended for DIY projects

### Circuit Breakers

**Resettable Protection:**
- Can reset after trip (no replacement needed)
- More expensive than fuses
- Convenient for testing
- Good for permanent installations

**Types:**
- Thermal: Resets after cooling
- Magnetic: Instant trip on overcurrent
- Hydraulic-Magnetic: Combination (best)

### Additional Protection

**TVS Diode (Transient Voltage Suppressor):**
- Protects against voltage spikes
- Clamps overvoltage
- Cheap insurance (~$1)
- Place across power supply output

**Schottky Diode (Reverse Polarity):**
- Prevents damage if power connected backwards
- Small voltage drop (0.3V)
- Must be rated for full current
- Place in series with positive

**Inrush Current Limiter:**
- Limits startup current surge
- Prevents nuisance fuse blows
- Usually not needed for WLED

---

## Special Considerations

### Outdoor Installations

**Requirements:**
- Weatherproof/waterproof PSU
- IP65 minimum rating
- IP67 recommended for direct exposure
- Properly sealed enclosure

**Recommended PSUs:**
- Mean Well HLG series (IP67)
- LED driver style (waterproof)
- Enclosed PSU in weatherproof box

**Additional Protection:**
- GFCI protection on AC side
- Weatherproof enclosure for connections
- Silicone seal all wire entries
- Elevated mounting (avoid water pooling)
- Drip loops on all cables

### High Power Installations (500+ LEDs)

**Strategies:**
1. **Multiple Medium PSUs** (vs. one huge PSU)
   - Easier to cool
   - Distribute load
   - Redundancy (if one fails, partial operation)

2. **Segment Your Strip:**
   - Each segment on separate PSU
   - Each segment independently fused
   - Easier troubleshooting

3. **Professional Components:**
   - Use Mean Well or equivalent
   - Proper enclosures
   - Industrial terminal blocks
   - Strain relief for all wires

### Portable/Battery Powered

**Battery Types:**

**USB Power Bank (Easiest):**
- Capacity: 10,000-30,000 mAh typical
- Output: 5V 2-3A
- Runtime: ~4-8 hours (small strips)
- No additional circuitry needed

**LiPo Battery (Advanced):**
- Voltage: 3.7V (1S), 7.4V (2S), 11.1V (3S), 14.8V (4S)
- Requires BMS (Battery Management System)
- Requires voltage regulator (buck/boost converter)
- High power density
- Dangerous if damaged

**Recommended Setup for Portable:**
```
LiPo Battery (11.1V 3S)
    ↓
BMS (protection circuit)
    ↓
Buck Converter (to 5V or 12V)
    ↓
ESP32 + LEDs
```

**Safety with LiPo:**
- Always use BMS
- Don't over-discharge (<3.0V per cell)
- Don't over-charge (>4.2V per cell)
- Use LiPo-safe bag for charging
- Monitor temperature
- Don't use if puffy/damaged

### Multiple Voltage Systems

**Example: 5V LEDs + 12V Fans**

**Option 1: Dual PSU**
```
5V PSU → LEDs
12V PSU → Fans
(Connect grounds together)
```

**Option 2: 12V PSU + Buck Converter**
```
12V PSU → Fans directly
         ↓
     Buck Converter (12V → 5V)
         ↓
       LEDs
```

**Option 3: ATX Computer PSU**
```
ATX PSU (has 3.3V, 5V, 12V built-in)
    ↓ 5V
   LEDs
    ↓ 12V
   Fans
```

---

## Common Mistakes

### Mistake 1: Undersizing Power Supply

**Problem:**
```
User: "I have 300 LEDs but my 5V 5A PSU keeps shutting down"
Reality: 300 LEDs need ~20A at 5V
```

**Fix:** Calculate properly, don't guess!

### Mistake 2: Connecting 12V to 5V LEDs

**Problem:**
```
User: "All my LEDs instantly died when I powered on"
Reality: Connected 12V PSU to 5V LEDs (instant death)
```

**Fix:** Triple-check voltage before powering on!

### Mistake 3: Forgetting Common Ground

**Problem:**
```
User: "Data signal is erratic with multiple PSUs"
Reality: Forgot to connect PSU grounds together
```

**Fix:** Always connect all grounds together in multi-PSU setups!

### Mistake 4: Using Cheap/Uncertified PSU

**Problem:**
```
User: "My power supply caught fire"
Reality: No-name PSU from sketchy website, no certifications
```

**Fix:** Always use UL/CE certified power supplies!

### Mistake 5: No Fusing

**Problem:**
```
User: "Wires melted when LED strip shorted"
Reality: No fuse to protect against short circuit
```

**Fix:** Always fuse your projects!

### Mistake 6: Ignoring Voltage Drop

**Problem:**
```
User: "LEDs at end of 300-LED strip are dim and wrong color"
Reality: Voltage dropped from 5V to 3.5V due to wire resistance
```

**Fix:** Use power injection!

### Mistake 7: Wrong Polarity

**Problem:**
```
User: "Nothing works after I connected power"
Reality: Connected + to - and - to +
```

**Fix:**
- Mark polarity clearly
- Use different colored wires (red=+, black=-)
- Add reverse polarity protection diode

### Mistake 8: Overloading USB Port

**Problem:**
```
User: "Computer USB port stopped working"
Reality: Tried to power 100 LEDs from 0.5A USB port
```

**Fix:** USB ports are limited (0.5A typical, 2A max). Use dedicated PSU!

---

## Buying Guide

### What to Check Before Ordering

Power Supply Checklist:

- [ ] **Correct voltage** (5V, 12V, or 24V)
- [ ] **Adequate current** (calculate from LED count)
- [ ] **Safety certifications** (UL, CE at minimum)
- [ ] **Reputable brand** (Mean Well, TDK, etc. or verified generic)
- [ ] **Correct plug type** (screw terminals vs. barrel jack)
- [ ] **IP rating** (if outdoor: IP65 minimum)
- [ ] **Form factor fits** (size, mounting holes)
- [ ] **AC input voltage** (110V vs 220V, or universal)
- [ ] **Warranty** (at least 1 year for quality units)
- [ ] **Return policy** (in case of DOA)
- [ ] **Availability** (in stock, reasonable shipping)
- [ ] **Price reasonable** (compare to similar models)

### Where to Buy

**USA Retailers:**

**Digi-Key:**
- Huge selection
- Guaranteed authentic
- Same-day shipping
- Higher prices
- Best for Mean Well

**Mouser:**
- Similar to Digi-Key
- Excellent selection
- Fast shipping

**Amazon:**
- Fast shipping (Prime)
- Easy returns
- Wide selection
- Verify seller reputation
- Check for fake reviews
- Good for generic PSUs

**Newark/Element14:**
- Industrial components
- Quality brands
- Professional-grade

**Jameco:**
- Electronics supplier
- Good hobbyist selection
- Reasonable prices

**International:**

**AliExpress:**
- Lowest prices
- Long shipping (2-8 weeks)
- Quality varies widely
- Read reviews carefully
- Good for budget builds
- Verify certifications

**Banggood:**
- Similar to AliExpress
- Slightly faster shipping
- Decent quality

**Local Electronics Store:**
- Instant availability
- Can inspect before buying
- Support local business
- Usually higher prices

### Pricing Guide (2024)

**5V Power Supplies:**
- 5V 2A (10W): $5-8
- 5V 5A (25W): $8-12
- 5V 10A (50W): $12-18
- 5V 20A (100W): $20-30 (generic), $25-30 (Mean Well LRS-100-5)
- 5V 40A (200W): $40-60 (generic), $80-100 (Mean Well HLG-240H-5 IP67)
- 5V 60A (300W): $60-90 (generic), $70-80 (Mean Well RSP-320-5)

**12V Power Supplies:**
- 12V 2A (24W): $6-10
- 12V 5A (60W): $10-15
- 12V 10A (120W): $18-25 (generic), $30-40 (Mean Well)
- 12V 20A (240W): $35-50 (generic), $80-100 (Mean Well HLG-240H-12 IP67)
- 12V 30A (360W): $50-70

**Premium Add-On:**
- Mean Well brand: +$10-30 over generic
- IP67 waterproof rating: +$20-40
- UL listing (vs just CE): +$5-15

---

## Quick Decision Chart

```
Start Here
    │
    ├─ How many LEDs?
    │  │
    │  ├─ <50 LEDs ──→ USB 5V 2-3A or 5V 5A PSU
    │  ├─ 50-100 LEDs ──→ 5V 5-10A PSU
    │  ├─ 100-200 LEDs ──→ 5V 20A PSU (add injection)
    │  ├─ 200-300 LEDs ──→ 5V 30A PSU or 12V 5A (if 12V LEDs)
    │  └─ 300+ LEDs ──→ Multiple PSUs or 12V LEDs with 12V 10A+ PSU
    │
    ├─ Indoor or Outdoor?
    │  │
    │  ├─ Indoor ──→ Standard enclosed PSU (IP20)
    │  └─ Outdoor ──→ IP67 LED driver (Mean Well HLG series)
    │
    ├─ Budget?
    │  │
    │  ├─ Tight budget ──→ Generic UL/CE PSU from Amazon
    │  ├─ Normal budget ──→ Mean Well LRS series
    │  └─ Professional ──→ Mean Well HLG or RSP series
    │
    ├─ Portable?
    │  │
    │  ├─ Yes ──→ USB power bank or LiPo battery
    │  └─ No ──→ Standard AC-DC PSU
    │
    └─ 5V or 12V LEDs?
       │
       ├─ 5V LEDs ──→ 5V PSU (more common, easier)
       └─ 12V LEDs ──→ 12V PSU (better for long runs)
```

---

## Summary & Recommendations

### For Most People

**Recommended: Mean Well LRS-100-5 (5V 20A)**
- Excellent quality/price ratio (~$25-30)
- Powers up to 250 WS2812B LEDs comfortably
- UL/CE/TUV certified
- Reliable brand
- Perfect for typical home installations

**Alternative Budget: Generic 5V 20A PSU**
- Must have UL or CE certification
- Read reviews carefully
- Price: ~$15-20
- Adequate for non-critical applications

### By Project Size

**Tiny (<50 LEDs):**
- Anker/RAVPower USB charger 5V 2-3A
- Price: ~$10-15
- Easy, safe, portable

**Small (50-100 LEDs):**
- Generic 5V 5-10A enclosed PSU
- Price: ~$12-18
- Perfect for learning/hobby

**Medium (100-300 LEDs):**
- Mean Well LRS-100-5 or LRS-150-5
- Add power injection at 150 LEDs
- Price: ~$25-40
- Best value for typical projects

**Large (300-500 LEDs):**
- 5V: Mean Well RSP-320-5 (5V 60A) with injection
- 12V: WS2815 LEDs + Mean Well LRS-150-12 (12V 12.5A)
- Price: ~$70-100
- Professional quality

**Very Large (500+ LEDs):**
- Multiple PSUs (easier to manage)
- Or switch to 12V LEDs (WS2815)
- Use Mean Well HLG series for outdoor
- Price: $100-300+
- Consider professional installation

### By Use Case

**Permanent Indoor:**
- Mean Well LRS series
- Proper fusing
- Quality wiring

**Permanent Outdoor:**
- Mean Well HLG series (IP67)
- Weatherproof enclosure
- GFCI protection

**Portable/Events:**
- USB power bank (small)
- LiPo battery (advanced)
- ATX computer PSU (budget large)

**Professional/Commercial:**
- Mean Well HLG or RSP series
- Redundant PSUs if critical
- Professional installation
- Proper electrical code compliance

---

## Resources

**Calculators:**
- [WLED Power Calculator](https://wled-calculator.github.io/)
- [LED Strip Power Calculator](https://www.ledstripstudio.com/power-supply-calculator)

**Datasheets:**
- [Mean Well LRS Series](https://www.meanwell.com/productPdf.aspx?i=459)
- [Mean Well HLG Series](https://www.meanwell.com/productPdf.aspx?i=510)

**Buying:**
- Digi-Key: https://www.digikey.com
- Mouser: https://www.mouser.com
- Amazon: https://www.amazon.com
- Mean Well Official: https://www.meanwell.com

**Safety Standards:**
- UL Standards: https://www.ul.com
- CE Marking: https://ec.europa.eu/growth/ce-marking

**Related Guides:**
- [LED Selection Guide](LED_SELECTION_GUIDE.md)
- [Wire Selection Guide](WIRE_SELECTION_GUIDE.md)
- [Hardware Guide](HARDWARE_GUIDE.md)

---

**Safety Disclaimer:** Working with mains voltage (AC) can be dangerous. If you're not comfortable with electrical work, consult or hire a licensed electrician. This guide is for informational purposes only.
