import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wedstra_mobile_app/data/models/sellers.dart';
import 'package:wedstra_mobile_app/presentations/screens/signup/signup.dart';
import 'package:wedstra_mobile_app/presentations/screens/vendor_signup/vendor_signup.dart';

import '../../../data/services/Auth_Service/user_services/user_services.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   bool isValid = await checkTokenAndRedirect(context);
    //   print("Token valid: $isValid");
    // });
  }

  @override
  Widget build(BuildContext context) {
    final SearchController _searchController = SearchController();

    final List<String> items = ['Maharashtra', 'Delhi', 'Goa', 'Punjab'];
    final List<Sellers> vendors = [
      Sellers(
        name: "Elegant Events",
        imageUrl: "https://example.com/images/vendor1.jpg",
      ),
      Sellers(
        name: "Royal Weddings",
        imageUrl: "https://example.com/images/vendor2.jpg",
      ),
      Sellers(
        name: "Blissful Moments",
        imageUrl: "https://example.com/images/vendor3.jpg",
      ),
      Sellers(
        name: "Classic Decorators",
        imageUrl: "https://example.com/images/vendor4.jpg",
      ),
      Sellers(
        name: "Dream Makers",
        imageUrl: "https://example.com/images/vendor5.jpg",
      ),
      Sellers(
        name: "Royal Weddings",
        imageUrl: "https://example.com/images/vendor2.jpg",
      ),
      Sellers(
        name: "Blissful Moments",
        imageUrl: "https://example.com/images/vendor3.jpg",
      ),
      Sellers(
        name: "Classic Decorators",
        imageUrl: "https://example.com/images/vendor4.jpg",
      ),
      Sellers(
        name: "Dream Makers",
        imageUrl: "https://example.com/images/vendor5.jpg",
      ),
    ];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/profile.png', // your custom image path
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Icon(
                          Iconsax.location5,
                          size: 25,
                          color: Color(0xFFCB0033),
                        ),
                        Text('Location', style: TextStyle(fontSize: 17.86)),
                      ],
                    ),

                    Row(
                      spacing: 10,
                      children: [
                        Icon(Iconsax.like5, size: 30),
                        Icon(Iconsax.notification5, size: 30),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: SearchAnchor(
                          viewShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          searchController: _searchController,
                          builder: (context, controller) => SearchBar(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // For search bar
                              ),
                            ),
                            controller: controller,
                            hintText: 'Search',
                            onTap: () {
                              controller.openView();
                            },
                            onChanged: (_) {
                              controller
                                  .openView(); // Optional: open while typing
                            },
                          ),
                          suggestionsBuilder: (context, controller) {
                            return items
                                .where(
                                  (item) => item.toLowerCase().contains(
                                    controller.text.toLowerCase(),
                                  ),
                                )
                                .map(
                                  (item) => ListTile(
                                    title: Text(item),
                                    onTap: () {
                                      controller.closeView(item);
                                    },
                                  ),
                                )
                                .toList();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFCB0033),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Icon(
                            Iconsax.shopping_bag5,
                            size: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const VendorSignup(), // or VendorSignup() if not const
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey,
                      image: DecorationImage(
                        image: AssetImage('assets/notification.png'),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  childAspectRatio:
                      0.7, // 👈 makes it taller (width / height ratio)
                  children: vendors.map((vendor) {
                    return GestureDetector(
                      onTap: () {
                        print(vendor.name);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // example child content
                            Container(
                              height: 85,
                              width: 85,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  vendor.name[0],
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              vendor.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // return Scaffold(
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         const Text('This is Home Tab'),
    //         ElevatedButton(
    //           onPressed: () {
    //             Navigator.of(context).push(
    //               MaterialPageRoute(builder: (context) => const SubPage(title: 'Home')),
    //             );
    //           },
    //           child: const Text('Go to Home SubPage'),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

class SubPage extends StatelessWidget {
  final String title;

  const SubPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SubPage - $title')),
      body: Center(child: Text('SubPage of $title tab')),
    );
  }
}
