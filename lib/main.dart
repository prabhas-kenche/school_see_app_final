import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'registrationpage.dart';
import 'reset-password.dart';
import 'navigation.dart';
import 'dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SchoolSeeApp());
}

class SchoolSeeApp extends StatelessWidget {
  const SchoolSeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School See - Parent Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        fontFamily: 'Arial',
      ),
      home: Navigation(initialScreen: const AdminLoginPage()),
    );
  }
}

class AdminLoginPage extends StatelessWidget {
  const AdminLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with shadow styling
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        offset: const Offset(5, 5),
                        blurRadius: 15,
                      ),
                      const BoxShadow(
                        color: Colors.white,
                        offset: Offset(-5, -5),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: const Color(0xFFE0E5EC),
                    backgroundImage: AssetImage(
                      'assets/images/school_see_logo.png',
                    ),
                  ),
                ),
              ),
              // Container with form
              Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Login Title
                    const Text(
                      'Parent Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Login Form
                    const LoginForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm();

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController enrollIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  String _errorMessage = '';

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final enrollId = enrollIdController.text.trim();
    final password = passwordController.text.trim();
    try {
      final response = await http.post(
        Uri.parse('http://192.168.202.116:3000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'enrollId': enrollId, 'password': password}),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful')),
        );
        // Store the enrollId before navigating
        final loggedInEnrollId = enrollId; 
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            // Pass the logged-in enrollId to the Navigation widget
            builder: (_) => Navigation(enrollId: loggedInEnrollId, initialScreen: const DashboardScreen()), 
          ),
        );
      } else {
        final responseBody = jsonDecode(response.body);
        setState(() {
          _errorMessage = responseBody['error'] ?? 'An error occurred';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error connecting to server: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                'Enroll ID',
                enrollIdController,
                'Enter Your Enroll ID',
              ),
              _buildPasswordField(
                'Password',
                passwordController,
                'Enter Your Password',
              ),
            ],
          ),
        ),
        if (_errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _login,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF97C8D6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Login',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrationPage(),
                  ),
                );
              },
              child: const Text(
                'Register',
                style: TextStyle(color: Color(0xFF007AFF)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResetPasswordScreen(),
                  ),
                );
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: Color(0xFFE53D6D)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
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
                      offset: const Offset(-10, -12),
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
                  obscureText: !_isPasswordVisible,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
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

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
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
