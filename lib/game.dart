import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Counter {
  int value = 0;
  bool isRunning = false;
  late Timer _timer;
  final Function onTick;

  Counter({required this.onTick});

  Future<void> start() async {
    if (!isRunning) {
      isRunning = true;
      await loadCounter();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        value++;
        onTick(value);
        saveCounter();
      });
    }
  }

  void stop() {
    if (isRunning) {
      isRunning = false;
      _timer.cancel();
    }
  }

  void reset() {
    value = 0;
    onTick(value);
  }

  Future<void> saveCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('counterValue', value);
  }

  Future<void> loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    value = prefs.getInt('counterValue') ?? 0;
    onTick(value);
  }
}
