import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'navigation.dart';
import 'all_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color(0xFF00C853),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(
              builder: (context) {
                try {
                  return SvgPicture.asset(
                    'assets/images/notifications.svg',
                    height: 250,
                    width: 250,
                  );
                } catch (e) {
                  return const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 100,
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'No new notifications',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'All caught up',
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              onPressed: () {
                // Navigate back to the DashboardScreen
                final navigationState = context.findAncestorStateOfType<NavigationState>();
                if (navigationState != null) {
                  navigationState.setState(() {
                    navigationState.selectedIndex = 2; // Changed here
                    navigationState.currentScreen = navigationState.screens[2]; // Changed here
                  });
                }
              },
              child: const Text(
                'GO BACK',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              onPressed: () {
                final navigationState = context.findAncestorStateOfType<NavigationState>();
                if (navigationState != null) {
                  navigationState.setState(() {
                    navigationState.selectedIndex = 1;
                  });
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllNotifications()),
                );
              },
              child: const Text(
                'All Notifications',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),

          ],
        ),
      ),
    );
  }
}