# Reliability & Maintenance Guide

Best practices for building reliable WLED installations and maintaining them long-term.

## Table of Contents

1. [Design for Reliability](#design-for-reliability)
2. [Installation Best Practices](#installation-best-practices)
3. [Preventive Maintenance](#preventive-maintenance)
4. [Troubleshooting & Repair](#troubleshooting--repair)
5. [Long-Term Monitoring](#long-term-monitoring)
6. [Seasonal Maintenance](#seasonal-maintenance)

---

## Design for Reliability

### Planning Phase

#### Reliability Checklist

**Before starting your project:**

- [ ] **Calculate power correctly** - Add 20% safety margin
- [ ] **Choose reliable LED type** - WS2813/WS2815 for critical installs
- [ ] **Plan power injection** - Every 100-150 LEDs for 5V
- [ ] **Select quality components** - Don't cheap out on PSU/wire
- [ ] **Consider environment** - Temp, humidity, exposure
- [ ] **Plan for maintenance** - How will you access for repairs?
- [ ] **Document everything** - Wiring, configs, parts used
- [ ] **Test before deployment** - Burn-in for 24 hours minimum
- [ ] **Include monitoring** - How will you know if it fails?
- [ ] **Have spares** - Extra LEDs, wire, connectors

### Component Selection for Reliability

#### Power Supply

**Quality Indicators:**
✅ UL/CE/FCC certified
✅ Brand name (Mean Well, TDK, etc.)
✅ Active PFC (power factor correction)
✅ Overload/short protection
✅ Thermal protection
✅ Low ripple (<100mV)
✅ 80+ efficiency
✅ Expected 50,000+ hour MTBF

**Avoid:**
❌ Unbranded generic PSUs
❌ No safety certifications
❌ Suspiciously cheap
❌ No protection features
❌ Poor reviews

**Sizing:**
```
Recommended PSU = (LED Power × 1.2) + ESP32 Power
Never run PSU at >80% capacity continuously
```

**Example:**
```
100 LEDs × 60mA = 6A max
6A × 1.2 safety = 7.2A
+ ESP32 (0.3A) = 7.5A total
Recommended: 10A PSU (75% load)
```

#### LED Type

**For Critical Installations:**

**Best Choice: WS2813 or WS2815**
- Backup data line
- If one LED fails, chain continues
- Worth the premium

**When to use each:**
- **WS2813 (5V)**: Runs up to 5m, easier power
- **WS2815 (12V)**: Runs 10m+, better for long installations

**Avoid for critical:**
- WS2812B (no backup, single point of failure)

#### Wiring

**Reliability Principles:**
1. **Thicker than needed** - Go one gauge thicker
2. **Quality wire** - Not CCA (copper-clad aluminum)
3. **Proper termination** - Solder or crimp, never twist-and-tape
4. **Strain relief** - At every connection
5. **Protection** - Heat shrink, conduit, or sleeving

**Connection Methods by Reliability:**

| Method | Reliability | Use For |
|--------|-------------|---------|
| Solder + Heat Shrink | ⭐⭐⭐⭐⭐ | Permanent, critical |
| Crimp + Heat Shrink | ⭐⭐⭐⭐⭐ | Professional installs |
| Ferrule in terminal | ⭐⭐⭐⭐ | Serviceable connections |
| Screw terminal | ⭐⭐⭐ | Temporary, easy access |
| Twist & wire nut | ⭐⭐ | Indoor, low current |
| Twist & tape | ⭐ | Never for permanent! |

### Environmental Protection

#### Indoor

**Requirements:**
- Temperature: 0-40°C
- Humidity: <80% RH
- IP20 rating sufficient
- Dust protection helpful

**Best Practices:**
- Keep away from heat sources
- Avoid direct sunlight (UV degrades plastic)
- Provide ventilation if enclosed
- Clean periodically

#### Outdoor

**Requirements:**
- Temperature: -20 to 50°C (check LED spec)
- Humidity: Any (with proper IP rating)
- IP65+ rating minimum
- UV protection

**Critical Factors:**
- **Waterproofing**: IP67 minimum, IP68 for submersion
- **UV Protection**: Conformal coating or aluminum channel
- **Temperature**: Use industrial-grade components for extremes
- **Drainage**: Ensure water can't pool
- **Sealing**: Silicone seal all entry points
- **Expansion**: Account for thermal expansion

**Outdoor Checklist:**
- [ ] IP67+ rated LEDs
- [ ] Outdoor-rated power supply (or in weatherproof box)
- [ ] All connections sealed
- [ ] Drip loops on cable entries
- [ ] UV-resistant materials
- [ ] Proper grounding
- [ ] GFCI protection
- [ ] Scheduled inspections

### Redundancy & Fault Tolerance

#### Power Redundancy

**Single Point of Failure:**
```
[PSU] ──→ [LEDs]
If PSU fails, all LEDs fail
```

**Redundant Design:**
```
[PSU 1] ──→ [LEDs 1-150]
[PSU 2] ──→ [LEDs 151-300]
If one PSU fails, half still works
```

**Best Practice:**
- Divide long runs into segments
- Separate power supplies per segment
- Independent control possible

#### Data Redundancy

**Standard (Single Point):**
```
[ESP32] ──→ [LED Chain]
One bad LED = entire chain fails (WS2812B)
```

**Redundant Data (WS2813/WS2815):**
```
[ESP32] ──→ [LED Chain with Backup]
One bad LED = bypassed, chain continues
```

**Multiple Chains:**
```
[ESP32] ──→ GPIO2 ──→ [Chain 1]
        └──→ GPIO4 ──→ [Chain 2]
If one chain fails, other continues
```

#### Controller Redundancy

**For Critical Systems:**

**Dual Controller Setup:**
```
[ESP32 Primary] ─┐
                  ├──→ [LEDs]
[ESP32 Backup]  ─┘

With relay switching:
- Primary operates normally
- Backup monitors primary
- Auto-switches if primary fails
```

**Implementation:**
- Use MQTT heartbeat
- Watchdog monitoring
- Automatic failover relay

---

## Installation Best Practices

### Pre-Installation

#### Testing Protocol

**Bench Test (Before Installation):**

1. **Connectivity Test**
   ```bash
   # Flash test firmware
   ./build.sh flash esp32_debug /dev/ttyUSB0

   # Monitor output
   ./build.sh monitor
   ```
   - Verify WiFi connects
   - Check serial output
   - No error messages

2. **LED Test (Small Section)**
   - Connect 10-20 LEDs only
   - Test all colors (R, G, B, W)
   - Verify brightness levels
   - Check for flickering
   - Measure power consumption

3. **Full Strip Test**
   - Connect entire strip
   - Run at 50% white for 1 hour
   - Monitor temperature
   - Check voltage at end of strip
   - Verify all LEDs work

4. **Power Test**
   - Measure current at full white
   - Compare to calculations
   - Verify PSU doesn't overheat
   - Check voltage under load
   - Test thermal protection

5. **Effects Test**
   - Try various effects
   - Fast animations
   - Color transitions
   - Maximum brightness
   - Watch for glitches

6. **Burn-In**
   - Run at 50% brightness for 24 hours
   - Monitor for failures
   - Check temperature stability
   - Verify no degradation

### During Installation

#### Mechanical

**Mounting Best Practices:**

✅ **Clean surface** - Isopropyl alcohol before adhesive
✅ **Adequate support** - Every 30-50cm for strips
✅ **No stress** - Wire shouldn't pull on connections
✅ **Gentle bends** - Minimum radius 3× strip width
✅ **Secure firmly** - Won't fall/sag over time
✅ **Allow expansion** - Thermal expansion for long runs
✅ **Cable management** - Tidy, labeled, serviceable

❌ **Avoid:**
- Stretching strip during mounting
- Sharp bends (>90°)
- Mounting to hot surfaces
- Leaving unsupported spans
- Compressing/crushing strip

**For Permanent Installations:**
- Use aluminum channel
- Provides heatsink
- Physical protection
- Professional appearance
- Diffuser for smooth light

#### Electrical

**Wiring Best Practices:**

1. **Power Distribution**
   ```
   PSU (+5V)
    ├──→ LED Strip Start
    ├──→ LED Strip Middle (Injection)
    └──→ LED Strip End (Injection)

   PSU (GND)
    ├──→ LED Strip Start
    ├──→ LED Strip Middle
    ├──→ LED Strip End
    └──→ ESP32 GND
   ```

2. **Data Line Routing**
   - Separate from power wires (reduce interference)
   - Keep as short as possible
   - Use shielded cable for long runs
   - Twist with ground for runs >2m
   - 470Ω resistor near ESP32

3. **Grounding**
   - Single common ground point
   - Star grounding from PSU
   - ESP32, LEDs, all grounds connected
   - No ground loops

4. **Protection**
   - Fuse at PSU output (appropriate rating)
   - TVS diode on power (optional, for surge protection)
   - Current limiting in firmware (WLED ABL)

#### Environmental

**Indoor Installation:**
- Keep away from heat (>40°C)
- Avoid direct sunlight
- Good ventilation if enclosed
- Dust protection in dusty areas

**Outdoor Installation:**
- All connections in waterproof boxes
- Drip loops on cables
- Strain relief on all wires
- UV-resistant materials
- Proper drainage
- Cable glands for enclosures

### Post-Installation

#### Final Testing

**Commissioning Checklist:**

- [ ] All LEDs light up
- [ ] Correct color order (not BGR when should be GRB)
- [ ] Brightness works (0-100%)
- [ ] No flickering
- [ ] All effects work
- [ ] WiFi connects reliably
- [ ] Web interface accessible
- [ ] Voltage at strip end >4.7V under load
- [ ] PSU doesn't overheat after 1 hour
- [ ] No error messages in serial monitor
- [ ] Presets load correctly
- [ ] Button works (if applicable)
- [ ] Remote access works
- [ ] Backup/restore tested

#### Documentation

**Create Installation Documentation:**

1. **Wiring Diagram**
   - Draw or photograph wiring
   - Label all connections
   - Note wire gauges
   - Mark polarity clearly

2. **Parts List**
   - ESP32 model
   - LED type and count
   - Power supply specs
   - Wire types and gauges
   - Where purchased (for reordering)

3. **Configuration**
   - Backup WLED config (cfg.json)
   - Save presets
   - Note any custom settings
   - MQTT settings if used

4. **Firmware**
   - WLED version used
   - Custom build flags
   - PlatformIO environment
   - Save .bin file

5. **Maintenance Schedule**
   - When installed
   - Expected maintenance dates
   - Warranty info

**Store Safely:**
- Cloud backup (Google Drive, etc.)
- Local backup
- Physical copy near installation
- Share with client/user

---

## Preventive Maintenance

### Inspection Schedule

#### Weekly (High-Use Installations)

- Visual check for obvious issues
- Quick functional test
- Monitor for unusual behavior

#### Monthly

- [ ] Clean dust from LEDs/controller
- [ ] Check all connections are tight
- [ ] Verify PSU cooling fan (if applicable)
- [ ] Test all effects still work
- [ ] Check for degraded LEDs (dimming)
- [ ] Backup current configuration

#### Quarterly (Every 3 Months)

- [ ] Thorough cleaning
- [ ] Inspect wiring for damage
- [ ] Check solder joints
- [ ] Measure voltage under load
- [ ] Check PSU output ripple
- [ ] Test thermal performance
- [ ] Update firmware if stable version available
- [ ] Verify all safety features work

#### Annually

- [ ] Full system inspection
- [ ] Replace any degraded components
- [ ] Check structural mounting
- [ ] Clean all connections
- [ ] Re-seal outdoor connections
- [ ] Measure LED brightness degradation
- [ ] Consider proactive LED replacement
- [ ] Review and update documentation

### Cleaning

#### LED Strips

**Indoor (IP20):**
- Power off first!
- Soft brush or compressed air
- Microfiber cloth slightly damp
- No liquids directly on LEDs
- Let dry completely before power on

**Outdoor (IP65+):**
- Can use water (gentle spray)
- Mild soap if needed
- Soft brush for stubborn dirt
- Rinse thoroughly
- Check seals after cleaning

**Never:**
- Use harsh chemicals
- Spray directly with high pressure
- Clean while powered
- Use abrasive materials

#### Aluminum Channel

- Remove diffuser
- Clean separately with soap and water
- Clean LEDs as above
- Check thermal contact
- Reattach diffuser

### Firmware Updates

**When to Update:**
✅ Major new features you need
✅ Security fixes
✅ Bug fixes for issues you experience
✅ Scheduled maintenance window

**When NOT to Update:**
❌ "If it ain't broke" - stable production system
❌ Beta/experimental versions (unless testing)
❌ Right before important event
❌ Without testing on spare system first

**Update Procedure:**

1. **Backup Current Config**
   - Download cfg.json
   - Save presets
   - Screenshot all settings

2. **Test New Version**
   - On spare/test system if possible
   - Or on non-critical installation first

3. **Schedule Downtime**
   - Not during events
   - Have time to troubleshoot
   - Plan rollback if needed

4. **Perform Update**
   - OTA if possible (safer)
   - USB if needed
   - Monitor serial output

5. **Verify**
   - All LEDs work
   - Settings preserved
   - No new issues
   - Performance acceptable

6. **Monitor**
   - Watch for 24-48 hours
   - Check for stability
   - Verify no memory leaks

### Proactive Replacement

**Replace Before Failure:**

**LEDs:**
- After 30,000-40,000 hours (check log)
- When 20%+ have noticeably degraded
- Before critical event if old
- Cost of replacement < cost of failure

**Power Supply:**
- After 5-7 years (capacitor aging)
- If fan becomes loud (bearing wear)
- If efficiency drops (measure)
- Before out-of-warranty

**ESP32:**
- Rarely fails if not abused
- Replace if unstable
- Upgrade for new features
- Keep spare on hand

**Wiring:**
- If insulation cracking
- If oxidation visible
- If was underrated
- As part of major service

---

## Troubleshooting & Repair

### Diagnostic Approach

#### Systematic Troubleshooting

**Problem: LEDs Don't Work**

```
Step 1: Check Power
├─ Is PSU plugged in? ──→ Yes ──→ Step 2
└─ No ──→ Plug in, test again

Step 2: Measure Voltage
├─ 5V at PSU output? ──→ Yes ──→ Step 3
└─ No ──→ Replace PSU

Step 3: Voltage at LED Strip?
├─ 5V at start? ──→ Yes ──→ Step 4
└─ No ──→ Check wiring, connections

Step 4: Data Line
├─ Data signal present? (oscilloscope/logic analyzer)
│  ├─ Yes ──→ Check first LED (may be dead)
│  └─ No ──→ Check ESP32, wiring
└─ Can't measure ──→ Try different GPIO pin

Step 5: Configuration
├─ LED count correct? ──→ Verify in WLED settings
├─ GPIO pin correct? ──→ Should match wiring
└─ LED type correct? ──→ WS2812B vs WS2813, etc.
```

### Common Failures & Fixes

#### Dead LED in Chain

**Symptoms:**
- LEDs after certain point don't work
- Some work, rest dark
- (WS2812B only - WS2813/15 bypass dead LEDs)

**Diagnosis:**
1. Power off
2. Visual inspection for burnt/damaged LED
3. Identify last working LED
4. Problem is next LED

**Repair Options:**

**Option 1: Bypass (Temporary)**
```
Cut out dead LED:
[LED n-1] ──X── [Dead LED] ──X── [LED n+1]

Bridge data line:
[LED n-1] DATA OUT ──→ [LED n+1] DATA IN

Power lines:
Maintain 5V and GND continuity
```

**Option 2: Replace LED**
- Requires soldering skills
- Desolder dead LED
- Solder in replacement
- Test before reassembly

**Option 3: Replace Segment**
- Cut strip at nearest cut point before and after
- Install new segment
- Solder connections
- Test thoroughly

#### Power Supply Failure

**Symptoms:**
- No output voltage
- Output voltage low (<4.5V)
- PSU overheating
- Fan not running (if applicable)
- Burning smell

**Diagnosis:**
- Measure output with multimeter
- Check fuse (if accessible)
- Listen for fan
- Feel for excessive heat

**Repair:**
⚠️ **PSUs contain high voltage - don't open unless qualified**

**Safer Approach:**
1. Replace entire PSU
2. Keep failed PSU for RMA/warranty
3. Use opportunity to upgrade if undersized

**Prevention:**
- Don't overload (<80% capacity)
- Ensure good ventilation
- Keep clean (dust clogs cooling)
- Quality brand (Mean Well, etc.)

#### WiFi Connection Issues

**Symptoms:**
- Can't connect to WLED
- Frequent disconnects
- Slow response

**Fixes:**

1. **Check Signal Strength**
   - Move closer to router
   - Add WiFi extender
   - Use external antenna on ESP32

2. **Router Settings**
   - Ensure 2.4GHz enabled
   - Disable AP isolation
   - Set channel (try 1, 6, or 11)
   - Static IP for WLED

3. **ESP32 Settings**
   - Reboot WLED
   - Factory reset and reconfigure
   - Update firmware
   - Check antenna connection

4. **Interference**
   - LED strip can cause interference!
   - Use shielded USB cable
   - Separate ESP32 from LED power
   - Use ferrite beads

#### Flickering LEDs

**Causes & Fixes:**

| Cause | Symptoms | Fix |
|-------|----------|-----|
| Voltage drop | End of strip flickers | Power injection |
| Insufficient capacitance | All flicker on transitions | Add 1000µF cap |
| Poor data signal | Random flickers | Check wiring, add resistor |
| Interference | Irregular flickers | Separate power/data, shield |
| Failing LED | Single LED flickers | Replace LED |
| Underpowered PSU | Flicker at high brightness | Bigger PSU or limit current |

### Repair Tools & Spares

**Essential Tools:**
- Multimeter
- Soldering iron (with fine tip)
- Wire strippers
- Heat shrink tubing
- Spare wire (various gauges)
- Crimpers (if using crimp connectors)

**Helpful Tools:**
- Logic analyzer (cheap USB ones ~$10)
- Oscilloscope (for advanced diagnosis)
- Label maker
- Cable tester

**Spare Parts:**
- Extra LED strip (same type)
- Spare ESP32
- Extra power supply (or known-good for testing)
- Assorted connectors
- Resistors (470Ω for data line)
- Capacitors (1000µF for LED power)

---

## Long-Term Monitoring

### Health Indicators

**Monitor These Metrics:**

1. **Uptime**
   - How long since last reboot?
   - Frequent reboots = problem

2. **WiFi Signal**
   - RSSI level
   - Degrading signal = antenna issue

3. **Voltage**
   - At LED strip end
   - <4.7V under load = need injection

4. **Current Draw**
   - Compared to calculated
   - Much higher = problem
   - Much lower = LEDs failing

5. **Temperature**
   - ESP32 temperature
   - PSU temperature
   - LED temperature (infrared thermometer)

6. **LED Brightness**
   - Periodic test at 100% white
   - Camera reading
   - Compare to baseline
   - 20% loss = consider replacement

### MQTT Monitoring

**Setup Home Assistant or Similar:**

```yaml
# Example monitoring
sensor:
  - platform: mqtt
    name: "WLED Voltage"
    state_topic: "wled/voltage"
    unit_of_measurement: "V"

  - platform: mqtt
    name: "WLED Uptime"
    state_topic: "wled/uptime"

  - platform: mqtt
    name: "WLED WiFi Signal"
    state_topic: "wled/rssi"
    unit_of_measurement: "dBm"

automation:
  - alias: "WLED Offline Alert"
    trigger:
      platform: state
      entity_id: sensor.wled_uptime
      to: 'unavailable'
      for: '00:05:00'
    action:
      service: notify.notify
      data:
        message: "WLED controller is offline!"
```

### Logging

**Keep Maintenance Log:**

```
Date: 2024-12-25
Action: Quarterly inspection
Findings:
  - All LEDs working
  - Voltage at end: 4.9V (good)
  - PSU temperature: 45°C (normal)
  - 2 LEDs slightly dimmer (acceptable)
Actions Taken:
  - Cleaned dust
  - Tightened terminal block screw #3
  - Updated to WLED 0.14.1
Next Service: 2025-03-25
```

---

## Seasonal Maintenance

### Spring

- [ ] Inspect outdoor installations after winter
- [ ] Check for water damage
- [ ] Re-seal any opened connections
- [ ] Clean winter grime
- [ ] Test after being off season

### Summer

- [ ] Check for UV damage (outdoor)
- [ ] Monitor temperatures (LEDs in hot areas)
- [ ] Verify cooling adequate
- [ ] Clean dust/pollen

### Fall

- [ ] Prepare for winter (if seasonal)
- [ ] Extra weatherproofing check
- [ ] Test before holiday season
- [ ] Stock spare parts
- [ ] Update firmware before busy season

### Winter

- [ ] Monitor for condensation (temperature swings)
- [ ] Check operation in cold
- [ ] Ensure heaters not near LEDs
- [ ] Holiday lighting peak - be ready for issues

---

## Summary

### Keys to Reliability

1. **Quality Components** - Don't cheap out
2. **Proper Sizing** - Never at limits
3. **Good Installation** - Do it right first time
4. **Regular Maintenance** - Catch problems early
5. **Documentation** - Know your system
6. **Monitoring** - Early warning of issues
7. **Spare Parts** - Be ready for repairs

### Maintenance Schedule Quick Reference

| Frequency | Tasks |
|-----------|-------|
| **Weekly** | Visual check, quick function test |
| **Monthly** | Clean, check connections, backup config |
| **Quarterly** | Thorough inspection, voltage test, firmware update |
| **Annually** | Full service, proactive replacements, reseal outdoor |

### When to Call for Help

**DIY OK:**
- Replacing dead LEDs
- Firmware updates
- Basic wiring fixes
- Configuration changes

**Get Professional Help:**
- Electrical work beyond low voltage
- Structural mounting concerns
- High-voltage power supply issues
- Building code compliance
- Liability concerns (commercial)

### Emergency Contacts

Keep handy:
- Electrician (if needed)
- LED supplier (for replacements)
- WLED community (Discord, Reddit)
- Your own documentation/notes

---

**Remember:** An ounce of prevention is worth a pound of cure. Regular maintenance is far cheaper than emergency repairs!
