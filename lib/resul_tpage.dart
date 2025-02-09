import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Student Performance Report',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              _buildAssessmentCard('Formative Assessment 1', 50),
              _buildAssessmentCard('Formative Assessment 2', 50),
              _buildAssessmentCard('Quarterly Examination', 100),
              _buildAssessmentCard('Formative Assessment 3', 50),
              _buildAssessmentCard('Formative Assessment 4', 50),
              _buildAssessmentCard('Half Yearly Examination', 100),
              _buildAssessmentCard('Annual Examination', 100),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add download functionality here
                  },
                  child: Text('Download Report'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssessmentCard(String title, int totalMarks) {
    List<Map<String, dynamic>> subjects = [
      {'name': 'Mathematics', 'theory': totalMarks == 50 ? 30 : 80, 'internal': 20},
      {'name': 'Science', 'theory': totalMarks == 50 ? 30 : 80, 'internal': 20},
      {'name': 'English', 'theory': totalMarks == 50 ? 30 : 80, 'internal': 20},
    ];

    int totalTheory = subjects.fold(0, (sum, sub) => sum + (sub['theory'] as int));
    int totalInternal = subjects.fold(0, (sum, sub) => sum + (sub['internal'] as int));
    int totalObtained = totalTheory + totalInternal;
    double percentage = (totalObtained / (subjects.length * totalMarks)) * 100;
    String grade = _getGrade(percentage);

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Table(
              border: TableBorder.all(color: Colors.black),
              columnWidths: {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    _buildTableHeader('Subject'),
                    _buildTableHeader('Internal'),
                    _buildTableHeader('Theory'),
                    _buildTableHeader('Total'),
                  ],
                ),
                ...subjects.map((sub) => TableRow(children: [
                  _buildTableCell(sub['name']),
                  _buildTableCell(sub['internal'].toString()),
                  _buildTableCell(sub['theory'].toString()),
                  _buildTableCell((sub['internal'] + sub['theory']).toString()),
                ])),
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  children: [
                    _buildTableHeader('Total'),
                    _buildTableCell(totalInternal.toString()),
                    _buildTableCell(totalTheory.toString()),
                    _buildTableCell(totalObtained.toString()),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Percentage: ${percentage.toStringAsFixed(2)}% | Grade: $grade',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, textAlign: TextAlign.center),
    );
  }

  String _getGrade(double percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B+';
    if (percentage >= 60) return 'B';
    if (percentage >= 50) return 'C';
    return 'F';
  }
}
