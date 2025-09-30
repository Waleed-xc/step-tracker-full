
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:pedometer/pedometer.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   late Stream<StepCount> _stepCountStream;
//   int _stepsThisPeriod = 0; // steps since last reset
//   int _baseline = 0;        // step count at the start of the period
//   int _lastReset = DateTime.now().millisecondsSinceEpoch;
//   int _latestTotalSteps = 0; // always keep track of latest sensor reading
//   Timer? _sendTimer;
//   Timer? _checkResetTimer;
//
//   // static const int PERIOD_MS = 12 * 60 * 60 * 1000; // 12 hours
//   static const int PERIOD_MS = 1 * 60 * 1000; // 1 minute (for testing)
//
//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//     loadSavedState();
//     startAutoSendTimer();
//     startResetCheckTimer();
//   }
//
//   Future<void> loadSavedState() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _baseline = prefs.getInt('baseline') ?? 0;
//       _lastReset = prefs.getInt('lastReset') ?? DateTime.now().millisecondsSinceEpoch;
//     });
//   }
//
//   void saveState() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('baseline', _baseline);
//     await prefs.setInt('lastReset', _lastReset);
//   }
//
//   void onStepCount(StepCount event) {
//     final totalSteps = event.steps;
//     _latestTotalSteps = totalSteps;
//
//     if (_baseline == 0) {
//       _baseline = totalSteps;
//       _lastReset = DateTime.now().millisecondsSinceEpoch;
//       saveState();
//     }
//
//     setState(() {
//       _stepsThisPeriod = totalSteps - _baseline;
//     });
//   }
//
//   void onStepCountError(error) {
//     setState(() {
//       _stepsThisPeriod = 0;
//     });
//   }
//
//   Future<bool> _checkActivityRecognitionPermission() async {
//     bool granted = await Permission.activityRecognition.isGranted;
//     if (!granted) {
//       granted = await Permission.activityRecognition.request() ==
//           PermissionStatus.granted;
//     }
//     return granted;
//   }
//
//   Future<void> initPlatformState() async {
//     bool granted = await _checkActivityRecognitionPermission();
//     if (!granted) {
//       return;
//     }
//
//     _stepCountStream = Pedometer.stepCountStream;
//     _stepCountStream.listen(onStepCount).onError(onStepCountError);
//
//     if (!mounted) return;
//   }
//
//   void startAutoSendTimer() {
//     _sendTimer = Timer.periodic(Duration(minutes: 2), (timer) {
//       sendStepsToBackend(); // auto send, but do not reset
//     });
//   }
//
//   void startResetCheckTimer() {
//     _checkResetTimer = Timer.periodic(Duration(minutes: 1), (timer) {
//       checkAndResetPeriod();
//     });
//   }
//
//   void checkAndResetPeriod() async {
//     final now = DateTime.now().millisecondsSinceEpoch;
//     if (now - _lastReset >= PERIOD_MS) {
//       // Send steps for the past period
//       await sendStepsToBackend(force: true);
//     }
//   }
//
//   Future<void> sendStepsToBackend({bool force = false}) async {
//     if (_stepsThisPeriod == 0 && !force) return;
//
//     final url = Uri.parse('https://step-tracker-backend-1.onrender.com/steps');
//     final body = json.encode({
//       'date': DateTime.now().toIso8601String(),
//       'steps': _stepsThisPeriod,
//     });
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: body,
//       );
//
//       if (response.statusCode == 201 || response.statusCode == 200) {
//         print('Steps sent successfully! $_stepsThisPeriod steps');
//
//         // ✅ Only reset if this is a forced (period-end) send
//         if (force) {
//           setState(() {
//             _baseline = _latestTotalSteps;
//             _stepsThisPeriod = 0;
//             _lastReset = DateTime.now().millisecondsSinceEpoch;
//           });
//           saveState();
//         }
//       } else {
//         print('Failed to send steps.');
//       }
//     } catch (e) {
//       print('Error sending steps: $e');
//     }
//   }
//
//   @override
//   void dispose() {
//     _sendTimer?.cancel();
//     _checkResetTimer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Step Counter'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text('Steps This Period', style: TextStyle(fontSize: 24)),
//               Text('$_stepsThisPeriod', style: TextStyle(fontSize: 50)),
//               SizedBox(height: 20),
//               Text('Last Reset: ${DateTime.fromMillisecondsSinceEpoch(_lastReset)}'),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   sendStepsToBackend(); // normal send, does not reset
//                 },
//                 child: Text("Send Steps Now"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:pedometer/pedometer.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:pedometer/pedometer.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   runApp(StepCounterApp());
// }
//
// class StepCounterApp extends StatefulWidget {
//   @override
//   _StepCounterAppState createState() => _StepCounterAppState();
// }
//
// class _StepCounterAppState extends State<StepCounterApp> {
//   late Stream<StepCount> _stepCountStream;
//   int _latestTotalSteps = 0; // raw steps from sensor
//   int _baseline = 0; // steps at start of period
//   int _stepsThisPeriod = 0; // steps during current period
//
//   int _lastReset = DateTime.now().millisecondsSinceEpoch;
//   List<int> _resetHistory = []; // ✅ list of all reset timestamps
//
//   // testing: 1 minute period (change back to 12 * 60 * 60 * 1000 for production)
//   static const int PERIOD_MS = 1 * 60 * 1000;
//
//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//     loadState();
//
//     // check if period ended every minute
//     Timer.periodic(Duration(minutes: 1), (_) {
//       checkAndResetPeriod();
//     });
//
//     // auto send every 2 minutes (but don’t reset unless forced)
//     Timer.periodic(Duration(minutes: 2), (_) {
//       sendStepsToBackend(force: false);
//     });
//   }
//
//   // initialize pedometer
//   void initPlatformState() {
//     _stepCountStream = Pedometer.stepCountStream;
//     _stepCountStream.listen(onStepCount).onError((error) {
//       print("Pedometer error: $error");
//     });
//   }
//
//   // step event received
//   void onStepCount(StepCount event) {
//     setState(() {
//       _latestTotalSteps = event.steps;
//       _stepsThisPeriod = _latestTotalSteps - _baseline;
//     });
//   }
//
//   // check if a full period passed
//   void checkAndResetPeriod() {
//     final now = DateTime.now().millisecondsSinceEpoch;
//     if (now - _lastReset >= PERIOD_MS) {
//       // send & reset only at period end
//       sendStepsToBackend(force: true);
//     }
//   }
//
//   // send steps to backend
//   Future<void> sendStepsToBackend({bool force = false}) async {
//     if (_stepsThisPeriod == 0 && !force) return;
//
//     final url = Uri.parse('https://step-tracker-backend-1.onrender.com/steps');
//     final body = json.encode({
//       'date': DateTime.now().toIso8601String(),
//       'steps': _stepsThisPeriod,
//     });
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: body,
//       );
//
//       if (response.statusCode == 201 || response.statusCode == 200) {
//         print('Steps sent successfully: $_stepsThisPeriod steps');
//
//         // ✅ reset only when forced (end of period)
//         if (force) {
//           setState(() {
//             _baseline = _latestTotalSteps;
//             _stepsThisPeriod = 0;
//             _lastReset = DateTime.now().millisecondsSinceEpoch;
//
//             // ✅ add to history
//             _resetHistory.add(_lastReset);
//           });
//           saveState();
//         }
//       } else {
//         print('Failed to send steps. Status: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error sending steps: $e');
//     }
//   }
//
//   // save state
//   Future<void> saveState() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setInt('baseline', _baseline);
//     prefs.setInt('stepsThisPeriod', _stepsThisPeriod);
//     prefs.setInt('lastReset', _lastReset);
//
//     // ✅ save reset history as List<String>
//     List<String> stringList =
//     _resetHistory.map((e) => e.toString()).toList();
//     prefs.setStringList('resetHistory', stringList);
//   }
//
//   // load state
//   Future<void> loadState() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _baseline = prefs.getInt('baseline') ?? 0;
//       _stepsThisPeriod = prefs.getInt('stepsThisPeriod') ?? 0;
//       _lastReset =
//           prefs.getInt('lastReset') ?? DateTime.now().millisecondsSinceEpoch;
//
//       // ✅ load reset history
//       List<String>? savedList = prefs.getStringList('resetHistory');
//       _resetHistory =
//           savedList?.map((e) => int.tryParse(e) ?? 0).toList() ?? [];
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Step Counter")),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("Steps this period: $_stepsThisPeriod",
//                   style: TextStyle(fontSize: 30)),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => sendStepsToBackend(force: false),
//                 child: Text("Send Steps Manually"),
//               ),
//               SizedBox(height: 30),
//               Text("Reset History:", style: TextStyle(fontSize: 20)),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _resetHistory.length,
//                   itemBuilder: (context, index) {
//                     final ts = _resetHistory[index];
//                     return ListTile(
//                       title: Text(
//                         DateTime.fromMillisecondsSinceEpoch(ts).toString(),
//                       ),
//                     );
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(StepCounterApp());
}

