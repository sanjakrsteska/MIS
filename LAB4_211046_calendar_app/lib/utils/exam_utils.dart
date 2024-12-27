import '../models/exam_model.dart';

List<Exam> generateExamList() {
  return [
    Exam(
      course: 'MIS',
      timestamp: DateTime.now(),
      location: 'Prostorija 1',
      latitude: 42.004099,
      longitude: 21.409744,
    ),
    Exam(
      course: 'EMT',
      timestamp: DateTime.now().add(Duration(days: 3)),
      location: 'Prostorija 2',
      latitude: 42.0042,
      longitude: 21.3917,
    ),
    Exam(
      course: 'VEB',
      timestamp: DateTime.now().add(Duration(days: 4)),
      location: 'Lab 215 TMF',
      latitude: 42.0042,
      longitude: 21.4098,
    ),
    Exam(
      course: 'ABS',
      timestamp: DateTime.now().add(Duration(days: 5)),
      location: 'Lab 117 TMF',
      latitude: 42.0055,
      longitude: 21.4000,
    ),
  ];
}
