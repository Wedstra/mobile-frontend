import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';
import 'package:wedstra_mobile_app/data/services/Auth_Service/user_services/user_services.dart';
import 'package:wedstra_mobile_app/presentations/screens/edit_profile/edit_profile.dart';
import 'package:wedstra_mobile_app/presentations/screens/expense_track/expense_tracker.dart';
import 'package:wedstra_mobile_app/presentations/screens/help_center/help_center.dart';
import 'package:wedstra_mobile_app/presentations/screens/upgrade_plan/upgrade_plan.dart';
import 'package:wedstra_mobile_app/presentations/screens/vendor_documents/vendor_documents.dart';
import 'package:wedstra_mobile_app/presentations/screens/wishlist/wishlist.dart';
import 'package:wedstra_mobile_app/presentations/widgets/Toast_helper/toast_helper.dart';

import '../../../data/services/Auth_Service/auth_layout.dart';
import '../../screens/manage_services/manage_services.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Map<String, dynamic>? _userDetails;
  String? userRole = '';

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
            userRole = parsedJson['role'];
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
                    _userDetails != null
                        ? _userDetails!['username'][0].toUpperCase()
                        : 'G',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                _userDetails != null ? _userDetails!['username'] : 'Guest',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                _userDetails != null
                    ? _userDetails!['email']
                    : 'Guest@gmail.com',
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(height: 20),
              _buildProfileTabs(userRole!),
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

  Widget _buildProfileTabs(String userRole) {
    if (userRole == 'USER') {
      return Column(
        children: [
          _buildTabTile('assets/profile_user.png', 'Edit Profile', () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => EditProfile()));
          }),
          _buildTabTile('assets/profile_wishlist.png', 'Wishlist', () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => Wishlist()));
          }),
          _buildTabTile('assets/profile_payment.png', 'Expense Tracker', () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) =>
                  ExpenseTracker(
                    userId: _userDetails?['id'],
                    budget: _userDetails?['budget'],
                  ),
            ));
          }),
          _buildTabTile('assets/profile_upgrade.png', 'Upgrade Plan', () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => UpgradePlan()));
          }),
          _buildTabTile('assets/profile_help.png', 'Help Center', () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => HelpCenter()));
          }),
        ],
      );
    } else if (userRole == 'VENDOR') {
      return Column(
        children: [
          _buildTabTile('assets/profile_user.png', 'Edit Vendor Profile', () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => VendorProfile()));
          }),
          _buildTabTile('assets/profile_user.png', 'Documents', () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => VendorDocuments()));
          }),
          _buildTabTile('assets/profile_user.png', 'Manage Services', () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => ManageServices(vendorId: _userDetails?['id'])));
          }),
          _buildTabTile('assets/profile_user.png', 'Upgrade Plan', () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => UpgradePlan()));
          }),
          _buildTabTile('assets/profile_help.png', 'Help Center', () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => HelpCenter()));
          }),
        ],
      );
    } else if (userRole == 'ADMIN') {
      return Column(
        children: [
          _buildTabTile('assets/profile_user.png', 'Manage Users', () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => ManageUsers()));
          }),
          _buildTabTile('assets/profile_user.png', 'Manage Vendors', () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => ManageVendors()));
          }),
          _buildTabTile('assets/profile_user.png', 'Manage Blogs', () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => ManageBlogs()));
          }),
          _buildTabTile('assets/profile_help.png', 'Admin Help Center', () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => HelpCenter()));
          }),
        ],
      );
    } else {
      return Center(child: Text('Invalid role'));
    }
  }


}

ManageBlogs() {
}

ManageVendors() {
}

ManageUsers() {
}

VendorProfile() {
}


Widget _buildTabTile(String assetPath, String label, VoidCallback onTap) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            Image.asset(assetPath),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
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
  );
}



