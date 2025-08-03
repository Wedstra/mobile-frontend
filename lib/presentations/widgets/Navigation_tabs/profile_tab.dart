import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';
import 'package:wedstra_mobile_app/data/services/Auth_Service/user_services/user_services.dart';
import 'package:wedstra_mobile_app/presentations/screens/edit_profile/edit_profile.dart';
import 'package:wedstra_mobile_app/presentations/screens/help_center/help_center.dart';
import 'package:wedstra_mobile_app/presentations/screens/payment_method/payment_method.dart';
import 'package:wedstra_mobile_app/presentations/screens/upgrade_plan/upgrade_plan.dart';
import 'package:wedstra_mobile_app/presentations/screens/wishlist/wishlist.dart';
import 'package:wedstra_mobile_app/presentations/widgets/Toast_helper/toast_helper.dart';

import '../../../data/services/Auth_Service/auth_layout.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Map<String, dynamic>? _userDetails;

  void _logoutUser(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');
      await prefs.remove('user_data');
      ToastHelper().showToast('Logout Success!', ToastType.success);
      // Remove all previous routes and reload AuthLayout as the new root
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
              AuthLayout(), // Should evaluate token and show Login()
        ),
        (route) => false, // Remove all routes
      );
    } on FirebaseAuthException catch (e) {
      ToastHelper().showToast('Logout Error!', ToastType.error);
      print(e.message);
    }
  }

  void loadUserDetails() async {
    String? userDetailsString = await getLoggedInUserDetails();
    if (userDetailsString != null) {
      try {
        // Decode once
        var firstDecode = json.decode(userDetailsString);

        // Check if it's still a String
        var parsedJson = firstDecode is String
            ? json.decode(firstDecode)
            : firstDecode;
        setState(() {
          _userDetails = parsedJson;
        });
      } catch (e) {
        print('JSON Decode Error: $e');
      }
    } else {
      print('No user data found in SharedPreferences');
    }
  }


  @override
  void initState() {
    ToastHelper().init(context);
    loadUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Color(AppConstants.primaryColor),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    _userDetails != null ? _userDetails!['username'][0].toUpperCase() : 'G',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
                  ),

                ),
              ),
              SizedBox(height: 10),
              Text(
                _userDetails != null ? _userDetails!['username'] : 'Guest',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                  _userDetails != null ? _userDetails!['email'] : 'Guest@gmail.com',
                  style: TextStyle(fontSize: 17)),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EditProfile(), // Should evaluate token and show Login()
                    ), // Remove all routes
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/profile_user.png'),
                      const SizedBox(width: 10),
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Color(0xFF414141),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Color(0xFF414141),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          Wishlist(), // Should evaluate token and show Login()
                    ), // Remove all routes
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/profile_wishlist.png'),
                      SizedBox(width: 10),
                      Text(
                        'Wishlist',
                        style: TextStyle(
                          color: Color(0xFF414141),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Color(0xFF414141),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PaymentMethod(), // Should evaluate token and show Login()
                    ), // Remove all routes
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/profile_payment.png'),
                      SizedBox(width: 10),
                      Text(
                        'Payment Method',
                        style: TextStyle(
                          color: Color(0xFF414141),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Color(0xFF414141),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          UpgradePlan(), // Should evaluate token and show Login()
                    ), // Remove all routes
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/profile_upgrade.png'),
                      SizedBox(width: 10),
                      Text(
                        'Upgrade Plan',
                        style: TextStyle(
                          color: Color(0xFF414141),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Color(0xFF414141),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          HelpCenter(), // Should evaluate token and show Login()
                    ), // Remove all routes
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/profile_help.png'),
                      SizedBox(width: 10),
                      Text(
                        'Help Center',
                        style: TextStyle(
                          color: Color(0xFF414141),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Color(0xFF414141),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () => _logoutUser(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/profile_logout.png'),
                      SizedBox(width: 10),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Color(0xFF414141),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
