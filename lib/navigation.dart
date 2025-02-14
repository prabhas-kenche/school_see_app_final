import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dashboard_screen.dart';
import 'digitalclasses.dart';
import 'fee_status.dart';
import 'busTrackingScreen.dart';
import 'resul_tpage.dart';
import 'studentdetails_page.dart';
import 'notifications.dart'; // Import the NotificationsPage
import 'assignments.dart';
import 'time_table.dart';
import 'all_notifications.dart';

class Navigation extends StatefulWidget {
  final Widget initialScreen;

  const Navigation({super.key, required this.initialScreen});

  @override
  NavigationState createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  int selectedIndex = 2;
  int notificationCount = 1;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final List<Widget> screens = [
    AssignmentPage(),
    NotificationsPage(),
    const DashboardScreen(),
    const BusTrackingScreen(),
    const StudentdetailsPage(),
  ];

  late Widget currentScreen;

  @override
  void initState() {
    super.initState();
    currentScreen = widget.initialScreen;
    _initializeNotifications();
    _showNotification();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Notification',
      'You have new notifications',
      platformChannelSpecifics,
    );
  }

  Color getNavBarBackgroundColor() {
    if (currentScreen is DashboardScreen) {
      return const Color(0xFFF5F7FB);
    } else if (currentScreen is EducationPage) {
      return const Color(0xFFF5F7FB);
    } else if (currentScreen is FeeStatusPage) {
      return Colors.white;
    } else if (currentScreen is BusTrackingScreen) {
      return Colors.deepPurple;
    } else if (currentScreen is ResultsPage) {
      return Colors.white;
    } else if (currentScreen is NotificationsPage) {
      return const Color(0xFF00C853);
    } else if (currentScreen is TimeTableScreen) {
      return Colors.green;
    } else {
      return const Color(0xFFF5F7FB);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentScreen,
      bottomNavigationBar: Container(
        color: getNavBarBackgroundColor(),
        child: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: Colors.blueGrey,
          items: [
            const Icon(Icons.assignment, size: 30, color: Colors.white),
            Stack(
              children: [
                const Icon(Icons.notifications, size: 30, color: Colors.white),
                if (notificationCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        notificationCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const Icon(Icons.home, size: 30, color: Colors.white),
            const Icon(Icons.directions_bus, size: 30, color: Colors.white),
            const Icon(Icons.person, size: 30, color: Colors.white),
          ],
          index: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
              currentScreen = screens[index];
              if (index == 1) {
                notificationCount = 0;
              } else if (notificationCount < 10) {
                notificationCount++;
              }
            });
          },
        ),
      ),
    );
  }
}
