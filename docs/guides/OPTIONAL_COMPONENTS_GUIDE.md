# Optional Components Interface Guide

Comprehensive guide to integrating buttons, rotary encoders, displays, and other user interface components with WLED controllers.

## Table of Contents

1. [Push Buttons](#push-buttons)
2. [Rotary Encoders](#rotary-encoders)
3. [OLED Displays](#oled-displays)
4. [TFT Displays](#tft-displays)
5. [Infrared Remotes](#infrared-remotes)
6. [Relays](#relays)
7. [Status LEDs](#status-leds)
8. [Sound Modules](#sound-modules)
9. [Real-Time Clocks (RTC)](#real-time-clocks-rtc)
10. [Complete Interface Examples](#complete-interface-examples)

---

## Push Buttons

### Basic Button Connection

**Simplest User Input:**

#### Wiring

```
                ESP32
                  │
Button ──────┬─── GPIO0 (or any GPIO)
             │
           [10kΩ Pull-up to 3.3V]
             │
            GND
```

**Alternate (Internal Pull-up):**
```
Button ──────┬─── GPIO0
             │
            GND

Use INPUT_PULLUP in code
```

#### Circuit Diagram

```
3.3V ────[10kΩ]────┬──── GPIO0
                   │
                [Button]
                   │
                  GND
```

**Operation:**
- Button not pressed: GPIO reads HIGH (3.3V through pull-up)
- Button pressed: GPIO reads LOW (connected to GND)

### Debouncing

**Why Needed:**
- Mechanical buttons "bounce"
- One press can register as multiple
- Causes issues with toggles/counts

**Hardware Debouncing:**

```
GPIO ──┬────[Button]──── GND
       │
    [10kΩ]
       │
    [0.1µF]
       │
      GND
```

**Software Debouncing:**

```cpp
#define BUTTON_PIN 0
#define DEBOUNCE_DELAY 50  // milliseconds

int buttonState;
int lastButtonState = HIGH;
unsigned long lastDebounceTime = 0;

void setup() {
    pinMode(BUTTON_PIN, INPUT_PULLUP);
}

void loop() {
    int reading = digitalRead(BUTTON_PIN);

    if (reading != lastButtonState) {
        lastDebounceTime = millis();
    }

    if ((millis() - lastDebounceTime) > DEBOUNCE_DELAY) {
        if (reading != buttonState) {
            buttonState = reading;

            if (buttonState == LOW) {
                // Button pressed!
                handleButtonPress();
            }
        }
    }

    lastButtonState = reading;
}
```

### Button Functions

**Common Actions:**

**1. Toggle On/Off:**
```cpp
bool ledsOn = false;

void handleButtonPress() {
    ledsOn = !ledsOn;
    if (ledsOn) {
        turnOnLEDs();
    } else {
        turnOffLEDs();
    }
}
```

**2. Cycle Effects:**
```cpp
int currentEffect = 0;
#define NUM_EFFECTS 10

void handleButtonPress() {
    currentEffect = (currentEffect + 1) % NUM_EFFECTS;
    setEffect(currentEffect);
}
```

**3. Brightness Toggle:**
```cpp
int brightnessLevels[] = {25, 50, 100, 150, 200, 255};
int currentBrightnessIndex = 3;

void handleButtonPress() {
    currentBrightnessIndex = (currentBrightnessIndex + 1) % 6;
    setBrightness(brightnessLevels[currentBrightnessIndex]);
}
```

**4. Long Press Detection:**
```cpp
#define LONG_PRESS_TIME 1000  // 1 second

void loop() {
    if (buttonState == LOW) {  // Pressed
        if (!longPressTriggered) {
            if (millis() - pressStartTime > LONG_PRESS_TIME) {
                handleLongPress();
                longPressTriggered = true;
            }
        }
    } else {  // Released
        if (!longPressTriggered && millis() - pressStartTime < LONG_PRESS_TIME) {
            handleShortPress();
        }
        longPressTriggered = false;
        pressStartTime = millis();
    }
}
```

### Multiple Buttons

**Matrix Approach (Many Buttons):**

```
GPIO0 ──┬───[Button 1]─── GND
        ├───[Button 2]─── GND
        ├───[Button 3]─── GND
        └───[Button 4]─── GND

Each button on separate GPIO
```

**Functions:**
- Button 1: On/Off
- Button 2: Next Effect
- Button 3: Brightness +
- Button 4: Brightness -

### WLED Button Configuration

**Built-in Support:**

```
WLED Settings → LED Preferences:

Button 0 GPIO: 0
Button 1 GPIO: 35
Button 2 GPIO: 34

Button Types:
- Push button
- Push button inverted
- Switch
- PIR sensor
```

**Functions:**
- Short press: Toggle on/off
- Long press: Enter preset cycling mode
- Double press: Random effect

---

## Rotary Encoders

### KY-040 Rotary Encoder

**Best for Smooth Control:**

#### Pinout

```
KY-040 Module
┌─────────┐
│  CLK    │──── ESP32 GPIO16 (A phase)
│  DT     │──── ESP32 GPIO17 (B phase)
│  SW     │──── ESP32 GPIO5  (switch)
│  +      │──── 3.3V
│  GND    │──── GND
└─────────┘
```

#### Connection Diagram

```
                ESP32
              ┌─────────┐
KY-040 CLK ───│ GPIO16  │
       DT  ───│ GPIO17  │
       SW  ─┬─│ GPIO5   │
            │ └─────────┘
         [10kΩ]
            │
           3.3V

       +   ─── 3.3V
       GND ─── GND
```

### How Encoders Work

**Quadrature Encoding:**

```
Rotation Clockwise:
CLK: ──┐  ┌──┐  ┌──
       └──┘  └──┘
DT:  ───┐  ┌──┐  ┌─
        └──┘  └──┘

Rotation Counter-Clockwise:
CLK: ──┐  ┌──┐  ┌──
       └──┘  └──┘
DT:  ────┐  ┌──┐
         └──┘  └──

Detection:
If CLK changes and DT is LOW → Clockwise
If CLK changes and DT is HIGH → Counter-Clockwise
```

### Code Example

**Simple Encoder Reading:**

```cpp
#define CLK_PIN 16
#define DT_PIN 17
#define SW_PIN 5

int counter = 128;  // Brightness value (0-255)
int lastCLK;

void setup() {
    pinMode(CLK_PIN, INPUT);
    pinMode(DT_PIN, INPUT);
    pinMode(SW_PIN, INPUT_PULLUP);

    lastCLK = digitalRead(CLK_PIN);
}

void loop() {
    int currentCLK = digitalRead(CLK_PIN);

    if (currentCLK != lastCLK) {  // CLK changed
        if (digitalRead(DT_PIN) != currentCLK) {
            // Clockwise
            counter++;
            if (counter > 255) counter = 255;
        } else {
            // Counter-clockwise
            counter--;
            if (counter < 0) counter = 0;
        }

        setBrightness(counter);
    }

    lastCLK = currentCLK;

    // Check button
    if (digitalRead(SW_PIN) == LOW) {
        toggleOnOff();
        delay(200);  // Simple debounce
    }
}
```

**Better: Using Interrupts:**

```cpp
#define CLK_PIN 16
#define DT_PIN 17

volatile int counter = 128;
volatile int lastEncoded = 0;

void setup() {
    pinMode(CLK_PIN, INPUT_PULLUP);
    pinMode(DT_PIN, INPUT_PULLUP);

    attachInterrupt(digitalPinToInterrupt(CLK_PIN), updateEncoder, CHANGE);
    attachInterrupt(digitalPinToInterrupt(DT_PIN), updateEncoder, CHANGE);
}

void updateEncoder() {
    int MSB = digitalRead(CLK_PIN);
    int LSB = digitalRead(DT_PIN);

    int encoded = (MSB << 1) | LSB;
    int sum = (lastEncoded << 2) | encoded;

    if (sum == 0b1101 || sum == 0b0100 || sum == 0b0010 || sum == 0b1011) {
        counter++;
    } else if (sum == 0b1110 || sum == 0b0111 || sum == 0b0001 || sum == 0b1000) {
        counter--;
    }

    lastEncoded = encoded;
}

void loop() {
    static int lastCounter = 128;

    if (counter != lastCounter) {
        if (counter < 0) counter = 0;
        if (counter > 255) counter = 255;

        setBrightness(counter);
        lastCounter = counter;
    }
}
```

### Rotary Encoder Functions

**1. Brightness Control:**
- Rotate: Adjust brightness 0-255
- Press: Toggle on/off

**2. Effect Selection:**
- Rotate: Cycle through effects
- Press: Select/confirm effect

**3. Speed Control:**
- Rotate: Adjust effect speed
- Press: Reset to default speed

**4. Menu Navigation:**
- Rotate: Navigate menu items
- Press: Select/enter

### Recommended Library

**Using ESP32Encoder:**

```cpp
#include <ESP32Encoder.h>

ESP32Encoder encoder;

void setup() {
    encoder.attachHalfQuad(16, 17);  // CLK, DT pins
    encoder.setCount(128);  // Initial value
}

void loop() {
    int count = encoder.getCount();
    if (count < 0) encoder.setCount(0);
    if (count > 255) encoder.setCount(255);

    setBrightness(count);
}
```

---

## OLED Displays

### SSD1306 OLED (0.96" 128×64)

**Common Display for Status:**

#### Pinout (I2C)

```
SSD1306 OLED
┌─────────┐
│  VCC    │──── 3.3V
│  GND    │──── GND
│  SCL    │──── ESP32 GPIO22 (I2C Clock)
│  SDA    │──── ESP32 GPIO21 (I2C Data)
└─────────┘
```

#### Connection

```
SSD1306           ESP32
  VCC ────────── 3.3V
  GND ────────── GND
  SCL ────────── GPIO22
  SDA ────────── GPIO21
```

**I2C Address:**
- Common: 0x3C
- Alternative: 0x3D (check module)

### Software Setup

**Libraries:**

```cpp
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1  // No reset pin
#define SCREEN_ADDRESS 0x3C

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

void setup() {
    if (!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
        Serial.println(F("SSD1306 allocation failed"));
        for (;;);  // Loop forever
    }

    display.clearDisplay();
    display.setTextSize(1);
    display.setTextColor(SSD1306_WHITE);
    display.setCursor(0, 0);
    display.println(F("WLED Controller"));
    display.display();
}
```

### Display Functions

**1. Status Display:**

```cpp
void displayStatus() {
    display.clearDisplay();

    // Title
    display.setTextSize(2);
    display.setCursor(0, 0);
    display.println("WLED");

    // Status info
    display.setTextSize(1);
    display.setCursor(0, 20);
    display.print("Brightness: ");
    display.println(brightness);

    display.setCursor(0, 30);
    display.print("Effect: ");
    display.println(effectName);

    display.setCursor(0, 40);
    display.print("WiFi: ");
    display.println(WiFi.SSID());

    display.setCursor(0, 50);
    display.print("IP: ");
    display.println(WiFi.localIP());

    display.display();
}
```

**2. Menu System:**

```cpp
const char* menuItems[] = {
    "Brightness",
    "Effect",
    "Color",
    "Speed",
    "WiFi Info"
};

int menuIndex = 0;

void displayMenu() {
    display.clearDisplay();
    display.setTextSize(1);

    for (int i = 0; i < 5; i++) {
        display.setCursor(0, i * 12);

        if (i == menuIndex) {
            display.print("> ");  // Selection indicator
        } else {
            display.print("  ");
        }

        display.println(menuItems[i]);
    }

    display.display();
}
```

**3. Graph/Bar:**

```cpp
void displayBrightnessBar() {
    display.clearDisplay();

    display.setTextSize(1);
    display.setCursor(0, 0);
    display.println("Brightness");

    // Draw bar
    int barWidth = map(brightness, 0, 255, 0, 120);
    display.fillRect(0, 20, barWidth, 10, SSD1306_WHITE);
    display.drawRect(0, 20, 120, 10, SSD1306_WHITE);

    // Value
    display.setCursor(0, 35);
    display.print(brightness);
    display.print("/255");

    display.display();
}
```

### WLED Usermod

**Four Line Display Usermod:**

**Features:**
✅ Shows WLED status
✅ IP address, brightness, effect
✅ Automatic updates
✅ Configurable

**Configuration:**
```
Settings → Four Line Display:

Type: SSD1306
I2C SDA: GPIO21
I2C SCL: GPIO22
Address: 0x3C
```

---

## TFT Displays

### ST7789 TFT (1.3" 240×240 Color)

**For Colorful UI:**

#### Pinout (SPI)

```
ST7789 TFT
┌─────────┐
│  VCC    │──── 3.3V or 5V
│  GND    │──── GND
│  SCL    │──── ESP32 GPIO18 (SPI SCK)
│  SDA    │──── ESP32 GPIO23 (SPI MOSI)
│  RES    │──── ESP32 GPIO4  (Reset)
│  DC     │──── ESP32 GPIO2  (Data/Command)
│  CS     │──── ESP32 GPIO15 (Chip Select)
│  BL     │──── 3.3V (Backlight, optional PWM)
└─────────┘
```

#### Connection

```
ST7789            ESP32
  VCC ────────── 3.3V
  GND ────────── GND
  SCL ────────── GPIO18 (SPI SCK)
  SDA ────────── GPIO23 (SPI MOSI)
  RES ────────── GPIO4
  DC  ────────── GPIO2
  CS  ────────── GPIO15
  BL  ────────── 3.3V (or PWM GPIO)
```

### Software Setup

```cpp
#include <TFT_eSPI.h>

TFT_eSPI tft = TFT_eSPI();

void setup() {
    tft.init();
    tft.setRotation(0);  // 0-3 for rotation
    tft.fillScreen(TFT_BLACK);

    tft.setTextColor(TFT_WHITE, TFT_BLACK);
    tft.setTextSize(2);
    tft.setCursor(0, 0);
    tft.println("WLED Controller");
}
```

**Note:** Requires User_Setup.h configuration in TFT_eSPI library

### TFT Features

**Full Color Graphics:**
- Display RGB colors
- Show effect previews
- Graph data (VU meter, FFT)
- Touch interface (if touch-enabled)

**Example VU Meter:**

```cpp
void drawVUMeter(int level) {
    // level: 0-100
    int barHeight = map(level, 0, 100, 0, 240);

    tft.fillRect(0, 0, 120, 240, TFT_BLACK);  // Clear

    // Draw bar with color gradient
    for (int y = 0; y < barHeight; y++) {
        uint16_t color;
        if (y < 80) {
            color = TFT_GREEN;
        } else if (y < 160) {
            color = TFT_YELLOW;
        } else {
            color = TFT_RED;
        }

        tft.drawFastHLine(0, 240 - y, 120, color);
    }
}
```

---

## Infrared Remotes

### IR Receiver (VS1838B / TSOP38238)

**Universal Remote Control:**

#### Pinout

```
IR Receiver
┌─────────┐
│   OUT   │──── ESP32 GPIO15
│   VCC   │──── 3.3V (or 5V)
│   GND   │──── GND
└─────────┘
```

#### Connection

```
IR Receiver       ESP32
  OUT ────────── GPIO15
  VCC ────────── 3.3V
  GND ────────── GND
```

**Optional: Add 100Ω resistor and 4.7µF capacitor on VCC for noise filtering**

### Software Setup

**Library: IRremoteESP8266**

```cpp
#include <IRremoteESP8266.h>
#include <IRrecv.h>
#include <IRutils.h>

#define IR_RECV_PIN 15

IRrecv irrecv(IR_RECV_PIN);
decode_results results;

void setup() {
    irrecv.enableIRIn();  // Start receiver
}

void loop() {
    if (irrecv.decode(&results)) {
        handleIRCode(results.value);
        irrecv.resume();  // Receive next code
    }
}

void handleIRCode(unsigned long code) {
    switch (code) {
        case 0xFFA25D:  // Power button
            toggleOnOff();
            break;
        case 0xFFE21D:  // Brightness +
            increaseBrightness();
            break;
        case 0xFF629D:  // Brightness -
            decreaseBrightness();
            break;
        // Add more codes...
    }
}
```

### Learning Remote Codes

**Sketch to Print Codes:**

```cpp
void loop() {
    if (irrecv.decode(&results)) {
        Serial.print("Code: 0x");
        Serial.println(results.value, HEX);
        irrecv.resume();
    }
}
```

**Process:**
1. Upload sketch
2. Open serial monitor
3. Press each remote button
4. Note the hex codes
5. Add to handleIRCode() switch statement

### Common Remote Mappings

**Standard Functions:**
- Power: Toggle on/off
- Vol+: Brightness up
- Vol-: Brightness down
- CH+: Next effect
- CH-: Previous effect
- 0-9: Preset selection
- Mute: Blackout toggle
- Play/Pause: Freeze effect

---

## Relays

### Relay Module Connection

**For Switching High Power:**

#### Single Relay Module

```
Relay Module      ESP32
  VCC ────────── 5V
  GND ────────── GND
  IN  ────────── GPIO26

  COM ────────── AC/DC common
  NO  ────────── Load (Normally Open)
  NC  ────────── (Normally Closed, not used)
```

**Important: Relay coil needs 5V, but GPIO signal can be 3.3V (most modules OK)**

### Use Cases

**1. Switch Mains-Powered Lights:**

```
AC Mains HOT ───┬─── Light
                │
        Relay NO ───┤

AC Mains NEUTRAL ──── Light
```

**Warning:**
⚠️ **Mains voltage is dangerous!**
- Only if qualified
- Follow electrical code
- Use proper enclosures
- Consider using solid state relay (SSR)

**2. Switch 12V LED Strips (non-addressable):**

```
12V PSU (+) ───┬─── Non-addressable LED strip (+)
               │
       Relay NO ───┤

12V PSU (-) ──────── LED strip (-)
```

**3. Control Other Devices:**
- Fans
- Pumps
- Solenoids
- Sirens/alarms

### Multi-Channel Relay

**4-Channel Relay Board:**

```
ESP32             4-Relay Module
GPIO26 ────────── IN1 (Relay 1)
GPIO27 ────────── IN2 (Relay 2)
GPIO32 ────────── IN3 (Relay 3)
GPIO33 ────────── IN4 (Relay 4)
5V ────────────── VCC
GND ───────────── GND
```

**Applications:**
- Zone control (4 rooms)
- RGB control (R, G, B, W channels)
- Sequential devices

### Code Example

```cpp
#define RELAY_PIN 26

void setup() {
    pinMode(RELAY_PIN, OUTPUT);
    digitalWrite(RELAY_PIN, LOW);  // Relay off
}

void turnOnRelay() {
    digitalWrite(RELAY_PIN, HIGH);
}

void turnOffRelay() {
    digitalWrite(RELAY_PIN, LOW);
}
```

**Note:** Some relay modules are active-LOW (HIGH = off, LOW = on). Check module documentation!

---

## Status LEDs

### Simple Indicator LED

**Visual Feedback:**

#### Connection

```
ESP32 GPIO25 ───[220Ω]───[LED]──── GND
                        (Anode)  (Cathode)
```

**Current Limiting Resistor:**
```
R = (Vsupply - Vled) / Iled
R = (3.3V - 2.0V) / 0.020A = 65Ω

Use 220Ω for safety (lower current, dimmer LED)
Use 100Ω for brighter LED
```

### RGB LED (Common Cathode)

```
ESP32                RGB LED
GPIO25 ──[220Ω]──── R (Red)
GPIO26 ──[220Ω]──── G (Green)
GPIO27 ──[220Ω]──── B (Blue)
GND ────────────── Cathode (-)
```

**Code (PWM for colors):**

```cpp
void setRGB(int r, int g, int b) {
    analogWrite(25, r);  // 0-255
    analogWrite(26, g);
    analogWrite(27, b);
}

// Examples:
setRGB(255, 0, 0);    // Red
setRGB(0, 255, 0);    // Green
setRGB(0, 0, 255);    // Blue
setRGB(255, 255, 0);  // Yellow
setRGB(255, 0, 255);  // Magenta
```

### WS2812B as Status

**Use One Addressable LED:**

```
ESP32 GPIO25 → [WS2812B single LED] → not connected

Just 1 LED for status indication
Simpler wiring than RGB LED
Full color control
```

---

## Sound Modules

### DFPlayer Mini (MP3 Player)

**Play Sounds/Music:**

#### Pinout

```
DFPlayer Mini
┌─────────┐
│  VCC    │──── 5V
│  GND    │──── GND
│  TX     │──── ESP32 RX (GPIO16)
│  RX     │──── ESP32 TX (GPIO17)
│  SPK_1  │──── Speaker +
│  SPK_2  │──── Speaker -
└─────────┘
```

**Note:** DFPlayer RX needs 3.3V signal → Use 1kΩ resistor in series

#### Connection with Level Shift

```
ESP32 TX (GPIO17) ─────────────── DFPlayer RX
ESP32 RX (GPIO16) ─────────────── DFPlayer TX
                   ┌──[1kΩ]──┐
                   │         │
5V ────────────────┴─────── VCC
GND ──────────────────────── GND
```

### Use Cases

**1. Sound Effects:**
- Play startup sound
- Effect change notification
- Button press confirmation
- Alert sounds

**2. Music Playback:**
- Background music
- Synchronized with LED effects
- Party mode

**Code Example:**

```cpp
#include <SoftwareSerial.h>
#include <DFRobotDFPlayerMini.h>

SoftwareSerial mySerial(16, 17);  // RX, TX
DFRobotDFPlayerMini myDFPlayer;

void setup() {
    mySerial.begin(9600);
    myDFPlayer.begin(mySerial);

    myDFPlayer.volume(20);  // 0-30
}

void playStartupSound() {
    myDFPlayer.play(1);  // Play file 0001.mp3 from SD card
}

void playEffectChange() {
    myDFPlayer.play(2);  // Play file 0002.mp3
}
```

**SD Card Structure:**
```
SD Card:
└── mp3/
    ├── 0001.mp3  (startup sound)
    ├── 0002.mp3  (effect change)
    ├── 0003.mp3  (button press)
    └── 0004.mp3  (alert)
```

---

## Real-Time Clocks (RTC)

### DS3231 RTC Module

**Accurate Timekeeping:**

#### Features
✅ High accuracy (±2ppm)
✅ Battery backup (keeps time when power off)
✅ Temperature compensated
✅ I2C interface

#### Pinout

```
DS3231 RTC
┌─────────┐
│  VCC    │──── 3.3V or 5V
│  GND    │──── GND
│  SCL    │──── ESP32 GPIO22 (I2C SCL)
│  SDA    │──── ESP32 GPIO21 (I2C SDA)
│  SQW    │──── (Square wave output, optional)
└─────────┘
```

### Use Cases

**1. Time-Based Effects:**
```cpp
void loop() {
    DateTime now = rtc.now();
    int hour = now.hour();

    if (hour >= 22 || hour < 6) {
        // Night mode: Dim, warm colors
        setBrightness(50);
        setColor(255, 147, 41);  // Warm white
    } else {
        // Day mode: Full brightness
        setBrightness(255);
        setColor(255, 255, 255);
    }
}
```

**2. Scheduled Events:**
```cpp
void loop() {
    DateTime now = rtc.now();

    // Turn on at 6:00 AM
    if (now.hour() == 6 && now.minute() == 0 && now.second() == 0) {
        turnOnLEDs();
    }

    // Turn off at 11:00 PM
    if (now.hour() == 23 && now.minute() == 0 && now.second() == 0) {
        turnOffLEDs();
    }
}
```

**Code Setup:**

```cpp
#include <RTClib.h>

RTC_DS3231 rtc;

void setup() {
    if (!rtc.begin()) {
        Serial.println("Couldn't find RTC");
        while (1);
    }

    // Set time (only needed once):
    // rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));

    // Or set specific date/time:
    // rtc.adjust(DateTime(2024, 1, 1, 12, 0, 0));
}
```

**Note:** ESP32 can also use NTP (Network Time Protocol) over WiFi, making RTC optional for internet-connected projects.

---

## Complete Interface Examples

### Example 1: Basic Control Panel

**Components:**
- 2× Buttons (On/Off, Next Effect)
- 1× Rotary Encoder (Brightness)
- 1× OLED Display (Status)

#### Wiring

```
ESP32
├── GPIO0:  Button 1 (On/Off)
├── GPIO35: Button 2 (Next Effect)
├── GPIO16: Encoder CLK
├── GPIO17: Encoder DT
├── GPIO5:  Encoder SW
├── GPIO21: OLED SDA
└── GPIO22: OLED SCL
```

#### Functions

- Button 1: Toggle LED on/off
- Button 2: Cycle to next effect
- Encoder Rotate: Adjust brightness
- Encoder Press: Reset to default brightness
- Display: Show status (brightness, effect, WiFi)

---

### Example 2: Advanced Control Station

**Components:**
- 1× Rotary Encoder with button
- 1× TFT Display (color)
- 1× IR Receiver
- 3× Status LEDs (Power, WiFi, Activity)

#### Features

**Display Menu:**
1. Brightness control
2. Effect selection (with preview)
3. Color picker
4. WiFi status
5. Settings

**Navigation:**
- Rotate encoder: Navigate menu
- Press encoder: Select/enter
- IR remote: Quick access

**Status LEDs:**
- Power LED: On when powered
- WiFi LED: Blinks when connected
- Activity LED: Flashes on data activity

---

### Example 3: Wall-Mounted Controller

**Components:**
- 4× Tactile buttons in panel
- 1× Rotary encoder
- 1× OLED (small, 0.91")
- 1× Enclosure with laser-cut front panel

#### Layout

```
┌─────────────────────┐
│                     │
│   [OLED Display]    │
│                     │
│  [Power] [Effect]   │
│                     │
│  [  Encoder  ]      │
│                     │
│  [Color] [Preset]   │
│                     │
└─────────────────────┘
```

#### Functions

- Power button: On/Off
- Effect button: Cycle effects
- Color button: Cycle color palettes
- Preset button: Load presets 1-10 (with encoder)
- Encoder: Adjust selected parameter

---

## Summary

### Recommended Components by Use Case

| Use Case | Components | Priority |
|----------|-----------|----------|
| **Basic Control** | 1-2 buttons | Essential |
| **Smooth Adjustment** | Rotary encoder | High |
| **Status Display** | OLED display | Medium |
| **Visual Status** | RGB LED | Low |
| **Colorful UI** | TFT display | Nice to have |
| **Remote Control** | IR receiver | Convenient |
| **High Power Switch** | Relay | As needed |
| **Time-Based** | RTC module | Optional |
| **Sound Effects** | DFPlayer | Fun addition |

### GPIO Planning Checklist

Before starting:

- [ ] List all components
- [ ] Assign GPIO to each function
- [ ] Check for conflicts (SPI, I2C, strapping pins)
- [ ] Verify enough available GPIO
- [ ] Plan for future expansion
- [ ] Document pinout clearly

### Related Guides

- [Sensor Integration Guide](SENSOR_INTEGRATION_GUIDE.md)
- [Level Shifter Guide](LEVEL_SHIFTER_GUIDE.md)
- [Hardware Development Guide](HARDWARE_GUIDE.md)

---

**Happy Interfacing!** 🎛️🔘💡
