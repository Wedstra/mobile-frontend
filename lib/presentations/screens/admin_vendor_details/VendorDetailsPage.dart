import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wedstra_mobile_app/constants/app_constants.dart';
import 'package:wedstra_mobile_app/presentations/widgets/snakbar_component/snakbars.dart';
import '../../../data/services/Auth_Service/user_services/user_services.dart';

class Vendordetailspage extends StatefulWidget {
  final Map<String, dynamic> vendor;

  const Vendordetailspage({super.key, required Map<String, dynamic> this.vendor});

  @override
  State<Vendordetailspage> createState() => _VendordetailspageState();
}



class _VendordetailspageState extends State<Vendordetailspage> {
  String? token;

  Future<void> _getToken() async {
    String storedToken = await getToken();

    if (storedToken != null) {
      setState(() {
        token = storedToken;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vendor["vendor_name"] ?? "Vendor Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Photo
            if (widget.vendor['business_photos'] != null &&
                widget.vendor['business_photos'].isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.vendor['business_photos'][0],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),

            Row(
              spacing: 5,
              children: [
                Text("Business Name:",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${widget.vendor['business_name'] ?? 'N/A'}',style: const TextStyle(fontSize: 18,)),
              ],
            ),
            Row(
              spacing: 5,
              children: [
                Text("Category:",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${widget.vendor['business_category'] ?? 'N/A'}',style: const TextStyle(fontSize: 18,)),
              ],
            ),
            Row(
              spacing: 5,
              children: [
                Text("City:",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${widget.vendor['city'] ?? 'N/A'}',style: const TextStyle(fontSize: 18,)),
              ],
            ),


            const SizedBox(height: 5),

            const Text("Documents",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 5),

            _buildDocumentTile("Aadhar Card", widget.vendor["vendor_aadharCard"]),
            _buildDocumentTile("Vendor PAN", widget.vendor["vendor_PAN"]),
            _buildDocumentTile("Business PAN", widget.vendor["business_PAN"]),
            _buildDocumentTile("Electricity Bill", widget.vendor["electricity_bill"]),
            _buildDocumentTile("License", widget.vendor["liscence"]),
            _buildPhotosTile("Business Photos", widget.vendor["business_photos"]),
          ],
        ),
      ),
      bottomNavigationBar:
      !widget.vendor['verified'] ?
      Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.vendor['verified'] ? Colors.red : Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            _toggleVendorStatus(context, widget.vendor['verified'], widget.vendor['id']);
          },
          child: Text(
            widget.vendor['verified'] ? "Unauthorize" : "Authorize",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    ) : null ,
    );
  }

  Widget _buildPhotosTile(String title, List<dynamic>? photos) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.photo_library, color: Colors.blue),
        onTap: () {
          if (photos != null && photos.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: Text(title)),
                  body: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // two images per row
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: photos.length,
                    itemBuilder: (_, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          photos[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }


  Widget _buildDocumentTile(String title, String? url) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title),
        trailing: Icon(Icons.picture_as_pdf, color: Colors.blue),
        onTap: () {
          if (url != null && url.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: Text(title)),
                  body: Center(
                    child: Image.network(url),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // handle authorize/unauthorize action
  void _toggleVendorStatus(BuildContext context, bool isCurrentlyVerifie, String vendorId) async {

    try {
      await _getToken();
      final response = await http.put(Uri.parse('${ AppConstants.BASE_URL }/vendor/verify/${vendorId}'),headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },);

      if(response.statusCode == 200){
        showSnack(context, 'Vendor marked as Authorized!');
        Navigator.pop(context);
      }
      else{
        showSnack(context, 'Something went wrong!',success: false);
      }
    } on Exception catch (e) {
      print(e);
    }

  }
}

