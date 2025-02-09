import 'package:flutter/material.dart';

void main() {
  runApp(Assignments());
}

class Assignments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Assignments',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AssignmentPage(),
    );
  }
}

class AssignmentPage extends StatelessWidget {
  // Sample Data (Replace with your actual data source)
  final List<Assignment> assignments = [
    Assignment(
      title: 'Math Worksheet #3',
      dueDate: DateTime(2025, 2, 12),
      subject: 'Mathematics',
      description: 'Solve problems 1-15 on page 42.',
    ),
    Assignment(
      title: 'English Essay: My Favorite Book',
      dueDate: DateTime(2025, 2, 15),
      subject: 'English',
      description: 'Write a 500-word essay about your favorite book and why you enjoy it.',
    ),
    Assignment(
      title: 'Science Project: Solar System Model',
      dueDate: DateTime(2025, 2, 19),
      subject: 'Science',
      description: 'Create a model of the solar system using any materials you like.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Assignments', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple[300],
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple[100]!, Colors.blue[100]!],
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: assignments.length,
          itemBuilder: (context, index) {
            return AssignmentCard(assignment: assignments[index]);
          },
        ),
      ),
    );
  }
}

class AssignmentCard extends StatelessWidget {
  final Assignment assignment;

  const AssignmentCard({Key? key, required this.assignment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assignment.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple[700],
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.book, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(assignment.subject, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  'Due: ${assignment.dueDate.day}/${assignment.dueDate.month}/${assignment.dueDate.year}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              assignment.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // TODO: Implement view details functionality
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple[400],
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Assignment {
  final String title;
  final DateTime dueDate;
  final String subject;
  final String description;

  Assignment({
    required this.title,
    required this.dueDate,
    required this.subject,
    required this.description,
  });
}
