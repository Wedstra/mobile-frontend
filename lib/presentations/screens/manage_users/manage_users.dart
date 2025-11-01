import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wedstra_mobile_app/constants/app_constants.dart';
import '../../../data/services/Auth_Service/user_services/user_services.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  String? token;
  List<dynamic> userList = [];
  bool isLoading = false;

  Future<void> _getToken() async {
    String storedToken = await getToken();

    if (storedToken != null) {
      setState(() {
        token = storedToken;
      });
    }
  }

  Future<void> _loadAllUsers() async {
    try {
      await _getToken();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/user/get-all-user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if(response.statusCode == 200){
        final jsonDecode = json.decode(response.body);
        print(jsonDecode);
        setState(() {
          userList = jsonDecode;
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _loadAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Users',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: userList.isEmpty
          ? const Center(child: CircularProgressIndicator()) // loader
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
          columns: const [
            DataColumn(label: Text("Username")),
            DataColumn(label: Text("Email")),
            DataColumn(label: Text("Gender")),
            DataColumn(label: Text("DOB")),
            DataColumn(label: Text("Address")),
            DataColumn(label: Text("Role")),
            DataColumn(label: Text("Plan Type")),
          ],
          rows: userList.map((user) {
            return DataRow(cells: [
              DataCell(Text(user["username"] ?? "")),
              DataCell(Text(user["email"] ?? "")),
              DataCell(Text(user["gender"] ?? "")),
              DataCell(
                Text(user["dob"] != null
                    ? user["dob"].toString().split("T").first // remove time
                    : ""),
              ),
              DataCell(Text(user["address"] ?? "")),
              DataCell(Text(user["role"] ?? "")),
              DataCell(Text(user["planType"] ?? "N/A")),
            ]);
          }).toList(),
        ),
      ),
    );
  }

}
