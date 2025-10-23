import 'package:flutter/material.dart';

class TimeTableScreen extends StatelessWidget {
  const TimeTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 228, 230), // Light gray background
      body: Column(
        children: [
          // Top Section (Profile & Stats)
          Container(
            width: double.infinity,
            height: 250,
            padding: const EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
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
                        const Text(
                          "June 28th",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Hey, Wesley!",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    // Profile Image
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue[100],
                      child: const Icon(Icons.person, size: 35, color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Status Cards (Wrapped)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _statusCard("13", "Active", Colors.blue),
                    _statusCard("15", "Pending", Colors.black),
                    _statusCard("21", "Completed", Colors.black),
                  ],
                ),
              ],
            ),
          ),

          // Image List Section (Scrollable)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return _lessonCard(lesson["time"], lesson["title"]);
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
      padding: const EdgeInsets.all(12),
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
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _lessonCard(String time, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between icons and title
        children: [
          // Left Icon (Arrow facing right)
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 180, 231, 122), // Light green
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.black,
            ),
          ),
          // Title and Time (centered)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Center the title and time
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center, // Ensure text is centered
                ),
                const SizedBox(height: 5),
                Text(
                  time,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                  textAlign: TextAlign.center, // Ensure text is centered
                ),
              ],
            ),
          ),
          // Right Icon (Arrow facing left)
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 233, 126, 119), // Light red
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// Lesson Data
final List<Map<String, dynamic>> lessons = [
  {"time": "7:00 AM to 9:00 AM", "title": "Introduction", "duration": "2:00", "isLocked": false},
  {"time": "9:00 AM to 10:00 AM", "title": "AI Tools Overview", "duration": "1:00", "isLocked": false},
  {"time": "10:00 AM to 11:00 AM", "title": "AI-Driven UI Design", "duration": "1:00", "isLocked": false},
  {"time": "11:00 AM to 12:00 PM", "title": "Smart Home App Design", "duration": "1:00", "isLocked": true},
  {"time": "12:00 PM to 1:00 PM", "title": "AI Image to User Interface", "duration": "1:00", "isLocked": true},
  {"time": "1:00 PM to 2:00 PM", "title": "Buttons and Effects", "duration": "1:00", "isLocked": true},
  {"time": "2:00 PM to 3:00 PM", "title": "Lunch", "duration": "1:00", "isLocked": true},
  {"time": "3:00 PM to 5:00 PM", "title": "React JS", "duration": "2:00", "isLocked": true},
  {"time": "5:00 PM to 6:00 PM", "title": "Node JS", "duration": "1:00", "isLocked": true},
  {"time": "6:00 PM to 8:00 PM", "title": "AI and its Features", "duration": "2:00", "isLocked": true},
  {"time": "8:00 PM to 10:00 PM", "title": "Project Work", "duration": "2:00", "isLocked": true},
  {"time": "10:00 PM to 6:00 AM", "title": "Sleep", "duration": "8:00", "isLocked": true},
];

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TimeTableScreen(),
  ));
}