import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/exam_model.dart';

class ExamListMapScreen extends StatefulWidget {
  final List<Exam> exams;

  const ExamListMapScreen({super.key, required this.exams});

  @override
  _ExamListMapScreenState createState() => _ExamListMapScreenState();
}

class _ExamListMapScreenState extends State<ExamListMapScreen> {
  Position? currentPosition;
  late List<Exam> exams;
  List<LatLng> routePoints = [];

  @override
  void initState() {
    super.initState();
    exams = widget.exams;
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentPosition = position;
      });
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  Future<void> _getRoute(LatLng destination) async {
    if (currentPosition == null) return;

    final String osrmServerUrl =
        "https://router.project-osrm.org/route/v1/driving";

    final response = await http.get(Uri.parse(
      "$osrmServerUrl/${currentPosition!.longitude},${currentPosition!.latitude};${destination.longitude},${destination.latitude}?geometries=geojson",
    ));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final coordinates = data['routes'][0]['geometry']['coordinates'];
      setState(() {
        routePoints = coordinates
            .map<LatLng>((point) => LatLng(point[1], point[0]))
            .toList();
      });
    } else {
      debugPrint("Failed to fetch route: ${response.body}");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Locations'),
      ),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
        options: MapOptions(
          center: LatLng(currentPosition!.latitude, currentPosition!.longitude),
          zoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                color: Colors.blue,
                strokeWidth: 4.0,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              for (var exam in exams)
                Marker(
                  point: LatLng(exam.latitude, exam.longitude),
                  builder: (ctx) => GestureDetector(
                    onTap: () => _getRoute(
                        LatLng(exam.latitude, exam.longitude)),
                    child: const Icon(Icons.location_on, color: Colors.red),
                  ),
                ),
              if (currentPosition != null)
                Marker(
                  point: LatLng(currentPosition!.latitude, currentPosition!.longitude),
                  builder: (ctx) =>
                  const Icon(Icons.person_pin_circle, color: Colors.blue),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
