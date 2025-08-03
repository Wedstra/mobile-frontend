import 'package:flutter/material.dart';

class ServiceDetails extends StatefulWidget {
  final Map<String, dynamic> service;
  const ServiceDetails({super.key,required this.service});

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Details'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Service Details for ${ widget.service['service_name'] }'),
      ),
    );
  }
}
