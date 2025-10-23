import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import the Cupertino package
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'attendence_page.dart';
import 'dashboard_screen.dart';
import 'digitalclasses.dart';
import 'fee_status.dart';
import 'busTrackingScreen.dart';
import 'resul_tpage.dart';
import 'studentdetails_page.dart';
import 'notifications.dart'; // Import the NotificationsPage
import 'assignments.dart';
import 'time_table.dart';
import 'gate_pass_screen.dart';
import 'subjectclasses_page.dart';
import 'main.dart';
import 'package:flutter/services.dart';

class Navigation extends StatefulWidget {
  final Widget initialScreen;
  final String? enrollId; // Add enrollId parameter (optional)
  const Navigation({super.key, required this.initialScreen, this.enrollId});

  @override
  NavigationState createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  int selectedIndex = 2;
  int notificationCount = 1;
  bool isVideoFullScreen = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // Remove StudentDetailsApp/Profile page from static list, handle dynamically
  final List<Widget> screens = [
    AssignmentPage(),         // Index 0
    NotificationsPage(),      // Index 1
    const DashboardScreen(),  // Index 2
    const BusTrackingScreen(),// Index 3
    // Index 4 (Profile) handled in onTap
  ];
  // Add other screens if they correspond to indices > 4 in the nav bar
  // For now, assuming the nav bar only has 5 items as shown later.

  late Widget currentScreen;

  @override
  void initState() {
    super.initState();
    if (widget.initialScreen is SubjectClassesPage) {
      // Create SubjectClassesPage with fullscreen callback
      currentScreen = SubjectClassesPage(
        onFullScreenChanged: setFullScreen,
      );
    } else {
      currentScreen = widget.initialScreen;
    }
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
   if (currentScreen is EducationPage) {
      return const Color(0xFFF5F7FB);
    } else if (currentScreen is FeeStatusPage) {
      return Colors.white;
    } else if (currentScreen is BusTrackingScreen) {
      return const Color.fromARGB(255, 202, 201, 203);
    } else if (currentScreen is ResultsPage) {
      return Colors.white;
    } else if (currentScreen is NotificationsPage) {
      return const Color(0xFF00C853);
    } else if (currentScreen is TimeTableScreen) {
      return Colors.green;
    } else if (currentScreen is AttendanceScreen) {
      return const Color.fromARGB(251, 241, 169, 26);
    } else {
      return const Color(0xFFF5F7FB);
    }
  }

  bool shouldShowBottomNav() {
    // Bottom navigation bar should not appear on the login page, main page, or when video is in full screen
    return !(currentScreen is LoginForm || 
            currentScreen is SchoolSeeApp || 
            currentScreen is AdminLoginPage ||
            currentScreen is CourseListPage) && !isVideoFullScreen;
  }

  void setFullScreen(bool isFullScreen) {
    if (mounted) {
      setState(() {
        isVideoFullScreen = isFullScreen;
        
        // Set orientation based on fullscreen state
        if (isFullScreen) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        } else {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Normal scaffold with gradient background and bottom nav
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 248, 251, 252),
              const Color.fromARGB(255, 250, 253, 255),
            ],
          ),
        ),
        child: currentScreen,
      ),
      bottomNavigationBar: shouldShowBottomNav()
          ? CurvedNavigationBar(
              backgroundColor: Colors.transparent,
              color: Colors.blueGrey,
              height: 60,
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 380),
              items: [
                Icon(Icons.assignment, size: 30, color: Colors.white),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.notifications, size: 30, color: Colors.white),
                    if (notificationCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            notificationCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                Icon(Icons.home, size: 30, color: Colors.white),
                Icon(Icons.directions_bus, size: 30, color: Colors.white),
                Icon(Icons.person, size: 30, color: Colors.white),
              ],
              index: selectedIndex,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                  // Reset fullscreen state when navigating
                  isVideoFullScreen = false;
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                  // Dynamically create the screen based on index
                  switch (index) {
                    case 0:
                      currentScreen = AssignmentPage();
                      break;
                    case 1:
                      currentScreen = NotificationsPage();
                      notificationCount = 0; // Reset count when viewing notifications
                      break;
                    case 2:
                      currentScreen = const DashboardScreen();
                      break;
                    case 3:
                      currentScreen = const BusTrackingScreen();
                      break;
                    case 4:
                      // Pass the enrollId when navigating to the profile page
                      currentScreen = StudentProfilePage(enrollId: widget.enrollId ?? ''); 
                      break;
                    default:
                      if (widget.initialScreen is SubjectClassesPage) {
                        currentScreen = SubjectClassesPage(
                          onFullScreenChanged: setFullScreen,
                        );
                      } else {
                        currentScreen = widget.initialScreen;
                      }
                      break;
                  }

                  // Handle notification count increment separately if needed (removed from here)
                  // Original logic: incremented count unless index was 1
                  if (index != 1 && notificationCount < 10) {
                     // This logic might need review - why increment on every tap except notifications?
                     // Commenting out for now as it seems unrelated to the primary task.
                     // notificationCount++; 
                  } else if (notificationCount < 10) {
                    notificationCount++;
                  }
                });
              },
            )
          : null,
    );
  }

  @override
  void dispose() {
    // Reset orientation when disposing
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
