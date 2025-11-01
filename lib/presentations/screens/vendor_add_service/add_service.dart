import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';
import 'package:wedstra_mobile_app/data/services/Auth_Service/user_services/user_services.dart';
import 'package:wedstra_mobile_app/presentations/widgets/snakbar_component/snakbars.dart';

class AddService extends StatefulWidget {
  final String? vendorId;

  const AddService({Key? key, required this.vendorId}) : super(key: key);

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  List<XFile> selectedImages = [];
  bool isLoading = false;
  String? token;

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    final storedToken = await getToken();
    setState(() {
      token = storedToken;
    });
  }

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      setState(() {
        selectedImages = images;
      });
    }
  }

  Future<void> submitService(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      var uri = Uri.parse(
        '${AppConstants.BASE_URL}/service/${widget.vendorId}/create-service',
      );
      var request = http.MultipartRequest('POST', uri);

      // Add form fields
      request.fields['service_name'] = serviceNameController.text.trim();
      request.fields['description'] = descriptionController.text.trim();
      request.fields['category'] = categoryController.text.trim();
      request.fields['min_price'] = minPriceController.text.trim();
      request.fields['max_price'] = maxPriceController.text.trim();
      request.fields['location'] = locationController.text.trim();

      // Add files
      for (var file in selectedImages) {
        final mimeType = lookupMimeType(file.path);
        request.files.add(
          await http.MultipartFile.fromPath(
            'files',
            file.path,
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          ),
        );
      }

      request.headers['Authorization'] = 'Bearer $token';

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        showSnack(context, 'Service created successfully');
        Navigator.pop(context);
      } else {
        showSnack(context, response.body, success: false);
      }
    } catch (e) {
      print('Exception: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget buildImagePreview() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: selectedImages.map((image) {
        return Stack(
          children: [
            Image.file(
              File(image.path),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedImages.remove(image);
                  });
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 12,
                  child: Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Service",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField("Service Name", serviceNameController),
            buildTextField("Description", descriptionController),
            buildTextField("Category", categoryController),
            Row(
              children: [
                Expanded(
                  child: buildTextField(
                    "Min Price",
                    minPriceController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildTextField(
                    "Max Price",
                    maxPriceController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            buildTextField("Location", locationController),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: pickImages,
                icon: const Icon(Icons.image, color: Colors.indigo),
                label: const Text(
                  "Pick Images",
                  style: TextStyle(color: Colors.indigo),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Colors.indigo),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (selectedImages.isNotEmpty) buildImagePreview(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : () => submitService(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(AppConstants.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Color(0xFFD63F66),
                ),
                child: isLoading
                    ? Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      )
                    : const Text(
                        "Create Service",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
