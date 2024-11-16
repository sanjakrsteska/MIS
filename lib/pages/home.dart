import 'package:flutter/material.dart';

import '../models/Piece.dart';

class _HomePageState extends State<HomePage> {
  List<Piece> clothes = [];
  @override
  void initState() {
    super.initState();
    clothes = Piece.getPieces();
  }
  @override
  Widget build(BuildContext context) {
    Color cardBackgroundColor = Theme.of(context).cardColor;
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: clothes.map((piece) {
            return Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: Image.network(
                  piece.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  piece.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Navigate to a details screen or show a dialog with more info
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(piece.name),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(piece.image),
                              const SizedBox(height: 10),
                              Text(piece.description),
                              const SizedBox(height: 10),
                              Text(
                                '\$${piece.price}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text("Details"),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

}
AppBar appBar() {
  return AppBar(
      title: const Text(
        '211046',
        style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
      backgroundColor: Colors.deepPurple,
      elevation: 0.0,
      centerTitle: true);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
