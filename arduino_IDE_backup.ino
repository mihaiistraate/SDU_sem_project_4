// Input pins:
// Sensor 1A : D2
// Sensor 1B : D3
// Sensor 2A : D4
// Sensor 2B : D5
// Sensor 3A : D6
// Sensor 3B : D7

// In button 1 : D8
// In button 2 : D9
// In button 3 : D10

// Out button 1 (up) : D11
// Out button 2 down : D12
// Out button 2 up : D13
// Out button 3 (down) : D14

// Output pins:
// Motor 1 : D16 / A2
// Motor 2 : D17 / A3
// Motor 3 : D18 / A4
// Motor 4 : D19 / A5

const int sensor_1A = 4;
const int sensor_1B = 5;
const int sensor_2A = 6;
const int sensor_2B = 7;
const int sensor_3A = 15;
const int sensor_3B = 16;

const int inbutton1 = 17;
const int inbutton2 = 18;
const int inbutton3 = 8;

const int outbutton1 = 3;
const int outbutton2down = 46;
const int outbutton2up = 9;
const int outbutton3 = 10;

const int HIGH_SIDE1 = 11; // Assuming this is for one direction (e.g., controlling one half of an H-bridge)
const int LOW_SIDE1 = 12;  // PWM control for that direction
const int HIGH_SIDE2 = 13; // For the other direction
const int LOW_SIDE2 = 14;  // PWM control for the other direction

const int LED1 = 40; // 3 LEDs that light up from when one of the exterior buttons is pressed until the cart reaches that floor
const int LED2 = 41;
const int LED3 = 42;

// --- Global Variables for Elevator Logic ---
int motorInitialSpeed = 70, motorActualSpeed = 0;
bool firstTime = true;
int motorSpeedFast = 50; // Faster speed when between floors (0-255)
int motorSpeedSlow = 30;  // Slower speed for precise stopping (0-255)

// Elevator states
enum ElevatorState {
  state_idle,             // No active calls, waiting
  state_moving_up,        // Actively moving upwards
  state_moving_down,      // Actively moving downwards
  state_stopping_at_floor // Decelerating to stop at a floor
};
ElevatorState elevatorState = state_idle;

// Current direction of travel / preference
enum Direction {
  DIR_NONE, // Not moving in any specific direction
  DIR_UP,   // Preferred direction is up
  DIR_DOWN  // Preferred direction is down
};
Direction currentDirection = DIR_NONE;

int currentFloor = 1;      // Current detected floor (1, 2, or 3). Assumed at 1 on startup.
int destinationFloor = 0;  // The immediate target floor the elevator is moving towards

// Request queues (true if a request exists for that floor)
// Index 0 is unused, floors 1, 2, 3 correspond to indices 1, 2, 3
bool internalRequests[4] = {false, false, false, false};      // Calls from inside the elevator
bool externalUpRequests[4] = {false, false, false, false};    // Calls from outside, requesting up
bool externalDownRequests[4] = {false, false, false, false};  // Calls from outside, requesting down

// Timers for non-blocking delays (e.g., stop at floor, debounce)
unsigned long stopTimer = 0;
const unsigned long stopDuration = 4000; // Time (ms) elevator stays stopped at a floor

// Debounce variables for buttons
const int NUM_BUTTONS = 7;
const long debounceDelay = 100; // milliseconds
unsigned long lastButtonPressTime[NUM_BUTTONS]; // To store last press time for each button

// Array to store the pinout of the input buttons
const int buttonPins[] = {
  inbutton1, inbutton2, inbutton3,
  outbutton1, outbutton2down, outbutton2up, outbutton3
};
bool lastButtonState[NUM_BUTTONS]; // Store last read state for debounce (assuming INPUT_PULLUP)

// --- Motor Control Functions ---
void Up(int speed) {
  digitalWrite(HIGH_SIDE1, HIGH); // Turn on P-channel high-side
  analogWrite(LOW_SIDE1, 0); // Control speed with PWM on low-side
  digitalWrite(HIGH_SIDE2, LOW); // Turn off P-channel high-side
  analogWrite(LOW_SIDE2, speed); // Ensure low-side on reverse side is off
}

