import 'package:exercisetracker/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class TimerPage extends StatefulWidget {

  final String selectedExercise;
  final double weight;
  final int targetReps;
  final int bpm;

  const TimerPage({
    required this.selectedExercise,
    required this.weight,
    required this.targetReps,
    required this.bpm,
  });

  @override
  TimerPageState createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {

  late final AudioPlayer audioPlayer;
  final _dbHelper = DBHelper();

  int clickCount = 0;
  Timer? metronomeTimer;
  DateTime? startTime;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    startMetronome();
  }

  @override
  void dispose() {
    stopMetronome();
    audioPlayer.dispose();
    super.dispose();
  }

  void startMetronome() {
    startTime = DateTime.now();
    metronomeTimer = Timer.periodic(
      Duration(milliseconds: (60000 / widget.bpm).round()),
      (timer) async {
        clickCount = (clickCount + 1) % 4;
        String soundPath = (clickCount % 4 == 0) ? 'sounds/beep1.mp3' : 'sounds/beep3.mp3';
        await audioPlayer.play(AssetSource(soundPath));
      },
    );
  }

  void stopMetronome() {
    metronomeTimer?.cancel();
  }

  Future<void> _saveExerciseData(int duration, int actualReps) async {
    Map<String, dynamic> data = {
      'exercise': widget.selectedExercise,
      'weight': widget.weight,
      'target_reps': widget.targetReps,
      'bpm': widget.bpm,
      'duration': duration,
      'actual_reps': actualReps,
    };
    await _dbHelper.insertData(data);
  }

  Future<void> showActualRepsForm(int duration) async {
    int? actualReps = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int actualReps = 0;
        return AlertDialog(
          title: const Text('Enter Actual Reps'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              actualReps = int.parse(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(actualReps);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    if (actualReps != null) {
      await _saveExerciseData(duration, actualReps);
      Navigator.pop(context); // Close timer page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer & Metronome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Exercise: ${widget.selectedExercise}',
              style: const TextStyle(fontSize: 24),
            ),
            if (widget.weight > 0)
              Text(
                'Weight: ${widget.weight} kg',
                style: const TextStyle(fontSize: 24),
              ),
            Text(
              'Target Reps: ${widget.targetReps}',
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              'BPM: ${widget.bpm}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                stopMetronome();
                int duration = DateTime.now().difference(startTime!).inSeconds;
                await showActualRepsForm(duration);
              },
              child: const Text('Finish Set'),
            ),
          ],
        ),
      ),
    );
  }
}
