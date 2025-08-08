import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';
import 'package:wedstra_mobile_app/data/services/Auth_Service/user_services/user_services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wedstra_mobile_app/presentations/screens/forget_password/forgot_password.dart';
import 'package:wedstra_mobile_app/presentations/screens/login/login_screen.dart';
import 'package:wedstra_mobile_app/presentations/screens/user_register/user_register.dart';
import 'package:wedstra_mobile_app/presentations/screens/vendor_signup/vendor_signup.dart';
import 'package:wedstra_mobile_app/presentations/widgets/Toast_helper/toast_helper.dart';

import '../main/main_screen.dart';

class VendorLogin extends StatefulWidget {
  const VendorLogin({super.key});

  @override
  State<VendorLogin> createState() => _VendorLoginState();
}

class _VendorLoginState extends State<VendorLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late var _isLoading = false;
  late var _isPasswordVisible = true;

  Future<void> _login(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      print('email address = ${_emailController.text}');
      print('password = ${_passwordController.text}');

      final url = Uri.parse('${AppConstants.BASE_URL}/vendor/login');

      var response = await http.post(
        url,
        headers: <String, String>{"Content-type": "application/json"},
        body: jsonEncode(<String, String>{
          'username': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final jwtToken = response.body;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("jwt_token", jwtToken);

        final newToken = await prefs.getString("jwt_token");

        // Check for expiry
        if (JwtDecoder.isExpired(jwtToken)) {
          print('Token expired');
          return;
        }

        // Decode token
        Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
        String username = decodedToken['sub'];
        getVendorByUserName(username);

        ToastHelper().showToast("Login successful!", ToastType.success);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      } else {
        ToastHelper().showToast("Invalid credentials", ToastType.error);
        print('Login failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ToastHelper().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(height: 60),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset(height: 150, 'assets/wedstra_logo.png')),
                  Text(
                    'Welcome Vendor,',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Connect with Customers and Grow Your Business Effortlessly.',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF505050),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.sms),
                  labelText: 'Email',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF474747), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xB35484FF), width: 1),
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
                  fillColor: Colors.white70,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                obscureText: _isPasswordVisible,
                controller: _passwordController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.password_check),
                  suffixIcon: InkWell(
                      onTap: (){
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      child: _isPasswordVisible ? Icon(Iconsax.eye) :  Icon(Iconsax.eye_slash)),
                  labelText: 'Password',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF474747), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xB35484FF), width: 1),
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
                  fillColor: Colors.white70,
                ),
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPassword()),
                    );
                  },
                  child: Text(
                    'Forgot psssword',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 15),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(AppConstants.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    disabledBackgroundColor: Color(0xFFD63F66),
                  ),
                  onPressed: _isLoading ? null : () => _login(context),
                  child: _isLoading
                      ? Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )
                      : const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VendorSignup()),
                    );
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Color(0xFF414141),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Are you user? ',
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginScreen()), (route) => false,);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25,),
              Row(
                children: [
                  Flexible(
                    child: Divider(
                      color: Color(0xFF505050),
                      thickness: 0.5,
                      indent: 60,
                      endIndent: 5,
                    ),
                  ),
                  Text(
                    'Or sign in with',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                  Flexible(
                    child: Divider(
                      color: Color(0xFF505050),
                      thickness: 0.5,
                      indent: 5,
                      endIndent: 60,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
