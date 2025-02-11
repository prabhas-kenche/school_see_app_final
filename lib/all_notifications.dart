import 'package:flutter/material.dart';

void main() => runApp(AllNotifications());

class AllNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final Map<String, List<Map<String, String>>> groupedNotifications = {
    "Today": [
      {
        "name": "Abilash",
        "message": "Commented on your post.",
        "color": "0xFFD8EFFF",
        "time": "Moments ago",
        "profilePic": "https://randomuser.me/api/portraits/women/1.jpg"
      },
      {
        "name": "Gokul",
        "message": "Sent you a friend request.",
        "color": "0xFFFFE1E0",
        "time": "2:30 PM",
        "profilePic": "https://randomuser.me/api/portraits/men/2.jpg"
      },
    ],
    "November 29, 2020": [
      {
        "name": "Mark",
        "message": "Liked your photo.",
        "color": "0xFFFFFFD7",
        "time": "1:15 PM",
        "profilePic": "https://randomuser.me/api/portraits/men/3.jpg"
      },
    ],
    "November 25, 2020": [
      {
        "name": "Suresh",
        "message": "Shared a post with you.",
        "color": "0xFFFFEDE6",
        "time": "10:45 AM",
        "profilePic": "https://randomuser.me/api/portraits/men/4.jpg"
      },
      {
        "name": "John",
        "message": "Tagged you in a post.",
        "color": "0xFFD8EFFF",
        "time": "Yesterday, 5:00 PM",
        "profilePic": "https://randomuser.me/api/portraits/men/5.jpg"
      },
    ],
  };

  bool _isNotificationOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Notifications"),
        actions: [
          IconButton(
            icon: Icon(_isNotificationOn ? Icons.notifications : Icons.notifications_off),
            onPressed: () {
              setState(() {
                _isNotificationOn = !_isNotificationOn;
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: groupedNotifications.keys.length,
        itemBuilder: (context, index) {
          String date = groupedNotifications.keys.elementAt(index);
          List<Map<String, String>> notifications = groupedNotifications[date]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        // Mark all as read functionality
                        print("Mark all notifications for $date as read");
                      },
                      child: Text("Mark All as Read"),
                    ),
                  ],
                ),
              ),
              ...notifications.map((notification) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Color(int.parse(notification["color"]!)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(notification["profilePic"]!),
                      backgroundColor: Colors.grey.shade300,
                    ),
                    title: Text(
                      notification["name"]!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(notification["message"]!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          notification["time"]!,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}

