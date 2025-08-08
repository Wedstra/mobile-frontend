import 'package:flutter/material.dart';

class VendorDocuments extends StatefulWidget {
  const VendorDocuments({super.key});

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
    );
  }
}
