import 'package:flutter/material.dart';

class Onlineexams extends StatelessWidget {
  const Onlineexams({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 253, 255),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            Center(
                child:
                    Image.asset(height: 70, 'assets/images/bluepapertest.png')),
            SizedBox(
              height: 20,
            ),
            // static text
            Text(
              " Your Test is ready ! ",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            Text(
              "  Every question is a step closer to success  ",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 25,
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: Colors.grey.shade100,
              ),
              height: 420,
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Exam Name ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 20.0),
                    child: Text(
                      "topics covered : Physics , Bio",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  //inner container -3
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      height: 240,
                      width: 270,
                      child: Column(
                        children: [
                          ReusableTile(
                              title: 'Time Allowed',
                              subtitle: 30,
                              imageUrl: "assets/images/timer2.png"),
                          Divider(
                            color: Colors.grey.shade300,
                            height: 10,
                            indent: 10,
                            endIndent: 10,
                          ),
                          ReusableTile(
                              title: 'No. of Questions',
                              subtitle: 20,
                              imageUrl: "assets/images/question2.png"),
                          Divider(
                            color: Colors.grey.shade300,
                            height: 10,
                            indent: 10,
                            endIndent: 10,
                          ),
                          ReusableTile(
                              title: 'Total Marks  ',
                              subtitle: 130,
                              imageUrl: "assets/images/tick2.png"),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StartButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ReusableTile extends StatelessWidget {
  final String title;
  final int subtitle;
  final String imageUrl;

  const ReusableTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.image, size: 50, color: Colors.grey[700]);
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  '$subtitle ',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor: Colors.blue.shade800,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Curved edges
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Start Your Test ",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
