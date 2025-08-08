import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';

class VendorSignup extends StatefulWidget {
  const VendorSignup({super.key});

  @override
  State<VendorSignup> createState() => _VendorSignupState();
}

class _VendorSignupState extends State<VendorSignup> {
  late int _step = 1;

  Map<String, dynamic> formData = {
    'username': '',                  // same as email or separate
    'password': '',
    'vendor_name': '',
    'business_name': '',
    'business_category': '',
    'email': '',
    'phone_no': '',
    'city': '',
    'state':'',
    'gst_number': '',
    'terms_and_conditions': '',
    'vendor_aadharCard': File(''),   // File object, not string
    'vendor_PAN': File(''),
    'business_PAN': File(''),
    'electricity_bill': File(''),
    'liscence': File(''),
    'business_photos': <File>[],     // List of File objects
  };


  void _nextTab() {
    setState(() {
      if (_step < 3) {
        _step = _step + 1;
      }
    });
    print('next called | step = $_step');
    print('Form Data: $formData');
  }

  void _previousTab() {
    setState(() {
      if (_step > 1) {
        _step = _step - 1;
      }
    });
    print('Prev called | step = $_step');
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 1:
        return PersonalInformation(formData: formData);
      case 2:
        return BusinessInformation(formData: formData);
      case 3:
        return DocumentUpload(formData: formData);
      default:
        return Center(child: Text('Invalid Step'));
    }
  }

  void _registerVendor(Map<String, dynamic> formData) async {
    var uri = Uri.parse('${AppConstants.BASE_URL}/vendor/register'); // Replace with actual URL

    var request = http.MultipartRequest('POST', uri);

    // Add text fields
    request.fields['username'] = formData['username'];
    request.fields['password'] = formData['password'];
    request.fields['vendor_name'] = formData['vendor_name'];
    request.fields['business_name'] = formData['business_name'];
    request.fields['business_category'] = formData['business_category'];
    request.fields['email'] = formData['email'];
    request.fields['phone_no'] = formData['phone_no'];
    request.fields['city'] = formData['city'];
    request.fields['gst_number'] = formData['gst_number'];
    request.fields['terms_and_conditions'] = formData['terms_and_conditions'];

    // Add file fields (exact backend keys)
    request.files.add(await http.MultipartFile.fromPath('liscence', formData['liscence'].path));
    request.files.add(await http.MultipartFile.fromPath('vendor_aadharCard', formData['vendor_aadharCard'].path));
    request.files.add(await http.MultipartFile.fromPath('vendor_PAN', formData['vendor_PAN'].path));
    request.files.add(await http.MultipartFile.fromPath('business_PAN', formData['business_PAN'].path));
    request.files.add(await http.MultipartFile.fromPath('electricity_bill', formData['electricity_bill'].path));

    // Add multiple business photos
    for (File photo in formData['business_photos']) {
      request.files.add(await http.MultipartFile.fromPath('business_photos', photo.path));
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Vendor created successfully!");
        print(response.body);
      } else {
        print("❌ Registration failed with status: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print("⚠️ Error during registration: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Vendor Registration',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: _step <= 3 ? Color(0xFFCB0033) : Colors.grey,
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Personal\nInformation',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    _buildLine(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: _step >= 2 ? Color(0xFFCB0033) : Colors.grey,
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: Center(
                            child: Text(
                              '2',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Business\nInformation',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    _buildLine(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: _step == 3 ? Color(0xFFCB0033) : Colors.grey,
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: Center(
                            child: Text(
                              '3',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Documents\nUpload',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Center(child: _buildStepContent()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: _previousTab,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          backgroundColor: Color(0xFFCB0033),
                        ),
                        child: Text(
                          "Previous",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: _step == 3 ? () => _registerVendor(formData) : () => _nextTab(),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          backgroundColor: _step == 3
                              ? Colors.green
                              : Color(0xFFCB0033),
                        ),
                        child: _step == 3
                            ? Text(
                                "Submit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                "Next",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key, required this.formData});
  final Map<String, dynamic> formData;

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  late TextEditingController _usernameController;
  late TextEditingController _vendorNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;

  @override
  void initState() {
    super.initState();
    _vendorNameController = TextEditingController(
      text: widget.formData['vendorName'],
    );
    _emailController = TextEditingController(text: widget.formData['email']);
    _passwordController = TextEditingController(
      text: widget.formData['password'],
    );
    _confirmPasswordController = TextEditingController(
      text: widget.formData['confirmPassword'],
    );

    _phoneController = TextEditingController(text: widget.formData['phone']);

    _cityController = TextEditingController(text: widget.formData['city']);

    _usernameController = TextEditingController(text: widget.formData['username']);

    _stateController = TextEditingController(text: widget.formData['state']);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _vendorNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          SizedBox(height: 30),
          TextFormField(
            controller: _usernameController,
            onChanged: (value) => widget.formData['username'] = value,
            autofocus: true,
            obscureText: false,
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              isDense: true,
              hint: Text("Username"),
              hintStyle: TextStyle(color: Color(0xFF474747)),

              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF474747), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xB35484FF), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.person, color: Color(0xFF414141)),
            ),
            style: TextStyle(letterSpacing: 0.0),
            cursorColor: Colors.black87,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _vendorNameController,
            onChanged: (value) => widget.formData['vendorName'] = value,
            autofocus: true,
            obscureText: false,
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              isDense: true,
              hint: Text("Vendor name"),
              hintStyle: TextStyle(color: Color(0xFF474747)),

              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF474747), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xB35484FF), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.person, color: Color(0xFF414141)),
            ),
            style: TextStyle(letterSpacing: 0.0),
            cursorColor: Colors.black87,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _emailController,
            onChanged: (value) => widget.formData['email'] = value,
            autofocus: true,
            obscureText: false,
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              isDense: true,
              hint: Text("Email"),
              hintStyle: TextStyle(color: Color(0xFF474747)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF474747), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xB35484FF), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.email_rounded, color: Color(0xFF414141)),
            ),
            style: TextStyle(letterSpacing: 0.0),
            cursorColor: Colors.black87,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _phoneController,
            onChanged: (value) => widget.formData['phone'] = value,
            autofocus: true,
            obscureText: false,
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              isDense: true,
              hint: Text("Phone"),
              hintStyle: TextStyle(color: Color(0xFF474747)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF474747), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xB35484FF), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.call, color: Color(0xFF414141)),
            ),
            style: TextStyle(letterSpacing: 0.0),
            cursorColor: Colors.black87,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _cityController,
            onChanged: (value) => widget.formData['city'] = value,
            autofocus: true,
            obscureText: false,
            decoration: InputDecoration(
              isDense: true,
              hint: Text("City"),
              hintStyle: TextStyle(color: Color(0xFF474747)),

              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF474747), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xB35484FF), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.location_on, color: Color(0xFF414141)),
            ),
            style: TextStyle(letterSpacing: 0.0),
            cursorColor: Colors.black87,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _stateController,
            onChanged: (value) => widget.formData['state'] = value,
            autofocus: true,
            obscureText: false,
            decoration: InputDecoration(
              isDense: true,
              hint: Text("State"),
              hintStyle: TextStyle(color: Color(0xFF474747)),

              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF474747), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xB35484FF), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.location_on, color: Color(0xFF414141)),
            ),
            style: TextStyle(letterSpacing: 0.0),
            cursorColor: Colors.black87,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _passwordController,
            onChanged: (value) => widget.formData['password'] = value,
            autofocus: true,
            obscureText: false,
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              isDense: true,
              hint: Text("Password"),
              hintStyle: TextStyle(color: Color(0xFF474747)),

              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF474747), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xB35484FF), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.lock, color: Color(0xFF414141)),
            ),
            style: TextStyle(letterSpacing: 0.0),
            cursorColor: Colors.black87,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _confirmPasswordController,
            onChanged: (value) => widget.formData['confirmPassword'] = value,
            autofocus: true,
            obscureText: false,
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              isDense: true,
              hint: Text("Confirm password"),
              hintStyle: TextStyle(color: Color(0xFF474747)),

              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF474747), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xB35484FF), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.lock, color: Color(0xFF414141)),
            ),
            style: TextStyle(letterSpacing: 0.0),
            cursorColor: Colors.black87,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

