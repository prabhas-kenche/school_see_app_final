import 'package:flutter/material.dart';
import 'upi_payment_page.dart';
import 'CardPayment.dart';
import 'Net_Banking.dart';

class PaymentPage extends StatefulWidget {
  final String term;
  final int fee;
  final String endDate;
  final String status;
  final List<Map<String, dynamic>> selectedFees;

  const PaymentPage({
    super.key,
    required this.term,
    required this.fee,
    required this.endDate,
    required this.status,
    required this.selectedFees,
    required Null Function(String termToRemove) onRemoveFee,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? selectedPaymentMethod;
  String? selectedNetBankingOption;
  bool showWarning = false;
  double _sliderPosition = 0.0;
  bool _isSlidingComplete = false;

  int getTotalFee() {
    num totalFee = widget.fee;
    for (var fee in widget.selectedFees) {
      totalFee += fee['fee'];
    }
    return totalFee.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.selectedFees); // Return updated fees
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Payment Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          toolbarHeight: 40,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          leading: Transform.translate(
            offset: Offset(0, -12),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, widget.selectedFees); // Return updated fees
              },
            ),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          'Base Fee: ₹${widget.fee}',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'End Date: ${widget.endDate}',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (widget.selectedFees.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Fees:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      ...widget.selectedFees.map((fee) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              fee['term'],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Fee: ₹${fee['fee']}', style: TextStyle(fontSize: 14, color: Colors.black54)),
                                Text('End Date: ${fee['endDate']}', style: TextStyle(fontSize: 14, color: Colors.black54)),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  widget.selectedFees.remove(fee);
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                const SizedBox(height: 20),
                Text(
                  'Total Fee: ₹${getTotalFee()}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, widget.selectedFees); // Return updated fees
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Add More',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                Divider(thickness: 1, color: Colors.black12),
                const SizedBox(height: 20),
                Text(
                  'Payment Methods',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.black12, width: 1),
                  ),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/googlepay.png', width: 30, height: 30),
                      const SizedBox(width: 8),
                      Image.asset('assets/images/phonepay.png', width: 30, height: 30),
                      const SizedBox(width: 8),
                      Image.asset('assets/images/paytm.png', width: 30, height: 30),
                    ],
                  ),
                  title: Text('UPI Payment'),
                  trailing: Radio<String>(
                    value: 'UPI Payment',
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value;
                        selectedNetBankingOption = null;
                        _resetSlider();
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      selectedPaymentMethod = 'UPI Payment';
                      selectedNetBankingOption = null;
                      _resetSlider();
                    });
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.black12, width: 1),
                  ),
                  leading: Image.asset('assets/images/cards.png', width: 30, height: 30),
                  title: Text('Credit & Debit Cards'),
                  trailing: Radio<String>(
                    value: 'Credit & Debit Cards',
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value;
                        selectedNetBankingOption = null;
                        _resetSlider();
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      selectedPaymentMethod = 'Credit & Debit Cards';
                      selectedNetBankingOption = null;
                      _resetSlider();
                    });
                  },
                ),
                const SizedBox(height: 8),
                ExpansionTile(
                  title: Text('Net Banking'),
                  leading: Icon(Icons.local_atm, color: Colors.green),
                  children: [
                    ListTile(
                      leading: Image.asset('assets/images/sbi.png', width: 30, height: 30),
                      title: Text('SBI'),
                      trailing: Radio<String>(
                        value: 'SBI',
                        groupValue: selectedNetBankingOption,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = 'Net Banking';
                            selectedNetBankingOption = value;
                            _resetSlider();
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          selectedPaymentMethod = 'Net Banking';
                          selectedNetBankingOption = 'SBI';
                          _resetSlider();
                        });
                      },
                    ),
                    ListTile(
                      leading: Image.asset('assets/images/icici.png', width: 30, height: 30),
                      title: Text('ICICI'),
                      trailing: Radio<String>(
                        value: 'ICICI',
                        groupValue: selectedNetBankingOption,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = 'Net Banking';
                            selectedNetBankingOption = value;
                            _resetSlider();
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          selectedPaymentMethod = 'Net Banking';
                          selectedNetBankingOption = 'ICICI';
                          _resetSlider();
                        });
                      },
                    ),
                    ListTile(
                      leading: Image.asset('assets/images/kotak.png', width: 30, height: 30),
                      title: Text('Kotak'),
                      trailing: Radio<String>(
                        value: 'Kotak',
                        groupValue: selectedNetBankingOption,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = 'Net Banking';
                            selectedNetBankingOption = value;
                            _resetSlider();
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          selectedPaymentMethod = 'Net Banking';
                          selectedNetBankingOption = 'Kotak';
                          _resetSlider();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (showWarning)
                  Center(
                    child: Text(
                      'Please select a payment method!',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  )
                else if (selectedPaymentMethod == null)
                  Center(
                    child: Text(
                      'Select Payment Method',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  )
                else
                  Center(
                    child: _buildSliderButton(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliderButton() {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _sliderPosition += details.delta.dx;
          if (_sliderPosition < 0) {
            _sliderPosition = 0;
          } else if (_sliderPosition > 200) {
            _sliderPosition = 200;
          }
        });
      },
      onHorizontalDragEnd: (details) {
        if (_sliderPosition >= 200) {
          setState(() {
            _isSlidingComplete = true;
          });
          _handleContinue();
        } else {
          setState(() {
            _sliderPosition = 0;
          });
        }
      },
      child: Container(
        width: 228,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              width: _sliderPosition,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                _isSlidingComplete ? 'Slide to Continue...' : 'Slide to Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _isSlidingComplete ? const Color.fromARGB(255, 13, 10, 10) : Colors.black,
                ),
              ),
            ),
            Positioned(
              left: _sliderPosition - 25,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleContinue() {
    if (selectedPaymentMethod == null) {
      setState(() {
        showWarning = true;
      });
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          showWarning = false;
        });
      });
      return;
    }
    if (selectedPaymentMethod == 'UPI Payment') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UPIPaymentPage(
            term: widget.term,
            fee: getTotalFee(),
          ),
        ),
      );
    } else if (selectedPaymentMethod == 'Credit & Debit Cards') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardPaymentPage(
            term: widget.term,
            fee: getTotalFee(),
          ),
        ),
      );
    } else if (selectedPaymentMethod == 'Net Banking') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NetBankingPage(
            term: widget.term,
            fee: getTotalFee(),
            selectedBank: selectedNetBankingOption!,
          ),
        ),
      );
    }
  }

  void _resetSlider() {
    setState(() {
      _sliderPosition = 0;
      _isSlidingComplete = false;
    });
  }
}