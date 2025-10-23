import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'otp_verification.dart';
import 'main.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _obscureText = true;
  bool _obscureConfirmText = true;
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController parentNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _requestOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://192.168.202.116:3000/api/request-reset-otp');
    final mobileNumber = parentNumberController.text.trim();
    final newPassword = newPasswordController.text.trim();

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mobileNumber': mobileNumber,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseBody['message'] ?? 'OTP requested successfully.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPVerificationScreen(
              mobileNumber: mobileNumber,
              newPassword: newPassword,
            ),
          ),
        );
      } else {
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${responseBody['error'] ?? 'Failed to request OTP'}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error connecting to server: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00C853),
      body: Column(
        children: [
          const SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Image.asset(
            'assets/images/forgot_password.png',
            height: 230,
            fit: BoxFit.contain,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFE0E5EC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildPasswordField(
                        'Enter New Password',
                        newPasswordController,
                        'Enter New Password',
                        _obscureText,
                        (value) {
                          setState(() {
                            _obscureText = value;
                          });
                        },
                      ),
                      const Text(
                        'Password must be 8+ characters with a number & symbol',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      _buildPasswordField(
                        'Confirm Password',
                        confirmPasswordController,
                        'Re-Enter Password',
                        _obscureConfirmText,
                        (value) {
                          setState(() {
                            _obscureConfirmText = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        'Parent Number',
                        parentNumberController,
                        'Enter Parent Number',
                        TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _requestOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF97C8D6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                ),
                                child: const Text(
                                  'Send OTP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    String hint,
    bool obscureText,
    Function(bool) onVisibilityChanged,
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
                  border: const Border(bottom: BorderSide(color: Colors.grey)),
                  color: const Color.fromARGB(255, 189, 189, 189).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(-10, -12),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.7),
                      blurRadius: 7,
                      offset: const Offset(10, 10),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: controller,
                  obscureText: obscureText,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () => onVisibilityChanged(!obscureText),
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: const Color.fromRGBO(229, 61, 109, 1),
                      ),
                    ),
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.black45.withOpacity(0.6)),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter $label';
                    }
                    if (label == 'Confirm Password' &&
                        value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    if (label == 'Enter New Password' && value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    if (label == 'Enter New Password' &&
                        (!RegExp(r'[0-9]').hasMatch(value) ||
                            !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value))) {
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

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
    TextInputType keyboardType,
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
                  border: const Border(bottom: BorderSide(color: Colors.grey)),
                  color: const Color.fromARGB(255, 189, 189, 189).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(-10, -12),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.7),
                      blurRadius: 7,
                      offset: const Offset(10, 10),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: controller,
                  style: const TextStyle(color: Colors.black87),
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.black45.withOpacity(0.6)),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter $label';
                    }
                    if (label.contains('Number') &&
                        (value.length < 10 || !RegExp(r'^[0-9]+$').hasMatch(value))) {
                      return 'Please enter a valid 10-digit mobile number';
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