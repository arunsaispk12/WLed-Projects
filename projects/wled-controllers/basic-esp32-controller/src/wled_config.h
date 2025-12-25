/**
 * WLED Configuration for Basic ESP32 Controller
 *
 * This file contains hardware-specific configuration for WLED.
 * Customize these settings for your specific hardware setup.
 */

#ifndef WLED_CONFIG_H
#define WLED_CONFIG_H

// ============================================
// HARDWARE CONFIGURATION
// ============================================

// LED Configuration
#ifndef LEDPIN
#define LEDPIN 2                      // LED data pin (GPIO2)
#endif

#ifndef DEFAULT_LED_COUNT
#define DEFAULT_LED_COUNT 60          // Number of LEDs
#endif

#ifndef DEFAULT_LED_TYPE
#define DEFAULT_LED_TYPE TYPE_WS2812_RGB  // LED type
#endif

// Button Configuration
#ifndef BTNPIN
#define BTNPIN 0                      // Button pin (GPIO0 - built-in flash button)
#endif

// Optional Features
// #define RLYPIN 12                  // Relay pin (uncomment if using relay)
// #define RLYMDE 1                   // Relay mode (1=active high, 0=active low)

// I2C Configuration (for displays/sensors)
// #define I2CSCLPIN 22               // I2C SCL pin
// #define I2CSDAPIN 21               // I2C SDA pin

// Sound Reactive (requires INMP441 or similar)
// #define AUDIOPIN 36                // Analog audio input
// #define I2S_SDPIN 33               // I2S SD (data)
// #define I2S_WSPIN 25               // I2S WS (word select)
// #define I2S_CKPIN 32               // I2S SCK (clock)

// ============================================
// WLED FEATURES
// ============================================

// Enable/Disable Features
#define WLED_ENABLE_WEBSOCKETS         // WebSocket support (recommended)
#define WLED_ENABLE_MQTT               // MQTT support
#define WLED_ENABLE_ADALIGHT           // Adalight protocol (for Prismatik, etc.)

// Disable unused features to save memory
#define WLED_DISABLE_HUESYNC           // Philips Hue sync (if not needed)
// #define WLED_DISABLE_INFRARED       // IR remote (if not needed)
// #define WLED_DISABLE_ALEXA          // Amazon Alexa (if not needed)

// ============================================
// NETWORK CONFIGURATION
// ============================================

// Access Point Configuration
#ifndef WLED_AP_SSID
#define WLED_AP_SSID "WLED-AP"         // AP SSID when not connected
#endif

#ifndef WLED_AP_PASS
#define WLED_AP_PASS "wled1234"        // AP password (min 8 characters)
#endif

// Default Device Name (shows up in network)
#ifndef WLED_DEVICE_NAME
#define WLED_DEVICE_NAME "WLED-Controller"
#endif

// mDNS Hostname
#ifndef WLED_MDNS_NAME
#define WLED_MDNS_NAME "wled"          // Access via http://wled.local
#endif

// ============================================
// POWER & PERFORMANCE
// ============================================

// Maximum Current (mA)
// Set this to your power supply's safe limit
#ifndef WLED_MAX_CURRENT
#define WLED_MAX_CURRENT 3000          // 3A for 60 LEDs
#endif

// Default Brightness (0-255)
#ifndef WLED_DEFAULT_BRIGHTNESS
#define WLED_DEFAULT_BRIGHTNESS 128    // 50% brightness
#endif

// Transitions
#define WLED_ENABLE_TRANSITIONS        // Smooth transitions
#define DEFAULT_TRANSITION_TIME 7      // Default transition time (x100ms)

// ============================================
// ADVANCED SETTINGS
// ============================================

// LED Bus Configuration
#ifndef WLED_MAX_BUSSES
#define WLED_MAX_BUSSES 1              // Number of LED outputs
#endif

// Segments
#ifndef WLED_MAX_SEGMENTS
#define WLED_MAX_SEGMENTS 10           // Maximum number of segments
#endif

// Usermods
#ifndef WLED_MAX_USERMODS
#define WLED_MAX_USERMODS 4            // Maximum custom modules
#endif

