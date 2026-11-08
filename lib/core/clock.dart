// Current time, injectable so date rules and timers can be tested.
typedef Clock = DateTime Function();

DateTime systemClock() => DateTime.now();
