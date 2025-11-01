import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wedstra_mobile_app/constants/app_constants.dart';

import '../../../data/services/Auth_Service/user_services/user_services.dart';
import '../admin_vendor_details/VendorDetailsPage.dart';

class ManageVendors extends StatefulWidget {
  @override
  _ManageVendorsScreenState createState() => _ManageVendorsScreenState();
}

class _ManageVendorsScreenState extends State<ManageVendors> {
  String selectedFilter = "authorized";
  late List<dynamic> vendorList = [];
  String? token;
  bool isLoading = false;

  void _loadVendors() async {
    setState(() {
      isLoading = true;
    });
    try {
      await _getToken();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/vendor/getVendors'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );


      if (response.statusCode == 200) {
        final jsonDecoded = json.decode(response.body);
        debugPrint(jsonEncode(jsonDecoded), wrapWidth: 1024);
        setState(() {
          vendorList = jsonDecoded;
        });
      }
    } on Exception catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
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

  @override
  void initState() {
    _loadVendors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final filteredVendors = vendorList.where((v) {
      final bool isVerified = (v["verified"] ?? false) == true;
      return selectedFilter == "authorized" ? isVerified : !isVerified;
    }).toList();



    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Vendors',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Filter buttons with counts
            Row(
              children: [
                Expanded(
                  child: _buildFilterButton(
                    "Authorized (${vendorList.where((v) => v["verified"] == true).length})",
                    Colors.green,
                    "authorized",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildFilterButton(
                    "Unauthorized (${vendorList.where((v) => v["verified"] != true).length})",
                    Colors.red,
                    "unauthorized",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Vendor list or empty state
            Expanded(
              child: filteredVendors.isEmpty
                  ? Center(
                child: Text(
                  "No vendors found",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              )
                  : ListView.builder(
                itemCount: filteredVendors.length,
                itemBuilder: (context, index) {
                  return _buildVendorCard(filteredVendors[index],context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String title, Color color, String filterValue) {
    final bool isSelected = selectedFilter == filterValue;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = filterValue;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVendorCard(Map<String, dynamic> vendor, BuildContext context) {
    bool isVerified = vendor["verified"] == true;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Vendordetailspage(vendor: vendor),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vendor image/logo
              CircleAvatar(
                radius: 30,
                backgroundImage: vendor['business_photos'] != null &&
                    vendor['business_photos'].isNotEmpty
                    ? NetworkImage(vendor['business_photos'][0])
                    : null,
                backgroundColor: Colors.grey[300],
                child: (vendor['business_photos'] == null ||
                    vendor['business_photos'].isEmpty)
                    ? const Icon(Icons.store, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),

              // Vendor details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vendor name & status badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            vendor["vendor_name"] ?? "No name",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isVerified
                                ? Colors.green[100]
                                : Colors.red[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isVerified ? "Authorized" : "Unauthorized",
                            style: TextStyle(
                              color: isVerified
                                  ? Colors.green[800]
                                  : Colors.red[800],
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Category
                    Text(
                      vendor['business_category'] ?? "Unknown category",
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),

                    const SizedBox(height: 6),

                    // City
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          vendor['city'] ?? "No city",
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}

