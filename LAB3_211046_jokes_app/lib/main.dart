import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jokes_app/screens/categories.dart';
import 'package:jokes_app/screens/category_jokes.dart';
import 'package:jokes_app/screens/login.dart';
import 'package:jokes_app/screens/random_joke.dart';
import 'package:jokes_app/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseService().initNotifications();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Jokes',
      initialRoute: '/login',
      routes : {
        '/': (context) => const Categories(),
        '/category-jokes' : (context) => const CategoryJokes(),
        '/random-joke': (context) => const RandomJoke(),
        '/login': (context) => const LoginPage()
      }
    );
  }

}

