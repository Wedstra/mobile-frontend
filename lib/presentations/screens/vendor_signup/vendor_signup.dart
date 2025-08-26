import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:wedstra_mobile_app/constants/app_constants.dart';
import 'package:wedstra_mobile_app/presentations/widgets/snakbar_component/snakbars.dart';

class VendorSignup extends StatefulWidget {
  const VendorSignup({super.key});

  @override
  State<VendorSignup> createState() => _VendorSignupState();
}

class _VendorSignupState extends State<VendorSignup> {
  int _step = 1;
  late bool isLoading = false;

  // Step keys
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  final _step3Key = GlobalKey<FormState>();



  Map<String, dynamic> formData = {
    'username': '',
    'password': '',
    'vendor_name': '',
    'business_name': '',
    'business_category': '',
    'email': '',
    'phone_no': '',
    'city': '',
    'state': '',
    'gst_number': '',
    'terms_and_conditions': '',
    'vendor_aadharCard': null, // File?
    'vendor_PAN': null,
    'business_PAN': null,
    'electricity_bill': null,
    'liscence': null,
    'business_photos': <File>[],
  };

  void _nextTab() {
    setState(() {
      if (_step < 3) _step++;
    });
  }

  void _previousTab() {
    setState(() {
      if (_step > 1) _step--;
    });
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

  Future<void> _registerVendor() async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.parse('${AppConstants.BASE_URL}/vendor/register');
    var request = http.MultipartRequest('POST', uri);

    // Add text fields safely
    request.fields['username'] = (formData['username'] ?? '').toString();
    request.fields['password'] = (formData['password'] ?? '').toString();
    request.fields['vendor_name'] = (formData['vendor_name'] ?? '').toString();
    request.fields['business_name'] = (formData['business_name'] ?? '')
        .toString();
    request.fields['business_category'] = (formData['business_category'] ?? '')
        .toString();
    request.fields['email'] = (formData['email'] ?? '').toString();
    request.fields['phone_no'] = (formData['phone_no'] ?? '').toString();
    request.fields['city'] = (formData['city'] ?? '').toString();
    request.fields['state'] = (formData['state'] ?? '').toString();
    request.fields['gst_number'] = (formData['gst_number'] ?? '').toString();
    request.fields['terms_and_conditions'] =
        (formData['terms_and_conditions'] ?? '').toString();

    // Helper to add a single file if present
    Future<void> addFile(String fieldName, dynamic fileObj) async {
      if (fileObj is File && fileObj.path.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(fieldName, fileObj.path),
        );
      }
    }

    await addFile('liscence', formData['liscence']);
    await addFile('vendor_aadharCard', formData['vendor_aadharCard']);
    await addFile('vendor_PAN', formData['vendor_PAN']);
    await addFile('business_PAN', formData['business_PAN']);
    await addFile('electricity_bill', formData['electricity_bill']);

    // business_photos (multiple)
    if (formData['business_photos'] is List<File>) {
      for (File photo in (formData['business_photos'] as List<File>)) {
        if (photo.path.isNotEmpty) {
          request.files.add(
            await http.MultipartFile.fromPath('business_photos', photo.path),
          );
        }
      }
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        showSnack(context, 'Vendor registered successfully!');
        Navigator.pop(context);
      } else {
        showSnack(context, 'Vendor Registration failed', success: false);
      }
    } catch (e) {
      print("Error during registration: $e");
    } finally {
      isLoading = true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Vendor Registration',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
              const SizedBox(height: 16),
              _buildStepContent(),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _previousTab,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCB0033),
                      ),
                      child: const Text(
                        'Previous',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (isLoading && _step == 3)
                          ? null // disable if loading and on last step
                          : (_step == 3 ? _registerVendor : _nextTab),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _step == 3
                            ? Colors.green
                            : const Color(0xFFCB0033),
                      ),
                      child: (_step == 3 && isLoading)
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _step == 3 ? 'Register' : 'Next',
                              style: const TextStyle(color: Colors.white),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLine() {
    return Expanded(child: Container(height: 2, color: Colors.grey));
  }
}

/* ----------------- PersonalInformation ----------------- */

class PersonalInformation extends StatefulWidget {
  final Map<String, dynamic> formData;

  const PersonalInformation({super.key, required this.formData});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  late final TextEditingController _usernameController;
  late final TextEditingController _vendorNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;

