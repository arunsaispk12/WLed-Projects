# Quick Start Guide

Get up and running with your WLED development workspace quickly.

## First Time Setup

### 1. Explore the Structure

```bash
# View the directory structure
ls -la

# Main directories:
projects/        # Your WLED projects
hardware/        # Hardware designs and schematics
docs/            # Documentation and guides
integrations/    # Third-party integrations
firmware/        # Custom firmware and libraries
templates/       # Project templates
```

### 2. Read the Documentation

Essential docs to get started:

1. **Main README**: `README.md` - Overview of entire workspace
2. **Hardware Guide**: `docs/guides/HARDWARE_GUIDE.md` - Build your own controllers
3. **Project Setup**: `docs/guides/PROJECT_SETUP.md` - Start new projects
4. **RainMaker Integration**: `integrations/rainmaker/INTEGRATION_GUIDE.md` - Cloud connectivity

### 3. Start Your First Project

```bash
# Go to projects directory
cd projects/wled-controllers/

# Create your project
mkdir my-first-controller
cd my-first-controller

# Copy template files
cp -r ../../templates/project-template/* .

# Edit README.md with your project details
nano README.md
```

## Common Tasks

### Creating a New WLED Controller Project

```bash
# 1. Choose project type
cd projects/wled-controllers/  # or custom-builds/ or experimental/

# 2. Create project directory
mkdir project-name && cd project-name

# 3. Copy templates
cp -r ../../templates/project-template/* .

# 4. Edit project files
# - README.md: Project description
# - platformio.ini: Build configuration
# - hardware/pinout.md: Pin assignments

# 5. Start developing!
```

### Adding Hardware Design

```bash
# 1. Create hardware files
cd hardware/schematics/
mkdir my-controller

# 2. Add your design files
# - KiCad/Eagle files
# - PDF schematic
# - Gerber files for manufacturing

# 3. Create BOM
cd ../bom/
# Create CSV with all components
```

### Integrating with RainMaker

```bash
# 1. Read the guide
cat integrations/rainmaker/INTEGRATION_GUIDE.md

# 2. Follow step-by-step instructions
# The guide covers:
# - Hardware setup
# - Firmware configuration
# - RainMaker account setup
# - Testing and deployment
```

## Development Workflow

### Typical Project Flow

```
1. Plan → 2. Design → 3. Prototype → 4. Test → 5. Document → 6. Share
   │         │           │             │          │             │
   │         │           │             │          │             │
   └─────────┴───────────┴─────────────┴──────────┴─────────────┘
                          ↑                                      │
                          └──────────────────────────────────────┘
                                   Iterate as needed
```

### Step-by-Step

1. **Planning**
   - Define project goals
   - List required features
   - Choose hardware components
   - Review existing examples

2. **Design**
   - Create schematic (use `hardware/schematics/`)
   - Plan PCB layout if needed
   - Document pin assignments
   - Create BOM

3. **Prototype**
   - Breadboard circuit
   - Test basic functionality
   - Flash WLED firmware
   - Verify all features work

4. **Test**
   - All LEDs light correctly
   - WiFi connects reliably
   - Effects work smoothly
   - Power consumption acceptable

5. **Document**
   - Update README.md
   - Take photos
   - Create wiring diagrams
   - Write troubleshooting guide

6. **Share**
   - Push to Git repository
   - Share on WLED community
   - Help others with issues

## Essential Tools

### Software

**Required:**
- Arduino IDE or PlatformIO
- ESP32 board support
- USB drivers (CH340/CP2102)

**Recommended:**
- Git for version control
- KiCad for PCB design
- VS Code with PlatformIO
- Serial monitor tool

### Hardware

**Required:**
- ESP32 development board
- LED strip (WS2812B or similar)
- 5V power supply
- USB cable
- Breadboard and jumper wires

**Recommended:**
- Multimeter
- Soldering iron
- Level shifter (74HCT125)
- Assorted resistors and capacitors

