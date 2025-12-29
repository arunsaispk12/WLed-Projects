# Fuse Selection Guide

Comprehensive guide to selecting, sizing, and installing fuses for WLED projects to ensure safety and protect equipment.

## Table of Contents

1. [Why Fusing is Critical](#why-fusing-is-critical)
2. [Fuse Basics](#fuse-basics)
3. [Fuse Types](#fuse-types)
4. [Fuse Sizing](#fuse-sizing)
5. [Where to Install Fuses](#where-to-install-fuses)
6. [Installation Methods](#installation-methods)
7. [Circuit Breakers](#circuit-breakers)
8. [Special Cases](#special-cases)
9. [Troubleshooting](#troubleshooting)

---

## Why Fusing is Critical

### What Fuses Protect Against

**1. Short Circuits:**
```
Normal Operation:
PSU (+) → Wire → LEDs → Wire → PSU (-)
Current: 10A (normal)

Short Circuit:
PSU (+) → Wire → [SHORT] → PSU (-)
Current: 100A+ (DANGER!)
Without Fuse: Wire overheats → Fire
With Fuse: Fuse blows → Circuit opens → Safe
```

**2. Overload Conditions:**
- Too many LEDs for wire gauge
- Power supply failure
- Component malfunction
- Gradual wire damage

**3. Equipment Damage:**
- Protects expensive components
- Prevents cascading failures
- Limits damage to faulted section

### Real-World Scenarios

**❌ Without Fuse:**
```
Scenario: LED strip wire shorts to metal frame
Result:
1. Wire draws 50A (vs normal 10A)
2. Wire insulation melts in seconds
3. Fire starts
4. Property damage / injury risk
```

**✅ With Properly Sized Fuse:**
```
Same Scenario:
1. Wire shorts
2. Current spike to 50A
3. 15A fuse blows in <1 second
4. Circuit opens, current stops
5. No fire, minimal damage
```

### Legal/Code Requirements

**May Be Required:**
- Permanent installations
- Commercial installations
- Some residential codes
- Insurance requirements
- UL/CE certification

**Always Recommended:**
- ANY permanent installation
- ANY high-power project (>5A)
- Outdoor installations
- Unattended operation

---

## Fuse Basics

### How Fuses Work

**Construction:**
```
┌────────────────────┐
│  [Fusible Element] │ ← Thin wire or metal strip
│   │            │   │
│   ●────────────●   │ ← Metal end caps
└────────────────────┘
```

**Operation:**
1. **Normal Current:** Flows through fusible element, slight heating
2. **Overcurrent:** Element heats up rapidly
3. **Melting:** Element melts, breaks circuit
4. **Arc Quenching:** Fuse housing extinguishes arc
5. **Safe State:** Circuit open, no current flow

### Key Specifications

**1. Current Rating (Amperes):**
- Maximum continuous current
- Example: 10A, 15A, 20A

**2. Voltage Rating (Volts):**
- Maximum voltage fuse can safely interrupt
- Must exceed circuit voltage
- Example: 32VDC, 125VAC, 250VAC

**3. Breaking Capacity (kA):**
- Maximum fault current fuse can safely interrupt
- Higher is better for safety
- Typical: 100A - 10,000A

**4. Speed (Time-Current Characteristic):**
- **F (Fast-Acting):** Blows quickly on overcurrent
- **T (Slow-Blow/Time-Delay):** Tolerates brief surges
- **FF (Very Fast):** For sensitive electronics

### Important: AC vs DC Ratings

**⚠️ CRITICAL: DC Fuses for DC Circuits!**

**Why:**
- DC arc is harder to extinguish than AC
- AC arc naturally extinguishes at zero crossing (60Hz)
- DC arc continuous, requires special design

**Ratings:**
```
AC Fuse: 10A @ 250VAC
Same fuse on DC: 10A @ 32VDC only!

Never use AC-only fuse on high-voltage DC!
```

**For WLED (Low Voltage DC):**
- 5V/12V DC
- Most fuses work fine
- Automotive fuses perfect for this application
- Look for "32VDC" or "58VDC" rating

---

## Fuse Types

### Automotive Blade Fuses (Recommended for WLED)

**ATO/ATC Standard Blade Fuses:**

**Advantages:**
✅ Cheap ($0.20-0.50 each)
✅ Widely available (auto parts stores, Amazon)
✅ Easy to replace
✅ Color-coded for current rating
✅ Clear indication when blown
✅ Available in many ratings (1A-40A)
✅ Holder/panel mounts available

**Disadvantages:**
❌ Bulky (compared to glass fuses)
❌ Not for AC mains (32VDC max)

**Color Coding:**
| Color | Rating | Common Use |
|-------|--------|------------|
| Black | 1A | Very small projects |
| Grey | 2A | <30 LEDs |
| Violet | 3A | 30-50 LEDs |
| Pink | 4A | 50-70 LEDs |
| Tan | 5A | 70-100 LEDs |
| Brown | 7.5A | 100-150 LEDs |
| Red | 10A | 150-200 LEDs |
| Blue | 15A | 200-300 LEDs |
| Yellow | 20A | 300-400 LEDs |
| Clear | 25A | 400-500 LEDs |
| Green | 30A | 500-600 LEDs |
| Orange | 40A | 600+ LEDs |

**Dimensions:**
- Length: 19mm
- Width: 5mm (blade spacing)
- Height: 18.5mm

#### Fuse Holder Options

**Inline Holder:**
```
Wire ───┤ [Fuse] ├─── Wire
      Holder      Holder
```
- Price: $0.50-1.00
- Weatherproof versions available
- Easy to install mid-wire

**Panel Mount:**
```
   ┌────────┐
   │  Fuse  │
   │  [  ]  │ ← Panel mount
   └────────┘
```
- Price: $1-2
- Professional appearance
- Easy fuse access

**Fuse Block (Multiple):**
```
┌──────────────┐
│ [F][F][F][F] │ ← 4-6 fuses
│ IN        OUT│
└──────────────┘
```
- Price: $3-10
- For multi-channel projects
- One input, multiple fused outputs
- Professional installations

### Glass Tube Fuses

**Common Sizes:**
- 5×20mm (most common)
- 6×30mm (higher current)

**Advantages:**
✅ Very compact
✅ Cheap
✅ Available in wide range
✅ Clear indication when blown

**Disadvantages:**
❌ Fragile (glass breaks)
❌ Harder to find holders
❌ Holder can corrode
❌ Not as durable as blade fuses

**Use When:**
- Space constrained
- Low current (<5A)
- Internal PCB mounting

### Cartridge Fuses

**Industrial/High Power:**

**Types:**
- Midget fuses (13/32" × 1-1/2")
- Standard cartridge
- Class J, Class T (high breaking capacity)

**Use When:**
- High current (>40A)
- Professional installations
- AC mains protection
- UL/NEC compliance required

**Typical:** Not needed for most WLED projects

### Resettable Fuses (PTC - Positive Temperature Coefficient)

**Self-Resetting:**

**How They Work:**
- Polymer increases resistance when hot
- Overcurrent → heats up → high resistance → limits current
- Cools down → resets automatically

**Model Numbers:**
- PolySwitch (brand name)
- MF-R series (common)

**Advantages:**
✅ Auto-reset (no replacement needed)
✅ Reusable
✅ Good for testing/development

**Disadvantages:**
❌ Slow response (seconds)
❌ Not true "open circuit" when tripped
❌ Degrade over time
❌ Not for AC mains

**Use When:**
- Development/testing phase
- Non-critical protection
- Frequent reset needed
- USB power protection

**Don't Use When:**
- Critical safety application
- Fast response needed
- Permanent installation
- High reliability required

---

## Fuse Sizing

### The Golden Rule

**Fuse Current = 1.25 × Maximum Normal Current**

**Why 1.25 (125%)?**
- Gives 25% safety margin
- Prevents nuisance blowing
- Accounts for inrush current
- Standard electrical practice

### Step-by-Step Sizing

**Step 1: Calculate Maximum Current**

```
For LEDs:
Max Current = Number of LEDs × Current per LED

Example: 200 WS2812B LEDs
Max Current = 200 × 0.06A = 12A
```

**Step 2: Apply Usage Factor**

```
Typical Usage = Max Current × 0.8 (80%)
```

**Step 3: Apply Safety Factor**

```
Fuse Rating = Typical Usage × 1.25 = Max Current × 0.8 × 1.25

Example: 200 LEDs
Fuse = 12A × 0.8 × 1.25 = 12A
```

**Step 4: Select Next Standard Size**

```
Standard Fuse Sizes: 1, 2, 3, 5, 7.5, 10, 15, 20, 25, 30, 40A

For 12A calculated: Use 15A fuse
```

### Quick Reference Table

**For 5V WS2812B/WS2813/SK6812:**

| LED Count | Max Current | Typical Current | Fuse Size |
|-----------|-------------|-----------------|-----------|
| 50 | 3A | 2.4A | 3A or 5A |
| 100 | 6A | 4.8A | 5A or 7.5A |
| 150 | 9A | 7.2A | 10A |
| 200 | 12A | 9.6A | 10A or 15A |
| 300 | 18A | 14.4A | 15A or 20A |
| 400 | 24A | 19.2A | 20A or 25A |
| 500 | 30A | 24A | 25A or 30A |

**For 12V WS2815:**

| LED Count | Max Current | Typical Current | Fuse Size |
|-----------|-------------|-----------------|-----------|
| 100 | 1.5A | 1.2A | 2A or 3A |
| 200 | 3A | 2.4A | 3A or 5A |
| 300 | 4.5A | 3.6A | 5A |
| 400 | 6A | 4.8A | 5A or 7.5A |
| 500 | 7.5A | 6A | 7.5A or 10A |

### Wire Gauge Consideration

**CRITICAL: Fuse Must Protect Wire!**

**Rule: Fuse < Wire Capacity**

**Wire Current Capacity (Chassis Wiring):**
| Wire Gauge | Max Current |
|------------|-------------|
| 24 AWG | 3.5A |
| 22 AWG | 5A |
| 20 AWG | 7.5A |
| 18 AWG | 10A |
| 16 AWG | 13A |
| 14 AWG | 17A |
| 12 AWG | 23A |
| 10 AWG | 33A |

**Example:**
```
Scenario: 200 LEDs, need 15A fuse

If using 18 AWG wire (10A max):
❌ WRONG: 15A fuse + 18 AWG wire
   Wire overheats before fuse blows!

✅ CORRECT Options:
   1. Use 15A fuse + 14 AWG wire
   2. Use 10A fuse + 18 AWG wire (but split into sections)
```

**Golden Rule: Fuse protects the weakest link (usually the wire)!**

### Multiple Sections

**For Large Installations:**

```
Main Fuse:
PSU → [30A Main Fuse] → Distribution

Branch Fuses:
Distribution → [10A] → Section 1 (150 LEDs)
            → [10A] → Section 2 (150 LEDs)
            → [10A] → Section 3 (150 LEDs)

Total: 450 LEDs, 27A max
Main fuse: 30A
Branch fuses: 10A each
```

**Benefits:**
- Fault in one section doesn't kill all
- Easier troubleshooting
- Can use smaller wire for branches
- More professional

---

## Where to Install Fuses

### Fuse Placement Rules

**1. On Positive (+) Side Only**
```
✅ CORRECT:
PSU (+) ──[Fuse]─── LEDs
PSU (-) ──────────── LEDs

❌ WRONG:
PSU (+) ──────────── LEDs
PSU (-) ──[Fuse]─── LEDs
(Can create unsafe conditions!)
```

**2. As Close to Source as Practical**
```
✅ GOOD:
PSU ──[Fuse]── 10ft wire ── LEDs

❌ BAD:
PSU ── 10ft wire ──[Fuse]── LEDs
(10ft of unfused wire is hazard!)
```

**3. Before Any Branch**
```
Main PSU ──[Main Fuse]──┬──[Branch Fuse]── Section 1
                        ├──[Branch Fuse]── Section 2
                        └──[Branch Fuse]── Section 3
```

### Recommended Locations

**Single Strip Project:**
```
Power Supply
    (+) ──[Fuse]──┬── LED Strip (+)
                  └── ESP32 5V (if powered from same supply)
    (-) ──────────┴── Common Ground
```

**Multi-Channel Project:**
```
Power Supply
    (+) ──[Main Fuse]──┬──[Fuse]── Channel 1
                       ├──[Fuse]── Channel 2
                       ├──[Fuse]── Channel 3
                       └──[Fuse]── Channel 4
```

**With Power Injection:**
```
PSU ──[Main Fuse]──┬──[Fuse]── LED Start (0-150)
                   └──[Fuse]── Injection Point (150-300)
```

---

## Installation Methods

### Inline Fuse Holder

**Installation Steps:**

1. **Cut Positive Wire:**
   - Measure where fuse holder will go
   - Cut positive (+) wire only
   - Leave negative (-) wire intact

2. **Strip Wire Ends:**
   - Strip 1/4" from each cut end
   - Twist stranded wire tight

3. **Insert into Holder:**
   - Crimp or solder wires to holder terminals
   - Ensure good connection

4. **Insert Fuse:**
   - Check fuse rating
   - Push firmly into holder
   - Verify secure

5. **Secure:**
   - Heat shrink over connections
   - Zip tie to prevent strain
   - Label fuse rating

**Crimping vs Soldering:**

**Crimping (Preferred for High Current):**
- Use insulated crimp terminals
- Proper crimping tool required
- More reliable at high current
- Easier to service

**Soldering:**
- Good for low current (<10A)
- Use heat shrink after
- Don't overheat wire insulation
- Ensure solid connection

### Panel Mount Holder

**Installation:**

1. **Drill Hole:**
   - Measure holder diameter
   - Drill hole in enclosure panel
   - Deburr edges

2. **Mount Holder:**
   - Insert from outside
   - Secure with retaining nut
   - Ensure weather seal if outdoor

3. **Wire Connections:**
   - Connect wires to screw terminals
   - Tighten securely
   - Verify polarity

4. **Label:**
   - Mark fuse rating on panel
   - Indicate purpose ("LED Power", "Main", etc.)

### Fuse Block Installation

**For Multi-Channel:**

1. **Mount Block:**
   - Secure to enclosure with screws
   - Leave space for wire management

2. **Input Connection:**
   - Connect PSU positive to input terminal
   - Use appropriate gauge wire
   - Secure tightly

3. **Fuse Installation:**
   - Insert appropriate rated fuse in each position
   - Can use different ratings for different channels

4. **Output Connections:**
   - Connect each output to its load
   - Label each output
   - Keep wires organized

---

## Circuit Breakers

### Resettable Protection

**Advantages over Fuses:**
✅ No replacement needed
✅ Quick reset
✅ Easy to test
✅ Good for development
✅ Can indicate fault visibly

**Disadvantages:**
❌ More expensive
❌ Larger size
❌ Can wear out
❌ Not as precise as fuses

### Types of Circuit Breakers

**1. Thermal Circuit Breaker:**
- Bimetallic strip heats up
- Bends and trips mechanism
- Slow response (seconds)
- Auto or manual reset

**2. Magnetic Circuit Breaker:**
- Electromagnetic coil
- Fast response (milliseconds)
- Precise trip point
- Professional grade

**3. Hydraulic-Magnetic:**
- Combination of above
- Best performance
- More expensive
- Ideal for critical systems

### When to Use Circuit Breakers

**Good For:**
- Development/testing (frequent resets)
- Easy-access locations
- Systems requiring field reset
- Non-critical applications

**Use Fuses For:**
- Permanent installations
- Hidden/inaccessible locations
- Critical safety applications
- Lowest cost

### Recommended Circuit Breakers

**For WLED Projects:**

**E-T-A 2210 Series:**
- Thermal breaker
- Panel mount
- 1-30A ratings
- 32VDC rated
- Price: $8-15

**Carling Technologies:**
- Rocker switch breaker
- Easy panel mount
- Visual indication
- Price: $5-10

**Automotive Circuit Breakers:**
- Auto-reset style
- Cheap ($3-5)
- Good for 12V systems
- Available at auto parts stores

---

## Special Cases

### High Inrush Current (Capacitive Load)

**Problem:**
```
LED strips have large capacitors
At power-on: Brief high current spike (inrush)
Can blow fuse even though normal current is fine
```

**Solution: Use Slow-Blow (Time-Delay) Fuse**

**Designation:**
- **T** (Time-delay) or **MDL** (Midget Delay)
- Tolerates 5× current for 0.1 seconds
- Still protects against sustained overcurrent

**Example:**
```
200 LEDs:
- Normal current: 10A
- Fast-blow fuse: 15A (might nuisance trip)
- Slow-blow fuse: 15A Time-Delay (perfect!)
```

### Outdoor Installations

**Requirements:**
- Weatherproof fuse holder
- Corrosion-resistant materials
- IP65+ rating
- UV-resistant

**Recommended:**
- Automotive-style waterproof inline holder
- Marine-grade fuse holder
- Conformal coating on connections

### Multiple Power Supplies

**Separate Fusing:**

```
PSU 1 ──[Fuse 1]── Section 1 (LEDs 1-150)
PSU 2 ──[Fuse 2]── Section 2 (LEDs 151-300)

Each PSU independently fused
Grounds connected together
```

**Do NOT:**
- Connect fused outputs of multiple PSUs together
- Share one fuse across multiple PSUs

### Very Low Current (<1A)

**Use:**
- Smaller fuses (500mA, 1A)
- Fast-blow type
- Glass tube fuses (space efficient)

**Example:**
```
ESP32 only (no LEDs):
- Current: 200mA typical
- Fuse: 500mA or 1A
- Type: Fast-blow
```

---

## Troubleshooting

### Fuse Keeps Blowing

**Possible Causes:**

1. **Short Circuit:**
   - Check all connections
   - Look for pinched/damaged wires
   - Verify no + touching -
   - Inspect LED strip for damage

2. **Fuse Too Small:**
   - Recalculate required current
   - Measure actual current draw
   - Upgrade to next size

3. **Inrush Current:**
   - Switch to slow-blow fuse
   - Add inrush limiter circuit
   - Soft-start power supply

4. **Faulty Component:**
   - Disconnect loads one by one
   - Find which section causes blow
   - Repair/replace faulty component

### Fuse Doesn't Blow When Expected

**Possible Causes:**

1. **Fuse Too Large:**
   - Wire may overheat before fuse blows
   - Recalculate fuse size
   - Check wire gauge vs fuse rating

2. **Wrong Fuse Type:**
   - Slow-blow used where fast needed
   - Check fuse markings
   - Replace with correct type

3. **Poor Fuse Contact:**
   - Corrosion in holder
   - Loose fuse
   - Clean holder, replace fuse

### Intermittent Blowing

**Causes:**

1. **Marginal Sizing:**
   - Fuse at edge of rating
   - Upgrade to next size
   - Add safety margin

2. **Vibration:**
   - Fuse not seated properly
   - Holder loose
   - Secure fuse and holder

3. **Temperature:**
   - Fuse in hot environment
   - Derate fuse or relocate
   - Improve ventilation

---

## Best Practices

### DO These Things

✅ **Always Fuse:**
- Every project over 2A
- Every permanent installation
- Any unattended operation

✅ **Size Properly:**
- Use 1.25× normal current
- Never exceed wire rating
- Consider inrush current

✅ **Fuse on Positive (+) Side:**
- Standard practice
- Safer operation
- Easier troubleshooting

✅ **Use Quality Fuses:**
- Name-brand fuses (Littelfuse, Bussmann)
- Proper voltage rating
- Check for UL/CE marks

✅ **Document:**
- Label fuse ratings
- Mark on schematic
- Keep spare fuses

✅ **Test:**
- Verify fuse is correct rating
- Check it's properly seated
- Test that it blows (optional, with test fuse)

### DON'T Do These Things

❌ **Don't Skip Fusing:**
- "It's just temporary" → leads to permanent
- "Low power" → still a fire risk
- "Just testing" → when accidents happen

❌ **Don't Oversize:**
- Defeats purpose of protection
- Wire can overheat before fuse blows
- False sense of security

❌ **Don't Use Wrong Type:**
- AC fuse on high voltage DC
- Fast-blow where slow-blow needed
- Undersized voltage rating

❌ **Don't Bypass:**
- Never bridge a blown fuse
- Don't use wire/foil instead of fuse
- Find and fix the problem!

❌ **Don't Trust Cheap Fuses:**
- Unknown brand fuses may not blow properly
- Counterfeit fuses exist
- Buy from reputable suppliers

---

## Summary

### Quick Selection Guide

**Small Project (<100 LEDs, <5A):**
- **Fuse:** 5A or 7.5A automotive blade
- **Type:** Fast-blow (or slow-blow if nuisance trips)
- **Holder:** Inline automotive holder
- **Cost:** ~$2

**Medium Project (100-300 LEDs, 5-20A):**
- **Fuse:** 10A, 15A, or 20A automotive blade
- **Type:** Slow-blow recommended
- **Holder:** Panel mount or inline
- **Cost:** ~$3-5

**Large Project (300+ LEDs, 20-40A):**
- **Fuse:** 25A, 30A, or 40A automotive blade
- **Type:** Slow-blow
- **Holder:** High-current automotive holder
- **Cost:** ~$5-10

**Multi-Channel:**
- **Main Fuse:** Size for total current
- **Branch Fuses:** Size per channel (10-15A typical)
- **Holder:** Fuse block (4-6 position)
- **Cost:** ~$10-20

### Essential Safety Checklist

Before powering on ANY project:

- [ ] Fuse installed on positive (+) side
- [ ] Fuse rating appropriate for current
- [ ] Fuse rating does NOT exceed wire capacity
- [ ] Fuse properly seated in holder
- [ ] Holder connections secure
- [ ] Spare fuses available
- [ ] Fuse rating documented/labeled
- [ ] All connections checked for shorts
- [ ] Polarity verified (+ and -)

### Related Guides

- [Power Supply Selection Guide](POWER_SUPPLY_SELECTION_GUIDE.md)
- [Wire Selection Guide](WIRE_SELECTION_GUIDE.md)
- [Hardware Development Guide](HARDWARE_GUIDE.md)

---

**Remember: Fuses are cheap. Replaceable. Your safety and property are not. Always fuse your projects!** 🔥🛡️
