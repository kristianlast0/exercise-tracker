import 'package:exercisetracker/Screens/timer_page.dart';
import 'package:flutter/material.dart';

class ExerciseFormPage extends StatefulWidget {
  const ExerciseFormPage({super.key});
  @override
  ExerciseFormPageState createState() => ExerciseFormPageState();
}

class ExerciseFormPageState extends State<ExerciseFormPage> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String selectedCategory = '';
  String selectedExercise = '';
  double weight = 0;
  int targetReps = 0;
  int bpm = 0;

  List<String> exerciseCategories = [
  'Cardio',
  'Strength',
  'Flexibility',
  'Balance',
  'Plyometrics',
  'Calisthenics',
  'Functional',
];

  Map<String, List<String>> categoriesAndExercises = {
    'Cardio': [
      'Running',
      'Cycling',
      'Jumping Jacks',
      'Jump Rope',
      'Swimming',
      'Stair Climbing',
      'Rowing',
      'Elliptical',
      'Burpees',
      'Box Jumps',
    ],
    'Strength': [
      'Squats',
      'Lunges',
      'Deadlifts',
      'Bench Press',
      'Shoulder Press',
      'Bicep Curls',
      'Tricep Dips',
      'Leg Press',
      'Calf Raises',
      'Push-ups',
      'Pull-ups',
      'Chin-ups',
      'Leg Curls',
      'Leg Extensions',
      'Lat Pull-downs',
      'Barbell Rows',
      'T-bar Rows',
      'Pendlay Rows',
      'Seated Rows',
      'Incline Bench Press',
      'Decline Bench Press',
      'Dumbbell Flyes',
      'Chest Flyes',
      'Hammer Curls',
      'Concentration Curls',
      'Skull Crushers',
      'Close-Grip Bench Press',
      'Tricep Pushdowns',
      'Military Press',
      'Upright Rows',
      'Shrugs',
      'Front Raises',
      'Lateral Raises',
      'Rear Delt Raises',
      'Farmer\'s Walk',
      'Plank',
      'Side Plank Left',
      'Side Plank Right',
      'Russian Twist',
      'Hanging Leg Raise',
      'Leg Raise',
      'Crunches',
      'Sit-ups',
      'Reverse Crunches',
      'V-ups',
      'Bicycle Crunches',
    ],
    'Flexibility': [
      'Forward Bend',
      'Downward Dog',
      'Cobra Pose',
      'Pigeon Pose',
      'Child\'s Pose',
      'Seated Forward Bend',
      'Butterfly Stretch',
      'Cat-Cow Stretch',
      'Happy Baby Pose',
      'Triangle Pose',
      'Half Lord of the Fishes Pose',
      'Gate Pose',
      'Seated Twist',
      'Quad Stretch',
      'Hamstring Stretch',
      'Calf Stretch',
      'Triceps Stretch',
      'Shoulder Stretch',
      'Wrist Stretch',
    ],
    'Balance': [
      'Single Leg Stance',
      'Heel-to-Toe Walk',
      'Tree Pose',
      'Warrior III',
      'Half Moon Pose',
      'Extended Hand-to-Big-Toe Pose',
      'Dancer\'s Pose',
      'Crow Pose',
      'Side Plank',
      'Eagle Pose',
      'King Pigeon Pose',
    ],
    'Plyometrics': [
      'Box Jumps',
      'Lateral Jumps',
      'Tuck Jumps',
      'Plyo Push-ups',
      'Power Skips',
      'Jumping Lunges',
      'Depth Jumps',
      'Bounding',
      'Single Leg Hops',
    ],
    'Calisthenics': [
      'Push-ups',
      'Pull-ups',
      'Chin-ups',
      'Dips',
      'Handstands',
      'Muscle-ups',
      'Pistol Squats',
      'L-sits',
      'Front Lever',
      'Back Lever',
      'Planche',
      'Human Flag',
      'One-arm Push-ups',
      'One-arm Pull-ups',
      'Dragon Flags',
      'Hollow Body Hold',
      'Inverted Rows',
      'Hanging Leg Raises',
      'Bodyweight Squats',
      'Glute Bridges',
      'Calf Raises',
    ],
    'Functional': [
      'Kettlebell Swing',
      'Turkish Get-up',
      'Goblet Squat',
      'Medicine Ball Slam',
      'Tire Flip',
      'Battle Ropes',
      'Box Jumps',
      'Wall Balls',
      'Farmer\'s Walk',
      'Walking Lunges',
      'Step-ups',
      'Bear Crawl',
      'Push Sled',
      'Plank Drag',
      'Burpees',
      'Dead Bug',
      'Bird Dog',
      'Bulgarian Split Squat',
      'TRX Row',
      'TRX Push-up',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: selectedCategory.isEmpty ? null : selectedCategory,
                decoration: const InputDecoration(labelText: 'Select Category'),
                items: categoriesAndExercises.keys.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                    selectedExercise = '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedExercise.isEmpty ? null : selectedExercise,
                decoration: const InputDecoration(labelText: 'Select Exercise'),
                items: selectedCategory == "" ? [] : categoriesAndExercises[selectedCategory]!.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: selectedCategory.isEmpty
                    ? null
                    : (String? newValue) {
                        setState(() {
                          selectedExercise = newValue!;
                        });
                      },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an exercise';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Weight (optional)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) =>
                    weight = value!.isEmpty ? 0 : double.parse(value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Target Reps'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter target reps';
                  }
                  return null;
                },
                onSaved: (value) => targetReps = int.parse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'BPM'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter BPM';
                  }
                  return null;
                },
                onSaved: (value) => bpm = int.parse(value!),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimerPage(
                          selectedExercise: selectedExercise,
                          weight: weight,
                          targetReps: targetReps,
                          bpm: bpm,
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Create Set'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