  late List<dynamic> stateList = [];
  late List<dynamic> cityList = [];

  // Step keys
  final _step1Key = GlobalKey<FormState>();

  void _loadStates() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/location/states'),
      );

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        setState(() {
          stateList = decodedJson;
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void _loadCitiesByState(String state) async {
    final response = await http.get(
      Uri.parse('${AppConstants.BASE_URL}/location/cities?state=$state'),
    );
    if (response.statusCode == 200) {
      setState(() {
        cityList = json.decode(response.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadStates();
    _usernameController = TextEditingController(
      text: widget.formData['username'] ?? '',
    );
    _vendorNameController = TextEditingController(
      text: widget.formData['vendor_name'] ?? '',
    );
    _emailController = TextEditingController(
      text: widget.formData['email'] ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.formData['password'] ?? '',
    );
    _confirmPasswordController = TextEditingController(
      text: widget.formData['confirmPassword'] ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.formData['phone_no'] ?? '',
    );
    _cityController = TextEditingController(
      text: widget.formData['city'] ?? '',
    );
    _stateController = TextEditingController(
      text: widget.formData['state'] ?? '',
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _vendorNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  InputDecoration _dec(String hint, IconData icon) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF414141)),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF474747)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xB35484FF)),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _step1Key,
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: _dec('Username', Icons.person),
              onChanged: (v) => widget.formData['username'] = v,
              validator: (value) =>
              value == null || value.trim().isEmpty ? 'Username is required' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _vendorNameController,
              decoration: _dec('Vendor name', Icons.person),
              onChanged: (v) => widget.formData['vendor_name'] = v,
              validator: (value) =>
              value == null || value.trim().isEmpty ? 'Vendor name is required' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: _dec('Email', Icons.email),
              keyboardType: TextInputType.emailAddress,
              onChanged: (v) => widget.formData['email'] = v,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _phoneController,
              decoration: _dec('Phone', Icons.call),
              keyboardType: TextInputType.phone,
              onChanged: (v) => widget.formData['phone_no'] = v,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Phone number is required';
                }
                if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                  return 'Enter a valid 10-digit phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _stateController.text.isNotEmpty
                  ? _stateController.text
                  : null,
              decoration: _dec('State', Icons.location_on),
              items: stateList
                  .map<DropdownMenuItem<String>>(
                    (state) => DropdownMenuItem<String>(
                  value: state,
                  child: Text(state),
                ),
              )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  _stateController.text = value;
                  widget.formData['state'] = value;
                  _loadCitiesByState(value);
                }
              },
              validator: (value) => value == null || value.isEmpty
                  ? 'Please select a state'
                  : null,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _cityController.text.isNotEmpty
                  ? _cityController.text
                  : null,
              decoration: _dec('City', Icons.location_on),
              items: cityList
                  .map<DropdownMenuItem<String>>(
                    (city) => DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                ),
              )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  _cityController.text = value;
                  widget.formData['city'] = value;
                }
              },
              validator: (value) => value == null || value.isEmpty
                  ? 'Please select a city'
                  : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: _dec('Password', Icons.lock),
              obscureText: true,
              onChanged: (v) => widget.formData['password'] = v,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: _dec('Confirm password', Icons.lock),
              obscureText: true,
              onChanged: (v) => widget.formData['confirmPassword'] = v,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

/* ----------------- BusinessInformation ----------------- */

class BusinessInformation extends StatefulWidget {
  final Map<String, dynamic> formData;
  const BusinessInformation({super.key, required this.formData});

  @override
  State<BusinessInformation> createState() => _BusinessInformationState();
}

class _BusinessInformationState extends State<BusinessInformation> {
  late final TextEditingController _businessNameController;
  late final TextEditingController _businessCategoryController;
  late final TextEditingController _gstController;
  late final TextEditingController _termsController;

  late List<dynamic> categoryList = [];

