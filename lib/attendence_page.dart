import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'studentdetails_page.dart';
void main() {
  runApp(const AttendencePage());
}
class AttendencePage extends StatelessWidget {
  const AttendencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AttendanceDashboard(),
    );
  }
}

class AttendanceDashboard extends StatefulWidget {
  const AttendanceDashboard({super.key});

  @override
  _AttendanceDashboardState createState() => _AttendanceDashboardState();
}

class _AttendanceDashboardState extends State<AttendanceDashboard> {
  int _selectedIndex = 2; // Set the initial active index for the navigation bar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 178, 30),
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,

        ),
        backgroundColor: const Color.fromARGB(255, 242, 178, 30),
        elevation: 0,
        actions: [
          // Notifications Icon with White Background
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 8),

          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Top Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date and Week Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                '27',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                              Text(
                                'Wednesday',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                'August 2019',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.chevron_right,
                              size: 32,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "This week status",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildWeekStatus('M', true),
                          _buildWeekStatus('T', false, isAbsent: true),
                          _buildWeekStatus('W', true),
                          _buildWeekStatus('Th', false),
                          _buildWeekStatus('Fr', false),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Bottom Cards with Circular Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCircularCard('83%', 'Attendance', Colors.indigo),
                  _buildCircularCard('03', 'Leave Taken', Colors.deepPurple),
                  _buildCircularCard('23', 'Ongoing Days', Colors.blueAccent),
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildWeekStatus(String day, bool isPresent, {bool isAbsent = false}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: isPresent
              ? Colors.indigo
              : isAbsent
                  ? Colors.red
                  : Colors.grey.shade300,
          child: Icon(
            isPresent
                ? Icons.check
                : isAbsent
                    ? Icons.close
                    : Icons.circle,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isPresent
                ? Colors.indigo
                : isAbsent
                    ? Colors.red
                    : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildCircularCard(String value, String label, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 100,
        height: 120,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular Progress Indicator
            Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.83, // Replace with dynamic value
                  strokeWidth: 8,
                  backgroundColor: Colors.grey.shade300,
                  color: color,
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: const Center(
        child: Text("This is the Notifications Page"),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: const Center(
        child: Text("This is the Profile Page"),
      ),
    );
  }
}
