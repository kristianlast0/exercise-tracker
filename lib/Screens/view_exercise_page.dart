import 'package:exercisetracker/db_helper.dart';
import 'package:flutter/material.dart';

class ViewExercisePage extends StatefulWidget {
  final Map<String, dynamic> exerciseData;

  ViewExercisePage({required this.exerciseData});

  @override
  ViewExercisePageState createState() => ViewExercisePageState();
}

class ViewExercisePageState extends State<ViewExercisePage> {
  final _dbHelper = DBHelper();
  Map<String, dynamic>? _previousExerciseData;

  @override
  void initState() {
    super.initState();
    _fetchPreviousExercise();
  }

  Future<void> _fetchPreviousExercise() async {
    Map<String, dynamic>? previousExerciseData = await _dbHelper.fetchLastExerciseByName(widget.exerciseData['exercise'], widget.exerciseData['id']);
    setState(() {
      _previousExerciseData = previousExerciseData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exercise: ${widget.exerciseData['exercise']}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              'Weight: ${widget.exerciseData['weight']} kg',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              'Target Reps: ${widget.exerciseData['target_reps']}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              'BPM: ${widget.exerciseData['bpm']}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              'Duration: ${widget.exerciseData['duration']} seconds',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              'Actual Reps: ${widget.exerciseData['actual_reps']}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Stats:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Reps per minute: ${widget.exerciseData['actual_reps'] / (widget.exerciseData['duration'] / 60)}',
              style: TextStyle(fontSize: 18),
            ),
            if (_previousExerciseData != null) ...[
              SizedBox(height: 16),
              Text(
                'Previous set:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Previous duration: ${_previousExerciseData!['duration']} seconds',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Previous actual reps: ${_previousExerciseData!['actual_reps']}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}