class StepCounterApp extends StatefulWidget {
  @override
  _StepCounterAppState createState() => _StepCounterAppState();
}

class _StepCounterAppState extends State<StepCounterApp> {
  late Stream<StepCount> _stepCountStream;
  int _latestTotalSteps = 0; // raw steps from sensor
  int _baseline = 0; // steps at start of period
  int _stepsThisPeriod = 0; // steps during current period

  int _lastReset = DateTime.now().millisecondsSinceEpoch;
  List<int> _resetHistory = []; // list of all reset timestamps

  // ✅ hourly reset (1 hour = 60 * 60 * 1000 ms)
  static const int PERIOD_MS = 6 * 60 * 1000;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    loadState();

    // check every minute if an hour passed
    Timer.periodic(Duration(seconds: 10), (_) {
      checkAndResetPeriod();
    });
  }

  // initialize pedometer
  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError((error) {
      print("Pedometer error: $error");
    });
  }

  // step event received
  void onStepCount(StepCount event) {
    setState(() {
      _latestTotalSteps = event.steps;
      _stepsThisPeriod = _latestTotalSteps - _baseline;
    });
  }

  // check if a full hour passed
  void checkAndResetPeriod() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastReset >= PERIOD_MS) {
      sendStepsToBackend(force: true);
    }
  }

  // send steps to backend
  Future<void> sendStepsToBackend({bool force = false}) async {
    if (_stepsThisPeriod == 0 && !force) return;

    final url = Uri.parse('https://step-tracker-backend-1.onrender.com/steps');
    final body = json.encode({
      'date': DateTime.now().toIso8601String(),
      'steps': _stepsThisPeriod,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Steps sent successfully: $_stepsThisPeriod steps');

        if (force) {
          setState(() {
            _baseline = _latestTotalSteps;
            _stepsThisPeriod = 0;
            _lastReset = DateTime.now().millisecondsSinceEpoch;
            _resetHistory.add(_lastReset); // log reset
          });
          saveState();
        }
      } else {
        print('Failed to send steps. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending steps: $e');
    }
  }

  // save state
  Future<void> saveState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('baseline', _baseline);
    prefs.setInt('stepsThisPeriod', _stepsThisPeriod);
    prefs.setInt('lastReset', _lastReset);
    prefs.setStringList(
      'resetHistory',
      _resetHistory.map((e) => e.toString()).toList(),
    );
  }

  // load state
  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _baseline = prefs.getInt('baseline') ?? 0;
      _stepsThisPeriod = prefs.getInt('stepsThisPeriod') ?? 0;
      _lastReset =
          prefs.getInt('lastReset') ?? DateTime.now().millisecondsSinceEpoch;
      _resetHistory = prefs
          .getStringList('resetHistory')
          ?.map((e) => int.tryParse(e) ?? 0)
          .toList() ??
          [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Step Counter")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Steps taken this 6 Minutes: $_stepsThisPeriod",
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 30),
            Text("Reset History:", style: TextStyle(fontSize: 15)),
            Expanded(
              child: ListView.builder(
                itemCount: _resetHistory.length,
                itemBuilder: (context, index) {
                  final ts = _resetHistory[index];
                  return ListTile(
                    title: Text(
                      DateTime.fromMillisecondsSinceEpoch(ts).toString(),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
