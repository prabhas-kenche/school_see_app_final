import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parent Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentFirstNameController = TextEditingController();
  final TextEditingController _studentLastNameController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _enrollIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  bool _obscureText = true;
  bool _obscureConfirmText = true;

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    final url = Uri.parse('http://192.168.202.116:3000/api/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'studentFirstName': _studentFirstNameController.text.trim(),
          'studentLastName': _studentLastNameController.text.trim(),
          'class': _classController.text.trim(),
          'dob': _dobController.text.trim(),
          'fatherName': _fatherNameController.text.trim(),
          'motherName': _motherNameController.text.trim(),
          'email': _emailController.text.trim(),
          'enrollId': _enrollIDController.text.trim(),
          'mobileNumber': _mobileNumberController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SchoolSeeApp()),
        );
      } else {
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${responseBody['error']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error connecting to server: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      appBar: AppBar(
        title: const Text(
          'Parent Registration',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E5EC),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade500,
                  offset: const Offset(10, 10),
                  blurRadius: 20,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-10, -10),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Register',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                      'Student First Name',
                      _studentFirstNameController,
                      'Enter your first name'),
                  _buildTextField(
                      'Student Last Name',
                      _studentLastNameController,
                      'Enter your last name'),
                  _buildTextField('Class', _classController, 'Enter class'),
                  _buildTextField(
                      'Date of Birth', _dobController, '(DD/MM/YYYY)'),
                  _buildTextField(
                      'Father Name', _fatherNameController, 'Father name'),
                  _buildTextField(
                      'Mother Name', _motherNameController, 'Mother name'),
                  _buildTextField(
                      'Email ID', _emailController, 'Enter your email'),
                  _buildTextField(
                      'Mobile Number', _mobileNumberController, 'Enter your mobile number'),
                  _buildTextField('EnrollId', _enrollIDController, 'EnrollId'),
                  _buildPasswordField(
                      'Password',
                      _passwordController,
                      'Enter a secure password',
                      _obscureText,
                      (value) => setState(() => _obscureText = value)),
                  const Text(
                    "Password must be 8+ characters with a number & symbol",
                    style: TextStyle(fontSize: 12),
                  ),
                  _buildPasswordField(
                      'Confirm Password',
                      _confirmPasswordController,
                      'Re-enter your password',
                      _obscureConfirmText,
                      (value) => setState(() => _obscureConfirmText = value)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const SchoolSeeApp()),
                          );
                        },
                        child: const Text(
                          'Back to Login',
                          style: TextStyle(color: Color(0xFF007AFF)),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF97C8D6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                  color: const Color.fromARGB(255, 189, 189, 189).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: Offset(-10, -12),
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      blurRadius: 7,
                      offset: Offset(10, 10),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: controller,
                  style: const TextStyle(color: Colors.black87),
                  keyboardType: label.contains('Mobile Number') ? TextInputType.phone : TextInputType.text,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.black45.withOpacity(0.6)),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter $label';
                    }
                    if (label == 'Mobile Number' && (value.length < 10 || !RegExp(r'^[0-9]+$').hasMatch(value))) {
                      return 'Please enter a valid 10-digit mobile number';
                    }
                    if (label == 'Email ID' && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, String hint, bool obscureText, Function(bool) onVisibilityChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                  color: const Color.fromARGB(255, 189, 189, 189).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: Offset(-10, -12),
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      blurRadius: 7,
                      offset: Offset(10, 10),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: controller,
                  obscureText: obscureText,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.red,
                      ),
                      onPressed: () => onVisibilityChanged(!obscureText),
                    ),
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.black45.withOpacity(0.6)),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter $label';
                    }
                    if (label == 'Confirm Password' && value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    if (label == 'Password' && value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    if (label == 'Password' && (!RegExp(r'[0-9]').hasMatch(value) || !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value))) {
                      return 'Password must contain a number and a special character';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}