// Playlists & Presets
#define WLED_MAX_PALETTES 100          // Color palettes
#define WLED_MAX_PRESETS 50            // Saved presets

// ============================================
// SAFETY FEATURES
// ============================================

// Automatic brightness limiting based on current
#define WLED_ABL_ENABLE                // Auto brightness limiter

// Watchdog
#define WLED_WATCHDOG_TIMEOUT 8000     // Reset if frozen (ms)

// Recovery Mode
// Hold button during boot to enter WiFi recovery mode
#define WLED_ENABLE_RECOVERY_MODE

// ============================================
// DEBUG SETTINGS
// ============================================

#ifdef DEBUG_BUILD
  #define WLED_DEBUG                   // Enable debug output
  #define WLED_DEBUG_HEAP              // Monitor heap usage
  #define WLED_DEBUG_WIFI              // WiFi debug messages
#endif

// Serial Baud Rate
#define WLED_SERIAL_BAUD 115200

// ============================================
// HARDWARE VARIANTS
// ============================================

// Uncomment for specific ESP32 variants
// #define ARDUINO_ARCH_ESP32C3         // ESP32-C3
// #define ARDUINO_ARCH_ESP32S3         // ESP32-S3
// #define BOARD_HAS_PSRAM              // ESP32 with PSRAM

// ============================================
// LED TYPE CONFIGURATIONS
// ============================================

// Common LED configurations (uncomment the one you're using)

// WS2812B (most common)
// #define LED_TYPE_WS2812B
// #define LED_COLOR_ORDER GRB
// #define LED_DATA_RATE 800000

// SK6812 (better color accuracy)
// #define LED_TYPE_SK6812
// #define LED_COLOR_ORDER GRB
// #define LED_DATA_RATE 800000

// WS2813 (backup data line)
// #define LED_TYPE_WS2813
// #define LED_COLOR_ORDER GRB
// #define LED_DATA_RATE 800000

// APA102 (requires clock pin)
// #define LED_TYPE_APA102
// #define LED_COLOR_ORDER BGR
// #define LED_CLOCK_PIN 14
// Note: APA102 uses SPI, different wiring

// ============================================
// VALIDATION
// ============================================

// Validate configuration
#if WLED_MAX_CURRENT < 500
  #warning "WLED_MAX_CURRENT seems low. Ensure this is correct."
#endif

#if DEFAULT_LED_COUNT > 500 && !defined(BOARD_HAS_PSRAM)
  #warning "Large LED count without PSRAM may cause memory issues"
#endif

// ============================================
// NOTES & RECOMMENDATIONS
// ============================================

/*
 * PRODUCTION CHECKLIST:
 *
 * [ ] Set correct LED count (DEFAULT_LED_COUNT)
 * [ ] Configure maximum current (WLED_MAX_CURRENT)
 * [ ] Set LED data pin (LEDPIN)
 * [ ] Choose LED type (DEFAULT_LED_TYPE)
 * [ ] Set WiFi AP password (min 8 chars)
 * [ ] Disable unused features to save memory
 * [ ] Test with actual hardware before deployment
 * [ ] Set appropriate brightness for your use case
 * [ ] Enable ABL if using high LED counts
 *
 * POWER CALCULATIONS:
 * - Each LED draws ~60mA at full white
 * - Set WLED_MAX_CURRENT to 80% of PSU capacity
 * - Example: 5V 5A PSU → Set to 4000mA max
 *
 * MEMORY OPTIMIZATION:
 * - Reduce WLED_MAX_SEGMENTS for simple setups
 * - Disable HUESYNC if not using Philips Hue
 * - Disable INFRARED if not using IR remote
 * - Consider ESP32-WROVER for >300 LEDs (has PSRAM)
 *
 * RELIABILITY:
 * - Enable watchdog timer
 * - Set reasonable current limits
 * - Use quality power supply
 * - Add capacitor at LED power input
 * - Keep data lines short
 * - Use level shifter for 5V LEDs
 */

#endif // WLED_CONFIG_H
