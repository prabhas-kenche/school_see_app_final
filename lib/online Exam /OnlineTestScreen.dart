import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final String subjectName = "Computer Science";
  final int questionNumber = 1;
  final String question = "What is the time complexity of binary search?";
  final List<String> options = ["O(n)", "O(log n)", "O(n^2)", "O(1)"];

  int? selectedOptionIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text(
              subjectName,
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Question $questionNumber",
              style: const TextStyle(fontSize: 20, color: Colors.lightGreen),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              question,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedOptionIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[800],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(2, 4),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Radio<int>(
                              value: index,
                              groupValue: selectedOptionIndex,
                              onChanged: (value) {
                                setState(() {
                                  selectedOptionIndex = value;
                                });
                              },
                              activeColor: Colors.greenAccent,
                            ),
                            SizedBox(width: 10),
                            Text(
                              options[index],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                backgroundColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Submit",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}
