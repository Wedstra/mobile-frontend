import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../constants/app_constants.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  late var _isLoading = false;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _mobileNoController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGender;

  final _formKey = GlobalKey<FormState>();

  void _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'User Registration',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Register for getting started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _firstNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'First name is required';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          prefixIcon: Icon(Iconsax.user),
                          labelText: 'First Name',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF474747),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(AppConstants.primaryColor),
                              width: 1,
                            ),
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
                          fillColor: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _lastNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Last name is required';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          prefixIcon: Icon(Iconsax.user_tick),
                          labelText: 'Last Name',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF474747),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(AppConstants.primaryColor),
                              width: 1,
                            ),
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
                          fillColor: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _userNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          prefixIcon: Icon(Iconsax.profile_circle),
                          labelText: 'Username',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF474747),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(AppConstants.primaryColor),
                              width: 1,
                            ),
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
                          fillColor: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          prefixIcon: Icon(Iconsax.sms),
                          labelText: 'Email',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF474747),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(AppConstants.primaryColor),
                              width: 1,
                            ),
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
                          fillColor: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }

                          if (value.length < 6) {
                            return 'Password must contain minium 6 characters';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          prefixIcon: Icon(Iconsax.password_check),
                          suffixIcon: Icon(Iconsax.eye_slash),
                          labelText: 'Password',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF474747),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(AppConstants.primaryColor),
                              width: 1,
                            ),
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
                          fillColor: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }

                          if (value.length < 6) {
                            return 'Password must contain minium 6 characters';
                          }

                          if (_passwordController.text != value ||
                              _passwordController.text.length != value.length) {
                            return 'Password does not match above field';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          prefixIcon: Icon(Iconsax.password_check),
                          labelText: 'Confirm Password',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF474747),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(AppConstants.primaryColor),
                              width: 1,
                            ),
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
                          fillColor: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _mobileNoController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone is required';
                          }

                          if (value.length < 10 || value.length > 10) {
                            return 'Phone must contain only 10 digits';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          prefixIcon: Icon(Iconsax.call),
                          labelText: 'Phone',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF474747),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(AppConstants.primaryColor),
                              width: 1,
                            ),
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
                          fillColor: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () => _pickDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _dateOfBirthController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Date of Birth is required';
                              }
                              return null;
                            },
                            readOnly: true,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              prefixIcon: Icon(Iconsax.calendar),
                              suffixIcon: Icon(Icons.arrow_drop_down),
                              labelText: 'Date of Birth',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF474747),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(AppConstants.primaryColor),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          _showGenderDialog(context);
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _genderController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Gender is required';
                              }
                              return null;
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              prefixIcon: Icon(Iconsax.personalcard),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF474747),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(AppConstants.primaryColor),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        maxLines: 3,
                        controller: _addressController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Address is required';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          prefixIcon: Icon(Iconsax.location),
                          labelText: 'Address',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF474747),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(AppConstants.primaryColor),
                              width: 1,
                            ),
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
                          fillColor: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(AppConstants.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            disabledBackgroundColor: Color(0xFFD63F66),
                          ),
                          onPressed: _isLoading ? null : _registerUser,
                          child: _isLoading
                              ? Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _registerUser() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      // All fields are valid
      String firstName = _firstNameController.text.trim();
      String lastName = _lastNameController.text.trim();
      String username = _userNameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text;
      String confirmPassword = _confirmPasswordController.text;
      String mobileNo = _mobileNoController.text.trim();
      String dob = _dateOfBirthController.text;
      String gender = _genderController.text;
      String address = _addressController.text;

      if (password != confirmPassword) {
        // show error only for confirm password
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Passwords do not match')));
        return;
      }

      print("First Name: ${_firstNameController.text}");
      print("Last Name: ${_lastNameController.text}");
      print("Username: ${_userNameController.text}");
      print("Email: ${_emailController.text}");
      print("Password: ${_passwordController.text}");
      print("Mobile No: ${_mobileNoController.text}");
      print("DOB: ${_dateOfBirthController.text}");
      print("Gender: ${_genderController.text}");
      print("Address: ${_addressController.text}");


      // var requestBody = {
      //   "firstname": "Yuvraj",
      //   "lastname": "Lolage",
      //   "username": "yuvraj123",
      //   "email": "yuvraj@example.com",
      //   "password": "your_password",
      //   "mobileNo": "9876543210",
      //   "dob": "2000-05-23",
      //   "gender": "Male",
      //   "address": "Mumbai, India",
      //   "roles": [],
      //   "role": "USER",
      //   "planType": "FREE",
      // };

      var requestBody = {
        "firstname": _firstNameController.text.trim(),
        "lastname": _lastNameController.text.trim(),
        "username": _userNameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
        "mobileNo": _mobileNoController.text.trim(),
        "dob": _dateOfBirthController.text,
        "gender": _genderController.text,
        "address": _addressController.text.trim(),
        "roles": [],
        "role": "USER",
        "planType": "FREE",
      };

      try {
        final response = await http.post(
          Uri.parse('${AppConstants.BASE_URL}/user/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green[500],
              content: Text(
                'User Register Success!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
          Navigator.pop(context);
        } else {
          print("Failed with status: ${response.statusCode}");
          print("Body: ${response.body}");
        }
      } catch (e) {
        print("Exception: $e");
      }
    } else {
      // If form is not valid, it will auto show field errors
      print("Form not valid");
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showGenderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Gender'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Male'),
              leading: Radio<String>(
                value: 'Male',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                    _genderController.text = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              onTap: () {
                setState(() {
                  _selectedGender = 'Male';
                  _genderController.text = 'Male';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Female'),
              leading: Radio<String>(
                value: 'Female',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                    _genderController.text = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              onTap: () {
                setState(() {
                  _selectedGender = 'Female';
                  _genderController.text = 'Female';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Other'),
              leading: Radio<String>(
                value: 'Other',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                    _genderController.text = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              onTap: () {
                setState(() {
                  _selectedGender = 'Other';
                  _genderController.text = 'Other';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
