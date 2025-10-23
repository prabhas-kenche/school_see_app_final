import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'payment.dart';

class FeeStatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fee Status',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FeeStatusBody(),
    );
  }
}

class FeeStatusBody extends StatefulWidget {
  @override
  _FeeStatusBodyState createState() => _FeeStatusBodyState();
}

class _FeeStatusBodyState extends State<FeeStatusBody> {
  int selectedCount = 0;
  final List<Map<String, dynamic>> selectedFees = [];
  bool showFloatingButtons = false;

  void updateSelection(String term, int fee, bool isSelected, Color color) {
    setState(() {
      if (isSelected) {
        selectedCount++;
        selectedFees.add({'term': term, 'fee': fee});
      } else {
        selectedCount--;
        selectedFees.removeWhere((item) => item['term'] == term);
      }
      showFloatingButtons = selectedCount > 0;
    });
  }

  Future<void> navigateToPayment(BuildContext context) async {
    final updatedFees = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          term: 'All Terms',
          fee: 50000,
          endDate: '30-06-2025',
          status: 'Pending',
          selectedFees: List.from(selectedFees),
          onRemoveFee: (String termToRemove) {},
        ),
      ),
    );
    if (updatedFees != null && updatedFees is List<Map<String, dynamic>>) {
      setState(() {
        selectedFees.clear();
        selectedFees.addAll(updatedFees);
        selectedCount = selectedFees.length;
        showFloatingButtons = selectedCount > 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade300, Colors.blueGrey.shade200],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fee Status',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Class: 8',
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                FeeList(
                  onUpdateSelection: updateSelection,
                ),
              ],
            ),
          ),
        ),
        if (showFloatingButtons)
          Positioned(
            bottom: 16,
            left: 16,
            child: CounterWidget(selectedCount: selectedCount),
          ),
        if (showFloatingButtons)
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.blueGrey.shade200],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: () => navigateToPayment(context),
                label: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class FeeList extends StatefulWidget {
  final Function(String, int, bool, Color) onUpdateSelection;

  FeeList({required this.onUpdateSelection});

  @override
  _FeeListState createState() => _FeeListState();
}

class _FeeListState extends State<FeeList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 6,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return FeeCard(
                  term: 'All Terms',
                  fee: 85000,
                  percentagePaid: 1.0,
                  startDate: '10-03-2025',
                  endDate: '30-09-2025',
                  status: 'One Settlement',
                  onSelectionChanged: (isSelected) =>
                      widget.onUpdateSelection('All Terms', 85000, isSelected, Colors.blue.shade300),
                );
              case 1:
                return FeeCard(
                  term: 'Term 1',
                  fee: 40000,
                  percentagePaid: 0.5,
                  endDate: '31-03-2025',
                  status: 'Completed',
                  onSelectionChanged: (isSelected) =>
                      widget.onUpdateSelection('Term 1', 40000, isSelected, Colors.blue.shade300),
                );
              case 2:
                return FeeCard(
                  term: 'Term 2',
                  fee: 25000,
                  percentagePaid: 0.3,
                  endDate: '30-06-2025',
                  status: 'Pending',
                  onSelectionChanged: (isSelected) =>
                      widget.onUpdateSelection('Term 2', 25000, isSelected, Colors.blue.shade300),
                );
              case 3:
                return FeeCard(
                  term: 'Term 3',
                  fee: 20000,
                  percentagePaid: 0.2,
                  endDate: '30-09-2025',
                  status: 'Over Due',
                  onSelectionChanged: (isSelected) =>
                      widget.onUpdateSelection('Term 3', 20000, isSelected, Colors.blue.shade300),
                );
              case 4:
                return FeeCard(
                  term: 'Exam Fee',
                  fee: 5000,
                  percentagePaid: 1.0,
                  endDate: '15-10-2025',
                  status: 'Pending',
                  onSelectionChanged: (isSelected) =>
                      widget.onUpdateSelection('Exam Fee', 5000, isSelected, Colors.blue.shade300),
                );
              case 5:
                return FeeCard(
                  term: 'Bus Fee',
                  fee: 20000,
                  percentagePaid: 1.0,
                  endDate: '15-10-2025',
                  status: 'Completed',
                  onSelectionChanged: (isSelected) =>
                      widget.onUpdateSelection('Bus Fee', 20000, isSelected, Colors.blue.shade300),
                );
              default:
                return SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}

class CounterWidget extends StatelessWidget {
  final int selectedCount;

  const CounterWidget({required this.selectedCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.blueGrey.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Selected: $selectedCount',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class FeeCard extends StatefulWidget {
  final String term;
  final int fee;
  final double percentagePaid;
  final String? startDate;
  final String endDate;
  final String status;
  final Function(bool) onSelectionChanged;

  const FeeCard({
    required this.term,
    required this.fee,
    required this.percentagePaid,
    this.startDate,
    required this.endDate,
    required this.status,
    required this.onSelectionChanged,
  });

  @override
  _FeeCardState createState() => _FeeCardState();
}

class _FeeCardState extends State<FeeCard> {
  bool isSelected = false;

  void toggleSelection() {
    setState(() {
      isSelected = !isSelected;
      widget.onSelectionChanged(isSelected);
    });
  }

  Color _getBackgroundColor() {
    switch (widget.status) {
      case 'Pending':
      case 'One Time Settlement':
        return Colors.orangeAccent.shade100;
      case 'Completed':
        return Colors.green.shade100;
      case 'Over Due':
        return const Color.fromARGB(255, 245, 54, 73);
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getTextColor() {
    return widget.status == 'Completed' ? Colors.green : Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    bool isClickable = widget.status != 'Completed';
    Color cardColor = _getBackgroundColor();
    return GestureDetector(
      onTap: isClickable
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    term: widget.term,
                    fee: widget.fee,
                    endDate: widget.endDate,
                    status: widget.status,
                    selectedFees: [],
                    onRemoveFee: (String termToRemove) {},
                  ),
                ),
              );
            }
          : null,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.black12, width: 1),
        ),
        elevation: 4,
        margin: EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.term,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getTextColor(),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Fee: ₹${widget.fee}',
                        style: TextStyle(
                          fontSize: 16,
                          color: _getTextColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      if (widget.startDate != null)
                        Text(
                          'Start Date: ${widget.startDate}',
                          style: TextStyle(
                            fontSize: 14,
                            color: _getTextColor(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      SizedBox(height: 6),
                      Text(
                        'End Date: ${widget.endDate}',
                        style: TextStyle(
                          fontSize: 14,
                          color: _getTextColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: widget.status == 'Completed'
                            ? Colors.green
                            : Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.status == 'One Settlement'
                            ? 'One Time Settlement'
                            : widget.status,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    CircularPercentIndicator(
                      radius: 30,
                      lineWidth: 5.0,
                      percent: widget.percentagePaid,
                      center: Text(
                        '${(widget.percentagePaid * 100).toInt()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      progressColor: Colors.blue.shade600,
                      backgroundColor: Colors.grey.shade300,
                    ),
                    if (widget.status == 'Pending' ||
                        widget.status == 'Over Due' ||
                        widget.status == 'One Time Settlement')
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ElevatedButton(
                          onPressed: toggleSelection,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? Colors.red.shade300
                                : Colors.blue.shade300,
                            side: BorderSide(color: Colors.black54, width: 1.5),
                            elevation: 4,
                            shadowColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          child: Text(
                            isSelected ? 'Remove' : 'Add To Pay',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}