  void _loadCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}/resources/categories'),
      );

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        setState(() {
          categoryList = decodedJson;
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _businessNameController = TextEditingController(
      text: widget.formData['business_name'] ?? '',
    );
    _businessCategoryController = TextEditingController(
      text: widget.formData['business_category'] ?? '',
    );
    _gstController = TextEditingController(
      text: widget.formData['gst_number'] ?? '',
    );
    _termsController = TextEditingController(
      text: widget.formData['terms_and_conditions'] ?? '',
    );
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessCategoryController.dispose();
    _gstController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  InputDecoration _dec(String hint, IconData icon, {double bottomPad = 0}) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
      prefixIcon: bottomPad > 0
          ? Padding(
              padding: EdgeInsets.only(bottom: bottomPad),
              child: Icon(icon, color: const Color(0xFF414141)),
            )
          : Icon(icon, color: const Color(0xFF414141)),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF474747)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xB35484FF)),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          TextFormField(
            controller: _businessNameController,
            decoration: _dec('Business name', Icons.storefront),
            onChanged: (v) => widget.formData['business_name'] = v.trim(),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _businessCategoryController.text.isNotEmpty
                ? _businessCategoryController.text
                : null,
            decoration: _dec('City', Icons.category),
            items: categoryList
                .map<DropdownMenuItem<String>>(
                  (category) => DropdownMenuItem<String>(
                    value: category['category_name'],
                    child: Text(category['category_name']),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                _businessCategoryController.text = value;
                widget.formData['business_category'] = value;
              }
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _gstController,
            decoration: _dec('GSTIN number', Icons.receipt_long),
            onChanged: (v) => widget.formData['gst_number'] = v.trim(),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _termsController,
            decoration: _dec(
              'Terms & conditions',
              Icons.text_snippet,
              bottomPad: 95,
            ),
            maxLines: 5,
            onChanged: (v) =>
                widget.formData['terms_and_conditions'] = v.trim(),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

/* ----------------- DocumentUpload ----------------- */

class DocumentUpload extends StatefulWidget {
  final Map<String, dynamic> formData;
  const DocumentUpload({super.key, required this.formData});

  @override
  State<DocumentUpload> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
  File? _aadharCard;
  File? _vendorPAN;
  File? _businessPAN;
  File? _electricityBill;
  File? _license;
  List<File> _businessPhotos = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickSingle(String fieldKey) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (picked == null) return;
      final file = File(picked.path);
      setState(() {
        switch (fieldKey) {
          case 'vendor_aadharCard':
            _aadharCard = file;
            widget.formData['vendor_aadharCard'] = file;
            break;
          case 'vendor_PAN':
            _vendorPAN = file;
            widget.formData['vendor_PAN'] = file;
            break;
          case 'business_PAN':
            _businessPAN = file;
            widget.formData['business_PAN'] = file;
            break;
          case 'electricity_bill':
            _electricityBill = file;
            widget.formData['electricity_bill'] = file;
            break;
          case 'liscence':
            _license = file;
            widget.formData['liscence'] = file;
            break;
        }
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _pickMultipleBusinessPhotos() async {
    try {
      final List<XFile>? picked = await _picker.pickMultiImage();
      if (picked == null || picked.isEmpty) return;
      final files = picked.map((x) => File(x.path)).toList();
      setState(() {
        _businessPhotos.addAll(files);
        widget.formData['business_photos'] = _businessPhotos;
      });
    } catch (e) {
      print('Error picking multiple images: $e');
    }
  }

  Widget _uploadBox(
    String title,
    File? f,
    VoidCallback onTap, {
    bool multiple = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
            ),
            child: f == null
                ? Center(
                    child: Text(
                      multiple
                          ? "Click to upload (multiple)"
                          : "Click to upload",
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      f,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Note: for business_photos we show first photo preview if any
    File? firstBusinessPhoto = _businessPhotos.isNotEmpty
        ? _businessPhotos.first
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _uploadBox(
              "Aadhar Card",
              _aadharCard,
              () => _pickSingle('vendor_aadharCard'),
            ),
            _uploadBox("PAN Card", _vendorPAN, () => _pickSingle('vendor_PAN')),
            _uploadBox(
              "Business PAN Card",
              _businessPAN,
              () => _pickSingle('business_PAN'),
            ),
            _uploadBox(
              "Electricity Bill",
              _electricityBill,
              () => _pickSingle('electricity_bill'),
            ),
            _uploadBox("License", _license, () => _pickSingle('liscence')),
            _uploadBox(
              "Business Photos",
              firstBusinessPhoto,
              _pickMultipleBusinessPhotos,
              multiple: true,
            ),
            const SizedBox(height: 8),
            if (_businessPhotos.isNotEmpty)
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _businessPhotos.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.file(
                        _businessPhotos[i],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
