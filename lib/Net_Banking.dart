import 'package:flutter/material.dart';

class NetBankingPage extends StatefulWidget {
  final String term;
  final int fee;

  const NetBankingPage({
    super.key,
    required this.term,
    required this.fee, required String selectedBank,
  });

  @override
  _NetBankingPageState createState() => _NetBankingPageState();
}

class _NetBankingPageState extends State<NetBankingPage> {
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String? _selectedBank;
  bool _isTransactionSuccessful = false;

  // List of banks for dropdown
  final List<String> _banks = [
    'Select Bank',
    'State Bank of India',
    'HDFC Bank',
    'ICICI Bank',
    'Axis Bank',
    'Kotak Mahindra Bank',
    'Punjab National Bank',
    'Bank of Baroda'
  ];

  void _handlePayment() {
    if (_selectedBank == null || _selectedBank == 'Select Bank') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a valid bank.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red.shade800,
        ),
      );
      return;
    }

    if (_accountNumberController.text.isEmpty ||
        _ifscCodeController.text.isEmpty ||
        _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red.shade800,
        ),
      );
      return;
    }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Net Banking Payment',
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
              Colors.teal.shade50,
              Colors.teal.shade100,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.term,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal.shade700),
                            ),
                            Icon(Icons.info_outline, color: Colors.teal.shade600),
                          ],
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

                // Select Bank Dropdown
                Text(
                  'Select Bank',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal.shade700),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedBank,
                  items: _banks.map((bank) {
                    return DropdownMenuItem<String>(
                      value: bank,
                      child: Text(bank),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBank = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.teal.shade100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    prefixIcon: Icon(Icons.account_balance, color: Colors.teal),
                    hintText: 'Choose your bank',
                  ),
                  dropdownColor: Colors.white,
                ),
                const SizedBox(height: 16),

                // Account Number Field
                Text(
                  'Account Number',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal.shade700),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _accountNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.teal.shade100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    prefixIcon: Icon(Icons.credit_card, color: Colors.teal),
                    hintText: 'Enter your account number',
                  ),
                ),
                const SizedBox(height: 16),

                // IFSC Code Field
                Text(
                  'IFSC Code',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal.shade700),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _ifscCodeController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.teal.shade100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    prefixIcon: Icon(Icons.confirmation_number, color: Colors.teal),
                    hintText: 'Enter IFSC code (e.g., HDFC0000456)',
                  ),
                ),
                const SizedBox(height: 16),

                // Amount to Pay Field
                Text(
                  'Amount to Pay',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal.shade700),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.teal.shade100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    prefixIcon: Icon(Icons.currency_rupee, color: Colors.teal),
                    hintText: 'Enter amount to pay (₹)',
                  ),
                ),
                const SizedBox(height: 24),

                // Pay Button
                ElevatedButton(
                  onPressed: _handlePayment,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: Colors.teal.withOpacity(0.5),
                  ),
                  child: Text(
                    'Pay Now',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),

                // Transaction Success Message
                if (_isTransactionSuccessful)
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 50,
                        ),
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
}