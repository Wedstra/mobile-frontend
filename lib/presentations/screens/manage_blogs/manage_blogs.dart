import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/app_constants.dart';
import '../../../data/services/Auth_Service/user_services/user_services.dart';

class ManageBlogs extends StatefulWidget {
  const ManageBlogs({super.key});

  @override
  State<ManageBlogs> createState() => _ManageBlogsState();
}

class _ManageBlogsState extends State<ManageBlogs> {
  String? token;
  List<dynamic> blogList = [];
  bool isLoading = false;
  late Map<String, dynamic> userDetails;

  Future<void> _getToken() async {
    String storedToken = await getToken();

    if (storedToken != null) {
      setState(() {
        token = storedToken;
      });
    }
  }

  Future<void> _loadAllBlogs() async {
    try {
      await _getToken();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/blogs'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonDecode = json.decode(response.body);
        print(jsonDecode);
        setState(() {
          blogList = jsonDecode;
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> _loadUserDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userDate = pref.getString('user_data');

    final decodedJson = json.decode(userDate!);
    setState(() {
      userDetails = decodedJson;
    });
  }

  @override
  void initState() {
    _loadUserDetails();
    _loadAllBlogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // subtle background
      appBar: AppBar(
        title: const Text(
          'Manage Blogs',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: blogList.isEmpty
          ? const Center(
        child: Text(
          "No blogs available",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: blogList.length,
        itemBuilder: (context, index) {
          final blog = blogList[index];

          // Format date if available
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Blog Title Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    blog["title"] ?? "Untitled Blog",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Blog Content Preview
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    blog["content"] ?? "No content available",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Footer with author & date
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Created by  ${blog["authorType"]}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBlogDialog(context),
        child: Icon(Iconsax.add),
      ),
    );
  }


  void _showAddBlogDialog(BuildContext context) {
    final _titleController = TextEditingController();
    final _contentController = TextEditingController();
    final _authorIdController = TextEditingController(text: userDetails!['id']);
    final _authorTypeController = TextEditingController(text: "ADMIN");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Add New Blog",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title Field
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Blog Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Content Field
                TextField(
                  controller: _contentController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Blog Content",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Author ID Field
                TextField(
                  controller: _authorIdController,
                  decoration: const InputDecoration(
                    labelText: "Author ID",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Author Type
                TextField(
                  controller: _authorTypeController,
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: "Auther Type",
                    border: OutlineInputBorder(),
                  ),

                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isEmpty ||
                    _contentController.text.isEmpty ||
                    _authorIdController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                final newBlog = {
                  "title": _titleController.text,
                  "content": _contentController.text,
                  "authorId": _authorIdController.text,
                  "authorType": _authorTypeController.text,
                  "createdAt": DateTime.now().toIso8601String(),
                };

                // TODO: Send `newBlog` to your backend API
                print("Blog Added: $newBlog");

                Navigator.pop(context);
              },
              child: const Text("Add Blog"),
            ),
          ],
        );
      },
    );
  }
}