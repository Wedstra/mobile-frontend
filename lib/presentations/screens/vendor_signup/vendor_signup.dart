import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VendorSignup extends StatefulWidget {
  const VendorSignup({super.key});

  @override
  State<VendorSignup> createState() => _VendorSignupState();
}

class _VendorSignupState extends State<VendorSignup> {
  late int _step = 1;

  Map<String, dynamic> formData = {
    'vendorName': '',
    'email': '',
    'password': '',
    'phone': '',
    'city': '',
    'confirmPassword': '',
    'businessName': '',
    'businessCategory': '',
    'GSTIN': '',
    'termsAndConditions': '',
    'aadharCard': '',
    'PANCard': '',
    'businessPAN': '',
    'electricityBill': '',
    'liscence': '',
    'businessPhotos': List<String>,
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

  Future _registerVendor() async {
    try {

    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                'Vendor Registration',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
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
                        onPressed: _step == 3 ? _registerVendor : _nextTab,
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
  late TextEditingController _vendorNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;

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
  }

  @override
  void dispose() {
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
