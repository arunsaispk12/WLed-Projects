# Project Name

Brief description of what this WLED project does and what makes it unique.

## Overview

Provide a more detailed description of the project, its purpose, and main features.

## Features

- Feature 1
- Feature 2
- Feature 3
- Compatible with WLED vX.X.X

## Hardware Requirements

### Components

| Component | Specification | Quantity | Notes |
|-----------|--------------|----------|-------|
| ESP32 | ESP32-WROOM-32 | 1 | Or compatible |
| LED Strip | WS2812B | 1 | Specify length/LED count |
| Power Supply | 5V, XA | 1 | Calculate based on LED count |
| Level Shifter | 74HCT125 | 1 | Optional but recommended |
| Resistor | 470Ω | 1 | For data line |
| Capacitor | 1000µF, 10V | 1 | For LED power |
| Additional | ... | ... | ... |

### Pin Assignments

| ESP32 Pin | Function | Notes |
|-----------|----------|-------|
| GPIO2 | LED Data | Via level shifter |
| GPIO0 | Button | Pull-up to 3.3V |
| 5V | LED Power | From power supply |
| GND | Common Ground | All grounds connected |
| ... | ... | ... |

## Wiring Diagram

![Wiring Diagram](images/wiring.png)

### Wiring Instructions

1. **Power connections**
   - Connect 5V power supply to LED strip positive
   - Connect GND from power supply to LED strip and ESP32 GND
   - Ensure common ground between all components

2. **Data connection**
   - Connect ESP32 GPIO2 through 470Ω resistor to level shifter input
   - Connect level shifter output to LED strip data input
   - Connect level shifter VCC to 5V, GND to ground

3. **Protection**
   - Add 1000µF capacitor across LED power input
   - Verify all polarities before powering on

## Software Setup

### Prerequisites

- [ ] Arduino IDE with ESP32 support OR PlatformIO installed
- [ ] WLED firmware (latest version recommended)
- [ ] USB cable for programming
- [ ] (Optional) Git for version control

### Installation Steps

#### Method 1: Using WLED Binary (Easiest)

1. Download WLED firmware from [releases](https://github.com/Aircoookie/WLED/releases)
2. Use [WLED Web Installer](https://install.wled.me/)
3. Connect ESP32 via USB
4. Follow web installer instructions
5. Configure using steps in [Configuration](#configuration)

#### Method 2: PlatformIO (For Custom Builds)

1. Clone this repository
   ```bash
   git clone [your-repo-url]
   cd [project-directory]
   ```

2. Open in PlatformIO
   ```bash
   pio run
   ```

3. Upload to ESP32
   ```bash
   pio run -t upload
   ```

4. Monitor serial output
   ```bash
   pio device monitor
   ```

#### Method 3: Arduino IDE

1. Install ESP32 board support
2. Copy `src/` contents to Arduino sketch folder
3. Install required libraries (see `platformio.ini` for list)
4. Select board: ESP32 Dev Module
5. Upload

### Configuration

1. **Initial WiFi Setup**
   - On first boot, ESP32 creates WiFi AP named "WLED-AP"
   - Connect to AP (password: "wled1234")
   - Navigate to http://4.3.2.1
   - Configure your WiFi credentials

2. **LED Configuration**
   - Go to Config → LED Preferences
   - Set LED count: [your LED count]
   - Set GPIO: 2
   - Set Color Order: GRB (test if colors are wrong)
   - Click Save

3. **Project-Specific Settings**
   - Import presets from `config/wled_presets.json`
   - Configure any custom features
   - Set preferred effects

4. **Advanced Configuration**
   - Enable MQTT if needed
   - Configure sync settings
   - Set up time/location for sunrise/sunset

## Usage

### Basic Controls

- **Power On/Off**: Toggle power button in web interface
- **Brightness**: Adjust slider (0-255)
- **Effects**: Choose from effects menu
- **Colors**: Select from color picker
- **Presets**: Quick access to saved configurations

### Custom Features

[Document any project-specific features here]

### Integration

[If integrating with other systems like RainMaker, Home Assistant, etc., document here]

## Troubleshooting

### LEDs Don't Light Up

**Check:**
- [ ] Power supply connected and turned on
- [ ] Correct voltage at LED strip (should be ~5V)
- [ ] LED count matches configuration
- [ ] Correct GPIO pin configured
- [ ] Data line properly connected
- [ ] LED strip polarity correct (DI not DO)

**Solution:**
Try reducing brightness or LED count initially to test.

### WiFi Connection Issues

**Check:**
- [ ] WiFi credentials correct
- [ ] 2.4GHz network (ESP32 doesn't support 5GHz)
- [ ] Signal strength adequate
- [ ] No special characters in WiFi password

**Solution:**
Reset WiFi by holding button for 10 seconds or reflash firmware.

### LEDs Show Wrong Colors

**Check:**
- [ ] Color order setting (try GRB, RGB, or BGR)
- [ ] Level shifter working correctly
- [ ] Data line connection solid

**Solution:**
Go to Config → LED Preferences and change Color Order setting.

### ESP32 Keeps Resetting

**Check:**
- [ ] Power supply adequate for LED count
- [ ] Capacitor installed at LED power input
- [ ] No shorts in wiring
- [ ] Serial monitor for error messages

**Solution:**
Add larger capacitor or use higher current power supply.

### [Additional Issues]

Add more troubleshooting items as they arise.

## Photos

### Assembled Project

![Assembled Project](images/assembled.jpg)

### Detail Shots

[Add photos of your completed project]

## Improvements & Roadmap

### Completed
- [x] Initial implementation
- [x] Basic functionality

### Planned
- [ ] Feature A
- [ ] Feature B
- [ ] Feature C

### Ideas for Future
- Potential enhancement 1
- Potential enhancement 2

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/improvement`)
3. Commit changes (`git commit -am 'Add improvement'`)
4. Push to branch (`git push origin feature/improvement`)
5. Create Pull Request

## Credits

- Based on [WLED](https://github.com/Aircoookie/WLED) by Aircookie
- [Additional credits if using others' work]

## License

This project follows WLED's MIT License.

## Support

- WLED Documentation: https://kno.wled.ge/
- WLED Discord: https://discord.gg/QAh7wJHrRM
- Project Issues: [Link to your issues page]

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.
