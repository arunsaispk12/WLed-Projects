/**
 * Basic ESP32 WLED Controller
 *
 * This is a minimal example showing how to set up WLED with custom configuration.
 * For full WLED features, use the official WLED firmware.
 *
 * This file demonstrates:
 * - Custom pin configuration
 * - LED strip setup
 * - WiFi configuration
 * - Button handling
 */

#include <Arduino.h>

// Configuration
#ifndef LEDPIN
#define LEDPIN 2
#endif

#ifndef DEFAULT_LED_COUNT
#define DEFAULT_LED_COUNT 60
#endif

#ifndef BTNPIN
#define BTNPIN 0
#endif

// For full WLED functionality, include WLED headers
// This is a simplified example - actual WLED integration would use:
// #include "wled.h"

// LED Control
const int LED_PIN = LEDPIN;
const int LED_COUNT = DEFAULT_LED_COUNT;
const int BUTTON_PIN = BTNPIN;

// Button state
bool buttonPressed = false;
unsigned long lastButtonPress = 0;
const unsigned long DEBOUNCE_DELAY = 50;

void setup() {
  // Initialize serial
  Serial.begin(115200);
  Serial.println();
  Serial.println("═══════════════════════════════════");
  Serial.println("  Basic ESP32 WLED Controller");
  Serial.println("═══════════════════════════════════");
  Serial.printf("  LED Pin: GPIO%d\n", LED_PIN);
  Serial.printf("  LED Count: %d\n", LED_COUNT);
  Serial.printf("  Button Pin: GPIO%d\n", BUTTON_PIN);
  Serial.println("═══════════════════════════════════");

  // Configure pins
  pinMode(LED_PIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT_PULLUP);

  // Startup blink
  for (int i = 0; i < 3; i++) {
    digitalWrite(LED_PIN, HIGH);
    delay(100);
    digitalWrite(LED_PIN, LOW);
    delay(100);
  }

  Serial.println("[OK] Hardware initialized");

  // TODO: Initialize WLED
  // For actual WLED functionality, you would:
  // 1. Include WLED library
  // 2. Call WLED setup functions
  // 3. Configure LED strip type and count
  // 4. Set up WiFi
  // 5. Initialize web server

  Serial.println("[INFO] Ready to control LEDs");
  Serial.println("[INFO] This is a template - integrate WLED library for full functionality");
  Serial.println();
}

void loop() {
  // Handle button
  handleButton();

  // TODO: WLED main loop
  // For actual WLED functionality, you would call:
  // WLED.loop();

  // Simple blink as placeholder
  static unsigned long lastBlink = 0;
  if (millis() - lastBlink > 1000) {
    digitalWrite(LED_PIN, !digitalRead(LED_PIN));
    lastBlink = millis();
  }
}

void handleButton() {
  bool currentState = digitalRead(BUTTON_PIN) == LOW;

  if (currentState && !buttonPressed) {
    if (millis() - lastButtonPress > DEBOUNCE_DELAY) {
      buttonPressed = true;
      lastButtonPress = millis();
      onButtonPress();
    }
  } else if (!currentState && buttonPressed) {
    buttonPressed = false;
  }
}

void onButtonPress() {
  Serial.println("[BUTTON] Pressed!");

  // TODO: Handle button press
  // For actual WLED functionality:
  // - Toggle on/off
  // - Change preset
  // - Adjust brightness
  // etc.
}

// Additional helper functions

/**
 * Print system information
 */
void printSystemInfo() {
  Serial.println("\n=== System Information ===");
  Serial.printf("Chip Model: %s\n", ESP.getChipModel());
  Serial.printf("Chip Revision: %d\n", ESP.getChipRevision());
  Serial.printf("CPU Frequency: %d MHz\n", ESP.getCpuFreqMHz());
  Serial.printf("Free Heap: %d bytes\n", ESP.getFreeHeap());
  Serial.printf("Flash Size: %d bytes\n", ESP.getFlashChipSize());
  Serial.printf("SDK Version: %s\n", ESP.getSdkVersion());
  Serial.println("==========================\n");
}

/**
 * Example: Custom LED pattern
 * (Placeholder - real implementation would use LED library)
 */
void customPattern() {
  Serial.println("[INFO] Running custom pattern...");
  // TODO: Implement with FastLED or WLED effects
}

/*
 * INTEGRATION NOTES:
 *
 * To use full WLED functionality:
 *
 * 1. Include WLED library in platformio.ini:
 *    lib_deps = https://github.com/Aircoookie/WLED.git#v0.14.0
 *
 * 2. Replace this file content with WLED initialization:
 *    #include "wled.h"
 *
 *    void setup() {
 *      WLED::instance().setup();
 *    }
 *
 *    void loop() {
 *      WLED::instance().loop();
 *    }
 *
 * 3. Configure WLED options in platformio.ini build_flags
 *
 * 4. See WLED documentation for advanced features:
 *    https://kno.wled.ge/
 */