//Business information class
class BusinessInformation extends StatefulWidget {
  const BusinessInformation({super.key, required this.formData});
  final Map<String, dynamic> formData;

  @override
  State<BusinessInformation> createState() => _BusinessInformationState();
}

class _BusinessInformationState extends State<BusinessInformation> {
  late TextEditingController _businessNameController;
  late TextEditingController _businessCategoryController;
  late TextEditingController _GSTINController;
  late TextEditingController _termsAndConditionsController;

  @override
  void initState() {
    super.initState();
    _businessNameController = TextEditingController(
      text: widget.formData['businessName'],
    );
    _businessCategoryController = TextEditingController(
      text: widget.formData['businessCategory'],
    );
    _GSTINController = TextEditingController(text: widget.formData['GSTIN']);
    _termsAndConditionsController = TextEditingController(
      text: widget.formData['termsAndConditions'],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _businessNameController.dispose();
    _businessCategoryController.dispose();
    _GSTINController.dispose();
    _termsAndConditionsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          TextFormField(
            controller: _businessNameController,
            onChanged: (value) => widget.formData['businessName'] = value,
            autofocus: true,
            obscureText: false,
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              isDense: true,
              hint: Text("Business name"),
              hintStyle: TextStyle(color: Color(0xFF474747)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF474747), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xB35484FF), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.email_rounded, color: Color(0xFF414141)),
            ),
            style: TextStyle(letterSpacing: 0.0),
            cursorColor: Colors.black87,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _businessCategoryController,
            onChanged: (value) => widget.formData['businessCategory'] = value,
            autofocus: true,
            obscureText: false,
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              isDense: true,
              hint: Text("Business Category"),
              hintStyle: TextStyle(color: Color(0xFF474747)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF474747), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xB35484FF), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.email_rounded, color: Color(0xFF414141)),
            ),
            style: TextStyle(letterSpacing: 0.0),
            cursorColor: Colors.black87,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _GSTINController,
            onChanged: (value) => widget.formData['GSTIN'] = value,
            autofocus: true,
            obscureText: false,
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              isDense: true,
              hint: Text("GSTIN number"),
              hintStyle: TextStyle(color: Color(0xFF474747)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF474747), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xB35484FF), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.email_rounded, color: Color(0xFF414141)),
            ),
            style: TextStyle(letterSpacing: 0.0),
            cursorColor: Colors.black87,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _termsAndConditionsController,
            onChanged: (value) => widget.formData['termsAndConditions'] = value,
            maxLines: 5,
            autofocus: true,
            obscureText: false,
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              isDense: true,
              hint: Text("Terms & conditions"),
              hintStyle: TextStyle(color: Color(0xFF474747)),

              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF474747), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xB35484FF), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 95),
                child: Icon(Icons.text_snippet, color: Color(0xFF414141)),
              ),
            ),
            style: TextStyle(letterSpacing: 0.0),
            cursorColor: Colors.black87,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class DocumentUpload extends StatefulWidget {
  final Map<String, dynamic> formData;
  const DocumentUpload({super.key, required this.formData});

  @override
  State<DocumentUpload> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
  File? _selectedImage;
  Future _uploadDocuments() async {
    final ImagePicker _picker = ImagePicker();

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        // TODO: Upload this file to Firebase or display it
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        print('Image selected: ${imageFile.path}');
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Aadhar card',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(height: 0),
            GestureDetector(
              onTap: _uploadDocuments,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                child: _selectedImage == null
                    ? Center(child: Text("Click to upload"))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'PAN card',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            GestureDetector(
              onTap: _uploadDocuments,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                child: _selectedImage == null
                    ? Center(child: Text("Upload Document"))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Business PAN card',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            GestureDetector(
              onTap: _uploadDocuments,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                child: _selectedImage == null
                    ? Center(child: Text("Upload Document"))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Electricity Bill',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            GestureDetector(
              onTap: _uploadDocuments,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                child: _selectedImage == null
                    ? Center(child: Text("Upload Document"))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Liscence',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            GestureDetector(
              onTap: _uploadDocuments,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                child: _selectedImage == null
                    ? Center(child: Text("Upload Document"))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Business Photos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            GestureDetector(
              onTap: _uploadDocuments,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                child: _selectedImage == null
                    ? Center(child: Text("Upload Document"))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

Widget _buildLine() {
  return Expanded(child: Container(height: 2, color: Colors.grey));
}
