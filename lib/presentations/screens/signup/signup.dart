import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:wedstra_mobile_app/data/services/Auth_Service/auth_services.dart';
import 'package:wedstra_mobile_app/presentations/screens/login/login_screen.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void _navigateToSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _register() async {
    try {
      var userCredential = null;
      if (passwordController.text == confirmPasswordController.text) {
        userCredential = await authService.value.createAccount(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        throw new FirebaseAuthException(
          code: 'password and confirm password are not same!',
        );
      }

      //get UID of registered user
      final uid = userCredential.user?.uid;

      //Update additional information in firestore
      if (uid != null) {
        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': usernameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'role': "USER",
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
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
                    controller: usernameController,
                    autofocus: true,
                    obscureText: false,
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
                    controller: emailController,
                    autofocus: true,
                    obscureText: false,
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
                    controller: phoneController,
                    autofocus: true,
                    obscureText: false,
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
                    controller: passwordController,
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
                    controller: confirmPasswordController,
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
                      onPressed: _register,
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
