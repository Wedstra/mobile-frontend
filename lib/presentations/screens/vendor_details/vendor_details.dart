// vendor_details_screen.dart
import 'dart:convert';
import '../chat_room/chat_room.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';
import 'package:wedstra_mobile_app/presentations/screens/service_details/service_details.dart';
import 'package:wedstra_mobile_app/presentations/widgets/snakbar_component/snakbars.dart';
import '../../widgets/CurvedEdgesWidget/curved_edges.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class VendorDetailsScreen extends StatefulWidget {
  final String vendorId;
  final dynamic vendor;

  const VendorDetailsScreen({
    super.key,
    required this.vendorId,
    required this.vendor,
  });

  @override
  State<VendorDetailsScreen> createState() => _VendorDetailsScreenState();
}

class _VendorDetailsScreenState extends State<VendorDetailsScreen> {
  List<dynamic> serviceDetails = [];
  List<dynamic> reviews = [];
  List<dynamic> vendorDetails = [];
  String? userId;
  String? username;
  String? token;
  bool isWishlisted = false;

  void _checkIfWishlisted() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("jwt_token");
    final String? userData = prefs.getString("user_data");

    if (token == null || userData == null) return;

    final userId = jsonDecode(userData)['id'];

    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.BASE_URL}/wishlist/$userId/contains?vendorId=${widget.vendorId}',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final bool exists = json.decode(response.body);
        setState(() {
          isWishlisted = exists;
        });
      }
    } catch (e) {
      print('Error checking wishlist: $e');
    }
  }

  void loadServicesByVendor() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final storedtoken = prefs.getString("jwt_token");
      setState(() {
        token = storedtoken;
      });

      if (token == null) {
        print("Token is null – something went wrong");
        return;
      }

      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/service/${widget.vendorId}/all'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          serviceDetails = data;
        });
      } else {
        print('Failed to load services: ${response.statusCode}');
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void _loadVendorReviews() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final storedtoken = prefs.getString("jwt_token");
      setState(() {
        token = storedtoken;
      });
      print("token = $token");
      print("venodID = ${ widget.vendorId }");
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/reviews/vendor/${ widget.vendorId }'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          reviews = data;
        });
      } else {
        print('Failed to load Reviews: ${response.statusCode}');
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void _loadUserDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String? userData = pref.getString('user_data');

    if (userData != null) {
      final jsonDecoded = json.decode(userData);
      setState(() {
        userId = jsonDecoded['id'];
        username = jsonDecoded['username'];
      });
    }
  }

  void _addToWishlist() async {
    try {
      if (isWishlisted == false) {
        final response = await http.post(
          Uri.parse(
            '${AppConstants.BASE_URL}/wishlist/${userId}/add?vendorId=${widget.vendorId}',
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
        if (response.statusCode == 200) {
          showSnack(context, 'Vendor added to wishlist!');
          setState(() {
            isWishlisted = true;
          });
        } else {
          showSnack(context, 'Something went wrong! adding', success: false);
        }
      } else {
        final response = await http.delete(
          Uri.parse(
            '${AppConstants.BASE_URL}/wishlist/$userId/remove?vendorId=${widget.vendorId}',
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
        if (response.statusCode == 200) {
          setState(() {
            isWishlisted = false;
          });
          showSnack(context, 'Vendor removed from wishlist!');
        } else {
          showSnack(context, 'Something went wrong! removing', success: false);
        }
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    loadServicesByVendor();
    _checkIfWishlisted();
    _loadVendorReviews();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // for About, Services, Reviews
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Top Banner Image with Back & Favorite Buttons
                ClipPath(
                  clipper: CustomCurvedEdges(),
                  child: Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.vendor['business_photos'][0],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 16,
                          left: 16,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: CircleAvatar(
                              backgroundColor: Colors.white70,
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: InkWell(
                            onTap: _addToWishlist,
                            child: CircleAvatar(
                              backgroundColor: Colors.white70,
                              child: Icon(
                                isWishlisted
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isWishlisted ? Colors.red : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Vendor Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.vendor['business_name'],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFCB0033),
                              ),
                            ),
                          ),
                          Row(
                            children: const [
                              Icon(Icons.star, color: Colors.amber, size: 20),
                              SizedBox(width: 4),
                              Text('4.5', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),

                      // By vendor
                      Row(
                        children: [
                          const Text('by ', style: TextStyle(fontSize: 16)),
                          Text(
                            widget.vendor['vendor_name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Category and location
                      Row(
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
                              widget.vendor['business_category'],
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '| ${widget.vendor['city']}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),

                // Tabbed Pane
                const TabBar(
                  unselectedLabelStyle: TextStyle(fontSize: 18),
                  labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  labelColor: Color(0xFFCB0033),
                  unselectedLabelColor: Colors.black54,
                  indicatorColor: Color(0xFFCB0033),
                  tabs: [
                    Tab(text: 'About'),
                    Tab(text: 'Services'),
                    Tab(text: 'Reviews'),
                  ],
                ),
                SizedBox(
                  height: 400, // adjust height as needed
                  child: TabBarView(
                    children: [
                      // About Tab
                      AboutTab(vendor: widget.vendor),
                      // Services Tab
                      ServiceTab(serviceDetails: serviceDetails),
                      // Reviews Tab
                      ReviewsTab(
                        userId: userId,
                        username: username,
                        vendorId: widget.vendorId,
                        token: token,
                        reviews: reviews,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(AppConstants.primaryColor),
          onPressed: () {
            final chatRoom = ChatRoom(
              vendorId: widget.vendorId,
              vendorName: widget.vendor['vendor_name'],
              userId: userId ?? "", // from _loadUserDetails
              username: widget.vendor['vendor_name'], // or logged-in user name
            );
            chatRoom.openChat(context); // ✅ show dialog
          },
          child: Icon(Iconsax.messages, color: Colors.white),
        ),
      ),
    );
  }
}

class ReviewsTab extends StatelessWidget {
  final String? userId;
  final String? username;
  final String vendorId;
  final String? token;
  final List<dynamic> reviews;
  const ReviewsTab({
    super.key,
    required this.userId,
    required this.username,
    required String this.vendorId,
    required String? this.token,
    required List<dynamic> this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> addReviewToVendor(String reviewContent, int ratings) async {
      final Map<String, dynamic> jsonBody = {
        "userId": userId,
        "vendorId": vendorId,
        "username": username,
        "content": reviewContent,
        "rating": ratings.toInt(),
      };

      try {
        final response = await http.post(
          Uri.parse("${AppConstants.BASE_URL}/reviews"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token", // 🔑 token here
          },
          body: jsonEncode(jsonBody),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          showSnack(context, "Review submitted successfully!");
        } else {
          showSnack(context, "Failed to submit review!", success: false);
        }
      } catch (e) {
        print("Error submitting review: $e");
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Review Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      final TextEditingController reviewController =
                          TextEditingController();
                      double selectedRating = 0; // store user’s rating

                      return StatefulBuilder(
                        // use this so stars can update inside dialog
                        builder: (context, setState) {
                          return AlertDialog(
                            title: const Text("Add Review"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text input
                                TextField(
                                  controller: reviewController,
                                  decoration: const InputDecoration(
                                    hintText: "Write your review here...",
                                  ),
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 20),

                                // Rating stars
                                const Text("Rate this vendor:"),
                                const SizedBox(height: 8),
                                RatingBar.builder(
                                  initialRating: 0,
                                  minRating: 1,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 32,
                                  glow: false,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      selectedRating = rating;
                                    });
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final reviewContent = reviewController.text
                                      .trim();

                                  if (reviewContent.isNotEmpty &&
                                      selectedRating > 0) {
                                    addReviewToVendor(
                                      reviewContent,
                                      selectedRating.toInt(),
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    // optional: show validation error
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please add review & rating",
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text("Submit"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                icon: const Icon(Iconsax.message_add, color: Colors.white),
                label: const Text(
                  "Add Review",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(AppConstants.primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 16),

            ListView.separated(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // allow wrapping inside parent scroll
              itemCount: reviews.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final review = reviews[index];

                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: review['profileImage'] != null &&
                        review['profileImage'].isNotEmpty
                        ? NetworkImage(review['profileImage'])
                        : null,
                    child: (review['profileImage'] == null ||
                        review['profileImage'].isEmpty)
                        ? const Icon(Icons.person, color: Colors.grey)
                        : null,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              review['username'] ?? "Unknown",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          RatingBarIndicator(
                            rating: (review['rating'] ?? 0).toDouble(),
                            itemBuilder: (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                            itemSize: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        review['content'] ?? "",
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                  // Removing subtitle because we moved everything into title column
                  subtitle: null,
                );


              },
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceTab extends StatefulWidget {
  final List<dynamic> serviceDetails;
  const ServiceTab({super.key, required this.serviceDetails});

  @override
  State<ServiceTab> createState() => _ServiceTabState();
}

class _ServiceTabState extends State<ServiceTab> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.serviceDetails.isEmpty) {
      return const Center(child: Text('No services'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // so scroll handled by parent
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 per row
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3 / 4.5, // width : height ratio
          ),
          itemCount: widget.serviceDetails.length,
          itemBuilder: (context, index) {
            final service = widget.serviceDetails[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 13, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(service['images'][0]),
                    ),
                    Text(
                      service['service_name'] ?? 'No Title',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: Text(
                        service['description'] ?? 'No Description',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(AppConstants.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ServiceDetails(service: service),
                            ),
                          );
                        },
                        child: Text(
                          'View more',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AboutTab extends StatefulWidget {
  final dynamic vendor;
  const AboutTab({super.key, required this.vendor});

  @override
  State<AboutTab> createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.vendor['terms_and_conditions'],
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'GSTIN - ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.vendor['gst_number'],
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.vendor['city'],
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Contact',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Phone: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF414141),
                  ),
                ),
                Text(widget.vendor['phone_no'], style: TextStyle(fontSize: 16)),
              ],
            ),
            Row(
              children: [
                Text(
                  'Email: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF474747),
                  ),
                ),
                Text(widget.vendor['email'], style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
