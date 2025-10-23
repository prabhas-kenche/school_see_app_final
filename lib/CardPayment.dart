import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'dart:async'; // Import for Timer functionality

class CardPaymentPage extends StatefulWidget {
  final String term;
  final int fee;

  const CardPaymentPage({
    super.key,
    required this.term,
    required this.fee,
  });

  @override
  _CardPaymentPageState createState() => _CardPaymentPageState();
}

class _CardPaymentPageState extends State<CardPaymentPage> {
  final TextEditingController _cardHolderNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _otpController = TextEditingController(); // OTP Input Field
  String? _selectedMonth;
  String? _selectedYear;
  String? _cardType;
  bool _isOTPSent = false;
  String _otp = '';
  int _otpTimer = 45; // OTP validity timer in seconds
  bool _isOTPValid = true; // Tracks if OTP is valid
  bool _isPaymentSuccessful = false; // Tracks payment success status

  final List<String> _months = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'];
  final List<String> _years = ['2023', '2024', '2025', '2026', '2027', '2028'];

  late Timer _timer; // Timer for OTP countdown

  @override
  void initState() {
    super.initState();
    _startOTPTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Function to detect card type
  void _detectCardType(String cardNumber) {
    if (cardNumber.startsWith(RegExp(r'4'))) {
      setState(() {
        _cardType = 'Visa';
      });
    } else if (cardNumber.startsWith(RegExp(r'5[1-5]'))) {
      setState(() {
        _cardType = 'MasterCard';
      });
    } else if (cardNumber.startsWith(RegExp(r'3[47]'))) {
      setState(() {
        _cardType = 'American Express';
      });
    } else {
      setState(() {
        _cardType = 'Unknown Card Type';
      });
    }
  }

  // Function to handle camera permission and open the camera
  Future<void> _scanCard() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(camera: firstCamera),
        ),
      ).then((scannedCardNumber) {
        if (scannedCardNumber != null) {
          setState(() {
            _cardNumberController.text = scannedCardNumber;
            _detectCardType(scannedCardNumber);
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Camera permission is required to scan the card.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Function to generate OTP
  void _generateOTP() {
    setState(() {
      _otp = '123456'; // Simulated OTP
      _isOTPSent = true;
      _otpTimer = 45; // Reset timer
      _isOTPValid = true; // Reset OTP validity
      _startOTPTimer();
    });
  }

  // Start OTP countdown timer
  void _startOTPTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_otpTimer > 0) {
          _otpTimer--;
        } else {
          _isOTPValid = false; // Mark OTP as invalid after 45 seconds
          timer.cancel();
        }
      });
    });
  }

  // Validate OTP and process payment
  void _validateOTP() {
    if (_otpController.text == _otp) {
      setState(() {
        _isPaymentSuccessful = true; // Mark payment as successful
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment Successful!'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid OTP. Please re-enter or regenerate OTP.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Card Payment',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Holder Name
                _buildTextField(
                  label: 'Card Holder Name',
                  controller: _cardHolderNameController,
                  hintText: 'Enter card holder name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),

                // Card Number
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Card Number',
                        controller: _cardNumberController,
                        hintText: '0000 - 0000 - 0000 - 0000',
                        keyboardType: TextInputType.number,
                        onChanged: (value) => _detectCardType(value),
                        icon: Icons.credit_card,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _scanCard,
                      icon: Icon(Icons.camera_alt, color: Colors.blue),
                      tooltip: 'Scan Card',
                    ),
                  ],
                ),
                if (_cardType != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Card Type: $_cardType',
                      style: TextStyle(fontSize: 14, color: Colors.green.shade700),
                    ),
                  ),
                const SizedBox(height: 16),

                // Expiry Date and CVV
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Expiry Month',
                        value: _selectedMonth,
                        items: _months,
                        onChanged: (value) => setState(() => _selectedMonth = value),
                        hintText: 'MM',
                        icon: Icons.calendar_today,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Expiry Year',
                        value: _selectedYear,
                        items: _years,
                        onChanged: (value) => setState(() => _selectedYear = value),
                        hintText: 'YYYY',
                        icon: Icons.calendar_today,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // CVV and Amount
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'CVV',
                        controller: _cvvController,
                        hintText: 'Enter CVV',
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        icon: Icons.lock,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: 'Amount to Pay',
                        controller: _amountController,
                        hintText: '₹${widget.fee}',
                        keyboardType: TextInputType.number,
                        icon: Icons.currency_rupee_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // OTP Section
                if (_isOTPSent)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OTP Sent: $_otp',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'OTP Validity: ${_isOTPValid ? '$_otpTimer seconds remaining' : 'Expired'}',
                        style: TextStyle(fontSize: 14, color: _isOTPValid ? Colors.green : Colors.red),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        label: 'Enter OTP',
                        controller: _otpController,
                        hintText: 'Enter OTP',
                        keyboardType: TextInputType.number,
                        icon: Icons.security,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _isOTPValid ? _validateOTP : null,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(150, 40),
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Pay',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _generateOTP();
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(150, 40),
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Regenerate OTP',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                // Send OTP Button
                if (!_isOTPSent)
                  ElevatedButton(
                    onPressed: () {
                      if (_cardHolderNameController.text.isNotEmpty &&
                          _cardNumberController.text.isNotEmpty &&
                          _cvvController.text.isNotEmpty &&
                          _amountController.text.isNotEmpty &&
                          _selectedMonth != null &&
                          _selectedYear != null) {
                        _generateOTP();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill all fields.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 245, 163, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Send OTP',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 21, 9, 9)),
                    ),
                  ),

                // Payment Success Message
                if (_isPaymentSuccessful)
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.check_circle, size: 50, color: Colors.green),
                        const SizedBox(height: 8),
                        Text(
                          'Payment Successful!',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
    IconData? icon,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textAlign: TextAlign.center,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, color: Colors.blue.shade600) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade600),
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hintText,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Center(child: Text(item, style: TextStyle(color: Colors.black87))),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, color: Colors.blue.shade600) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade600),
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }
}

// Dummy Camera Screen for Scanning Cards
class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({super.key, required this.camera});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan Card')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            // Simulate card number extraction (replace with actual OCR logic)
            Navigator.pop(context, '4111111111111111'); // Example card number
          } catch (e) {
            print(e);
          }
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}