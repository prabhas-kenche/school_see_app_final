import 'package:flutter/material.dart';

class TimeTableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for contrast
      body: Column(
        children: [
          // Top Section (Profile & Stats)
          Container(
            width: double.infinity,
            height: 250,
            padding: EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "June 28th",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Hey, Wesley!",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    // Profile Image
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue[100],
                      child: Icon(Icons.person, size: 35, color: Colors.blue),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                // Status Cards (Wrapped)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _statusCard("13", "Active", Colors.blue),
                    _statusCard("15", "Pending", Colors.grey),
                    _statusCard("21", "Completed", Colors.black),
                  ],
                ),
              ],
            ),
          ),

          // Image List Section (Scrollable)
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return _lessonCard(lesson["index"], lesson["title"], lesson["duration"], lesson["isLocked"]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCard(String number, String label, Color color) {
    return Container(
      width: 100, // Fixed width for consistency
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _lessonCard(int index, String title, String duration, bool isLocked) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // Left Icon (Play or Lock)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isLocked ? Colors.grey[800] : Colors.yellow[700],
            ),
            child: Icon(
              isLocked ? Icons.lock : Icons.play_arrow,
              color: isLocked ? Colors.white54 : Colors.black,
            ),
          ),
          SizedBox(width: 15),
          // Title and Duration
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5),
                Text(
                  duration,
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          // Index
          Text(
            index.toString(),
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// Lesson Data
final List<Map<String, dynamic>> lessons = [
  {"index": 1, "title": "Introduction", "duration": "3:45", "isLocked": false},
  {"index": 2, "title": "AI Tools Overview", "duration": "38:17", "isLocked": true},
  {"index": 3, "title": "AI-Driven UI Design", "duration": "24:53", "isLocked": true},
  {"index": 4, "title": "Smart Home App Design", "duration": "15:48", "isLocked": true},
  {"index": 5, "title": "AI Image to User Interface", "duration": "23:45", "isLocked": true},
  {"index": 6, "title": "Buttons and Effects", "duration": "8:33", "isLocked": true},
];

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TimeTableScreen(),
  ));
}
