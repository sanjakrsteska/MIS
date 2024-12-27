import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../models/exam_model.dart';
import '../services/location_reminder_service.dart';
import '../utils/exam_utils.dart';
import '../widgets/exam_widget.dart';
import 'exam_list_map_screen.dart';
import 'map_screen.dart';

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

class MainListScreen extends StatefulWidget {
  const MainListScreen({super.key});

  @override
  MainListScreenState createState() => MainListScreenState();
}

class MainListScreenState extends State<MainListScreen> {
  late final List<Exam> exams;

  @override
  void initState() {
    super.initState();
    exams = generateExamList();
    for (var exam in exams) {
      scheduleLocationBasedReminder(exam);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exams'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExamListMapScreen(exams: exams),
                ),
              );
            },
          ),
        ],
      ),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: _getCalendarDataSource(),
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.calendarCell) {
            _handleDateTap(context, details.date!);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addExamFunction(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  _DataSource _getCalendarDataSource() {
    List<Appointment> appointments = [];

    for (var exam in exams) {
      appointments.add(Appointment(
        startTime: exam.timestamp,
        endTime: exam.timestamp.add(const Duration(hours: 2)),
        subject: exam.course,
      ));
    }

    return _DataSource(appointments);
  }
  void _handleDateTap(BuildContext context, DateTime selectedDate) {
    List<Exam> selectedExams = exams
        .where((exam) =>
    exam.timestamp.year == selectedDate.year &&
        exam.timestamp.month == selectedDate.month &&
        exam.timestamp.day == selectedDate.day)
        .toList();

    if (selectedExams.isNotEmpty) {
      _showExamsDialog(context, selectedDate, selectedExams);
    } else {
      _addExamFunction(context, selectedDate);
    }
  }

  void _addExam(Exam exam) {
    setState(() {
      exams.add(exam);
      scheduleLocationBasedReminder(exam);

    });
  }

  Future<void> _addExamFunction(BuildContext context, [DateTime? selectedDate]) async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ExamWidget(
          addExam: _addExam,
          selectedDate: selectedDate ?? DateTime.now(),
        );
      },
    );
  }

  void _showExamsDialog(
      BuildContext context, DateTime selectedDate, List<Exam> exams) {
    String formattedDate =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exams on $formattedDate'),
          content: Column(
            children: exams
                .map((exam) => ListTile(
              title: Text(
                  '${exam.course} - ${exam.timestamp.hour.toString().padLeft(2, '0')}:${exam.timestamp.minute.toString().padLeft(2, '0')}'),
              subtitle: Text('Location: ${exam.location}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(exam: exam),
                  ),
                );
              },
            ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }



}