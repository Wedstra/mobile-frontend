import 'package:flutter/material.dart';
import 'package:wedstra_mobile_app/presentations/screens/login/login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  void _navigateToSignIn() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    'Create account',
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(),
                  Text(
                    'Let’s get you signed in',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF474747),
                    ),
                  ),
                  SizedBox(height: 50),
                  //Text field 1 for username
                  TextFormField(
                    autofocus: true,
                    obscureText: true,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                      isDense: true,
                      hint: Text("Username"),
                      hintStyle: TextStyle(color: Color(0xFF474747)),

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
                      prefixIcon: Icon(Icons.person, color: Color(0xFF414141)),
                    ),
                    style: TextStyle(letterSpacing: 0.0),
                    cursorColor: Colors.black87,
                  ),
                  SizedBox(height: 20),

                  //Text field 2 for email
                  TextFormField(
                    autofocus: true,
                    obscureText: true,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                      isDense: true,
                      hint: Text("Email address"),
                      hintStyle: TextStyle(color: Color(0xFF474747)),

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
                  SizedBox(height: 20),

                  //Text field 3 for phone no
                  TextFormField(
                    autofocus: true,
                    obscureText: true,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                      isDense: true,
                      hint: Text('Phone'),
                      hintStyle: TextStyle(color: Color(0xFF474747)),

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
                      prefixIcon: Icon(Icons.phone, color: Color(0xFF414141)),
                    ),
                    style: TextStyle(letterSpacing: 0.0),
                    cursorColor: Colors.black87,
                  ),
                  SizedBox(height: 20),

                  //Text field 4 for password
                  TextFormField(
                    autofocus: true,
                    obscureText: true,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                      isDense: true,
                      hint: Text("Password"),
                      hintStyle: TextStyle(color: Color(0xFF474747)),

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
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF414141)),
                    ),
                    style: TextStyle(letterSpacing: 0.0),
                    cursorColor: Colors.black87,
                  ),
                  SizedBox(height: 20),

                  //Text field 5 for confirm password
                  TextFormField(
                    autofocus: true,
                    obscureText: true,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                      isDense: true,
                      hint: Text("Confirm password"),
                      hintStyle: TextStyle(color: Color(0xFF474747)),

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
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF414141)),
                    ),
                    style: TextStyle(letterSpacing: 0.0),
                    cursorColor: Colors.black87,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFCB0033),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: _navigateToSignIn,
                        child: Text(
                          ' Sign in',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
