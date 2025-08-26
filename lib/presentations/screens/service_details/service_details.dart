import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:wedstra_mobile_app/presentations/widgets/snakbar_component/snakbars.dart';

import '../../../data/services/Auth_Service/user_services/user_services.dart';

class ServiceDetails extends StatefulWidget {
  final Map<String, dynamic> service;
  const ServiceDetails({super.key, required this.service});

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  late List<String> images;
  late String userId;
  String? token;
  bool isLoading = false;

  Future<void> _getToken() async {
    String storedToken = await getToken(); // Your helper function
    setState(() {
      token = storedToken;
    });
  }

  void _handleAddToCart(Map<String, dynamic> service) async {
    setState(() {
      isLoading = true;
    });
    try {
      await _getToken();

      // get userId from SharedPreferences
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? userData = preferences.getString("user_data");

      if (userData != null) {
        final decodedUser = json.decode(userData);
        setState(() {
          userId = decodedUser['id'];
        });
      }

      print(service['id']);
      print(service['service_name']);

      final response = await http.post(
        Uri.parse('${AppConstants.BASE_URL}/cart/$userId/addItem'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "serviceId": service['id'],
          "serviceName": service['service_name'],
          "price": service['max_price'],
          "quantity": 1,
          "vendorId": service['vendor_id'],
        }),
      );

      if (response.statusCode == 200) {
        showSnack(context, "Item added to cart");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == 409) {
        setState(() {
          isLoading = false;
        });
        await showReplaceCartDialog(context);
      }
    } on Exception catch (e) {
      showSnack(context, "Something went wrong!", success: false);
      print(e);
    } finally {
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    images = List<String>.from(widget.service['images'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Service Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(AppConstants.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBackgroundColor: Color(0xFFD63F66),
            ),
            onPressed: () => _handleAddToCart(service),

            child: isLoading
                ? Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                : const Text(
                    "Add to Cart",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel Section
            if (images.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 220,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    autoPlay: true,
                  ),
                  items: images.map((imgUrl) {
                    return Image.network(
                      imgUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  }).toList(),
                ),
              )
            else
              const Center(child: Text('No images available')),

            const SizedBox(height: 24),

            // Title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['service_name'] ?? '',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber[600],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            service['category'],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '|',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.location5,
                              color: Color(AppConstants.primaryColor),
                              size: 18,
                            ),
                            Text(
                              '${service['location']}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(width: 4),
                    Text('4.5', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 5),
            Text(
              service['description'] ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),

            const SizedBox(height: 10),
            Text(
              'Pricing',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                  '₹${service['min_price']}',
                  style: TextStyle(fontSize: 18),
                ),
                Text(' - ', style: TextStyle(fontSize: 16)),
                Text(
                  '₹${service['max_price']}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Created at: ${DateTime.tryParse(service['created_at'])?.toLocal().toString().split('.')[0] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 80), // Space before bottom button
          ],
        ),
      ),
    );
  }

  Future<void> showReplaceCartDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Replace cart items?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Your cart already contains services from another vendor. "
            "Do you want to discard them and add services from this vendor?",
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false); // user said No
              },
              child: Text("No", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final response = await http.post(
                  Uri.parse(
                    '${AppConstants.BASE_URL}/cart/$userId/addItem?forceReplace=true',
                  ),
                  headers: {
                    'Authorization': 'Bearer $token',
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode({
                    "serviceId": "64f8a23b12b3456789abcd13",
                    "serviceName": "another service for same vendor",
                    "price": 10000,
                    "quantity": 1,
                    "vendorId": "67f20a67507a862158fb9f82",
                  }),
                );

                if (response.statusCode == 200) {
                  showSnack(context, "Item added to cart");
                } else {
                  showSnack(context, "Something went wrong", success: false);
                }
                Navigator.of(context).pop(true); // user said Yes
              },
              child: Text("Yes", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value ?? 'N/A', style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
