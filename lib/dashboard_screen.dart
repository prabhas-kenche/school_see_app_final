import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'attendence_page.dart';
import 'digitalclasses.dart';
import 'fee_status.dart';
import 'resul_tpage.dart';
import 'busTrackingScreen.dart';
import 'navigation.dart';
import 'qa-game.dart';
import 'smart-calender.dart';
import 'time_table.dart';
import 'dart:io'; // Added for app exit functionality

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentIndex = 0;

  final List<String> carouselImages = [
    'assets/images/school.png',
    'assets/images/school1.png',
    'assets/images/sports.png',
    'assets/images/school.png',
    'assets/images/school1.png',
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showExitConfirmation, // Intercept back button press
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'School See!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Where the students store their data',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/school_see_logo.png'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CarouselSlider(
                  items: carouselImages.map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 150.0,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  carouselController: _carouselController,
                ),
                const SizedBox(height: 10),
                Center(
                  child: AnimatedSmoothIndicator(
                    activeIndex: _currentIndex,
                    count: carouselImages.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Colors.blueGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                    children: [
                      _DashboardCard(title: 'Attendance', icon: Icons.person_rounded, onTap: () => _navigateTo(const AttendencePage())),
                      _DashboardCard(title: 'Digital Classes', icon: Icons.cast_for_education, onTap: () => _navigateTo(const Digitalclasses())),
                      _DashboardCard(title: 'Fee Status', icon: Icons.payment, onTap: () => _navigateTo(FeeStatusPage())),
                      _DashboardCard(title: 'Bus Tracking', icon: Icons.directions_bus, onTap: () => _navigateTo(BusTrackingScreen())),
                      _DashboardCard(title: 'School Calendar', icon: Icons.calendar_month, onTap: () => _navigateTo(SmartCalenderPage())),
                      _DashboardCard(title: 'Time Table', icon: Icons.schedule, onTap: () => _navigateTo(TimeTableScreen())),
                      _DashboardCard(title: 'Results', icon: Icons.bar_chart, onTap: () => _navigateTo(ResultsPage())),
                      _DashboardCard(title: 'QA Game', icon: Icons.videogame_asset, onTap: () => _navigateTo(QAExamScreen())),
                      _DashboardCard(title: 'My Library', icon: Icons.local_library_outlined, onTap: () => _navigateTo(QAExamScreen())),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Navigation(initialScreen: screen)),
    );
  }

  // Show exit confirmation dialog
  Future<bool> _showExitConfirmation() async {
    bool? shouldExit = await showDialog(
      context: context, // Use context directly
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFE0E5EC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Center(
          child: Text(
            'Exit ?',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        content: const Padding(
          padding: EdgeInsets.only(top: 0.0), // Reduce space between title and content
          child: Text(
            'Are you sure ?',
            textAlign: TextAlign.center,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center, // Center buttons closer
        actionsPadding: const EdgeInsets.symmetric(vertical: 10.0), // Adjust padding between buttons
        actions: [
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF2C672D), foregroundColor: Colors.white),
            onPressed: () => exit(0),
            child: const Text('Yes'),
          ),
          SizedBox(width: 50), // Add gap between buttons
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFAF362D), foregroundColor: Colors.white),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }



}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueGrey),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
