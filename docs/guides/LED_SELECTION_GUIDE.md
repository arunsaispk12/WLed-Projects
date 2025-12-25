# LED Type Selection Guide

Comprehensive guide to selecting the right addressable LED type for your WLED project based on use case, performance, and reliability requirements.

## Table of Contents

1. [LED Types Overview](#led-types-overview)
2. [Detailed Comparisons](#detailed-comparisons)
3. [Use Case Selection](#use-case-selection)
4. [Quality & Reliability](#quality--reliability)
5. [Installation Considerations](#installation-considerations)
6. [Buying Guide](#buying-guide)

---

## LED Types Overview

### Quick Comparison Table

| LED Type | Voltage | Speed | Colors | Data Pin(s) | Price | Reliability | Best For |
|----------|---------|-------|--------|-------------|-------|-------------|----------|
| **WS2812B** | 5V | 800kHz | RGB | 1 | $ | ⭐⭐⭐ | General use |
| **WS2813** | 5V | 800kHz | RGB | 2 (backup) | $$ | ⭐⭐⭐⭐⭐ | Critical installations |
| **SK6812** | 5V | 800kHz | RGB/RGBW | 1 | $$ | ⭐⭐⭐⭐ | Better colors |
| **SK6812 RGBW** | 5V | 800kHz | RGBW | 1 | $$$ | ⭐⭐⭐⭐ | White + colors |
| **WS2815** | 12V | 800kHz | RGB | 2 (backup) | $$$ | ⭐⭐⭐⭐⭐ | Long runs |
| **APA102** | 5V | 20MHz | RGB | 2 (CLK+DAT) | $$$ | ⭐⭐⭐⭐⭐ | High speed/POV |
| **SK9822** | 5V | 20MHz | RGB | 2 (CLK+DAT) | $$$ | ⭐⭐⭐⭐⭐ | APA102 alternative |

### Standard WS2812B

**The Default Choice**

**Specifications:**
- Voltage: 5V
- Current: 60mA max per LED (full white)
- Protocol: Single-wire serial
- Speed: 800kHz
- Color: RGB (3 channels)
- IC: Built into each LED

**Pros:**
✅ Most common (wide availability)
✅ Cheapest option
✅ Excellent WLED support
✅ Easy to find tutorials/help
✅ Single data wire (simple wiring)
✅ Good color accuracy
✅ Many form factors (strip, matrix, ring, etc.)

**Cons:**
❌ No redundancy (one bad LED breaks chain)
❌ Sensitive to voltage drops
❌ Timing-critical protocol
❌ Limited white quality (RGB mixing)

**Use When:**
- First project / learning
- Budget constrained
- Indoor installation
- Simple setups
- Wide availability needed

**WLED Configuration:**
```cpp
#define DEFAULT_LED_TYPE TYPE_WS2812_RGB
#define LED_COLOR_ORDER GRB
```

---

### WS2813 (Improved WS2812B)

**The Reliable Choice**

**Specifications:**
- Voltage: 5V
- Current: 60mA max per LED
- Protocol: Dual-signal (backup data line)
- Speed: 800kHz
- Color: RGB
- IC: WS2813B

**Key Difference:**
- **Backup data line**: If one LED fails, signal bypasses to next LED
- Chain continues working even with dead LEDs

**Pros:**
✅ Fault-tolerant (broken LED doesn't stop chain)
✅ Better reliability for long-term
✅ Same WLED compatibility as WS2812B
✅ Similar pricing to WS2812B
✅ Peace of mind for installations

**Cons:**
❌ Slightly more expensive than WS2812B
❌ Still 5V (voltage drop on long runs)
❌ Requires 3-pin connection (but middle pin unused)

**Use When:**
- Permanent installations
- Hard-to-maintain locations
- Critical applications (can't afford downtime)
- Long LED strips (>100 LEDs)
- Professional projects

**WLED Configuration:**
```cpp
#define DEFAULT_LED_TYPE TYPE_WS2813_RGB
#define LED_COLOR_ORDER GRB
```

**Recommendation:** ⭐ **Best reliability for 5V projects**

---

### SK6812 (Better Colors)

**The Quality Choice**

**Specifications:**
- Voltage: 5V
- Current: 60mA (RGB) or 70mA (RGBW)
- Protocol: Single-wire serial
- Speed: 800kHz
- Color: RGB or RGBW
- IC: SK6812

**Pros:**
✅ Better color accuracy than WS2812B
✅ More vibrant colors
✅ Better consistency between LEDs
✅ Available in RGBW (dedicated white LED)
✅ Smooth transitions
✅ Slightly better reliability

**Cons:**
❌ More expensive than WS2812B
❌ Still no backup data line (use WS2815 for that)
❌ RGBW uses more power
❌ RGBW needs 4-channel support in firmware

**RGBW Variant:**
- Separate white LED alongside RGB
- True white light (not RGB mixing)
- Better for lighting (not just decoration)
- Uses more power (extra LED)

**Use When:**
- Color accuracy important
- Need true white light (RGBW)
- Dual-purpose (lighting + effects)
- Willing to pay premium for quality

**WLED Configuration:**

RGB:
```cpp
#define DEFAULT_LED_TYPE TYPE_SK6812_RGB
#define LED_COLOR_ORDER GRB
```

RGBW:
```cpp
#define DEFAULT_LED_TYPE TYPE_SK6812_RGBW
#define LED_COLOR_ORDER GRBW
```

---

### WS2815 (12V with Backup)

**The Long-Run Choice**

**Specifications:**
- Voltage: 12V
- Current: 15mA per LED (much lower!)
- Protocol: Dual-signal (backup)
- Speed: 800kHz
- Color: RGB
- IC: WS2815B

**Key Advantages:**
- **12V operation**: Much less voltage drop over distance
- **Lower current**: Can run 3× longer before power injection
- **Backup data line**: Skip failed LEDs
- **Best for long runs**: 300+ LEDs on single injection

**Pros:**
✅ 12V = less voltage drop
✅ Lower current per LED (15mA vs 60mA)
✅ Longer runs without power injection
✅ Fault-tolerant (backup data)
✅ Less copper needed in wiring
✅ Best for architectural/professional installs

**Cons:**
❌ More expensive
❌ Requires 12V power supply (not 5V)
❌ Can't mix with 5V LEDs
❌ Less common / harder to find
❌ Need 12V-safe components

**Use When:**
- Very long LED runs (>5 meters)
- Architectural installations
- Minimizing power injection points
- Professional installations
- Outdoor/high-reliability needs

**WLED Configuration:**
```cpp
#define DEFAULT_LED_TYPE TYPE_WS2815_RGB
#define LED_COLOR_ORDER GRB
```

**Power Comparison:**
```
100 LEDs at full white:
WS2812B (5V): 6A → Voltage drop issues at 5m
WS2815 (12V): 1.5A → Works fine at 15m+
```

**Recommendation:** ⭐ **Best for installations >100 LEDs**

---

### APA102 / SK9822 (High Speed)

**The Performance Choice**

**Specifications:**
- Voltage: 5V
- Current: 60mA per LED
- Protocol: SPI (clock + data)
- Speed: Up to 20MHz
- Color: RGB
- IC: APA102 or SK9822

**Key Differences:**
- **Separate clock line**: More reliable signal
- **Much faster**: 25× faster than WS2812B
- **Global brightness**: Built-in PWM for smooth dimming
- **No timing requirements**: Clock-based, not timing-based

**Pros:**
✅ Extremely fast refresh (POV displays)
✅ Very reliable signaling (clock + data)
✅ Better color depth (global brightness)
✅ Not timing-sensitive (easier to program)
✅ Can daisy-chain for extreme lengths
✅ Smoother animations
✅ Better for high-speed applications

**Cons:**
❌ More expensive
❌ Two data wires needed (clock + data)
❌ More complex wiring
❌ Still 5V (voltage drop on long runs)
❌ Fewer mounting options

**Use When:**
- Persistence of vision (POV) displays
- Very fast animation rates needed
- Reliable signaling critical
- Budget allows
- Want smoothest possible effects

**WLED Configuration:**
```cpp
#define DEFAULT_LED_TYPE TYPE_APA102_RGB
#define LED_COLOR_ORDER BGR
#define APA102_CLOCK_PIN 14  // Clock pin
```

**Wiring:**
```
ESP32        APA102
GPIO2  ────→ DATA
GPIO14 ────→ CLOCK
GND    ────→ GND
```

**SK9822 vs APA102:**
- SK9822: Clone of APA102, cheaper, compatible
- APA102: Original, slightly better quality
- Both work with same WLED settings

**Recommendation:** ⭐ **Best for POV or high-speed applications**

---

## Detailed Comparisons

### Voltage: 5V vs 12V

**5V LEDs (WS2812B, WS2813, SK6812, APA102):**

**Advantages:**
- Common power supplies
- Can use USB power (small projects)
- ESP32 and LEDs same voltage (simpler)
- More LED types available

**Disadvantages:**
- Voltage drop over distance
- Need power injection every 100-150 LEDs
- Higher current (thicker wires needed)
- Limited to shorter runs

**Best For:**
- Projects <100 LEDs
- Indoor installations
- USB-powered projects
- Prototypes and learning

---

**12V LEDs (WS2815):**

**Advantages:**
- Much less voltage drop
- Can run 300+ LEDs per injection point
- Lower current (thinner wires OK)
- Better for long runs

**Disadvantages:**
- Need 12V power supply
- Can't use USB power
- Fewer LED type options
- More expensive

**Best For:**
- Long LED runs (>5 meters)
- Architectural lighting
- Outdoor installations
- Professional projects

---

### Protocol: Single Wire vs Dual Wire

**Single Wire (WS2812B, SK6812):**

**How it works:**
- Data encoded in precise timing
- One bad LED breaks entire chain
- Timing-critical

**Advantages:**
- Simple wiring (just one data line)
- Easy to understand
- Most common

**Disadvantages:**
- Failure-prone (one bad LED = broken chain)
- Timing-sensitive
- Harder to troubleshoot

**Best For:**
- Short, simple installations
- Easy access for repairs
- Learning projects

---

**Dual Wire - Backup Data (WS2813, WS2815):**

**How it works:**
- Each LED has backup data line
- If LED fails, data passes through to next
- Chain continues working

**Advantages:**
- Fault-tolerant
- More reliable long-term
- Professional quality

**Disadvantages:**
- Slightly more expensive
- Still timing-based (not as good as clock-based)

**Best For:**
- Permanent installations
- Hard to access locations
- Critical applications

---

**Dual Wire - Clock + Data (APA102, SK9822):**

**How it works:**
- Separate clock and data lines
- Clock controls timing (not precise delays)
- Very reliable signaling

**Advantages:**
- Most reliable protocol
- Not timing-sensitive
- Extremely fast capable
- Better color depth

**Disadvantages:**
- Two data lines needed
- More complex wiring
- More expensive

**Best For:**
- High-speed applications
- Maximum reliability
- POV displays

---

### RGB vs RGBW

**RGB (3 Colors):**

**White Light Method:**
- Mixes Red + Green + Blue = White
- "RGB White" has slight color tint
- Not true white

**Advantages:**
- Cheaper
- More common
- Simpler
- Full color range

**Disadvantages:**
- Poor white quality
- Inefficient for white light
- White has color tint
- Uses all 3 LEDs for white (more power)

**Best For:**
- Color effects primary
- Decorative lighting
- Budget builds
- Most WLED projects

---

**RGBW (4 Colors):**

**White Light Method:**
- Dedicated white LED
- True white light
- Can do colors OR white OR both

**Advantages:**
- Excellent white light quality
- More efficient for white
- Dual-purpose (effects + lighting)
- Better CRI (color rendering)

**Disadvantages:**
- More expensive
- Slightly more complex (4-channel)
- Uses more power with white
- Fewer product options

**Best For:**
- Accent + task lighting
- Need quality white light
- Home lighting applications
- Premium projects

**WLED RGBW Modes:**
- **White channel only**: Just white LED
- **RGB only**: Standard color effects
- **White + RGB**: Best of both
- **Auto white balance**: WLED manages for you

---

## Use Case Selection

### Project Type Matrix

| Use Case | Recommended LED | Alternative | Why |
|----------|----------------|-------------|-----|
| **First project** | WS2812B | SK6812 | Cheap, common, good support |
| **Learning WLED** | WS2812B | - | Most tutorials use this |
| **Budget project** | WS2812B | - | Cheapest option |
| **Permanent install** | WS2813 | WS2815 | Backup data line |
| **Long runs (>5m)** | WS2815 | - | 12V reduces voltage drop |
| **Outdoor** | WS2813/WS2815 | IP67 SK6812 | Reliability + weatherproof |
| **Color accuracy** | SK6812 RGB | APA102 | Better color rendering |
| **White lighting** | SK6812 RGBW | - | Dedicated white LED |
| **POV display** | APA102 | SK9822 | High speed required |
| **Matrix/grid** | WS2812B | APA102 | Depends on refresh rate |
| **Wearables** | WS2812B Mini | - | Small, lightweight |
| **Architectural** | WS2815 | WS2813 | Professional quality, long-term |
| **Event/temporary** | WS2812B | - | Cost-effective, replaceable |

---

### Detailed Use Cases

#### Home Accent Lighting (Beginner)

**Requirements:**
- 1-3 meters of LEDs
- Indoor use
- Easy to set up
- Budget-friendly

**Recommended: WS2812B 60 LED/m**

**Why:**
- Cheapest and most common
- Easy to find tutorials
- Good enough quality for home use
- Simple single-wire connection

**Specs:**
- Type: WS2812B
- Density: 60 LED/m
- IP Rating: IP20 (indoor)
- Power: 5V 3-5A

**Alternative:** SK6812 if want better colors

---

#### Living Room Cove Lighting

**Requirements:**
- 5-10 meters of LEDs
- Both white light and color effects
- Always on in evening (high usage)
- Hidden installation

**Recommended: SK6812 RGBW 60 LED/m**

**Why:**
- Dedicated white LED for quality lighting
- Can do white + colors
- Better CRI for living space
- Worth the premium for daily use

**Specs:**
- Type: SK6812 RGBW
- Density: 60 LED/m
- IP Rating: IP20
- Power: 5V 10A with power injection
- Color Temperature: 3000K or 6500K white

**Alternative:** WS2815 if >10m run

---

#### Outdoor Holiday Lighting

**Requirements:**
- Weatherproof
- Seasonal use (not 24/7)
- 10-20 meters
- Easy to remove/store

**Recommended: WS2813 30-60 LED/m, IP67**

**Why:**
- Backup data line (if one LED fails, rest work)
- Weatherproof coating
- Can be reused yearly
- Moderate cost for seasonal use

**Specs:**
- Type: WS2813
- Density: 30 or 60 LED/m
- IP Rating: IP67 (waterproof)
- Power: 5V 10A+ with outdoor PSU
- Silicone sleeve coating

**Alternative:** WS2815 IP67 if very long runs

---

#### Architectural Installation (Building Outline)

**Requirements:**
- 50-100 meters of LEDs
- Permanent outdoor
- Professional appearance
- High reliability

**Recommended: WS2815 30 LED/m, IP67**

**Why:**
- 12V = minimal voltage drop over long distance
- Backup data line for reliability
- Lower current = simpler power distribution
- Professional-grade durability

**Specs:**
- Type: WS2815
- Density: 30 LED/m (lower density for large scale)
- IP Rating: IP67
- Power: 12V 20A+ distributed
- Aluminum channel mounting

**Power Injection:**
- Every 300 LEDs (10 meters)
- Use proper outdoor-rated wire
- Fused distribution

---

#### POV Display / Light Painting

**Requirements:**
- Very fast refresh (60+ FPS)
- Smooth animations
- Portable
- Camera-friendly

**Recommended: APA102 144 LED/m**

**Why:**
- 20MHz refresh (extremely fast)
- No motion blur
- Global brightness for smooth fades
- Best for photography/video

**Specs:**
- Type: APA102 or SK9822
- Density: 144 LED/m (high density)
- IP Rating: IP20
- Power: 5V 5A (battery if portable)
- Short strip (0.5-1m typically)

**Alternative:** SK9822 (cheaper APA102 clone)

---

#### Dance Floor / Stage Lighting

**Requirements:**
- Rugged construction
- High brightness
- Fast effects
- Professional quality

**Recommended: WS2815 60 LED/m in aluminum channel**

**Why:**
- 12V = robust against voltage drops
- Backup data for reliability
- Aluminum channel protection
- Can drive hard (bright)

**Specs:**
- Type: WS2815
- Density: 60 LED/m
- IP Rating: IP65+ (if outdoor events)
- Power: 12V 30A+ distributed
- Aluminum U-channel with diffuser

---

#### Staircase Lighting (per-step)

**Requirements:**
- Multiple short segments
- Motion activated
- Always-on capability
- Safe (no trip hazard)

**Recommended: WS2813 or SK6812 RGBW 60 LED/m**

**Why:**
- Backup data (if one step fails, others work)
- RGBW for white stair lighting
- Each step can be separate segment
- Professional appearance

**Specs:**
- Type: WS2813 or SK6812 RGBW
- Density: 60 LED/m
- IP Rating: IP65 (in aluminum channel)
- Power: 5V 5-10A
- Aluminum channel in stair nose

**WLED Configuration:**
- Each step = separate segment
- Motion sensor trigger
- Auto-off timer

---

#### Gaming PC Case

**Requirements:**
- Compact space
- Heat tolerant
- Synchronized with games
- Small power budget

**Recommended: WS2812B 30 LED/m**

**Why:**
- Compact form factor
- Heat-tolerant IC
- Easy integration
- RGB sync capable

**Specs:**
- Type: WS2812B
- Density: 30 LED/m
- IP Rating: IP20
- Power: PC SATA/Molex adapter
- Magnetic or 3M adhesive mounting

**Integration:**
- Prismatik or similar for screen sync
- Game integration via API
- USB-powered via PC

---

## Quality & Reliability

### Quality Indicators

#### High-Quality LEDs

✅ **Consistent brightness** across all LEDs
✅ **Uniform color** (no greenish/pinkish tints)
✅ **Proper binning** (all LEDs from same batch)
✅ **Thick PCB** (1.6mm+, not thin/flexible cheap PCB)
✅ **Double-layer PCB** for better electrical
✅ **Quality solder joints** (clean, consistent)
✅ **Proper resistors** (surface mount, correct values)
✅ **Strong adhesive** backing (if strip)
✅ **Clear documentation** (specs, datasheets)
✅ **Brand name** (BTF-Lighting, Alitove, etc.)

#### Low-Quality LEDs (Avoid)

❌ Inconsistent brightness between LEDs
❌ Color variations (some greenish, some pink)
❌ Thin, flimsy PCB
❌ Poor solder joints
❌ Wrong or missing resistors
❌ Weak adhesive (falls off easily)
❌ No documentation
❌ Suspiciously cheap
❌ Unknown seller

### Testing New LEDs

**Upon Arrival:**

1. **Visual Inspection:**
   - Check solder joints
   - Look for damaged LEDs
   - Verify markings (chip type)
   - PCB quality

2. **Test Small Section:**
   - Connect only first 10 LEDs
   - Test all colors: Red, Green, Blue, White
   - Check brightness consistency
   - Verify data flows correctly

3. **Power Test:**
   - Measure current at full white
   - Should be ~60mA × LED count
   - Much less = fake/low quality
   - Measure voltage at strip (should be 5.0V ±0.2V)

4. **Burn-In:**
   - Run at 50% brightness for 8 hours
   - Check for failures
   - Temperature should be <50°C

### Reliability Factors

**Expected Lifespan:**

| LED Type | Expected Hours | Conditions |
|----------|---------------|------------|
| WS2812B | 30,000-50,000 | 50% brightness, indoor |
| WS2813 | 40,000-60,000 | 50% brightness, indoor |
| SK6812 | 40,000-60,000 | 50% brightness, indoor |
| WS2815 | 50,000-70,000 | 12V = less stress |
| APA102 | 40,000-60,000 | 50% brightness, indoor |

**At 100% continuous:** Divide by 2-3
**Outdoor exposure:** Divide by 2

**Degradation Over Time:**
- Brightness decreases 20-30% over lifespan
- Blue LEDs typically fail first
- Quality brands degrade slower

**What Kills LEDs:**
1. **Heat** - #1 killer
   - Keep <60°C
   - Provide airflow
   - Use aluminum channel as heatsink
   - Don't run at 100% continuously

2. **Overvoltage** - Instant death
   - Use regulated 5V ±5%
   - Protect from spikes
   - Quality power supply

3. **Static Electricity** - Kills IC
   - Ground yourself before handling
   - Use ESD-safe workspace
   - Be careful during installation

4. **Physical Damage**
   - Bending too sharply
   - Crushing/pressure
   - Cutting between wrong points

5. **Moisture** (for non-IP rated)
   - Corrosion
   - Shorts
   - Use IP65+ for outdoor

### Maximizing Lifespan

**Best Practices:**

1. **Limit Brightness**
   - 50-80% brightness vs 100%
   - Doubles lifespan
   - Still looks great

2. **Current Limiting**
   - Set WLED max current
   - ABL (Auto Brightness Limiter)
   - Protects PSU and LEDs

3. **Good Power Supply**
   - Quality brand
   - Regulated output
   - Adequate capacity
   - Low ripple

4. **Proper Cooling**
   - Aluminum channel
   - Airflow if enclosed
   - Monitor temperature

5. **Voltage Regulation**
   - Maintain 5V ±5%
   - Power injection as needed
   - Quality wiring

6. **Protection**
   - Fuse on power input
   - TVS diode for surges (optional)
   - Proper IP rating for environment

---

## Installation Considerations

### LED Density

**30 LED/meter:**
- Individual LEDs visible
- Lower power consumption
- Cheaper
- Good for large-scale (buildings)
- Effects more "pixelated"

**60 LED/meter:** ⭐ **Most Common**
- Good balance
- Smooth effects at close range
- Moderate power
- Most tutorials use this

**144 LED/meter:**
- Very smooth effects
- High power consumption
- Expensive
- Best for close viewing
- POV/photography

**Choose based on viewing distance:**
- >3m away: 30 LED/m fine
- 1-3m: 60 LED/m recommended
- <1m: 144 LED/m for smoothness

### Mounting

**Adhesive Backing:**
- **Pros**: Easy installation
- **Cons**: Falls off over time, heat-sensitive
- **Use**: Temporary, low-heat areas
- **Tip**: Clean surface with isopropyl alcohol first

**Aluminum Channel:**
- **Pros**: Professional, heatsink, protection, diffuser
- **Cons**: More expensive, harder to install
- **Use**: Permanent, high-visibility installations
- **Types**: U-channel, V-channel, corner channel

**Clips/Brackets:**
- **Pros**: Removable, precise positioning
- **Cons**: Time-consuming
- **Use**: Outdoor, high-vibration areas

**Hot Glue:**
- **Pros**: Strong, heat-resistant
- **Cons**: Permanent, hard to remove
- **Use**: Outdoor, vibration areas
- **Tip**: Apply to backing, not to LEDs directly

### IP Ratings

**IP20 (No Protection):**
- Indoor only
- Cheapest
- Bare strip
- Most common

**IP65 (Splash Resistant):**
- Silicone coating on top
- Light rain OK
- Good for humid areas
- Medium price

**IP67 (Waterproof):**
- Silicone sleeve all around
- Submersible (brief)
- Outdoor installations
- Higher price

**IP68 (Fully Waterproof):**
- Heavy silicone tube
- Continuous submersion
- Pool/fountain use
- Most expensive

**Note:** Higher IP = less heat dissipation. May need to reduce brightness.

---

## Buying Guide

### Recommended Brands

**Premium Quality:**
- **BTF-Lighting**: Excellent quality, widely available
- **Alitove**: Good quality, reliable
- **WS2812B Eco**: Eco-friendly option
- **Adafruit NeoPixel**: Premium price, best quality

**Good Budget Options:**
- **BTF-Lighting**: Still good at budget level
- **CHINLY**: Decent quality, good price
- **SHIJI Lighting**: Budget-friendly

**Avoid:**
- Unknown AliExpress sellers
- Listings without specs
- Impossibly cheap options
- No reviews or bad reviews

### Where to Buy

**USA:**
- BTF-Lighting (Amazon)
- Adafruit
- SparkFun
- DigiKey (for small quantities)

**International:**
- AliExpress (BTF-Lighting official store)
- Banggood
- Ray Wu's Store (AliExpress)

### What to Check

Before ordering:

- [ ] LED type (WS2812B, WS2813, etc.)
- [ ] Voltage (5V or 12V)
- [ ] Density (30, 60, or 144 LED/m)
- [ ] IP rating (for your environment)
- [ ] Length needed (+10% extra)
- [ ] White PCB or Black PCB (black looks better)
- [ ] Connector type (JST, wire leads, etc.)
- [ ] Power requirements (calculate from LED count)
- [ ] Seller reputation (reviews, ratings)
- [ ] Return policy
- [ ] Estimated delivery time

### Pricing Guide (2024)

**Per Meter (60 LED/m, IP20):**

- WS2812B: $5-8
- WS2813: $8-12
- SK6812 RGB: $8-12
- SK6812 RGBW: $12-18
- WS2815: $10-15
- APA102: $15-25

**Bulk discount:** Usually 20-30% for 5+ meters

**IP65/67:** Add $2-4 per meter

**Custom lengths:** May cost more (cut fees)

---

## Quick Decision Chart

```
Start Here
    │
    ├─ Budget <$50 total? ──→ WS2812B
    │
    ├─ Need waterproof? ──→ WS2813 IP67
    │
    ├─ >5 meter run? ──→ WS2815 (12V)
    │
    ├─ Need white light? ──→ SK6812 RGBW
    │
    ├─ POV / High speed? ──→ APA102
    │
    ├─ Maximum reliability? ──→ WS2813 or WS2815
    │
    └─ General purpose? ──→ WS2812B or SK6812
```

---

## Summary

### For Most People

**Recommended: WS2812B 60 LED/m**
- Most common, best support
- Cheapest option
- Perfect for learning
- Wide availability

**Upgrade to WS2813 if:**
- Permanent installation
- Hard-to-access location
- Want reliability

**Upgrade to SK6812 RGBW if:**
- Need white light
- Dual-purpose lighting/effects

**Upgrade to WS2815 if:**
- Long runs (>100 LEDs)
- Professional installation
- 12V acceptable

**Upgrade to APA102 if:**
- Need high speed
- POV display
- Maximum reliability

### Final Recommendation

**80% of projects:** WS2812B or WS2813
**Professional/permanent:** WS2813 or WS2815
**Dual-purpose lighting:** SK6812 RGBW
**High-performance:** APA102

**When in doubt:** Start with WS2812B, upgrade later if needed!

---

## Resources

**Datasheets:**
- [WS2812B Datasheet](https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf)
- [WS2813 Datasheet](https://www.led-stuebchen.de/download/WS2813_V1.2_EN.pdf)
- [SK6812 Datasheet](https://cdn-shop.adafruit.com/product-files/1138/SK6812+LED+datasheet+.pdf)

**Calculators:**
- [WLED Power Calculator](https://wled-calculator.github.io/)
- LED Strip Length Calculator: Length = Count ÷ Density

**Communities:**
- r/WLED on Reddit
- WLED Discord
- This repository!

