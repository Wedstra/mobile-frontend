import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';
import 'package:http/http.dart' as http;

import '../auth_layout.dart';

// void getUserByUserName(username) async {
//   print('inside getUserByUsername function');
//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('jwt_token');
//
//   // If token is null or empty
//   if (token == null || token.isEmpty) {
//     print('No token found.');
//     return;
//   }
//
//   // Check if token is expired
//   bool isExpired = JwtDecoder.isExpired(token);
//   if (isExpired) {
//     print('Token is expired. Returning...');
//     return; // Exit early if expired
//   }
//
//   print('Token expired: $isExpired');
//
//   // Get expiration date
//   DateTime expiryDate = JwtDecoder.getExpirationDate(token);
//   print('Expires at: $expiryDate');
//
//   final response = await http.get(
//     Uri.parse('${AppConstants.BASE_URL}/user/get-user/$username'),
//     headers: {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     },
//   );
//
//   print(response.body);
//   final userDetials = jsonEncode(response.body);
//   await prefs.setString('user_data', userDetials);
// }

void getUserByUserName(String username) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

  // Check if token exists
  if (token == null || token.isEmpty) {
    print('No token found.');
    return;
  }

  // Check if token is expired
  bool isExpired = JwtDecoder.isExpired(token);
  if (isExpired) {
    print('Token is expired. Returning...');
    return;
  }

  DateTime expiryDate = JwtDecoder.getExpirationDate(token);
  print('Token expires at: $expiryDate');

  // Make API call to fetch user details
  final url = Uri.parse('${AppConstants.BASE_URL}/user/get-user/$username');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );
  try {
    // Decode JSON response string to a Map
    final Map<String, dynamic> userDetails = json.decode(response.body);

    // Save JSON string to SharedPreferences
    await prefs.setString('user_data', json.encode(userDetails));

    print('User data saved to SharedPreferences');
  } catch (e) {
    print('Failed to decode or store user data: $e');
  }
}

Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("jwt_token");

  print('in GetToken = $token');

  if (token != null) {
    return token;
  } else {
    return 'null';
  }
}


Future<String?> getLoggedInUserDetails() async {
  final pref = await SharedPreferences.getInstance();
  final dataString = pref.getString('user_data');
  return dataString;
}




Future<bool> checkTokenAndRedirect(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null || token.isEmpty) {
    // Token not found
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => AuthLayout(), // Should evaluate token and show Login()
      ),
      (route) => false, // Remove all routes
    );
    return false;
  }

  bool isTokenExpired = JwtDecoder.isExpired(token);

  if (isTokenExpired) {
    // Token expired
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => AuthLayout(), // Should evaluate token and show Login()
      ),
      (route) => false, // Remove all routes
    );
    return false;
  } else {
    // Token valid
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => MainScreen()),
    // );
    return true;
  }
}
