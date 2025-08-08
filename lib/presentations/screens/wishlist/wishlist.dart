import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';
import 'package:wedstra_mobile_app/presentations/screens/vendor_details/vendor_details.dart';
import 'package:wedstra_mobile_app/presentations/widgets/snakbar_component/snakbars.dart';

import '../../../data/services/Auth_Service/user_services/user_services.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  late List<String> wishlist = [];
  late List<dynamic> vendorList = [];
  String? token;
  String? userId;
  late bool isLoading = false;

  Future<void> _loadWishlist() async {
    setState(() {
      isLoading = true;
    });
    await _getToken();
    final response = await http.get(
      Uri.parse('${AppConstants.BASE_URL}/wishlist/67ee41cf4efc613597f6b8d7'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> test = List<String>.from(data.map((id) => id.toString()));
      setState(() {
        wishlist = test;
      });
    } else {
      print('Error loading wishlist: ${response.statusCode}');
    }
  }

  Future<void> _getToken() async {
    String storedToken = await getToken();

    if (storedToken != null) {
      setState(() {
        token = storedToken;
      });
    }
  }

  Future<void> _loadVendorsFromWishlist() async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.BASE_URL}/vendor/byIds'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(wishlist),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          vendorList = data;
          isLoading = false;
        });
      } else {
        print('Error Loading vendors : ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  void _loadUserDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final userData = pref.getString("user_data");

    if (userData != null) {
      final decodedJson = json.decode(userData);
      setState(() {
        userId = decodedJson["id"];
      });
      print('USER ID :: ${userId}');
    }
  }

  void _removeFromWishlist(String vendorId) async {
    try {
      final response = await http.delete(
        Uri.parse('${AppConstants.BASE_URL}/wishlist/$userId/remove?vendorId=$vendorId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        showSnack(context, 'Vendor successfully removed from your wishlist.');
        setState(() {
          vendorList.removeWhere((vendor) => vendor['id'] == vendorId);
          wishlist.remove(vendorId);
        });
      } else {
        print('Failed to remove vendor. Status: ${response.statusCode}');
        showSnack(
          context,
          'Could not remove vendor at the moment. Please try again later.',
          success: false,
        );
      }
    } catch (e) {
      print('Exception while removing vendor: $e');
      showSnack(
        context,
        'Couldn’t remove vendor. Please check your internet connection.',
        success: false,
      );
    }
  }


  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    _loadWishlist().then((_) {
      _loadVendorsFromWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Wishlist')),
      body:
          isLoading ? Center(child: CircularProgressIndicator(),) :
      vendorList.isEmpty
          ? Center(child: Text("No vendors in wishlist"))
          : ListView.builder(
              itemCount: vendorList.length,
              itemBuilder: (context, index) {
                final vendor = vendorList[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VendorDetailsScreen(
                          vendorId: vendor["id"],
                          vendor: vendor,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          vendor["business_photos"][0],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.image_not_supported),
                        ),
                      ),
                      title: Text(
                        vendor["vendor_name"].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vendor["business_name"].toString()),
                          Text(
                            '${vendor["business_category"]} • ${vendor["city"]}',
                          ),
                        ],
                      ),
                      trailing: InkWell(
                        onTap: () => _removeFromWishlist(vendor["id"]),
                        child: Icon(Icons.favorite, color: Colors.red),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
