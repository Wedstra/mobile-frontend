import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Center'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(
                Icons.support_agent,
                size: 100,
                color: Color(AppConstants.primaryColor),
              ),
              const SizedBox(height: 16),
              const Text(
                'We’re Here to Help!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'If you have any questions, feedback, or need assistance, please feel free to reach out to us.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: const ListTile(
                  leading: Icon(Icons.email, color: Colors.blue),
                  title: Text(AppConstants.EMAIL),
                  subtitle: Text('Drop us an email anytime'),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: (){},
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: const ListTile(
                    leading: Icon(Icons.phone, color: Colors.green),
                    title: Text('+91 98765 43210'),
                    subtitle: Text('Available Mon–Sat, 9 AM – 6 PM'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '* Note: Our coordinator will respond within 2–3 working days.',
                style: TextStyle(fontSize: 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
