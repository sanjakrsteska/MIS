import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import '../models/exam_model.dart';

class MapScreen extends StatefulWidget {
  final Exam exam;

  const MapScreen({super.key, required this.exam});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? currentPosition;
  List<LatLng> routePoints = [];
  bool showDetails = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    }

    if (await Permission.location.isGranted) {
      _getCurrentLocation();
    } else {
      debugPrint('Location permission is denied.');
    }
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

    const String osrmServerUrl = "https://router.project-osrm.org/route/v1/driving";

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

  void _showExamDetails() {
    setState(() {
      showDetails = true;
    });
  }

  void _hideExamDetails() {
    setState(() {
      showDetails = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Location: ${widget.exam.location}'),
      ),
      body: Stack(
        children: [
          currentPosition == null
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
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(widget.exam.latitude, widget.exam.longitude),
                    builder: (ctx) => GestureDetector(
                      onTap: () {
                        _showExamDetails();
                      },
                      child: const Icon(Icons.location_on, color: Colors.red),
                    ),
                  ),
                  Marker(
                    point: LatLng(currentPosition!.latitude, currentPosition!.longitude),
                    builder: (ctx) => const Icon(Icons.person_pin_circle, color: Colors.blue),
                  ),
                ],
              ),
              if (routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
            ],
          ),
          if (showDetails)
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.exam.course,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Location: ${widget.exam.location}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Date & Time: ${widget.exam.timestamp}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _getRoute(LatLng(widget.exam.latitude, widget.exam.longitude));
                          _hideExamDetails();
                        },
                        icon: const Icon(Icons.directions),
                        label: const Text("Get Directions"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
