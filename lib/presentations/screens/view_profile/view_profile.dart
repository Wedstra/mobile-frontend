import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key, this.profileData});

  final Map<String, dynamic>? profileData;

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  String formatDate(String? isoDate) {
    if (isoDate == null) return "Not Provided";
    try {
      DateTime date = DateTime.parse(isoDate);
      return "${date.day}-${date.month}-${date.year}";
    } catch (e) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Color(AppConstants.primaryColor);
    final profile = widget.profileData ?? {}; // fallback if null
    final role = profile['role'] ?? "USER";
    final bool isVendor = role == "VENDOR";

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: profile.isEmpty
          ? const Center(
        child: Text(
          "No profile data available",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accentColor.withOpacity(0.8), accentColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: isVendor &&
                        profile['business_photos'] != null &&
                        profile['business_photos'].isNotEmpty
                        ? NetworkImage(profile['business_photos'][0])
                        : null,
                    child: (!isVendor ||
                        profile['business_photos'] == null ||
                        profile['business_photos'].isEmpty)
                        ? const Icon(Icons.person,
                        size: 60, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isVendor
                        ? profile['vendor_name'] ?? "Vendor"
                        : profile['username'] ?? "Unknown",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Chip(
                    label: Text(role),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                        color: accentColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // USER Profile
            if (!isVendor) ...[
              sectionCard("Personal Info", [
        buildInfoRow(
        Icons.calendar_today,
        "Date of Birth",
        formatDate(profile['dob']), // just pass string
    accentColor,
    ),

    buildInfoRow(Icons.male, "Gender", profile['gender'],
                    accentColor),
                buildInfoRow(Icons.email, "Email", profile['email'],
                    accentColor),
                buildInfoRow(Icons.home, "Address", profile['address'],
                    accentColor),
              ]),
              sectionCard("Account Details", [
                buildInfoRow(Icons.workspace_premium, "Plan",
                    profile['planType'], accentColor),
                buildInfoRow(Icons.account_balance_wallet, "Budget",
                    profile['budget'] != null
                        ? "₹${profile['budget']}"
                        : "Not Provided",
                    accentColor),
              ]),
            ],

            // VENDOR Profile
            if (isVendor) ...[
              sectionCard("Business Details", [
                buildInfoRow(Icons.business, "Business Name",
                    profile['business_name'], accentColor),
                buildInfoRow(Icons.category, "Category",
                    profile['business_category'], accentColor),
                buildInfoRow(Icons.location_city, "City", profile['city'],
                    accentColor),
                buildInfoRow(Icons.confirmation_number, "GST Number",
                    profile['gst_number'], accentColor),
                buildInfoRow(Icons.workspace_premium, "Plan",
                    profile['planType'], accentColor),
                buildInfoRow(Icons.verified, "Verified",
                    profile['verified'] == true ? "Yes" : "No",
                    accentColor),
              ]),

              sectionCard("Terms & Conditions", [
                Text(profile['terms_and_conditions'] ?? "",
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black87)),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  Widget sectionCard(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(
      IconData icon, String title, dynamic value, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: accentColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600)),
          ),
          Flexible(
            flex: 2,
            child: Text(
              value?.toString() ?? "Not Provided",
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
