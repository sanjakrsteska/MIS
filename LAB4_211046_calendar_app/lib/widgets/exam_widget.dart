import 'package:flutter/material.dart';
import '../models/exam_model.dart';

class ExamWidget extends StatefulWidget {
  final Function(Exam) addExam;
  final DateTime selectedDate;

  const ExamWidget({super.key, required this.addExam, required this.selectedDate});

  @override
  _ExamWidgetState createState() => _ExamWidgetState();
}

class _ExamWidgetState extends State<ExamWidget> {
  late TextEditingController courseController;
  late TextEditingController locationController;
  late TextEditingController hoursController;
  late TextEditingController minutesController;
  late TextEditingController longitudeController;
  late TextEditingController latitudeController;

  @override
  void initState() {
    super.initState();
    courseController = TextEditingController();
    locationController = TextEditingController();
    hoursController = TextEditingController();
    minutesController = TextEditingController();
    longitudeController = TextEditingController();
    latitudeController = TextEditingController();
  }

  @override
  void dispose() {
    courseController.dispose();
    locationController.dispose();
    hoursController.dispose();
    minutesController.dispose();
    longitudeController.dispose();
    latitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: courseController,
            decoration: const InputDecoration(labelText: 'Course'),
          ),
          TextField(
            controller: locationController,
            decoration: const InputDecoration(labelText: 'Location'),
          ),
          TextField(
            controller: longitudeController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Longitude'),
          ),
          TextField(
            controller: latitudeController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Latitude'),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: hoursController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Hours (0-23)'),
                  maxLength: 2,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: minutesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Minutes (0-59)'),
                  maxLength: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final int? hours = int.tryParse(hoursController.text);
              final int? minutes = int.tryParse(minutesController.text);
              final String location = locationController.text;
              final String course = courseController.text;

              if(course.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a course name')),
                );
                return;
              }
              if(location.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a location')),
                );
                return;
              }
              if (hours == null || minutes == null || hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter valid hours and minutes.')),
                );
                return;
              }

              final double? longitude = double.tryParse(longitudeController.text);
              final double? latitude = double.tryParse(latitudeController.text);

              if (longitude == null || latitude == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter valid longitude and latitude values.')),
                );
                return;
              }

              final exam = Exam(
                course: courseController.text,
                timestamp: DateTime(
                  widget.selectedDate.year,
                  widget.selectedDate.month,
                  widget.selectedDate.day,
                  hours,
                  minutes,
                ),
                location: locationController.text,
                longitude: longitude,
                latitude: latitude,
              );

              widget.addExam(exam);
              Navigator.pop(context);
            },
            child: const Text('Add Exam'),
          ),
        ],
      ),
    );
  }
}
