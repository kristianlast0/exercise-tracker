import 'package:exercisetracker/Screens/exercise_form_page.dart';
import 'package:exercisetracker/Screens/view_exercise_page.dart';
import 'package:exercisetracker/db_helper.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> exercises;
  final dbHelper = DBHelper();

  Future<void> truncateExercises() async {
    await dbHelper.truncateExercises();
    setState(() {}); // Refresh the page
  }

  @override
  void initState() {
    super.initState();
    exercises = dbHelper.fetchAllExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: exercises,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> exerciseData = snapshot.data![index];
                return ListTile(
                  title: Text(exerciseData['exercise']),
                  subtitle: Text('Weight: ${exerciseData['weight']} kg - Target: ${exerciseData['target_reps']} - Actual: ${exerciseData['actual_reps']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewExercisePage(exerciseData: exerciseData),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading exercises.'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ExerciseFormPage())).then((value) => setState(() {}));
            },
            heroTag: 'addButton', // Add this line
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16), // Spacing between buttons
          FloatingActionButton(
            onPressed: truncateExercises,
            backgroundColor: Colors.red, // Different color to distinguish the button
            heroTag: 'deleteButton', // Add this line
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}