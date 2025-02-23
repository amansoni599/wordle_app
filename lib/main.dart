import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wordle_app/game.dart';
import 'dart:async';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  late Counter _counter;
  bool isPause = false;

  @override
  void initState() {
    super.initState();
    _counter = Counter(onTick: _onTick);
    _loadCounter();
    _pauseCounter();
    _registerAppLifecycleObserver();
  }

  void _onTick(int value) {
    setState(() {
      // Update the UI when the counter value changes
    });
  }

  Future<void> _loadCounter() async {
    await _counter.loadCounter();
    setState(() {});
  }

  void _startCounter() {
    isPause = false;
    _counter.start();
    setState(() {});
  }

  void _pauseCounter() {
    isPause = true;

    _counter.stop();
    setState(() {});
  }

  void _resetCounter() {
    isPause = false;
    _counter.reset();
    setState(() {});
  }

  Future<void> _shareScore() async {
    String message = "I have counted to ${_counter.value}!";
    await Share.share(message);
  }

  // Listen for app lifecycle events to stop the counter when app goes to the background
  void _registerAppLifecycleObserver() {
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () async {
          _startCounter();
        },
        suspendingCallBack: () async {
          _pauseCounter();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Counter Value: ${_counter.value}',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isPause)
                  ElevatedButton(
                    onPressed: _startCounter,
                    child: const Text('Start'),
                  ),
                // if (isPause) const SizedBox(width: 10),
                if (isPause == false)
                  ElevatedButton(
                    onPressed: _pauseCounter,
                    child: const Text('Pause'),
                  ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetCounter,
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _shareScore,
              child: const Text("Share Score"),
            ),
          ],
        ),
      ),
    );
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;

  LifecycleEventHandler({
    required this.resumeCallBack,
    required this.suspendingCallBack,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      resumeCallBack();
    } else if (state == AppLifecycleState.paused) {
      suspendingCallBack();
    }
  }
}
