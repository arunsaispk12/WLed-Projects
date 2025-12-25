# Sound Reactive WLED Controller

Music-synchronized LED controller using ESP32 and INMP441 I2S microphone for real-time audio visualization.

![Build Status](https://img.shields.io/badge/build-ready-brightgreen)
![WLED](https://img.shields.io/badge/WLED-v0.14.x-blue)
![Audio](https://img.shields.io/badge/Audio-I2S-orange)

## Overview

Transform your LED strip into a music visualizer! This project combines WLED with an I2S digital microphone to create stunning audio-reactive effects that respond to music, voices, and ambient sounds.

## Features

- 🎵 **Real-time audio visualization** - LEDs react to music
- 📊 **FFT analysis** - Frequency-based effects
- 🎚️ **Beat detection** - Pulse on bass drops
- 🎨 **Multiple modes** - VU meter, frequency bars, ripples
- 🔊 **Adjustable sensitivity** - Auto-gain control
- 📡 **Full WLED compatibility** - All standard WLED features included
- 🌐 **WiFi control** - Adjust settings remotely
- 💾 **Save presets** - Store your favorite visualizations

## What Makes This Different

Unlike basic sound reactive setups using analog microphones:
- ✅ **Digital I2S microphone** - Better noise immunity, no ADC noise
- ✅ **FFT processing** - True frequency analysis, not just amplitude
- ✅ **Better sensitivity** - Picks up subtle sounds
- ✅ **No interference** - Digital signal immune to LED PWM noise
- ✅ **Auto-gain** - Adapts to quiet and loud environments

## Hardware Requirements

### Bill of Materials

| Component | Specification | Quantity | Est. Price | Purpose |
|-----------|--------------|----------|------------|---------|
| ESP32 DevKit | ESP32-WROOM-32 | 1 | $6-8 | Main controller |
| INMP441 Microphone | I2S MEMS | 1 | $3-5 | Audio input |
| LED Strip | WS2812B 60 LED/m | 1-5m | $8-40 | Visual output |
| Power Supply | 5V 5A | 1 | $8-12 | Power for LEDs |
| Jumper Wires | Female-Female | 6 | Included | Connections |
| **Total** | | | **$25-65** | |

### Recommended Upgrades

| Component | Upgrade | Benefit | Extra Cost |
|-----------|---------|---------|------------|
| LED Strip | SK6812 RGBW | Better white colors | +$5/m |
| ESP32 | ESP32-S3 | Better DSP performance | +$3 |
| Enclosure | 3D printed case | Professional look | $2-5 |
| Power Supply | 10A for longer strips | More LEDs | +$5-10 |

### Pin Configuration

| ESP32 Pin | Connection | INMP441 Pin | Notes |
|-----------|------------|-------------|-------|
| GPIO33 | I2S SD | SD (Data) | Serial data |
| GPIO32 | I2S SCK | SCK (Clock) | Bit clock |
| GPIO25 | I2S WS | WS (L/R) | Word select |
| 3.3V | Power | VDD | Microphone power |
| GND | Ground | GND, L/R | Common ground |
| GPIO2 | LED Data | - | To LED strip |

**INMP441 Microphone Pinout:**
```
  ┌─────────┐
  │  L/R    │  GND (or 3.3V for right channel)
  │  WS     │  Word Select
  │  SCK    │  Serial Clock
  │  SD     │  Serial Data
  │  VDD    │  3.3V Power
  │  GND    │  Ground
  └─────────┘
```

## Wiring Diagram

```
ESP32                    INMP441 Microphone
┌──────────┐            ┌──────────┐
│          │            │          │
│  GPIO33 ─┼────────────┼─ SD     │ (Data)
│          │            │          │
│  GPIO32 ─┼────────────┼─ SCK    │ (Clock)
│          │            │          │
│  GPIO25 ─┼────────────┼─ WS     │ (Word Select)
│          │            │          │
│  3.3V   ─┼────────────┼─ VDD    │ (Power)
│          │            │          │
│  GND    ─┼─────┬──────┼─ GND    │ (Ground)
│          │     │      │          │
│          │     └──────┼─ L/R    │ (Left channel)
│          │            │          │
│  GPIO2  ─┼──[470Ω]────┼──→ LED Strip Data
│          │            └──────────┘
│  5V     ─┼──────────→ LED Strip 5V
│          │
│  GND    ─┼──────────→ LED Strip GND
└──────────┘

Power Supply (5V 5A)
    │
    ├───→ LED Strip 5V
    ├───→ ESP32 5V (or USB)
    └───→ Common GND
```

## Software Setup

### Option 1: Flash Pre-Built Firmware (Easiest)

1. **Download WLED Sound Reactive**
   - Visit [WLED-SR Releases](https://github.com/atuline/WLED/releases)
   - Download latest sound reactive build

2. **Flash with Web Installer**
   - Go to [install.wled.me](https://install.wled.me/)
   - Select "Sound Reactive" version
   - Connect ESP32 via USB
   - Click Install

### Option 2: Build from Source (Custom)

```bash
# Clone repository
cd projects/wled-controllers/sound-reactive-controller

# Build firmware
./build.sh build sound_reactive

# Flash to ESP32
./build.sh flash sound_reactive /dev/ttyUSB0
```

### Initial Configuration

1. **Connect to WLED**
   - Power on ESP32
   - Connect to WiFi "WLED-AP" (password: `wled1234`)
   - Browser opens to http://4.3.2.1

2. **WiFi Setup**
   - Enter your WiFi credentials
   - Device restarts

3. **LED Configuration**
   - Config → LED Preferences
   - Length: Your LED count (e.g., 60)
   - GPIO: 2
   - Color Order: GRB (test if wrong)

4. **Sound Settings**
   - Config → Sound Settings
   - Enable "Sound Reactive"
   - I2S Microphone: Enabled
   - I2S SD Pin: 33
   - I2S WS Pin: 25
   - I2S SCK Pin: 32
   - Gain: Start at 50, adjust later

## Sound Reactive Effects

### Built-in Audio Effects

| Effect | Description | Best For |
|--------|-------------|----------|
| **Gravimeter** | VU meter style bars | Classic visualizer |
| **Juggles** | Bouncing particles | Energetic music |
| **Midnoise** | Frequency-based noise | Ambient/chill |
| **Noisefire** | Fire effect with audio | Rock/metal |
| **Plasmoid** | Plasma ball reactive | Electronic music |
| **Puddlepeak** | Water drop effect | Calm music |
| **Ripple Peak** | Ripples on beats | Bass-heavy music |
| **Waterfall** | Frequency waterfall | All music types |

### Effect Parameters

**Sensitivity:**
- Low (20-40): Quiet environments, soft music
- Medium (50-70): Normal listening volume
- High (80-100): Loud music, parties

**Frequency Range:**
- Bass (20-250Hz): Kick drums, bass guitar
- Mid (250-2kHz): Vocals, most instruments
- Treble (2kHz+): Cymbals, hi-hats

## Assembly Guide

### Step 1: Test Components

**Test ESP32:**
```bash
# Flash test firmware
./build.sh flash esp32_basic /dev/ttyUSB0

# Verify it works
./build.sh monitor
```

**Test Microphone:**
- Wire only microphone
- Flash sound reactive firmware
- Open serial monitor
- Should see audio levels

**Test LEDs:**
- Wire LEDs to GPIO2
- Test with basic WLED

### Step 2: Assemble

**Breadboard Version (Testing):**

1. Insert ESP32 into breadboard
2. Connect INMP441 with jumper wires:
   ```
   INMP441 VDD  → ESP32 3.3V
   INMP441 GND  → ESP32 GND
   INMP441 L/R  → ESP32 GND (left channel)
   INMP441 WS   → ESP32 GPIO25
   INMP441 SCK  → ESP32 GPIO32
   INMP441 SD   → ESP32 GPIO33
   ```
3. Connect LED strip:
   ```
   LED 5V   → Power supply +5V
   LED GND  → Power supply GND → ESP32 GND
   LED Data → 470Ω resistor → ESP32 GPIO2
   ```
4. Add 1000µF capacitor across LED power

**Permanent Version:**

1. Solder INMP441 wires to ESP32
2. Use heat shrink on connections
3. Mount in enclosure
4. Secure microphone pointing outward
5. Strain relief on all connections

### Step 3: Microphone Placement

**Important:** Microphone placement affects performance!

✅ **Good Placement:**
- Facing sound source
- Unobstructed (no fabric/foam over mic)
- Away from LED strip (reduces noise)
- Stable mounting (vibration causes noise)

❌ **Bad Placement:**
- Behind LEDs
- Inside enclosed box with no sound holes
- Touching vibrating surfaces
- Near speakers (too loud, distortion)

### Step 4: Calibration

1. **Set Gain:**
   - Play music at normal volume
   - Open WLED → Config → Sound Settings
   - Adjust Gain until LEDs respond well
   - Too high: Always maxed out
   - Too low: Barely responds

2. **Squelch (Noise Gate):**
   - Sets minimum level to ignore
   - Prevents LEDs from flickering when quiet
   - Increase if LEDs flicker in silence
   - Default: 10-20

3. **AGC (Auto Gain Control):**
   - Automatically adjusts to sound level
   - Enable for varying volumes
   - Disable for consistent response

## Usage Examples

### Party Mode

**Setup:**
- Effect: Gravimeter or Ripple Peak
- Palette: Rainbow or Party
- Sensitivity: High (80)
- Speed: Fast

**Best for:** Loud music, dancing

### Ambient Listening

**Setup:**
- Effect: Waterfall or Plasmoid
- Palette: Sunset or Ocean
- Sensitivity: Medium (50)
- Speed: Slow

**Best for:** Background music, relaxing

### Gaming

**Setup:**
- Effect: Noisefire
- Palette: Fire or Lava
- Sensitivity: Medium-High (65)
- AGC: Enabled

**Best for:** Game audio, voice chat

### Movie Watching

**Setup:**
- Effect: Puddlepeak
- Palette: Cool colors
- Sensitivity: Medium-Low (45)
- Squelch: Higher (30)

**Best for:** Dialogue and ambient sounds

## Troubleshooting

### No Audio Response

**Check:**
1. Microphone wiring (especially data lines)
2. Sound settings enabled in WLED
3. Correct I2S pins configured
4. Microphone not covered/blocked
5. Gain setting (try increasing)

**Test:**
```bash
# Serial monitor shows audio levels
./build.sh monitor

# Should see:
# [SOUND] Peak: 245, RMS: 128
# If all zeros, mic not working
```

### LEDs Respond But Badly

**If too sensitive:**
- Lower gain
- Increase squelch
- Move mic away from speakers

**If not sensitive enough:**
- Increase gain
- Lower squelch
- Move mic closer to sound
- Check microphone placement

### Noise/Interference

**Symptoms:**
- LEDs flicker when quiet
- Constant low-level activation

**Solutions:**
1. Increase squelch (noise gate)
2. Move microphone away from LED strip
3. Use shielded wire for I2S lines
4. Add ferrite bead on LED power
5. Separate ESP32 and LED power supplies

### Microphone Not Detected

**Check:**
1. 3.3V on VDD pin (measure with multimeter)
2. GND connected
3. L/R pin connected (to GND for left channel)
4. Correct GPIO pins in configuration
5. Try different I2S pins if available

**Serial Monitor:**
```
[ERROR] I2S device not found
→ Check wiring and pin configuration
```

## Advanced Features

### Frequency Bands

Configure which frequencies control effects:

- **Bass Mode**: Only low frequencies (20-250Hz)
- **Mid Mode**: Vocals and instruments (250-2kHz)
- **Treble Mode**: High frequencies (2kHz+)
- **Full Spectrum**: All frequencies

### Presets

Save your favorite setups:

1. Configure effect, colors, sensitivity
2. Presets → Save Preset
3. Name it (e.g., "Party Bass")
4. Quick recall anytime

### Schedules

Automate sound reactive modes:

1. Config → Time & Macros
2. Set time-based rules
3. Example: "Sound reactive on weekends 8PM-2AM"

### MQTT Integration

Control via Home Assistant:

```yaml
mqtt:
  - topic: "wled/sound/gain"
    payload: "60"
  - topic: "wled/sound/effect"
    payload: "gravimeter"
```

## Performance Optimization

### For Best Performance:

1. **Use ESP32-S3** - Better DSP performance
2. **Reduce LED count** - Fewer LEDs = faster processing
3. **Lower FPS** - 30 FPS instead of 60
4. **Disable unused features** - In build configuration

### Memory Usage:

- Basic WLED: ~150KB
- Sound Reactive: ~220KB
- With FFT: ~280KB

**If running out of memory:**
- Use ESP32-WROVER (with PSRAM)
- Or reduce LED count
- Or disable some effects

## Enclosure Design

### 3D Printable Case

**Requirements:**
- Hole for microphone
- Ventilation for ESP32
- Cable glands for wires
- Mounting holes

**STL Files:** (Coming soon)

### DIY Box

**Materials:**
- Small project box
- Drill for microphone hole
- Hot glue for mounting

**Steps:**
1. Drill hole for microphone (face outward)
2. Mount ESP32 with standoffs
3. Hot glue microphone near hole
4. Cable management for wires
5. Label connections

## Safety Notes

⚠️ **Audio Levels:**
- Don't place microphone right at speaker
- >85dB can damage MEMS microphones
- Protect from moisture
- Avoid shock/drop (MEMS is fragile)

⚠️ **Power:**
- Same safety as basic controller
- Check current requirements
- Proper grounding

## Example Projects

### Desktop Music Visualizer

- 60 LEDs in aluminum channel
- INMP441 pointing at desk
- USB powered (30 LEDs max)
- Compact enclosure

### Party Room Installation

- 300 LEDs around room
- Microphone mounted centrally
- High sensitivity
- Beat-reactive effects

### DJ Booth Lights

- Multiple strips (multi-channel)
- Professional INMP441 mic
- MQTT control from DJ software
- Preset switching via footswitch

## Comparison with Analog Mic

| Feature | I2S (INMP441) | Analog (MAX4466) |
|---------|---------------|------------------|
| **Noise Immunity** | Excellent | Poor |
| **LED Interference** | None | Significant |
| **Frequency Range** | 20Hz-20kHz | Limited |
| **Sensitivity** | Adjustable | Fixed |
| **Cost** | $3-5 | $2-3 |
| **Wiring** | 4 wires | 2 wires |
| **Quality** | Professional | Basic |
| **FFT Quality** | Excellent | Noisy |

**Recommendation:** I2S microphone for better results

## Frequently Asked Questions

**Q: Can I use multiple microphones?**
A: No, ESP32 I2S can only handle one input at a time.

**Q: Will this work with Spotify/streaming?**
A: Yes! Microphone picks up any audio playing.

**Q: Range of microphone?**
A: ~2-5 meters for typical music volumes.

**Q: Can I add more LEDs?**
A: Yes, up to 500+ with proper power injection.

**Q: Does this work without WiFi?**
A: Yes, sound reactive works offline. WiFi only for configuration.

## Changelog

- v1.0.0 - Initial sound reactive controller

## Resources

- [WLED Sound Reactive Fork](https://github.com/atuline/WLED)
- [INMP441 Datasheet](https://www.invensense.com/wp-content/uploads/2015/02/INMP441.pdf)
- [I2S Audio Guide](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/peripherals/i2s.html)

## Credits

- [WLED](https://github.com/Aircoookie/WLED) by Aircookie
- [WLED Sound Reactive](https://github.com/atuline/WLED) by atuline
- Community contributions

## License

MIT License (same as WLED)
