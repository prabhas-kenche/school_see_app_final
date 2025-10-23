import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';

class GatePassPage extends StatelessWidget {
  const GatePassPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example gate pass data
    final String studentName = "John Doe";
    final String reason = "Medical Appointment";
    final DateTime exitTime = DateTime.now();
    final String parentName = "Jane Doe"; // Parent name
    final String classSection = "9th-a";
    final String relationship = "Mother"; // Relationship with student
   

    final String qrData =
        "Student: $studentName\nReason: $classSection \n $reason\nExit Time: ${DateFormat('yyyy-MM-dd HH:mm').format(exitTime)}\nParent: $parentName\nRelationship: $relationship";

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Digital Gate Pass"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueGrey.withOpacity(0.5),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Animation
            Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    "Gate Pass Details",
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
                repeatForever: true,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 12),
              height: screenHeight * 0.17,
              width: screenWidth * 0.87,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(208, 223, 219, 0.898),
                borderRadius: BorderRadius.circular(45),
                border: Border.all(color: Colors.white),
              ),
              child: Image.asset(
                'assets/images/school_see_logo.png', // Ensure this path is correct
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            // Gate Pass Details Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gate Pass Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildDetailRow(Icons.person, "Student Name", studentName),
                    _buildDetailRow(Icons.crop_landscape_sharp, "Class-", classSection),
                    _buildDetailRow(Icons.info, "Reason", reason),
                    _buildDetailRow(
                      Icons.access_time,
                      "Exit Time",
                      DateFormat('yyyy-MM-dd HH:mm').format(exitTime),
                    ),
                    _buildDetailRow(Icons.supervised_user_circle, "Parent Name", parentName),
                    _buildDetailRow(Icons.people_alt, "Relationship", relationship),
                    
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // QR Code Section
            Center(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Scan this QR Code at the Gate",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 200,
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}