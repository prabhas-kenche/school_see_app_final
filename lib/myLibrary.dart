import 'package:flutter/material.dart';

class Mylibrary extends StatelessWidget {
  const Mylibrary({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final List<Map<String, String>> tileData = [
      {
        "image": "assets/images/maths.png",
        "text": "Maths",
        "subtitle": "Lorem ipsum lorem ipsum lorem ipsum"
      },
      {
        "image": "assets/images/science.png",
        "text": "Science",
        "subtitle": "Lorem ipsum lorem ipsum lorem ipsum"
      },
      {
        "image": "assets/images/social.png",
        "text": "Social",
        "subtitle": "Lorem ipsum lorem ipsum lorem ipsum"
      },
      {
        "image": "assets/images/english2.png",
        "text": "English",
        "subtitle": "Lorem ipsum lorem ipsum lorem ipsum"
      },
      {
        "image": "assets/images/algebra.png",
        "text": "Algebra",
        "subtitle": "Lorem ipsum lorem ipsum lorem ipsum"
      },
      {
        "image": "assets/images/algebra.png",
        "text": "Algebra",
        "subtitle": "Lorem ipsum lorem ipsum lorem ipsum"
      },
      {
        "image": "assets/images/algebra.png",
        "text": "Algebra",
        "subtitle": "Lorem ipsum lorem ipsum lorem ipsum"
      },
      {
        "image": "assets/images/algebra.png",
        "text": "Algebra",
        "subtitle": "Lorem ipsum lorem ipsum lorem ipsum"
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.08),
            Container(
              margin: const EdgeInsets.only(left: 30),
              height: screenHeight * 0.17,
              width: screenWidth * 0.87,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(208, 223, 219, 0.898),
                borderRadius: BorderRadius.circular(45),
                border: Border.all(color: Colors.white),
              ),
              child: Image.asset(
                'assets/images/school_see_logo.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Library is not a luxury but one of the necessities of life.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 21.0),
              child: Text(
                "Ready to Read something Special?",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Wrap(
                spacing: 10,
                runSpacing: 20,
                children: tileData.map((data) {
                  return SizedBox(
                    width: (screenWidth - 40) / 2, // 2 items per row
                    child: _buildStudytile(
                      data['text']!,
                      data['subtitle']!,
                      data['image']!,
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            _buildStudytileLong(
                "Product",
                "lorem ispum loren isoum loren ispum",
                'assets/images/differential.png'),
            _buildStudytileLong(
                "Product",
                "lorem ispum loren isoum loren ispum",
                'assets/images/differential.png'),
          ],
        ),
      ),
    );
  }
}

Widget _buildStudytile(String title, String subtitle, String imageUrl) {
  return GestureDetector(
    child: Container(
      height: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(228, 218, 234, 230),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageUrl,
              width: 40, // Adjust width for rectangle shape
              height: 50, // Adjust height to match width for a square image
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10), // Spacing between image and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildStudytileLong(String title, String subtitle, String imageUrl) {
  return GestureDetector(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imageUrl,
                width: 40, // Adjust width for rectangle shape
                height: 50, // Adjust height to match width for a square image
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10), // Spacing between image and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
