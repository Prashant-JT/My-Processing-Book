// En milisegundos
const float threshold = 0.75;
const int freqMax = 60;
const int freqMin = 600;
const int freqNormal = 250;

float jump = 0.1;
float value = 0;
float senFreq = 0;

void setup() {  
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  senFreq = sin(value);
  value += jump;
  
  if (value >= PI/2 || value <= -PI/2) jump = -jump;

  Serial.println(senFreq);

  if (senFreq > threshold) {
    blinkLed(freqMax);
  } else if (senFreq < -threshold) {
    blinkLed(freqMin);                       
  } else {
    blinkLed(freqNormal);
  }
}

void blinkLed (int freq) {
  digitalWrite(LED_BUILTIN, HIGH);  
  delay(freq);
  digitalWrite(LED_BUILTIN, LOW);    
  delay(freq);  
}
