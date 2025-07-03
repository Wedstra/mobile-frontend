import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wedstra_mobile_app/presentations/screens/signup/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  void _navigateToLogin(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Signup()), // Replace with your target screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Image.asset(
                    "assets/onboard-3.png",
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Welcome back!",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF414141),
                      letterSpacing: 0.0,
                    ),
                  ),
                  SizedBox(height: 0),
                  // Generated code for this Text Widget...
                  Text(
                    'Let\'s get you signed in',
                    style: TextStyle(
                      color: Color(0xFF474747),
                      fontSize: 20,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 12),
                    child: TextFormField(
                      autofocus: true,
                      obscureText: true,
                      decoration: InputDecoration(

                        isDense: true,
                        labelStyle: TextStyle(letterSpacing: 0.0),
                        hintText: 'Email address',
                        hintStyle: TextStyle(letterSpacing: 0.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF474747),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xB35484FF),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.email_rounded,
                          color: Color(0xFF414141),
                        ),
                      ),
                      style: TextStyle(letterSpacing: 0.0),
                      cursorColor: Colors.black87,
                    ),
                  ),
                  // SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 12),
                    child: TextFormField(
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle: TextStyle(letterSpacing: 0.0),
                        hintText: 'Password',
                        hintStyle: TextStyle(letterSpacing: 0.0, fontSize: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF474747),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xB35484FF),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.lock_rounded,
                          color: Color(0xFF414141),
                        ),
                      ),
                      style: TextStyle(letterSpacing: 0.0),
                      cursorColor: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 0),
                  Align(
                    alignment: AlignmentDirectional(1, 0),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.blueAccent[700],
                        fontSize: 16,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        backgroundColor: Color(0xFFCB0033),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "or connect using",
                    style: TextStyle(color: Color(0xFF8D8D8D), fontSize: 16),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      icon: FaIcon(
                        FontAwesomeIcons.google,
                        color: Color(0xFF424242),
                      ),
                      label: Text(
                        "Log in with Google",
                        style: TextStyle(
                          color: Color(0xFF424242),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: _navigateToLogin,
                        child: Text(
                          ' Signup here.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
