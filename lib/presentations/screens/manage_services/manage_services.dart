import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';
import 'package:wedstra_mobile_app/presentations/screens/vendor_add_service/add_service.dart';
import 'package:wedstra_mobile_app/presentations/widgets/snakbar_component/snakbars.dart';
import '../../../data/services/Auth_Service/user_services/user_services.dart';
import '../../widgets/service_card/service_card.dart';

class ManageServices extends StatefulWidget {
  final String? vendorId;
  const ManageServices({super.key, required this.vendorId});

  @override
  State<ManageServices> createState() => _ManageServicesState();
}

class _ManageServicesState extends State<ManageServices> {
  String? token;
  List<dynamic> serviceList = [];
  bool isLoading = false;

  Future<void> _getToken() async {
    String storedToken = await getToken();
    setState(() {
      token = storedToken;
    });
  }

  void _loadServiceByVendor() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _getToken();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/service/${widget.vendorId}/all'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final secivcesDecoded = json.decode(response.body);
        setState(() {
          serviceList = secivcesDecoded;
          isLoading = false;
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadServiceByVendor();
  }

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: serviceList.isEmpty
                  ? const Center(
                      child: Text(
                        'No services found vendor',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: serviceList.length,
                      itemBuilder: (context, index) {
                        return ServiceCard(
                          service: serviceList[index],
                          vendorId: widget.vendorId,
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(AppConstants.primaryColor),
        onPressed: () {
          if (serviceList.length == 1) {
            showSnack(context, 'Free plan limit reached!', success: false);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddService(vendorId: widget.vendorId),
              ),
            );
          }
        },
        child: Icon(Iconsax.add, color: Colors.white),
      ),
    );
  }
}
