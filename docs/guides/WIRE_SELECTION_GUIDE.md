# Wire Selection Guide

Comprehensive guide to selecting the right wire for your WLED project based on use case, current requirements, and reliability.

## Table of Contents

1. [Wire Basics](#wire-basics)
2. [Wire Types & Applications](#wire-types--applications)
3. [Wire Gauge Selection](#wire-gauge-selection)
4. [Use Case Examples](#use-case-examples)
5. [Quality & Reliability](#quality--reliability)
6. [Installation Best Practices](#installation-best-practices)

---

## Wire Basics

### Understanding Wire Gauge (AWG)

| AWG | Diameter | Max Current (Chassis) | Max Current (Power) | Resistance (Ω/m) | Common Use |
|-----|----------|----------------------|---------------------|------------------|------------|
| 30 | 0.25mm | 0.86A | 0.52A | 0.339 | Signal wires |
| 28 | 0.32mm | 1.4A | 0.84A | 0.213 | Breadboard jumpers |
| 26 | 0.40mm | 2.2A | 1.3A | 0.134 | LED data lines |
| 24 | 0.51mm | 3.5A | 2.1A | 0.084 | Short power runs |
| 22 | 0.64mm | 7A | 3A | 0.053 | LED power (short) |
| 20 | 0.81mm | 11A | 5A | 0.033 | LED power (medium) |
| 18 | 1.02mm | 16A | 10A | 0.021 | Main power lines |
| 16 | 1.29mm | 22A | 13A | 0.013 | High current |
| 14 | 1.63mm | 32A | 17A | 0.008 | Very high current |

**Key Terms:**
- **AWG (American Wire Gauge)**: Smaller number = Thicker wire
- **Chassis Wiring**: Short runs in open air (better cooling)
- **Power Transmission**: Longer runs in conduit/bundles
- **Resistance**: Lower is better (less voltage drop)

### Wire Types

#### Solid Core
- **Pros**: Holds shape, better contact in terminals, cheaper
- **Cons**: Breaks with repeated bending, harder to route
- **Use For**: Breadboards, terminal blocks, permanent installations

#### Stranded
- **Pros**: Flexible, withstands vibration, easier to route
- **Cons**: Harder to insert in terminals, may need ferrules
- **Use For**: Moving parts, tight spaces, final installations

#### Silicone Insulated
- **Pros**: Very flexible, heat resistant, durable
- **Cons**: More expensive, bulkier
- **Use For**: High temperature areas, tight routing, premium builds

---

## Wire Types & Applications

### Power Wires (5V and GND)

#### Red (+5V) and Black (GND)

**Requirements:**
- Must handle full current load
- Minimize voltage drop
- Adequate insulation rating

**Recommended Gauges by Current:**

| Current | Distance | Minimum AWG | Recommended AWG |
|---------|----------|-------------|-----------------|
| <2A | Any | 24 AWG | 22 AWG |
| 2-5A | <2m | 22 AWG | 20 AWG |
| 2-5A | 2-5m | 20 AWG | 18 AWG |
| 5-10A | <2m | 20 AWG | 18 AWG |
| 5-10A | 2-5m | 18 AWG | 16 AWG |
| 10-15A | <2m | 18 AWG | 16 AWG |
| 10-15A | 2-5m | 16 AWG | 14 AWG |
| 15-20A | Any | 14 AWG | 12 AWG |

**Color Code:**
- **Red**: +5V (positive)
- **Black**: GND (ground/negative)
- **Always follow this convention!**

### Data/Signal Wires

#### LED Data Line

**Requirements:**
- Fast signal transmission
- Clean signal (minimal interference)
- Relatively short runs

**Recommended:**
- **22-26 AWG** solid or stranded
- **Shielded wire** for runs >3m
- **Twisted pair** with ground for long runs
- Keep separate from power wires

**Color Suggestions:**
- **White, Yellow, or Green**: Data
- **Green with stripe**: Data (common in LED strips)

#### I2C (SDA/SCL)

**Requirements:**
- 22-26 AWG
- Twisted pair recommended
- Pull-up resistors at ends
- Max length ~1-2m (without buffering)

**Colors:**
- **Blue**: SDA
- **Yellow**: SCL
- Or use ribbon cable

### Ground Wires

**Critical Notes:**
- **Same gauge as power wire** (minimum)
- **Never undersized** - ground carries full return current
- **Star grounding** from single point preferred
- **Common ground** between all components

---

## Wire Gauge Selection

### Calculation Method

**Formula:**
```
Voltage Drop (V) = Current (A) × Resistance (Ω/m) × Length (m) × 2
(×2 because current flows both ways: power and ground)

Acceptable voltage drop: <0.5V for 5V systems (10%)
Better: <0.25V (5%)
```

**Example:**

60 LEDs drawing 3A, 2m wire run:

```
Using 22 AWG (0.053 Ω/m):
Drop = 3A × 0.053 Ω/m × 2m × 2 = 0.636V ❌ Too much!

Using 20 AWG (0.033 Ω/m):
Drop = 3A × 0.033 Ω/m × 2m × 2 = 0.396V ⚠️ Acceptable

Using 18 AWG (0.021 Ω/m):
Drop = 3A × 0.021 Ω/m × 2m × 2 = 0.252V ✅ Good!
```

**Recommendation: Use 18 AWG**

### Quick Reference Table

**For 5V LED Systems (max 10% voltage drop = 0.5V):**

| LED Count | Current | 1m Run | 2m Run | 3m Run | 5m Run |
|-----------|---------|--------|--------|--------|--------|
| 30 | 2A | 24 AWG | 22 AWG | 20 AWG | 18 AWG |
| 60 | 3A | 22 AWG | 20 AWG | 18 AWG | 16 AWG |
| 100 | 5A | 20 AWG | 18 AWG | 16 AWG | 14 AWG |
| 150 | 7A | 18 AWG | 16 AWG | 14 AWG | 12 AWG |
| 200 | 10A | 18 AWG | 16 AWG | 14 AWG | 12 AWG |
| 300 | 15A | 16 AWG | 14 AWG | 12 AWG | 10 AWG |

*Based on 60mA per LED at full white, actual may be less*

### When to Use Thicker Wire

**Always go thicker if:**
- Wire runs are bundled (reduces cooling)
- High ambient temperature (>30°C)
- Continuous high current operation
- Long-term reliability is critical
- Cost difference is minimal
- Safety margin desired

**Rule of Thumb:**
> When in doubt, go one size thicker. The cost difference is minimal, but reliability gain is significant.

---

## Use Case Examples

### Case 1: Beginner Project (30 LEDs, USB Powered)

**Specifications:**
- 30 WS2812B LEDs
- USB power (5V 2A max)
- 50cm wire runs
- Breadboard prototype

**Wire Selection:**

| Connection | Wire Type | Gauge | Notes |
|------------|-----------|-------|-------|
| PSU to Breadboard | Stranded | 22 AWG | Red/Black pair |
| Breadboard to LEDs | Stranded | 22 AWG | Red/Black pair |
| Data line | Solid | 24 AWG | White or Yellow |
| ESP32 power | Stranded | 24 AWG | Via USB is fine |

**Shopping List:**
- Red 22 AWG stranded (1m)
- Black 22 AWG stranded (1m)
- White 24 AWG solid (0.5m)
- Breadboard jumper kit

**Cost:** ~$5-8

### Case 2: Standard Home Installation (60 LEDs)

**Specifications:**
- 60 WS2812B LEDs (1 meter)
- 5V 5A power supply
- 1m wire runs
- Permanent installation

**Wire Selection:**

| Connection | Wire Type | Gauge | Notes |
|------------|-----------|-------|-------|
| PSU to LED strip | Silicone stranded | 20 AWG | Red/Black pair, flexible |
| ESP32 to LEDs | Stranded | 24 AWG | Short run, signal only |
| ESP32 power | Stranded | 22 AWG | Can share LED power |
| Ground | Silicone stranded | 20 AWG | Same as power |

**Shopping List:**
- Red 20 AWG silicone stranded (2m)
- Black 20 AWG silicone stranded (2m)
- White 24 AWG stranded (1m)
- Heat shrink tubing

**Cost:** ~$10-15

### Case 3: Large Installation (150 LEDs, 3m)

**Specifications:**
- 150 WS2812B LEDs (2.5 meters)
- 5V 10A power supply
- Power injection at midpoint
- 3m total wire runs
- Outdoor (weatherproof)

**Wire Selection:**

| Connection | Wire Type | Gauge | Notes |
|------------|-----------|-------|-------|
| Main PSU to first injection | Stranded | 16 AWG | Heavy duty outdoor rated |
| First to second injection | Stranded | 18 AWG | Mid-run injection |
| Data line | Stranded shielded | 22 AWG | Shield to ground one end |
| ESP32 power | Stranded | 22 AWG | Separate low-current line |
| All grounds | Stranded | 16 AWG | Same as main power |

**Additional:**
- Outdoor-rated wire or conduit
- Weatherproof connectors
- UV-resistant heat shrink

**Shopping List:**
- Red 16 AWG outdoor stranded (5m)
- Black 16 AWG outdoor stranded (5m)
- Red 18 AWG stranded (2m)
- Black 18 AWG stranded (2m)
- White 22 AWG shielded (3m)
- Waterproof connectors
- IP65 junction boxes

**Cost:** ~$30-50

### Case 4: Architectural Installation (300 LEDs, 10m)

**Specifications:**
- 300 WS2812B LEDs (5 meters)
- 5V 20A power supply
- Multiple injection points (every 100 LEDs)
- 10m total wire runs
- Professional installation

**Wire Selection:**

| Connection | Wire Type | Gauge | Notes |
|------------|-----------|-------|-------|
| PSU to main distribution | Stranded | 12 AWG | Main power trunk |
| Distribution to injections | Stranded | 14-16 AWG | Branch circuits |
| Between LEDs | Built-in strip | - | Use strip wires |
| Data line | Shielded CAT5/6 | 24 AWG | Pair + ground |
| ESP32 signal | Shielded | 22 AWG | Clean signal critical |

**Professional Features:**
- Terminal blocks for distribution
- Fused branches
- Proper cable management
- Labeled wires
- Service loop at each end

**Shopping List:**
- Red 12 AWG THHN (15m)
- Black 12 AWG THHN (15m)
- Red/Black 16 AWG pairs (25m)
- CAT6 cable (10m)
- Terminal blocks
- Inline fuses (3A)
- Cable ties and markers
- Junction boxes

**Cost:** ~$100-150

### Case 5: Mobile/Wearable (20 LEDs, Battery)

**Specifications:**
- 20 WS2812B LEDs
- 5V battery pack
- Minimal weight
- Flexible routing
- Frequent movement

**Wire Selection:**

| Connection | Wire Type | Gauge | Notes |
|------------|-----------|-------|-------|
| Battery to LEDs | Silicone stranded | 26-28 AWG | Ultra flexible, lightweight |
| Data line | Silicone stranded | 28-30 AWG | Fine gauge, flexible |
| All connections | Silicone stranded | 26-28 AWG | Withstands movement |

**Special Considerations:**
- Use smallest gauge that handles current
- Silicone insulation for flexibility
- Strain relief at all connections
- Lightweight JST connectors

**Shopping List:**
- Red 28 AWG silicone (2m)
- Black 28 AWG silicone (2m)
- White 30 AWG silicone (1m)
- JST connectors
- Mini heat shrink

**Cost:** ~$8-12

---

## Quality & Reliability

### Wire Quality Indicators

#### High Quality Wire
✅ Consistent insulation thickness
✅ Strands don't break easily
✅ Insulation doesn't crack when bent
✅ Proper gauge (test with micrometer)
✅ Tinned copper (prevents oxidation)
✅ Clear markings (AWG, specs)
✅ Flexibility appropriate to type
✅ UL or equivalent certification

#### Low Quality Wire (Avoid)
❌ CCA (Copper Clad Aluminum) - higher resistance
❌ Thin, brittle insulation
❌ Inconsistent gauge
❌ Strands break when flexed
❌ No markings
❌ Suspiciously cheap
❌ Oxidized/discolored copper

### Testing Wire Quality

**Visual Inspection:**
1. Strip 1cm of insulation
2. Check for consistent strand count
3. Copper should be shiny (if tinned) or bright (if not)
4. Insulation should be uniform thickness

**Resistance Test:**
1. Measure 1 meter of wire
2. Use multimeter in resistance mode
3. Compare to AWG resistance chart
4. Should be within 10% of spec

**Flexibility Test:**
1. Bend wire 180° back and forth 10 times
2. Good wire: No breaks, insulation intact
3. Bad wire: Strands break, insulation cracks

### Reliable Brands

**Premium:**
- Belden
- Alpha Wire
- General Cable
- Southwire

**Good Quality/Budget:**
- Remington Industries
- TEMCo
- StrivedayHobby Wire
- Ancor Marine

**Avoid:**
- Unbranded bulk cable
- "CCA" (copper-clad aluminum)
- Suspiciously cheap Amazon/eBay

---

## Installation Best Practices

### Preparation

**Stripping Wire:**
- Use proper wire strippers (not knife/teeth!)
- Strip 5-8mm for terminal blocks
- Strip 3-5mm for solder connections
- Don't nick the conductor

**Tinning Stranded Wire:**
```
For terminal blocks and screw connections:
1. Strip wire
2. Twist strands tightly
3. Apply flux
4. Tin with solder
5. Let cool
6. Trim any excess solder
```

Or use **ferrules** (better):
- Crimp ferrule onto stripped wire
- Provides solid termination
- Prevents strand breakage
- Professional appearance

### Connections

**Soldering:**
1. Clean surfaces
2. Apply flux
3. Heat joint, not solder
4. Use appropriate solder (60/40 or lead-free)
5. Let cool naturally (don't blow on it)
6. Inspect for cold joints
7. Cover with heat shrink

**Terminal Blocks:**
1. Strip correct length
2. Tin or use ferrule
3. Insert fully
4. Tighten screw firmly
5. Tug test
6. Double-check polarity

**Crimp Connectors:**
1. Use proper crimp tool
2. Strip correct length (follow connector spec)
3. Fully insert wire
4. Crimp firmly
5. Tug test
6. Inspect crimp

### Routing

**Good Practices:**
✅ Keep power and data wires separated
✅ Avoid sharp bends (minimum 3× wire diameter)
✅ Secure with zip ties or clips every 30cm
✅ Leave service loops (extra wire for future changes)
✅ Use spiral wrap or sleeving for neat appearance
✅ Label both ends of long runs
✅ Avoid running near heat sources
✅ Provide strain relief at connections

**Bad Practices:**
❌ Tight, sharp bends
❌ Wires under tension
❌ No strain relief
❌ Bundling power and data together
❌ No labels
❌ Exposed connections
❌ Wires crossing moving parts

### Protection

**Indoor:**
- Heat shrink tubing over connections
- Spiral wrap for wire management
- Cable clips for routing
- Conduit for walls (if drilling)

**Outdoor:**
- Outdoor-rated wire (UV resistant)
- Waterproof connectors
- Sealed enclosures
- Conduit for exposed runs
- Drip loops at entries
- IP65+ rating

**High Traffic:**
- Flexible conduit or wire loom
- Secure routing away from feet
- Strain relief
- Periodic inspection

---

## Wire Shopping Checklist

Before buying wire, answer:

- [ ] What is the maximum current? (Calculate from LED count)
- [ ] How long is the wire run? (Measure carefully)
- [ ] What is the environment? (Indoor/outdoor/temperature)
- [ ] Will it move? (Stationary/occasional/frequent)
- [ ] What voltage drop is acceptable? (Usually <0.5V for 5V)
- [ ] Do I need shielded wire? (For long data runs)
- [ ] What colors do I need? (Standard: Red +, Black -, White/Yellow data)
- [ ] Solid or stranded? (Based on application)
- [ ] How much extra to buy? (Add 25% for mistakes/future)

## Quick Reference

### Standard Wire Recommendations

**For 95% of WLED Projects:**

| Purpose | Gauge | Type |
|---------|-------|------|
| Power (main) | 18-20 AWG | Stranded, silicone |
| Power (short runs) | 20-22 AWG | Stranded |
| Ground | Same as power | Stranded |
| Data/Signal | 22-24 AWG | Solid or stranded |
| I2C/Sensors | 24-26 AWG | Solid or stranded |
| Breadboard | 22-24 AWG | Solid |

**Wire Colors:**
- **Red**: +5V (positive power)
- **Black**: GND (ground/negative)
- **White/Yellow**: Data/signals
- **Blue**: I2C SDA
- **Yellow**: I2C SCL
- **Green**: Additional data/sensors

---

## Common Mistakes to Avoid

❌ **Using wire too thin** → Voltage drop, overheating, fire risk
❌ **Mixing solid and stranded** in terminals → Poor connection
❌ **Not checking polarity** → Magic smoke!
❌ **Undersizing ground wire** → Same current as power!
❌ **Running data wires parallel to power** → Interference
❌ **No strain relief** → Wires pull out
❌ **Buying CCA wire** → High resistance
❌ **Sharp bends** → Wire breaks
❌ **Not allowing for voltage drop** → Dim/flickering LEDs
❌ **Forgetting service loops** → Can't make changes

---

## Resources

**Wire Gauge Calculators:**
- http://www.calculator.net/voltage-drop-calculator.html
- https://www.wirebarn.com/Wire-Calculator_ep_41.html

**AWG Reference:**
- https://www.engineeringtoolbox.com/wire-gauges-d_419.html

**Connector Types:**
- JST connectors: Low current, quick disconnect
- Lever nuts (Wago): Tool-free, reusable
- Terminal blocks: Screw terminals, permanent
- Ring/spade terminals: Screw/bolt connections

---

## Summary

**Golden Rules:**
1. **Never undersized wire** - use gauge table
2. **Calculate voltage drop** - keep under 0.5V (10%)
3. **Match power and ground gauge** - never skimp on ground
4. **Use quality wire** - avoid CCA, buy from reputable brands
5. **Proper connections** - solder, crimp, or ferrule correctly
6. **Strain relief** - at every connection
7. **Test before deployment** - measure voltage under load
8. **Document** - label wires, take photos

**When in doubt:** Go thicker, use better quality, and test thoroughly!