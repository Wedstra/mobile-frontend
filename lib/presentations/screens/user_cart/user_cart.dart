import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';
import 'package:http/http.dart' as http;

import '../../../data/services/Auth_Service/user_services/user_services.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late String userId;
  String? token;
  List<Map<String, dynamic>> cartItems = [];
  String? cartId;

  double getTotal() {
    return cartItems.fold<double>(0.0, (sum, item) {
      final price = (item['price'] as num).toDouble();
      final qty = (item['quantity'] as num).toDouble();
      return sum + (price * qty);
    });
  }

  Future<void> _getToken() async {
    String storedToken = await getToken(); // Your helper function
    setState(() {
      token = storedToken;
    });
  }

  void loadCartItems() async {
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

    final response = await http.get(
      Uri.parse('${AppConstants.BASE_URL}/cart/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      setState(() {
        cartId = decoded['id'];
      });

      if (decoded is Map<String, dynamic> && decoded['items'] != null) {
        setState(() {
          cartItems = List<Map<String, dynamic>>.from(decoded['items']);
        });
      } else if (decoded is List) {
        // In case backend directly sends a list
        setState(() {
          cartItems = List<Map<String, dynamic>>.from(decoded);
        });
      } else {
        debugPrint("Unexpected response format: $decoded");
      }
    } else {
      debugPrint("Failed to load cart: ${response.body}");
    }
  }

  void decreaseQuantity(serviceId){
    print("$cartId");
    print(serviceId);
  }

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          "My Cart",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.remove_shopping_cart,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Your cart is empty",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Try adding a service!",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                final price = (item['price'] as num).toDouble();
                final qty = (item['quantity'] as num).toInt();

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Item Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: item['image'] != null && item['image'].toString().isNotEmpty
                            ? Image.network(
                          item['image'],
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 60,
                              width: 60,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image_not_supported, color: Colors.grey),
                            );
                          },
                        )
                            : Container(
                          height: 60,
                          width: 60,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.shopping_bag, color: Colors.grey),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Item Info
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              item['serviceName'] ?? "Unknown",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),

                      // Quantity Stepper + Total
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Stepper (− 1 +)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 18),
                                  onPressed: () {
                                    decreaseQuantity(item['serviceId']);
                                  },
                                ),
                                Text(
                                  "$qty",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 18),
                                  onPressed: () {
                                    // increase qty logic
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "₹${(price * qty).toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(AppConstants.primaryColor),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )

          ),

          // ✅ Total & Checkout Button (only show if cart has items)
          if (cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "₹${getTotal().toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(AppConstants.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      // TODO: Checkout logic
                    },
                    child: const Text(
                      "Proceed to Checkout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
