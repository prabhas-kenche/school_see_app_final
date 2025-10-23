import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const AttendanceScreen());
}

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color.fromARGB(255, 236, 152, 27),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      home: const AttendanceDashboard(),
    );
  }
}

class AttendanceDashboard extends StatefulWidget {
  const AttendanceDashboard({super.key});

  @override
  _AttendanceDashboardState createState() => _AttendanceDashboardState();
}

class _AttendanceDashboardState extends State<AttendanceDashboard> {
  // Get current date and weekday dynamically
  DateTime _currentDate = DateTime.now();

  String _getWeekdayName(int weekday) {
    final List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[weekday - 1];
  }

  void _updateDate() {
    setState(() {
      _currentDate = DateTime.now();
    });
  }

  // Message feature variables
  final List<String> _reasons = [
    'Sick Leave',
    'Family Emergency',
    'Personal Reasons',
    'Functional Occasion',
    'Other'
  ];
  String? _selectedReason;
  final TextEditingController _detailedReasonController = TextEditingController();
  String? _attachmentPath;
  bool _isMessageSent = false;

  void _sendMessage(BuildContext context) {
    setState(() {
      _isMessageSent = true;

      // Reset message-related variables
      _selectedReason = null;
      _detailedReasonController.clear();
      _attachmentPath = null;
    });

    // Close the dialog
    Navigator.pop(context);

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message Delivered'),
        duration: Duration(seconds: 2),
      ),
    );

    // Optionally, you can navigate back to the same page
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const AttendanceDashboard()),
    // );
  }

  Future<void> _requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      // Permission granted, proceed with file picking
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission is required')),
      );
    }
  }

  Future<void> _pickAttachment() async {
    // Request storage permission
    if (await Permission.storage.request().isGranted) {
      // Use file_picker to pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _attachmentPath = result.files.single.path; // Get the file path
        });
      } else {
        // User canceled the picker
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No file selected')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission is required')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Dashboard'),
        backgroundColor: const Color.fromARGB(255, 234, 174, 22),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _updateDate,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 234, 174, 22),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Top Card
              Card(
                elevation: 6,
                color: Color.fromRGBO(77, 231, 149, 0.59),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dynamic Date and Week Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_currentDate.day}',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 239, 42, 98),
                                ),
                              ),
                              Text(
                                _getWeekdayName(_currentDate.weekday),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 20, 19, 16),
                                ),
                              ),
                              Text(
                                '${_currentDate.month}/${_currentDate.year}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 21, 19, 13),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: _updateDate,
                            icon: const Icon(
                              Icons.refresh,
                              size: 38,
                              color: Color.fromARGB(255, 244, 84, 31),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "This week status",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildWeekStatus('M', true),
                          _buildWeekStatus('T', false, isAbsent: true),
                          _buildWeekStatus('W', true),
                          _buildWeekStatus('Th', false),
                          _buildWeekStatus('Fr', false),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Bottom Cards with Circular Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCircularCard('90', 'Attendance', const Color.fromARGB(255, 74, 219, 134)),
                  _buildCircularCard('03', 'Leave Taken', const Color.fromARGB(255, 183, 58, 173)),
                  _buildCircularCard('23', 'Ongoing Days', Colors.blueAccent),
                ],
              ),
              const SizedBox(height: 20),
              // Call and Message Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Simulate a call to the teacher
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Calling the teacher...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.call, color: Colors.black),
                    label: const Text('Call Teacher'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 69, 202, 73),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Send Leave Message'),
                          content: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      labelText: 'Select Reason',
                                    ),
                                    value: _selectedReason,
                                    items: _reasons.map((reason) {
                                      return DropdownMenuItem<String>(
                                        value: reason,
                                        child: Text(reason),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedReason = value;
                                      });
                                    },
                                  ),
                                  if (_selectedReason != null)
                                    TextFormField(
                                      controller: _detailedReasonController,
                                      decoration: const InputDecoration(
                                        labelText: 'Detailed Explanation',
                                      ),
                                    ),
                                  if (_selectedReason != null)
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: _pickAttachment,
                                          child: const Text('Attach File'),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(_attachmentPath?.split('/').last ?? "No file attached"),
                                      ],
                                    ),
                                ],
                              );
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  // Reset message-related variables
                                  _selectedReason = null;
                                  _detailedReasonController.clear();
                                  _attachmentPath = null;
                                });
                                Navigator.pop(context); // Close the dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _sendMessage(context); // Send the message
                              },
                              child: const Text('Send'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.message, color: Colors.black),
                    label: const Text('Send Message'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 240, 238, 237),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              if (_isMessageSent)
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Message Delivered!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 232, 172, 31),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekStatus(String day, bool isPresent, {bool isAbsent = false}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: isPresent
              ? const Color.fromARGB(255, 53, 228, 64)
              : isAbsent
                  ? Colors.red
                  : Colors.grey.shade300,
          child: Icon(
            isPresent
                ? Icons.check
                : isAbsent
                    ? Icons.close
                    : Icons.circle,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isPresent
                ? const Color.fromARGB(255, 53, 237, 50)
                : isAbsent
                    ? Colors.red
                    : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildCircularCard(String value, String label, Color color) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 100,
        height: 120,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular Progress Indicator
            Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.83, // Replace with dynamic value
                  strokeWidth: 8,
                  backgroundColor: Colors.grey.shade300,
                  color: color,
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}