# Common Issues and Solutions

Comprehensive troubleshooting guide for WLED projects.

## Table of Contents

1. [Hardware Issues](#hardware-issues)
2. [Software/Firmware Issues](#softwarefirmware-issues)
3. [WiFi Connection Issues](#wifi-connection-issues)
4. [LED Strip Issues](#led-strip-issues)
5. [Power Issues](#power-issues)
6. [Performance Issues](#performance-issues)
7. [Programming/Upload Issues](#programmingupload-issues)

---

## Hardware Issues

### ESP32 Won't Power On

**Symptoms:**
- No LED lights on ESP32
- No response when connected via USB
- No WiFi AP created

**Possible Causes:**
1. USB cable is charge-only (no data lines)
2. USB port not providing enough power
3. Damaged ESP32 board
4. Short circuit in wiring

**Solutions:**

```
Step 1: Check USB Cable
- Try different USB cable (must be data cable)
- Verify cable works with other devices

Step 2: Check Power Source
- Try different USB port
- Use powered USB hub
- Try different computer/power adapter

Step 3: Visual Inspection
- Look for burnt components
- Check for solder bridges
- Verify no shorts between VCC and GND
- Measure resistance between power pins (should be >1kΩ)

Step 4: Test ESP32
- Disconnect all external components
- Connect only USB
- Check if built-in LED lights up
```

### Connections Keep Falling Out

**Symptoms:**
- Intermittent operation
- LEDs flicker randomly
- ESP32 resets unexpectedly

**Solutions:**
1. **Breadboard Projects:**
   - Use fresh breadboard (worn ones have loose connections)
   - Ensure wires fully inserted
   - Use  solid core wire, not stranded
   - Consider soldering to perfboard

2. **Solder Connections:**
   - Reflow questionable joints
   - Add strain relief
   - Use heat shrink tubing

3. **Terminal Blocks:**
   - Tighten screws firmly
   - Use ferrules on stranded wire
   - Double-check polarity

---

## Software/Firmware Issues

### Can't Upload Firmware

**Symptoms:**
- "Failed to connect" error
- Timeout during upload
- "A fatal error occurred" message

**Solutions:**

```
Method 1: Hold BOOT Button
1. Disconnect USB
2. Hold down BOOT button on ESP32
3. Connect USB while holding BOOT
4. Click upload in Arduino IDE/PlatformIO
5. Release BOOT when upload starts

Method 2: Check Drivers
Windows:
- Install CP210x or CH340 drivers
- Device Manager should show COM port

Linux:
- Add user to dialout group:
  sudo usermod -a -G dialout $USER
- Log out and back in
- Check port: ls /dev/ttyUSB*

Mac:
- Install drivers if needed
- Check: ls /dev/cu.*

Method 3: Check Port Selection
- Arduino IDE: Tools → Port
- PlatformIO: Check upload_port in platformio.ini
- Verify correct port selected

Method 4: Try Different Baud Rate
- Change upload_speed in platformio.ini:
  upload_speed = 115200  ; Instead of 460800
```

### Firmware Compiles but Doesn't Work

**Symptoms:**
- Upload successful but ESP32 doesn't run code
- Constant resets
- Serial monitor shows errors

**Check Serial Monitor:**

```bash
pio device monitor -b 115200
```

**Common Errors and Fixes:**

| Error | Cause | Solution |
|-------|-------|----------|
| "Brownout detector" | Insufficient power | Better power supply/cable |
| "Guru Meditation Error" | Code crash | Check debug logs, update libraries |
| "Stack canary watchpoint" | Stack overflow | Reduce LED count or features |
| "Flash write failed" | Corrupted flash | Erase and reflash |

**Solution:**

```bash
# Erase flash completely
pio run -t erase

# Re-upload firmware
pio run -t upload

# Monitor for errors
pio device monitor
```

---

## WiFi Connection Issues

### Can't Find WLED-AP Network

**Symptoms:**
- No WLED-AP WiFi network appears
- Can't access captive portal

**Solutions:**

```
Step 1: Force AP Mode
- Hold button for 10 seconds
- ESP32 should create AP

Step 2: Check Frequency
- Ensure looking for 2.4GHz network
- ESP32 doesn't support 5GHz

Step 3: Check Distance
- Move closer to ESP32
- Check antenna if using external

Step 4: Reset WiFi Settings
- Flash firmware with WiFi reset
- Or short GPIO0 to GND during boot
```

### Won't Connect to Home WiFi

**Symptoms:**
- Connects to AP but not home WiFi
- Keeps reverting to AP mode
- Credentials seem correct

**Common Issues:**

1. **Wrong Password:**
   - Re-enter carefully
   - Check for spaces
   - Verify caps lock

2. **Special Characters:**
   - Some special characters cause issues
   - Try simpler password
   - Use WPA2-PSK (not WPA3)

3. **Hidden SSID:**
   - WLED doesn't work well with hidden SSIDs
   - Unhide network or manually configure

4. **Router Settings:**
   - Disable AP isolation
   - Enable 2.4GHz band
   - Check MAC filtering
   - Verify DHCP enabled

**Debug via Serial Monitor:**

```
Connect via USB and monitor:
pio device monitor

Look for:
- "WiFi connected" (good)
- "WiFi connection failed" (bad)
- IP address assigned

If IP shown: Note it and access via IP instead of mDNS
```

### Can't Access Web Interface

**Symptoms:**
- WiFi connected but can't load http://wled.local
- Browser shows "can't connect"

**Solutions:**

```
Method 1: Use IP Address
- Check router's DHCP table for ESP32 IP
- Or check serial monitor for IP
- Access: http://192.168.1.XXX

Method 2: Check mDNS/Bonjour
Windows:
- Install Bonjour (comes with iTunes)
- Or use IP address

Mac/Linux:
- Should work by default
- Try: ping wled.local

Method 3: Check Firewall
- Temporarily disable firewall
- Add exception for port 80
- Check antivirus isn't blocking

Method 4: Try Different Browser
- Chrome/Edge usually work best
- Clear browser cache
- Try incognito/private mode
```

---

## LED Strip Issues

### No LEDs Light Up

**Systematic Diagnosis:**

```
Test 1: Power
- Measure 5V at LED strip with multimeter
- Should be 4.9-5.2V
- If no voltage: check power supply connections

Test 2: Data Signal
- Set WLED to solid color at full brightness
- Measure voltage on data line
- Should toggle between 0V and 3.3V (or 5V after level shifter)

Test 3: Level Shifter
- Verify 74HCT125 getting power (5V on pin 14)
- Check enable pin grounded (pin 1)
- Measure input vs output signal

Test 4: LED Strip
- Try different LED strip
- Check strip isn't damaged
- Verify correct input end (DI not DO)

Test 5: Configuration
- Config → LED Preferences
- Verify LED count correct
- Try different GPIO pin
- Test with LED count = 1
```

**Solutions:**

| Issue Found | Fix |
|-------------|-----|
| No 5V power | Check power supply, connections, fuse |
| No data signal | Check GPIO config, try different pin |
| Signal at ESP32 but not strip | Check level shifter, data line continuity |
| 5V and data present | LED strip may be damaged, try different strip |

### Wrong Colors

**Symptoms:**
- Red shows as green
- Blue shows as red
- Colors scrambled

**Solution:**
Change color order in Config → LED Preferences

Try in this order:
1. GRB (most common for WS2812B)
2. RGB
3. BGR
4. BRG
5. RBG
6. GBR

**Quick Test:**
```
Set to solid red in WLED
If shows green: Color order wrong
If shows correct: Color order correct
```

### First LED Works, Rest Don't

**Cause:**
- Data signal not reaching subsequent LEDs
- Damaged LED in chain
- Voltage drop

**Solutions:**

```
Test 1: Check Data Line Continuity
- Power off
- Test continuity from first LED DO to second LED DI
- Should be <1Ω

Test 2: Isolate Bad LED
- Cut strip in half
- Test each half
- Narrow down to specific LED
- Replace or bypass bad LED

Test 3: Power Injection
- Add power at midpoint of strip
- Inject 5V and GND every 100-150 LEDs
```

### LEDs Flicker or Glitch

**Symptoms:**
- Random flickering
- Wrong colors occasionally
- Intermittent operation

**Common Causes & Fixes:**

1. **Insufficient Capacitance:**
   ```
   Add 1000µF capacitor at LED power input
   Or add 100-220µF every 50-100 LEDs
   ```

2. **Data Line Issues:**
   ```
   - Add 220-470Ω resistor at ESP32 output
   - Keep data line short (<3m)
   - Use shielded cable for long runs
   - Add 0.1µF capacitor between data and GND at LED end
   ```

3. **Ground Loops:**
   ```
   - Ensure single common ground point
   - Don't create ground loops
   - Use star grounding from power supply
   ```

4. **Noise/Interference:**
   ```
   - Route data line away from power lines
   - Use twisted pair for data + ground
   - Add ferrite bead on data line
   ```

### LEDs Show Random Colors on Boot

**Normal Behavior:**
- During ESP32 boot, GPIO pins float
- LEDs may show random colors briefly
- Should stabilize after 2-3 seconds

**If Persistent:**
```
Add pull-down resistor on data line:
GPIO → [470Ω] → Data Line
Data Line → [10kΩ] → GND
```

---

## Power Issues

### ESP32 Keeps Resetting

**Serial Monitor Shows:**
```
Brownout detector was triggered
rst:0x10 (RTCWDT_RTC_RESET)
```

**Cause:** Insufficient power supply

**Solutions:**

```
Immediate Fix:
1. Reduce LED brightness in WLED
2. Reduce LED count
3. Disable WiFi temporarily

Permanent Fix:
1. Upgrade power supply:
   - 60 LEDs: 5V 3A minimum
   - 150 LEDs: 5V 5A minimum
   - 300+ LEDs: 5V 10A+ with power injection

2. Add bulk capacitance:
   - 1000-2200µF at LED power input
   - 220µF at ESP32 power

3. Separate ESP32 power:
   - Power ESP32 via USB
   - Power LEDs from main PSU
   - Connect grounds together

4. Power injection:
   - Inject power every 100-150 LEDs
   - Both 5V and GND
```

### Voltage Drop on LED Strip

**Symptoms:**
- End of strip dimmer than beginning
- Wrong colors at end
- Last LEDs don't light

**Measure Voltage:**
```
At start: 5.0V ✓
At middle: 4.5V (acceptable)
At end: 3.8V ✗ (too low)
```

**Solution: Power Injection**

```
For every 150 LEDs:
                Power Supply
                     │
                     ├─── LED Strip Start
                     │
                     ├─── LED Strip Middle (100-150 LEDs)
                     │
                     └─── LED Strip End (another 100-150 LEDs)

Inject both 5V and GND at each point
Use appropriate wire gauge (18-20 AWG)
```

### Power Supply Gets Hot

**Normal:**
- Slight warmth is okay
- <50°C acceptable

**Too Hot (>60°C):**
- Power supply undersized
- Overloaded
- Poor ventilation

**Solutions:**
1. Upgrade to higher wattage PSU
2. Improve ventilation
3. Reduce LED count/brightness
4. Use multiple power supplies

---

## Performance Issues

### Slow/Laggy Web Interface

**Causes:**
- Weak WiFi signal
- Too many LEDs for ESP32
- Heavy effects

**Solutions:**

```
1. Improve WiFi:
   - Move ESP32 closer to router
   - Use external antenna
   - Check WiFi channel interference

2. Optimize WLED:
   - Reduce LED count per segment
   - Use lighter effects
   - Disable unused features
   - Reduce web server refresh rate

3. Upgrade Hardware:
   - Use ESP32-S3 (faster)
   - Add PSRAM for more LEDs
```

### Effects Stuttering

**Causes:**
- Insufficient CPU time
- Too many LEDs
- Heavy WiFi traffic

**Solutions:**

```
Config → LED Preferences:
- Reduce FPS (Frame Rate)
- Enable "Skip first LEDs"
- Segment into smaller groups

PlatformIO build flags:
-D CONFIG_ASYNC_TCP_RUNNING_CORE=1
-D WLED_MAX_BUSSES=1
```

### Out of Memory Errors

**Serial Monitor:**
```
E (12345) wifi: Increase TCP/UDP TX buffer
Guru Meditation Error: Core 1 panic'ed (LoadProhibited)
```

**Solutions:**

```
1. Reduce LED count
2. Disable unused features:
   -D WLED_DISABLE_HUESYNC
   -D WLED_DISABLE_INFRARED

3. Use ESP32 with PSRAM:
   board = esp32-wrover-module
   -D BOARD_HAS_PSRAM

4. Optimize segments:
   - Fewer segments
   - Simpler effects
```

---

## Programming/Upload Issues

### Permission Denied (Linux)

**Error:**
```
Permission denied: '/dev/ttyUSB0'
```

**Solution:**
```bash
# Add user to dialout group
sudo usermod -a -G dialout $USER

# Log out and back in, or:
newgrp dialout

# Alternative: temporary fix
sudo chmod 666 /dev/ttyUSB0
```

### Port Not Found

**Windows:**
- Install CH340 or CP2102 drivers
- Check Device Manager
- Try different USB port

**Linux:**
```bash
# List USB devices
lsusb

# Check for ttyUSB
ls /dev/ttyUSB*

# Check dmesg
dmesg | grep tty
```

**Mac:**
```bash
# List serial ports
ls /dev/cu.*

# Should see something like:
# /dev/cu.usbserial-XXXX
```

### Compilation Errors

**"Library not found":**
```bash
# Update libraries
pio lib update

# Or clean and rebuild
pio run -t clean
pio run
```

**"Platformio.ini errors":**
- Check syntax (spacing, quotes)
- Verify environment names
- Update platform versions

**"Flash overflow":**
```
Firmware too large for partition

Solution:
- Enable smaller partition scheme
- Disable unused features
- Use release build (optimized):
  pio run -e esp32_release
```

---

## Advanced Diagnostics

### Using Serial Monitor

```bash
# Start monitoring
pio device monitor -b 115200

# Or with filters
pio device monitor -b 115200 --filter esp32_exception_decoder

Look for:
- Boot messages
- WiFi connection status
- IP address
- Error messages
- Crash dumps
```

### Enable Debug Logging

**PlatformIO:**
```ini
build_flags =
    -D CORE_DEBUG_LEVEL=5
    -D DEBUG_ESP_PORT=Serial
    -D WLED_DEBUG
```

**Serial Output:**
```
[V][WiFiGeneric.cpp:342] event(): Event: 0
[D][WiFiGeneric.cpp:342] event(): WiFi Connected
[D][WiFiGeneric.cpp:342] event(): Got IP: 192.168.1.100
```

### Test Modes

**1. Minimal Test:**
```cpp
void setup() {
    Serial.begin(115200);
    pinMode(2, OUTPUT);
}

void loop() {
    digitalWrite(2, HIGH);
    delay(500);
    digitalWrite(2, LOW);
    delay(500);
    Serial.println("Blink");
}
```

**2. LED Strip Test:**
```cpp
#include <FastLED.h>

#define NUM_LEDS 60
#define DATA_PIN 2

CRGB leds[NUM_LEDS];

void setup() {
    FastLED.addLeds<WS2812B, DATA_PIN, GRB>(leds, NUM_LEDS);
}

void loop() {
    // Red
    fill_solid(leds, NUM_LEDS, CRGB::Red);
    FastLED.show();
    delay(1000);

    // Green
    fill_solid(leds, NUM_LEDS, CRGB::Green);
    FastLED.show();
    delay(1000);

    // Blue
    fill_solid(leds, NUM_LEDS, CRGB::Blue);
    FastLED.show();
    delay(1000);
}
```

---

## Getting Help

If none of these solutions work:

1. **Check WLED Discord:**
   - https://discord.gg/QAh7wJHrRM
   - Very active community
   - Search before asking

2. **WLED Knowledge Base:**
   - https://kno.wled.ge/
   - Comprehensive documentation

3. **GitHub Issues:**
   - Search existing issues
   - Provide detailed info:
     - ESP32 model
     - WLED version
     - LED type and count
     - Power supply specs
     - Serial monitor output
     - Photos of wiring

4. **This Repository:**
   - [GitHub Issues](https://github.com/arunsaispk12/WLed-Projects/issues)
   - Share your specific project details

---

## Prevention Tips

**Before Building:**
- [ ] Read all documentation
- [ ] Verify component compatibility
- [ ] Calculate power requirements
- [ ] Plan wire routing

**During Building:**
- [ ] Double-check all connections
- [ ] Test incrementally
- [ ] Use multimeter to verify voltages
- [ ] Take photos for reference

**After Building:**
- [ ] Document your configuration
- [ ] Save working firmware
- [ ] Keep backup of presets
- [ ] Note any modifications

**Regular Maintenance:**
- [ ] Check connections periodically
- [ ] Monitor temperatures
- [ ] Update firmware when stable
- [ ] Keep power supply clean/ventilated
