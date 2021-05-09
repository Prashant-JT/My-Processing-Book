int IR_SENSOR = 0; // Sensor connected to the analog A0
int sensorResult = 0; // Sensor result
float sensorDistance = 0; // Calculated value

void setup() {
  // Setup communication with serial monitor
  Serial.begin(9600);
}

void loop() {
  // Read the value from the ir sensor
  sensorResult = analogRead(IR_SENSOR);
  // Calculate distance in cm
  sensorDistance = (6787.0 / (sensorResult - 3.0)) - 4.0;
  // Send distance to Processing
  Serial.println(sensorDistance);
  delay(200); // Wait
}
