import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UPIPaymentPage extends StatefulWidget {
  final String term;
  final int fee;

  const UPIPaymentPage({
    super.key,
    required this.term,
    required this.fee,
  });

  @override
  _UPIPaymentPageState createState() => _UPIPaymentPageState();
}

class _UPIPaymentPageState extends State<UPIPaymentPage> {
  final TextEditingController _upiIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _qrData;
  bool _isGenerated = false;
  bool _isTransactionSuccessful = false; // Tracks transaction success
  bool _isUpiIdValid = false; // Tracks if UPI ID is valid

  // Function to generate QR Code
  void _generateQRCode() {
    final upiId = _upiIdController.text.trim();
    final amount = _amountController.text.trim();

    if (!_isUpiIdValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please verify your UPI ID first.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red.shade800,
        ),
      );
      return;
    }

    if (upiId.isNotEmpty && amount.isNotEmpty) {
      setState(() {
        _qrData =
            'upi://pay?pa=$upiId&pn=School%20Fees&mc=0000&tid=123456789&tr=123456789&tn=School%20Fees&am=$amount&cu=INR';
        _isGenerated = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter UPI ID and amount.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red.shade800,
        ),
      );
    }
  }

  // Simulate Payment Process
  void _simulatePayment() {
    setState(() {
      _isTransactionSuccessful = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaction Successful!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green.shade800,
        ),
      );
    });
  }

  // Verify UPI ID
  void _verifyUpiId() {
    final upiId = _upiIdController.text.trim();
    final upiRegex = RegExp(r'^[a-zA-Z0-9.-]{2,256}@[a-zA-Z]{2,10}$');

    if (upiRegex.hasMatch(upiId)) {
      setState(() {
        _isUpiIdValid = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('UPI ID Verified Successfully!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green.shade800,
        ),
      );
    } else {
      setState(() {
        _isUpiIdValid = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid UPI ID. Please enter a valid UPI ID.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red.shade800,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'UPI Payment',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
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
                // Term and Fee Details
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.term,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Amount to be Paid: ₹${widget.fee}',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // UPI ID Input Field with Verify Button
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _upiIdController,
                        labelText: 'UPI ID',
                        hintText: 'e.g., user@bank or 9876543210@upi',
                        prefixIcon: Icons.account_balance_wallet,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _verifyUpiId,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 50),
                        backgroundColor: _isUpiIdValid ? Colors.green : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _isUpiIdValid ? 'Verified' : 'Verify',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Amount Input Field
                _buildTextField(
                  controller: _amountController,
                  labelText: 'Amount',
                  hintText: 'Enter amount to pay (₹)',
                  prefixIcon: Icons.currency_rupee_rounded,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                // Generate QR Code Button
                ElevatedButton(
                  onPressed: _generateQRCode,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Generate QR Code',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),

                // QR Code Section
                if (_isGenerated)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
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
                          QrImageView(
                            data: _qrData!,
                            version: QrVersions.auto,
                            size: 200.0,
                            backgroundColor: Colors.white,
                            foregroundColor: const Color.fromARGB(252, 88, 181, 193), // Sky Blue Color
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _generateQRCode,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    backgroundColor: Colors.amber,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Regenerate QR Code',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _simulatePayment,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Pay',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                // Transaction Success Message
                if (_isTransactionSuccessful)
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Icon(Icons.check_circle, color: Colors.green, size: 50),
                        const SizedBox(height: 8),
                        Text(
                          'Transaction Successful!',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
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

  // Reusable TextField Widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    IconData? prefixIcon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.blue.shade600) : null,
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
        hintStyle: TextStyle(color: Colors.grey.shade500),
      ),
    );
  }
}