## Quick Reference

### GPIO Pins

Common ESP32 pins for WLED:

| Pin | Use | Notes |
|-----|-----|-------|
| GPIO2 | LED Data | Most common |
| GPIO0 | Button | Boot button |
| GPIO21 | I2C SDA | Sensors/Display |
| GPIO22 | I2C SCL | Sensors/Display |
| GPIO25-33 | I2S Audio | Sound reactive |

### LED Strip Types

| Type | Voltage | Speed | Notes |
|------|---------|-------|-------|
| WS2812B | 5V | 800kHz | Most common |
| SK6812 | 5V | 800kHz | Better colors |
| WS2813 | 5V | 800kHz | Backup data line |
| APA102 | 5V | High | Needs clock line |

### Power Calculations

```
Simple formula:
LEDs × 60mA = Current (mA)
Current (mA) ÷ 1000 = Current (A)
Current (A) × 1.2 = Power Supply (A)

Example for 60 LEDs:
60 × 60 = 3600mA
3600 ÷ 1000 = 3.6A
3.6 × 1.2 = 4.32A
Recommendation: 5A power supply
```

## Getting Help

### Documentation

- `README.md` - Workspace overview
- `docs/guides/HARDWARE_GUIDE.md` - Hardware development
- `docs/guides/PROJECT_SETUP.md` - Project organization
- `integrations/rainmaker/INTEGRATION_GUIDE.md` - RainMaker setup

### Community Resources

- [WLED Knowledge Base](https://kno.wled.ge/)
- [WLED Discord](https://discord.gg/QAh7wJHrRM)
- [WLED GitHub](https://github.com/Aircoookie/WLED)
- [r/WLED Subreddit](https://reddit.com/r/WLED)

### Troubleshooting

Common issues and solutions:

**LEDs don't work:**
- Check power (5V at LED strip)
- Verify GPIO configuration
- Test with single LED first
- Check data line connection

**WiFi won't connect:**
- Use 2.4GHz network only
- Reset WiFi settings
- Check credentials
- Try WiFi AP mode

**ESP32 won't program:**
- Hold BOOT button during upload
- Check USB cable (data cable, not charging only)
- Verify correct COM port selected
- Install/update drivers

## Next Steps

1. **Set up your first project**
   - Follow "Creating a New WLED Controller Project" above
   - Start simple (basic ESP32 + LED strip)
   - Get it working before adding features

2. **Explore examples**
   - Look at existing projects in `projects/`
   - Study schematics in `hardware/schematics/`
   - Learn from others' code

3. **Customize and expand**
   - Add your own features
   - Design custom PCBs
   - Integrate with home automation
   - Share your creations!

## Tips for Success

1. **Start Simple**: Begin with a basic setup before adding complexity
2. **Document Everything**: Future you will thank you
3. **Test Incrementally**: Test each component as you add it
4. **Ask for Help**: Community is friendly and helpful
5. **Share Your Work**: Others can learn from your projects
6. **Safety First**: Always verify power and polarity before connecting

## Useful Commands

```bash
# PlatformIO
pio run                    # Build project
pio run -t upload          # Upload firmware
pio device monitor         # Serial monitor
pio run -t clean           # Clean build

# Git
git init                   # Initialize repository
git add .                  # Stage all files
git commit -m "message"    # Commit changes
git status                 # Check status

# Find files
find . -name "*.md"        # Find markdown files
grep -r "search term" .    # Search in files
```

## Additional Resources

### Hardware Suppliers

- Adafruit: Quality components, good docs
- SparkFun: Educational focus
- AliExpress: Budget parts
- Digi-Key/Mouser: Professional components

### Learning Platforms

- YouTube: Lots of WLED tutorials
- Instructables: Project guides
- Hackster.io: Advanced projects
- GitHub: Code examples

Happy building! 🎨💡
