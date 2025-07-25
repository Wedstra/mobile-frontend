import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedstra_mobile_app/presentations/screens/login/login_screen.dart';
import 'package:wedstra_mobile_app/presentations/screens/main/main_screen.dart';

class AuthLayout extends StatefulWidget {
  const AuthLayout({super.key, this.pageIfNotConnected});
  final Widget? pageIfNotConnected;

  @override
  State<AuthLayout> createState() => _AuthLayoutState();
}

class _AuthLayoutState extends State<AuthLayout> {
  late bool _isAuthencated = false;

  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token != null) {
      setState(() {
        _isAuthencated = true;
      });
    } else {
      setState(() {
        _isAuthencated = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return _isAuthencated ? MainScreen() : LoginScreen();
  }
}
