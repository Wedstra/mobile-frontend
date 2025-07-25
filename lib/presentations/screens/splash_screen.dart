import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wedstra_mobile_app/presentations/screens/main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Timer(Duration(seconds: 3), (){
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: MainScreen()));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset('assets/wedstra_logo.png', scale: 2)),
    );
  }
}
