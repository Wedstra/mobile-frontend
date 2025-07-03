import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wedstra_mobile_app/presentations/screens/login/login.dart';
import 'package:wedstra_mobile_app/presentations/screens/signup/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: const MyApp(),
      routes: {
        "/login": (context) => const Signup(),
        "/signup": (context) => const Login(),
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Login();
  }
}
