#include <Adafruit_NeoPixel.h>
#include <Servo.h>
#ifdef __AVR__
  #include <avr/power.h>
#endif

Servo rServo;
Servo lServo;

char lastByte='0';

#define PIN PB6

// Parameter 1 = number of pixels in strip
// Parameter 2 = Arduino pin number (most are valid)
// Parameter 3 = pixel type flags, add together as needed:
//   NEO_KHZ800  800 KHz bitstream (most NeoPixel products w/WS2812 LEDs)
//   NEO_KHZ400  400 KHz (classic 'v1' (not v2) FLORA pixels, WS2811 drivers)
//   NEO_GRB     Pixels are wired for GRB bitstream (most NeoPixel products)
//   NEO_RGB     Pixels are wired for RGB bitstream (v1 FLORA pixels, not v2)
Adafruit_NeoPixel strip = Adafruit_NeoPixel(60, PIN, NEO_GRB + NEO_KHZ800);

// IMPORTANT: To reduce NeoPixel burnout risk, add 1000 uF capacitor across
// pixel power leads, add 300 - 500 Ohm resistor on first pixel's data input
// and minimize distance between Arduino and first pixel.  Avoid connecting
// on a live circuit...if you must, connect GND first.

void setup() {
  // This is for Trinket 5V 16MHz, you can remove these three lines if you are not using a Trinket
  #if defined (__AVR_ATtiny85__)
    if (F_CPU == 16000000) clock_prescale_set(clock_div_1);
  #endif
  // End of trinket special code


  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
  Serial.begin(19200); // set the baud rate
  Serial.println("Ready"); // print "Ready" once
  randomSeed(analogRead(0));
  lServo.attach(11);
  rServo.attach(9);
  lServo.write(90); 
  rServo.write(90);
}

void loop() {
  int counter=random(9);
  if(counter==0){
    colorWipe(strip.Color(255, 0, 0), 5); // Red
  }
  else if(counter==1){
    colorWipe(strip.Color(0, 255, 0), 5); // Green
  }
  else if(counter==2){
    colorWipe(strip.Color(0, 0, 255), 5); // Blue
  }
  else if(counter==3){
    theaterChase(strip.Color(127, 0, 0), 5); // Red
  }
  else if(counter==4){
    theaterChase(strip.Color(127, 127, 127), 5); // White
  }
  else if(counter==5){
    theaterChase(strip.Color(0, 0, 127), 5); // Blue     
  }
  else if(counter==6){
    rainbow(5);
  }
  else if(counter==7){
    theaterChaseRainbow(5);
  }
  else if(counter==8){
    rainbowCycle(5);
  }
  if(Serial.available()){ // only send data back if data has been sent
    char inByte = Serial.read(); // read the incoming data
    Serial.println(inByte);
    if(inByte!=lastByte){
      lastByte=inByte;
      Serial.println("dif");
      if(inByte=='0'){
        lServo.write(90);
        rServo.write(90);
        delay(100);
      }
      else if(inByte=='1'){
        Serial.println("N");
        for (int i=90;i<180;i++){
          lServo.write(i);
          delay(40);
        }
        for (int i=180;i>90;i--){
          lServo.write(i);
          delay(40);
        }
      }
      else if(inByte=='2'){
        Serial.println("O");
        for (int i=90;i>0;i--){
          lServo.write(i);
          delay(40);
        }
        for (int i=0;i<90;i++){
          lServo.write(i);
          delay(40);
        }
      }
      else if(inByte=='3'){
        Serial.println("P");
        for (int i=90;i<180;i++){
          rServo.write(i);
          delay(40);
        }
        for (int i=180;i>90;i--){
          rServo.write(i);
          delay(40);
        }
      }
      else if(inByte=='4'){
        Serial.println("S");
        for (int i=90;i>0;i--){
          rServo.write(i);
          delay(40);
        }
        for (int i=0;i<90;i++){
          rServo.write(i);
          delay(40);
        }
      }
    }
  }
  delay(100);
}

// Fill the dots one after the other with a color
void colorWipe(uint32_t c, uint8_t wait) {
  for(uint16_t i=0; i<strip.numPixels(); i++) {
    strip.setPixelColor(i, c);
    strip.show();
    delay(wait);
  }
}

void rainbow(uint8_t wait) {
  uint16_t i, j;

  for(j=0; j<256; j+=5) {
    for(i=0; i<strip.numPixels(); i++) {
      strip.setPixelColor(i, Wheel((i+j) & 255));
    }
    strip.show();
    delay(wait);
  }
}

// Slightly different, this makes the rainbow equally distributed throughout
void rainbowCycle(uint8_t wait) {
  uint16_t i, j;

  for(j=0; j<256*2; j+=3) { // 5 cycles of all colors on wheel
    for(i=0; i< strip.numPixels(); i++) {
      strip.setPixelColor(i, Wheel(((i * 256 / strip.numPixels()) + j) & 255));
    }
    strip.show();
    delay(wait);
  }
}

//Theatre-style crawling lights.
void theaterChase(uint32_t c, uint8_t wait) {
  for (int j=0; j<3; j++) {  //do 10 cycles of chasing
    for (int q=0; q < 3; q++) {
      for (int i=0; i < strip.numPixels(); i=i+3) {
        strip.setPixelColor(i+q, c);    //turn every third pixel on
      }
      strip.show();

      delay(wait);

      for (int i=0; i < strip.numPixels(); i=i+3) {
        strip.setPixelColor(i+q, 0);        //turn every third pixel off
      }
    }
  }
}

//Theatre-style crawling lights with rainbow effect
void theaterChaseRainbow(uint8_t wait) {
  for (int j=0; j < 256; j+=4) {     // cycle all 256 colors in the wheel
    for (int q=0; q < 3; q++) {
      for (int i=0; i < strip.numPixels(); i=i+3) {
        strip.setPixelColor(i+q, Wheel( (i+j) % 255));    //turn every third pixel on
      }
      strip.show();

      delay(wait);

      for (int i=0; i < strip.numPixels(); i=i+3) {
        strip.setPixelColor(i+q, 0);        //turn every third pixel off
      }
    }
  }
}

// Input a value 0 to 255 to get a color value.
// The colours are a transition r - g - b - back to r.
uint32_t Wheel(byte WheelPos) {
  WheelPos = 255 - WheelPos;
  if(WheelPos < 85) {
    return strip.Color(255 - WheelPos * 3, 0, WheelPos * 3);
  }
  if(WheelPos < 170) {
    WheelPos -= 85;
    return strip.Color(0, WheelPos * 3, 255 - WheelPos * 3);
  }
  WheelPos -= 170;
  return strip.Color(WheelPos * 3, 255 - WheelPos * 3, 0);
}
