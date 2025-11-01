import 'package:flutter/material.dart';

import '../../widgets/fullscreen_image/fullscreen_iamge.dart';

class VendorDocuments extends StatefulWidget {
  final Map<String, dynamic>? vendor;
  const VendorDocuments({super.key, this.vendor});

  @override
  State<VendorDocuments> createState() => _VendorDocumentsState();
}

class _VendorDocumentsState extends State<VendorDocuments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vendor Documents',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),

              //AADHAR card
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Aadhar Card',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.vendor?['vendor_aadharCard'] != null
                          ? Image.network(
                              widget.vendor!['vendor_aadharCard'],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 200,
                                    color: Colors.grey[200],
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Image not available',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                            )
                          : Container(
                              height: 200,
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              child: const Text(
                                'No Aadhar uploaded',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                    ),

                    const SizedBox(height: 8),

                    if (widget.vendor?['vendor_aadharCard'] != null)
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullscreenImageView(
                                imageUrl: widget.vendor!['vendor_aadharCard'],
                                title: 'Aadhar Card',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.open_in_full),
                        label: const Text("View Fullscreen"),
                      ),
                  ],
                ),
              ),

              //VENDOR PAN card
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Vendor PAN Card',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.vendor?['vendor_PAN'] != null
                          ? Image.network(
                              widget.vendor!['vendor_PAN'],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 200,
                                    color: Colors.grey[200],
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Image not available',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                            )
                          : Container(
                              height: 200,
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              child: const Text(
                                'No Aadhar uploaded',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                    ),

                    const SizedBox(height: 8),

                    if (widget.vendor?['vendor_aadharCard'] != null)
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullscreenImageView(
                                imageUrl: widget.vendor!['vendor_aadharCard'],
                                title: 'Vendor PAN card',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.open_in_full),
                        label: const Text("View Fullscreen"),
                      ),
                  ],
                ),
              ),

              //BUSINESS PAN card
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Business PAN Card',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.vendor?['business_PAN'] != null
                          ? Image.network(
                              widget.vendor!['business_PAN'],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 200,
                                    color: Colors.grey[200],
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Image not available',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                            )
                          : Container(
                              height: 200,
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              child: const Text(
                                'No Aadhar uploaded',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                    ),

                    const SizedBox(height: 8),

                    if (widget.vendor?['business_PAN'] != null)
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullscreenImageView(
                                imageUrl: widget.vendor!['business_PAN'],
                                title: 'Business PAN',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.open_in_full),
                        label: const Text("View Fullscreen"),
                      ),
                  ],
                ),
              ),

              //VENDOR PAN card
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Electricity_bill',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.vendor?['electricity_bill'] != null
                          ? Image.network(
                              widget.vendor!['electricity_bill'],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 200,
                                    color: Colors.grey[200],
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Image not available',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                            )
                          : Container(
                              height: 200,
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              child: const Text(
                                'No electricity bill uploaded',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                    ),

                    const SizedBox(height: 8),

                    if (widget.vendor?['electricity_bill'] != null)
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullscreenImageView(
                                imageUrl: widget.vendor!['electricity_bill'],
                                title: 'Electricity bill',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.open_in_full),
                        label: const Text("View Fullscreen"),
                      ),
                  ],
                ),
              ),

              //liscence card
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Liscence',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.vendor?['liscence'] != null
                          ? Image.network(
                              widget.vendor!['liscence'],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 200,
                                    color: Colors.grey[200],
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Image not available',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                            )
                          : Container(
                              height: 200,
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              child: const Text(
                                'No liscence uploaded',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.vendor?['liscence'] != null)
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullscreenImageView(
                                imageUrl: widget.vendor!['liscence'],
                                title: 'Liscence',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.open_in_full),
                        label: const Text("View Fullscreen"),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Business Photos',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child:
                    widget.vendor?['business_photos'] != null &&
                        widget.vendor!['business_photos'] is List &&
                        widget.vendor!['business_photos'].isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.vendor!['business_photos'].length,
                        itemBuilder: (context, index) {
                          final imageUrl =
                              widget.vendor!['business_photos'][index];
                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  imageUrl,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        height: 200,
                                        color: Colors.grey[200],
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Image not available',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FullscreenImageView(
                                        imageUrl: imageUrl,
                                        title: 'Business Photo ${index + 1}',
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.open_in_full),
                                label: const Text("View Fullscreen"),
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      )
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'No Business Photos uploaded',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
