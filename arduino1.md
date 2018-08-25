Arduino First Program

```
void setup() {
  pinMode(13, OUTPUT);
  Serial.begin(9600);
}

int incomingByte = 0;

void loop() {

  if (Serial.available() > 0) {
    incomingByte = Serial.read(); // read the incoming byte:
    if( incomingByte == 49 ) {
     digitalWrite(13, HIGH);
    } else {
     digitalWrite(13, LOW);
    }
  }

}
```