void Down(int speed) {
  digitalWrite(HIGH_SIDE1, LOW); // Turn off P-channel high-side
  analogWrite(LOW_SIDE1, speed); // Ensure low-side on forward side is off
  digitalWrite(HIGH_SIDE2, HIGH); // Turn on P-channel high-side
  analogWrite(LOW_SIDE2, 0); // Control speed with PWM on low-side
}

void Stop() {
  digitalWrite(HIGH_SIDE1, LOW); // Turn off P-channel high-side
  analogWrite(LOW_SIDE1, 0); // Ensure low-side is off
  digitalWrite(HIGH_SIDE2, LOW); // Turn off P-channel high-side
  analogWrite(LOW_SIDE2, 0); // Ensure low-side is off
}

// Returns 1, 2, or 3 if at a floor, 0 otherwise (between floors)
int readCurrentFloorSensors() {
  if (digitalRead(sensor_1A) == HIGH && digitalRead(sensor_1B) == HIGH)
    return 1;
  else if (digitalRead(sensor_2A) == HIGH && digitalRead(sensor_2B) == HIGH)
    return 2;
  else if (digitalRead(sensor_3A) == HIGH && digitalRead(sensor_3B) == HIGH)
    return 3;
  return 0; // Not precisely at any floor
}

// --- Debounced Button Reading Function ---
// Assumes buttons have INPUT_PULLUP (active LOW when pressed)
bool readDebouncedButton(int pin, int buttonIndex) {
  int reading = digitalRead(pin); //reading the value of the corresponding pin

  if (reading != lastButtonState[buttonIndex]) {
    lastButtonPressTime[buttonIndex] = millis(); // reset debounce timer if the read value is different than the value from the array
  }

  if ((millis() - lastButtonPressTime[buttonIndex]) > debounceDelay) { //if the button has been pressed for long enough
    if (reading != lastButtonState[buttonIndex]) { //current reading is different than the stored one
      lastButtonState[buttonIndex] = reading;
      if (reading == LOW) { // button is pressed (active LOW)
        return true;
      }
    }
  }
  return false; // Not pressed or still debouncing
}

// Function to find the next target floor; It tries to serve calls in the current direction first.
int findNextDestination() {
  // if moving up, check for requests above current floor
  if (currentDirection == DIR_UP) {
    for (int i = currentFloor + 1; i <= 3; i++)
      if (internalRequests[i] || externalUpRequests[i] || externalDownRequests[i]) // check if there are any requests stored in the 3 registers
        return i; // found a request above
    
    // if no more requests above, check for requests below (change direction)
    for (int i = 3; i >= 1; i--) // start from top, go down to serve all
      if (internalRequests[i] || externalUpRequests[i] || externalDownRequests[i]) {
        currentDirection = DIR_DOWN; // change direction
        return i;
      }
  }
  // if moving down, check for requests below current floor
  else if (currentDirection == DIR_DOWN) {
    for (int i = currentFloor - 1; i >= 1; i--)
      if (internalRequests[i] || externalUpRequests[i] || externalDownRequests[i])
        return i; // found a request below
    
    // if no more requests below, check for requests above (change direction)
    for (int i = 1; i <= 3; i++) { // start from bottom, go up to serve all
      if (internalRequests[i] || externalUpRequests[i] || externalDownRequests[i]){
        currentDirection = DIR_UP; // change direction
        return i;
      }
    }
  }
  // If not moving or no preferred direction, pick the closest call
  else { // DIR_NONE or initial state
    // Check internal requests at current floor first
    if (internalRequests[currentFloor] || externalUpRequests[currentFloor] || externalDownRequests[currentFloor])
      return currentFloor;
    
    // Check upwards first from current floor
    for (int i = currentFloor + 1; i <= 3; i++)
      if (internalRequests[i] || externalUpRequests[i] || externalDownRequests[i]) {
        currentDirection = DIR_UP;
        return i;
      }
    
    // Then check downwards from current floor
    for (int i = currentFloor - 1; i >= 1; i--)
      if (internalRequests[i] || externalUpRequests[i] || externalDownRequests[i]) {
        currentDirection = DIR_DOWN;
        return i;
      }
  }
  return 0; // No pending requests
}

