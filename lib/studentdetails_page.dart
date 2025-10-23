import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'main.dart';

void main() {
  runApp(const StudentDetailsApp());
}

class StudentDetailsApp extends StatelessWidget {
  const StudentDetailsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Profile',
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const StudentProfilePage(enrollId: '123456'), // Pass enrollId dynamically
    );
  }
}

class StudentProfilePage extends StatefulWidget {
  final String enrollId;

  const StudentProfilePage({super.key, required this.enrollId});

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  bool _isDarkMode = false;
  bool _isEditing = false;
  bool _isLoading = true;
  String? _errorMessage;
  XFile? _profileImage;

  // Form controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _dobController = TextEditingController(); // Add DOB controller
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.202.116:3000/api/profile/${widget.enrollId}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userData = data;
          _emailController.text = data['email'] ?? '';
          _phoneController.text = data['mobileNumber'] ?? '';
          _motherNameController.text = data['motherName'] ?? '';
          _fatherNameController.text = data['fatherName'] ?? '';
          _classController.text = data['class'] ?? '';
          _dobController.text = data['dob'] ?? ''; // Populate DOB controller
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = jsonDecode(response.body)['error'] ?? 'Failed to load profile';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error connecting to server: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_isEditing) {
      setState(() {
        _isLoading = true;
      });

      final uri = Uri.parse('http://192.168.0.245:3000/api/profile/${widget.enrollId}');
      final request = http.MultipartRequest('PUT', uri);

      // Add text fields
      request.fields['motherName'] = _motherNameController.text.trim();
      request.fields['fatherName'] = _fatherNameController.text.trim();
      request.fields['class'] = _classController.text.trim();
      request.fields['email'] = _emailController.text.trim();
      request.fields['mobileNumber'] = _phoneController.text.trim();
      request.fields['dob'] = _dobController.text.trim(); // Add DOB to update request

      // Add profile image if selected
      if (_profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profileImage',
          _profileImage!.path,
        ));
      }

      try {
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          await _fetchProfile(); // Refresh data
          setState(() {
            _profileImage = null; // Clear selected image
            _isEditing = false;
          });
        } else {
          setState(() {
            _errorMessage = jsonDecode(responseBody)['error'] ?? 'Failed to update profile';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error connecting to server: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isEditing = true;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile;
      });
    }
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade400, Colors.teal.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Switch(
            value: _isDarkMode,
            onChanged: _toggleDarkMode,
            activeColor: Colors.orange,
          ),
        ],
      ),
      body: Theme(
        data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Student Image
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundImage: _profileImage != null
                                    ? FileImage(File(_profileImage!.path))
                                    : _userData['profileImage'] != null
                                        ? NetworkImage('http://192.168.0.245:3000${_userData['profileImage']}')
                                        : const AssetImage('assets/images/studentprofile.png') as ImageProvider,
                              ),
                              if (_isEditing)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.teal,
                                    child: IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.white, size: 16),
                                      onPressed: _pickImage,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Student Name
                        Text(
                          '${_userData['studentFirstName'] ?? ''} ${_userData['studentLastName'] ?? ''}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: _isDarkMode ? Colors.white : Colors.teal.shade700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Student ID
                        Text(
                          'ID: ${widget.enrollId}',
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        // Student Details Card
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: _isDarkMode ? Colors.grey[900] : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                // Mother's Name
                                TextFormField(
                                  controller: _motherNameController,
                                  enabled: _isEditing,
                                  decoration: InputDecoration(
                                    labelText: "Mother's Name",
                                    prefixIcon: const Icon(Icons.person, color: Colors.teal),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: _isDarkMode ? Colors.grey[850] : Colors.grey[50],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Father's Name
                                TextFormField(
                                  controller: _fatherNameController,
                                  enabled: _isEditing,
                                  decoration: InputDecoration(
                                    labelText: "Father's Name",
                                    prefixIcon: const Icon(Icons.person, color: Colors.teal),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: _isDarkMode ? Colors.grey[850] : Colors.grey[50],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Date of Birth
                                TextFormField(
                                  controller: _dobController,
                                  enabled: _isEditing,
                                  decoration: InputDecoration(
                                    labelText: "Date of Birth (DD/MM/YYYY)", // Add DOB field
                                    prefixIcon: const Icon(Icons.calendar_today, color: Colors.teal),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: _isDarkMode ? Colors.grey[850] : Colors.grey[50],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Class
                                TextFormField(
                                  controller: _classController,
                                  enabled: _isEditing,
                                  decoration: InputDecoration(
                                    labelText: 'Class',
                                    prefixIcon: const Icon(Icons.school, color: Colors.teal),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: _isDarkMode ? Colors.grey[850] : Colors.grey[50],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Email
                                TextFormField(
                                  controller: _emailController,
                                  enabled: _isEditing,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: const Icon(Icons.email, color: Colors.teal),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: _isDarkMode ? Colors.grey[850] : Colors.grey[50],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Phone
                                TextFormField(
                                  controller: _phoneController,
                                  enabled: _isEditing,
                                  decoration: InputDecoration(
                                    labelText: 'Phone',
                                    prefixIcon: const Icon(Icons.phone, color: Colors.teal),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: _isDarkMode ? Colors.grey[850] : Colors.grey[50],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Edit/Save Button
                        ElevatedButton.icon(
                          onPressed: _updateProfile,
                          icon: Icon(_isEditing ? Icons.save : Icons.edit, color: Colors.white),
                          label: Text(
                            _isEditing ? 'Save Changes' : 'Edit Profile',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                            shadowColor: Colors.teal.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Logout Button
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const SchoolSeeApp()),
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.logout_outlined, color: Colors.white),
                          label: const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: const Color.fromARGB(255, 232, 6, 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                            shadowColor: Colors.teal.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Additional Information
                        Text(
                          'Additional Information',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _isDarkMode ? Colors.white : Colors.teal.shade700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '''School Timings:
First Bell Rings At 8:00 AM
Parents Can Pick Their Children From School Premises After 3:00 PM.''',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
