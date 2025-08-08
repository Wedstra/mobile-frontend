import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';

import '../vendor_details/vendor_details.dart';

class VendorDisplay extends StatefulWidget {
  final List<dynamic>? vendorByCategory;
  const VendorDisplay({super.key,this.vendorByCategory});

  @override
  State<VendorDisplay> createState() => _VendorDisplayState();
}

class _VendorDisplayState extends State<VendorDisplay> {
  bool isLoading = true;
  List<dynamic> vendorList = [];
  String? selectedCategory;
  String? selectedState;
  String? selectedCity;

  List<dynamic> categoryList = [];
  List<String> stateList = [];
  List<String> cityList = [];

  Future<void> getVerifiedVendors() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();

      final token = prefs.getString("jwt_token");

      if (token == null) {
        print("Token is null – something went wrong");
        return;
      }

      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/vendor/get/verified'),
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

  void _getCategories() async {
    final response = await http.get(
      Uri.parse('${AppConstants.BASE_URL}/resources/categories'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> decoded = json.decode(response.body);

      setState(() {
        categoryList = decoded;
      });
    } else {
      print('Failed to load categories');
    }
  }

  void _fetchStates() async {
    final response = await http.get(
      Uri.parse('${AppConstants.BASE_URL}/location/states'),
    );

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);

      // If your response is a list
      if (decodedJson is List) {
        setState(() {
          stateList = List<String>.from(decodedJson);
        });
      }
    } else {
      print('Failed to load states');
    }
  }

  void _fetchCitiesForState(String? selectedState) async {
    final response = await http.get(
      Uri.parse(
        '${AppConstants.BASE_URL}/location/cities?state=${selectedState}',
      ),
    );

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);

      // If your response is a list
      if (decodedJson is List) {
        setState(() {
          cityList = List<String>.from(decodedJson);
        });
      }
    } else {
      print('Failed to load states');
    }
  }

  void filterVendors() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString("jwt_token");

      if (token == null) {
        print("Token is null – something went wrong");
        return;
      }
      final response = await http.get(
        Uri.parse(
          '${AppConstants.BASE_URL}/vendor/by-location/${selectedCity}/by-category/${selectedCategory}',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final decodedJson = json.decode(response.body);

      setState(() {
        vendorList = decodedJson;
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
    _fetchStates();

    // Case 1: Coming directly — no filters applied
    if (widget.vendorByCategory == null) {
      getVerifiedVendors(); // fetch all
    }
    // Case 2: Coming from home with no vendors found
    else if (widget.vendorByCategory!.isEmpty) {
      setState(() {
        vendorList = [];
        isLoading = false;
      });
    }
    // Case 3: Coming from home with filtered vendors
    else {
      setState(() {
        vendorList = widget.vendorByCategory!;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verified Vendors')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔽 Dropdowns Row
                      Row(
                        children: [
                          // Category Dropdown
                          Expanded(
                            child: _buildDropdown(
                              hint: "Category",
                              value: selectedCategory,
                              items: categoryList.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category['category_name'].toString(),
                                  child: Text(category['category_name']),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          // State Dropdown
                          Expanded(
                            child: _buildDropdown(
                              hint: "State",
                              value: selectedState,
                              items: stateList.map((state) {
                                return DropdownMenuItem<String>(
                                  value: state,
                                  child: Text(state),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedState = value!;
                                  selectedCity = null;
                                  _fetchCitiesForState(selectedState);
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (selectedState != null)
                            Expanded(
                              child: Opacity(
                                opacity: selectedState == null ? 0.5 : 1.0,
                                child: IgnorePointer(
                                  ignoring: selectedState == null,
                                  child: _buildDropdown(
                                    hint: "City",
                                    value: selectedCity,
                                    items: cityList.map((city) {
                                      return DropdownMenuItem<String>(
                                        value: city,
                                        child: Text(city),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCity = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 🔽 Filter & Clear Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  filterVendors();
                                },
                                icon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                label: const Text(
                                  "Search",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(
                                    AppConstants.primaryColor,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (selectedCategory != null ||
                              selectedState != null ||
                              selectedCity != null)
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedCategory = null;
                                    selectedState = null;
                                    selectedCity = null;
                                    cityList = [];
                                  });
                                  getVerifiedVendors();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Clear Filters",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 🔽 Vendor List or Empty Message
                Expanded(
                  child: vendorList.isEmpty
                      ? const Center(
                          child: Text(
                            'No vendors found.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: vendorList.length,
                          itemBuilder: (context, index) {
                            final vendor = vendorList[index];
                            final name = vendor['vendor_name'] ?? 'No name';
                            final business =
                                vendor['business_name'] ?? 'No business';
                            final category =
                                vendor['business_category'] ?? 'No category';
                            final List<dynamic> photos =
                                vendor['business_photos'] ?? [];
                            final String? imageUrl = photos.length > 1
                                ? photos[1]
                                : null;

                            return Card(
                              margin: const EdgeInsets.all(10),
                              child: ListTile(
                                onTap: () {
                                  final String vendorId =
                                      vendor['_id'] ?? vendor['id'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VendorDetailsScreen(
                                        key: UniqueKey(),
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
                ),
              ],
            ),
    );
  }
}

Widget _buildDropdown({
  required String hint,
  required String? value,
  required List<DropdownMenuItem<String>> items,
  required void Function(String?) onChanged,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    height: 52,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        hint: Text(hint),
        items: items,
        onChanged: onChanged,
      ),
    ),
  );
}
