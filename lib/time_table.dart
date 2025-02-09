import 'package:flutter/material.dart';

class TimeTableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green, // Dark background for contrast
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
                return _lessonCard(lesson["time"], lesson["title"], lesson["duration"], lesson["isLocked"]);
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

  Widget _lessonCard(String time, String title, String duration, bool isLocked) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
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
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5),
                Text(
                  duration,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
          ),
          // Index
          Text(
            time,
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// Lesson Data
final List<Map<String, dynamic>> lessons = [
  {"time": "7: 00 AM to 9: 00 AM", "title": "Introduction", "duration": "2:00", "isLocked": false},
  {"time": "9: 00 AM to 10: 00 AM", "title": "AI Tools Overview", "duration": "1:00", "isLocked": true},
  {"time": "10: 00 AM to 11: 00 AM", "title": "AI-Driven UI Design", "duration": "1:00", "isLocked": true},
  {"time": "11: 00 AM to 12: 00 PM", "title": "Smart Home App Design", "duration": "1:00", "isLocked": true},
  {"time": "12: 00 PM to 1: 00 PM", "title": "AI Image to User Interface", "duration": "1:00", "isLocked": true},
  {"time": "1: 00 PM to 2: 00 PM", "title": "Buttons and Effects", "duration": "1:00", "isLocked": true},
  {"time": "2: 00 PM to 3: 00 PM", "title": "Lunch", "duration": "1:00", "isLocked": true},
  {"time": "3: 00 PM to 5: 00 PM", "title": "React JS", "duration": "2:00", "isLocked": true},
  {"time": "5: 00 PM to 6: 00 PM", "title": "Node JS", "duration": "1:00", "isLocked": true},
  {"time": "6: 00 PM to 8: 00 PM", "title": "AI and its Features", "duration": "2:00", "isLocked": true},
  {"time": "8:00 PM to 10: 00 PM", "title": "Project Work", "duration": "2:00", "isLocked": true},
  {"time": "10: 00 PM to 6: 00 AM", "title": "Sleep", "duration": "8:00", "isLocked": true},
];


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TimeTableScreen(),
  ));
}
