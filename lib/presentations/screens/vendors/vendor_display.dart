import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';

import '../vendor_details/vendor_details.dart';

class VendorDisplay extends StatefulWidget {
  const VendorDisplay({super.key});

  @override
  State<VendorDisplay> createState() => _VendorDisplayState();
}

class _VendorDisplayState extends State<VendorDisplay> {
  bool isLoading = true;
  List<dynamic> vendorList = [];

  Future<void> getVerifiedVendors() async {
    print('inside getVerifiedVendors');

    try {
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();
      print('All keys: $allKeys'); // check if jwt_token exists

      final token = prefs.getString("jwt_token");
      print('Retrieved token = $token');

      if (token == null) {
        print("Token is null – something went wrong");
        return;
      }

      final response = await http.get(
        Uri.parse(
          '${ AppConstants.BASE_URL }/vendor/get/verified',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Vendor Response: ${response.statusCode}');
      setState(() {
        vendorList = jsonDecode(response.body);
        isLoading = false;
      });
    } catch (e) {
      print("Exception in getVerifiedVendors: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVerifiedVendors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verified Vendors')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : vendorList.isEmpty
          ? const Center(child: Text('No vendors found.'))
          : ListView.builder(
              itemCount: vendorList.length,
              itemBuilder: (context, index) {
                final vendor = vendorList[index];
                final name = vendor['vendor_name'] ?? 'No name';
                final business = vendor['business_name'] ?? 'No business';
                final category = vendor['business_category'] ?? 'No category';
                final List<dynamic> photos = vendor['business_photos'] ?? [];
                final String? imageUrl = photos.length > 1 ? photos[1] : null;

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    onTap: () {
                      final String vendorId = vendor['_id'] ?? vendor['id'];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VendorDetailsScreen(
                            key:
                                UniqueKey(), // 👈 force Flutter to treat this as a new instance
                            vendorId: vendorId,
                            vendor: vendor,
                          ),
                        ),
                      );
                    },
                    leading: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(business),
                    subtitle: Text("$name | $category"),
                  ),
                );
              },
            ),
    );
  }
}
