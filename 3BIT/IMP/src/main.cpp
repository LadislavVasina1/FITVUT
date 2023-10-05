/**************************************/
/*          IMP - PROJECT             */
/*      ESP32 - HEART BEAT SENSOR     */
/*     AUTHOR: LADISLAV VASINA        */
/*         LOGIN: XVASIN11            */
/*           YEAR: 2022               */
/**************************************/

#include <SPI.h>
#include <WiFi.h>
#include <WiFiClient.h>
#include <WebServer.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <MAX30105.h>
#include <heartRate.h>
#include <Fonts/FreeMono9pt7b.h>
#include <index.h>

#define SCREEN_WIDTH  128 // OLED display width  [px]
#define SCREEN_HEIGHT 64 // OLED display height [px]
#define OLED_DC       27
#define OLED_CS       5
#define OLED_RESET    17

const char* ssid = "XVASIN11-ESP32-AP";
const byte RATE_SIZE = 8;
byte rates[RATE_SIZE];
byte rateIndex = 0;
long lastBeat = 0;
float beatsPerMinute;
int bpmAvg;

WebServer server(80);
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &SPI, OLED_DC, OLED_RESET, OLED_CS);
MAX30105 heartBeatSensor;

// Function for sending HTML site to the server
void handleRoot() {
  // Load html from index.h
  String s = MAIN_page;
  // Send it to the server
  server.send(200, "text/html", s);
}


// Function for sending data to the server asynchronously
void handleWeb() {
  String dataToSend = String("BPM: ");
  dataToSend.concat(String(beatsPerMinute));
  dataToSend.concat("<br>AvgBPM: ");
  dataToSend.concat(String(bpmAvg));
  server.send(200, "text/plane", dataToSend);
}
 

// Function for initializing web server
void webServerInit(){
  //Access Point mode
  WiFi.mode(WIFI_AP); 
  WiFi.softAP(ssid);
  Serial.println("");
  Serial.print("Wifi name: ");
  Serial.println(ssid);
  server.on("/", handleRoot);
  server.on("/readData", handleWeb);
  //Start web server
  server.begin();                  
  Serial.println("HTTP server started");
}


// ESP32 setup function
void setup() {
  byte ledBrightness = 32;
  byte sampleAverage = 2;
  // Red + IR led mode
  byte ledMode = 2; 
  byte sampleRate = 3200; 
  int pulseWidth = 69;
  int adcRange = 4096;
  Serial.begin(115200);
  Serial.println("Initializing...");
  webServerInit();

  // Display init
  if(!display.begin(SSD1306_SWITCHCAPVCC)){
    Serial.println(F("SSD1306 allocation failed"));
    while(true);
  }
  // Sensor init
  if (!heartBeatSensor.begin(Wire, I2C_SPEED_FAST)){
    Serial.println("MAX30102 was not found. Please check wiring/power.");
    while(true);
  }
  Serial.println("PLACE YOUR FINGER ON THE SENSOR WITH STEADY PRESSURE.");
  // Configuring sensor with values from above
  heartBeatSensor.setup(ledBrightness, sampleAverage, ledMode, sampleRate, pulseWidth, adcRange);
  // Initial display settings
  display.display();
  display.clearDisplay();
  display.setFont(&FreeMono9pt7b);
  display.drawRect(0, 0, display.width(), display.height(), SSD1306_WHITE);
  display.display();
  display.setCursor(20, 20);
  display.setTextSize(1);
  display.setTextColor(SSD1306_WHITE);
  display.cp437(true);
  delay(1000);
}


// Function that handles displaying heartbeat info on the display
void printDisplayInfo(float beatsPerMinute, int bpmAvg){
  display.clearDisplay();
  display.setFont(&FreeMono9pt7b);
  display.setCursor(20, 20);
  display.setTextSize(1);
  display.setTextColor(SSD1306_WHITE);
  display.cp437(true);
  display.print("BPM:");
  display.println(beatsPerMinute);
  display.print("  AVG:");
  display.println(bpmAvg);
  display.display();
}


// Function that prints info if finger is not present
void printDisplayNoFinger(){
    display.clearDisplay();
    // Uncomment this to see message in serial monitor that the finger is not present
    // Serial.print("NO FINGER DETECTED!");
    // Serial.println();
    display.println("NO FINGER");
    display.println("DETECTED!");
    display.setCursor(10, 20);
    display.setTextSize(1);
    display.display();
    display.clearDisplay();
}


// ESP32 loop function
void loop() {
  // Geting IR value so we can calculate heart beat value
  long irValue = heartBeatSensor.getIR();
  if (checkForBeat(irValue)){
    long deltaBeat = millis() - lastBeat;
    lastBeat = millis();
    // Calculation heart beats per minute
    beatsPerMinute = 60 / (deltaBeat / 1000.0);

    // If beats are in certain range then calculate average
    if (50 < beatsPerMinute  && beatsPerMinute < 200){
      // Store this reading in the array
      rates[rateIndex++] = (byte)beatsPerMinute;
      // Wrap variable to start of array
      rateIndex = rateIndex % RATE_SIZE;
      // Take the average of readings
      bpmAvg = 0;
      for(byte x = 0 ; x < RATE_SIZE ; ++x){
        bpmAvg = bpmAvg + rates[x];
      }
      bpmAvg = bpmAvg / RATE_SIZE;
    }
  }

  // From IR value we can determine if finger is pressed on the sensor
  if (irValue < 66666){
    printDisplayNoFinger();
  }else{
    Serial.print("IR=");
    Serial.print(irValue);
    Serial.print(", BPM=");
    Serial.print(beatsPerMinute);
    Serial.print(", Avg BPM=");
    Serial.print(bpmAvg);
    printDisplayInfo(beatsPerMinute, bpmAvg);
    Serial.println();
  }

// Library function that handles client on the web server
server.handleClient();
delay(1);
}