// --- Setup Function ---
void setup() {
  Serial.begin(115200);

  // Motor pins setup
  pinMode(HIGH_SIDE1, OUTPUT);
  pinMode(LOW_SIDE1, OUTPUT);
  pinMode(HIGH_SIDE2, OUTPUT);
  pinMode(LOW_SIDE2, OUTPUT);
  Stop(); // Ensure motor is stopped on startup

  // Sensor pins setup - assuming they are active HIGH when cart is at floor
  pinMode(sensor_1A, INPUT);
  pinMode(sensor_1B, INPUT);
  pinMode(sensor_2A, INPUT);
  pinMode(sensor_2B, INPUT);
  pinMode(sensor_3A, INPUT);
  pinMode(sensor_3B, INPUT);

  // Button pins setup - using INPUT_PULLUP for simpler wiring (buttons connect to GND)
  // If you use external pull-down resistors and buttons connect to HIGH, use INPUT.
  pinMode(inbutton1, INPUT_PULLUP);
  pinMode(inbutton2, INPUT_PULLUP);
  pinMode(inbutton3, INPUT_PULLUP);
  pinMode(outbutton1, INPUT_PULLUP);
  pinMode(outbutton2down, INPUT_PULLUP);
  pinMode(outbutton2up, INPUT_PULLUP);
  pinMode(outbutton3, INPUT_PULLUP);

  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
  digitalWrite(LED1, LOW);
  digitalWrite(LED2, LOW);
  digitalWrite(LED3, LOW);

  // Initialize debounce states for buttons
  for (int i = 0; i < NUM_BUTTONS; i++) {
    lastButtonPressTime[i] = 0;
    lastButtonState[i] = 0; // Read initial state
  }

  // Determine initial current floor (at startup)
  currentFloor = readCurrentFloorSensors();
  elevatorState = state_idle; // Start in IDLE state
}

