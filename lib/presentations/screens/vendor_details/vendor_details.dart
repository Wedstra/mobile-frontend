// vendor_details_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';
import 'package:wedstra_mobile_app/presentations/screens/service_details/service_details.dart';
import '../../widgets/CurvedEdgesWidget/curved_edges.dart';
import 'package:http/http.dart' as http;

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

  void loadServicesByVendor() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString("jwt_token");
      print('Retrieved token = $token');

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
        print('Services Loaded: $data');
      } else {
        print('Failed to load services: ${response.statusCode}');
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    loadServicesByVendor();
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
                          child: CircleAvatar(
                            backgroundColor: Colors.white70,
                            child: Icon(
                              Icons.favorite_border,
                              color: Colors.red,
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
                              'Swami Caterers',
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
                        children: const [
                          Text('by ', style: TextStyle(fontSize: 16)),
                          Text(
                            'Ashwin Somnath',
                            style: TextStyle(
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
                            child: const Text(
                              'Photography',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('| Pune', style: TextStyle(fontSize: 16)),
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
                      AboutTab(),
                      // Services Tab
                      ServiceTab(serviceDetails: serviceDetails),
                      // Reviews Tab
                      ReviewsTab(),
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
            //TODO: open dialouge for chatting with vendor
          },
          child: Icon(Iconsax.messages, color: Colors.white),
        ),
      ),
    );
  }
}

class ReviewsTab extends StatelessWidget {
  const ReviewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: const [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Anjali Patel'),
              subtitle: Text('Amazing food and service!'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Rohan Mehta'),
              subtitle: Text('Highly recommended!'),
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
                          )
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceDetails(service: service),
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

class AboutTab extends StatelessWidget {
  const AboutTab({super.key});

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
            Text(
              'Lorem ipsum dolor sit amet, consectetur apiscing elit. Ut et massa mi. Aliquam in '
              'hendrerit urna. Pellentesque sit amet sapien fringilla, mattis lgula consectetur, ultrices '
              'mauris. Maecenas vitae attis tellus. Nullam quis imperdiet augue. Vestibulum auctor ornare leo, '
              'non suscipit magna interdum eu. Curabitur pellentesque nibh nibh, at maximus ante fermentum sit amet. '
              'Pellentesque commodo lacus at sodales sodales. Quisque sagittis orci ut diam condimentum, vel euismod '
              'erat placerat. In iaculis arcu eros, eget tempus orci facilisis id.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Lorem ipsum dolor sit amet, consectetur apiscing elit. Ut et massa mi. Aliquam in '
              'hendrerit urna. Pellentesque sit amet sapien fringilla, mattis lgula consectetur, ultrices '
              'mauris. Maecenas vitae attis tellus. Nullam quis imperdiet augue. Vestibulum auctor ornare leo, ',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
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
                Text('+91 34XXXXXX83', style: TextStyle(fontSize: 16)),
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
                Text('XXXXXX@gmail.com', style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
