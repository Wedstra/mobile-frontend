import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wedstra_mobile_app/presentations/widgets/snakbar_component/snakbars.dart';
import '../../../constants/app_constants.dart';

class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final String? vendorId;
  const ServiceCard({required this.service, super.key, String? this.vendorId});

  @override
  Widget build(BuildContext context) {
    final images = List<String>.from(service['images'] ?? []);
    final mainImage = images.isNotEmpty ? images.first : null;

    void _deleteService() async {
      try {
        final response = await http.delete(
          Uri.parse(
            '${AppConstants.BASE_URL}/service/${service['id']}/delete?vendorId=${vendorId}',
          ),
        );
        if (response.statusCode == 200) {
          showSnack(context, 'Service deleted successful');
        } else {
          showSnack(context, 'Something went wrong!', success: false);
        }
      } on Exception catch (e) {
        print(e);
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: mainImage != null
                ? Image.network(
                    mainImage,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: const Text(
                        "Image not available",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  )
                : Container(
                    height: 200,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Text(
                      "No Image",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Color(AppConstants.primaryColor).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    service['category'] ?? 'Uncategorized',
                    style: TextStyle(
                      color: Color(AppConstants.primaryColor),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Service name
                Text(
                  service['service_name'] ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                // Description
                Text(
                  service['description'] ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                // Price
                Text(
                  '₹${service['min_price']} - ₹${service['max_price']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 8),

                // Location row
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      service['location'] ?? '',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Buttons Row
                if (images.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ImageGalleryViewer(images: images),
                            ),
                          );
                        },
                        icon: Icon(Icons.photo_library),
                        label: Text("View Gallery"),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onPressed: _deleteService,
                        icon: const Icon(Icons.delete),
                        label: const Text(
                          "Delete",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _confirmDelete(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Delete Service"),
      content: const Text("Are you sure you want to delete this service?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            // Call delete API or method
          },
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

class ImageGalleryViewer extends StatelessWidget {
  final List<String> images;

  const ImageGalleryViewer({required this.images, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Image.network(
              images[index],
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Text('Image load failed')),
            ),
          );
        },
      ),
    );
  }
}
