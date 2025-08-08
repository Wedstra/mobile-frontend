import 'package:flutter/material.dart';

class ManageServices extends StatefulWidget {
  final String? vendorId;
  const ManageServices({super.key, required this.vendorId});

  @override
  State<ManageServices> createState() => _ManageServicesState();
}

class _ManageServicesState extends State<ManageServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Services',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(widget.vendorId.toString()),
      ),
    );
  }
}