void loop() {
  // 1. Read and debounce all button inputs and register calls
  unsigned long currentTime = millis();

  if (readDebouncedButton(inbutton1, 0)) internalRequests[1] = true;
  if (readDebouncedButton(inbutton2, 1)) internalRequests[2] = true;
  if (readDebouncedButton(inbutton3, 2)) internalRequests[3] = true;

  if (readDebouncedButton(outbutton1, 3)) externalUpRequests[1] = true;
  if (readDebouncedButton(outbutton2down, 4)) externalDownRequests[2] = true;
  if (readDebouncedButton(outbutton2up, 5)) externalUpRequests[2] = true;
  if (readDebouncedButton(outbutton3, 6)) externalDownRequests[3] = true;

  // 2. Main Elevator State Machine Logic
  currentFloor = readCurrentFloorSensors();
  switch (elevatorState) {
    case state_idle:
      Stop();
      destinationFloor = findNextDestination(); // check for any new requests

      if (externalUpRequests[1] || externalDownRequests[1]) digitalWrite(LED1, HIGH); //turn on the out LEDs according to the right out button
      else digitalWrite(LED1, LOW);
      if (externalUpRequests[2] || externalDownRequests[2]) digitalWrite(LED2, HIGH);
      else digitalWrite(LED2, LOW);
      if (externalUpRequests[3] || externalDownRequests[3]) digitalWrite(LED3, HIGH);
      else digitalWrite(LED3, LOW);

      if (destinationFloor != 0) {
        if (destinationFloor > currentFloor) //set the next state of the elevator control logic
          elevatorState = state_moving_up; 
        else if (destinationFloor < currentFloor)
          elevatorState = state_moving_down;
        else { // already at destinationFloor (could be an immediate internal call)
          // clear requests for the current floor
          internalRequests[currentFloor] = false;
          externalUpRequests[currentFloor] = false;
          externalDownRequests[currentFloor] = false;
          // set stop timer to simulate door open/close
          stopTimer = currentTime;
          elevatorState = state_stopping_at_floor; // briefly transition to stopping state
        }
      }
      break;

    case state_moving_up:
      if (firstTime){
        motorActualSpeed = motorInitialSpeed;
        firstTime = false;
      }
      else if (motorActualSpeed > motorSpeedFast) motorActualSpeed--;
      else if (motorActualSpeed < motorSpeedFast) motorActualSpeed++;
      Up(motorActualSpeed); // Keep moving fast
      
      // Check sensors for slowing down/stopping
      if (destinationFloor == 2) {
        if (digitalRead(sensor_2A) == HIGH && digitalRead(sensor_2B) == LOW){ // Nearing Floor 2
          if (motorActualSpeed > motorSpeedSlow) motorActualSpeed--;
          else if (motorActualSpeed < motorSpeedSlow) motorActualSpeed++;
          Up(motorActualSpeed); // Slow down
        }
        else if (digitalRead(sensor_2A) == HIGH && digitalRead(sensor_2B) == HIGH) { // At Floor 2
          currentFloor = 2;
          Stop();
          firstTime = true;
          stopTimer = currentTime; // Start stop timer
          elevatorState = state_stopping_at_floor;
        }
      } else if (destinationFloor == 3) {
        if (digitalRead(sensor_3A) == HIGH && digitalRead(sensor_3B) == LOW){ // Nearing Floor 3
          if (motorActualSpeed > motorSpeedSlow) motorActualSpeed--;
          else if (motorActualSpeed < motorSpeedSlow) motorActualSpeed++;
          Up(motorSpeedSlow); // Slow down
        }
        else if (digitalRead(sensor_3A) == HIGH && digitalRead(sensor_3B) == HIGH) { // At Floor 3
          currentFloor = 3;
          Stop();
          firstTime = true;
          stopTimer = currentTime; // Start stop timer
          elevatorState = state_stopping_at_floor;
        }
      }
      break;

    case state_moving_down:
      if (firstTime){
        motorActualSpeed = motorInitialSpeed;
        firstTime = false;
      }
      else if (motorActualSpeed > motorSpeedFast) motorActualSpeed--;
      else if (motorActualSpeed < motorSpeedFast) motorActualSpeed++;
      Down(motorActualSpeed); // Keep moving fast

      // Check sensors for slowing down/stopping
      if (destinationFloor == 2) {
        if (digitalRead(sensor_2B) == HIGH && digitalRead(sensor_2A) == LOW){ // Nearing Floor 2
          if (motorActualSpeed > motorSpeedSlow) motorActualSpeed--;
          else if (motorActualSpeed < motorSpeedSlow) motorActualSpeed++;
          Down(motorActualSpeed); // Slow down
        }
        else if (digitalRead(sensor_2B) == HIGH && digitalRead(sensor_2A) == HIGH) { // At Floor 2
          currentFloor = 2;
          Stop();
          firstTime = true;
          stopTimer = currentTime; // Start stop timer
          elevatorState = state_stopping_at_floor;
        }
      } else if (destinationFloor == 1) {
        if (digitalRead(sensor_1B) == HIGH && digitalRead(sensor_1A) == LOW){ // Nearing Floor 1
          if (motorActualSpeed > motorSpeedSlow) motorActualSpeed--;
          else if (motorActualSpeed < motorSpeedSlow) motorActualSpeed++;
          Down(motorSpeedSlow); // Slow down
        }
        else if (digitalRead(sensor_1B) == HIGH && digitalRead(sensor_1A) == HIGH) { // At Floor 1
          currentFloor = 1;
          Stop();
          firstTime = true;
          stopTimer = currentTime; // Start stop timer
          elevatorState = state_stopping_at_floor;
        }
      }
      break;

    case state_stopping_at_floor:
      Stop(); // Ensure motor is off

      // Clear the requests for the floor we just arrived at
      if (currentFloor == destinationFloor) {
        internalRequests[currentFloor] = false;
        externalUpRequests[currentFloor] = false;
        externalDownRequests[currentFloor] = false;
        destinationFloor = 0; // Clear immediate target
      }

      if (!externalUpRequests[1] && !externalDownRequests[1]) digitalWrite(LED1, LOW);
      if (!externalUpRequests[2] && !externalDownRequests[2]) digitalWrite(LED2, LOW);
      if (!externalUpRequests[3] && !externalDownRequests[3]) digitalWrite(LED3, LOW);

      // After stopping, wait for a duration (e.g., doors open/close)
      if (currentTime - stopTimer >= stopDuration)
        elevatorState = state_idle; // Go back to idle to find next request
      break;
  }
}
