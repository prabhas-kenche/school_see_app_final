import 'package:flutter/material.dart';
import 'package:school_see/assignments.dart';

class Examtimetablescreen extends StatelessWidget {
  const Examtimetablescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Exam_time> exam_details = [
      Exam_time(
        title: 'UNIT TEST 1',
        StartDate: DateTime(2025, 12, 2),
        EndDate: DateTime(2025, 12, 10),
        description: 'Stay Focused on Learning ',
      ),
      Exam_time(
        title: 'UNIT TEST 2',
        StartDate: DateTime(2025, 12, 2),
        EndDate: DateTime(2025, 12, 10),
        description: ' Stay Focused on Learning ',
      ),
      Exam_time(
        title: 'UNIT TEST 3',
        StartDate: DateTime(2025, 12, 2),
        EndDate: DateTime(2025, 12, 10),
        description: 'Stay Focused on Learning ',
      ),
      Exam_time(
        title: 'Summative Assessment  1',
        StartDate: DateTime(2025, 12, 2),
        EndDate: DateTime(2025, 12, 10),
        description: 'Stay Focused on Learning ',
      ),
      Exam_time(
        title: 'UNIT TEST 4',
        StartDate: DateTime(2025, 12, 2),
        EndDate: DateTime(2025, 12, 10),
        description: 'Stay Focused on Learning ',
      ),
      Exam_time(
        title: 'UNIT TEST 5',
        StartDate: DateTime(2025, 12, 2),
        EndDate: DateTime(2025, 12, 10),
        description: 'Stay Focused on Learning ',
      ),
      Exam_time(
        title: 'Summative Assessment 2',
        StartDate: DateTime(2025, 12, 2),
        EndDate: DateTime(2025, 12, 10),
        description: 'Stay Focused on Learning ',
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      appBar: AppBar(
        title:
            Text('My Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 195, 219, 213),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 195, 219, 213),
              Colors.blue[100]!
            ],
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: exam_details.length,
          itemBuilder: (context, index) {
            return ExamTimeTable_Card(exam_timetable: exam_details[index]);
          },
        ),
      ),
    );
  }
}

class ExamTimeTable_Card extends StatelessWidget {
  final Exam_time exam_timetable;

  ExamTimeTable_Card({Key? key, required this.exam_timetable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Section (Title + Dates + Description)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with Gradient Background
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.lightGreen, Colors.green.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.0)),
                  ),
                  child: Text(
                    exam_timetable.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.event, size: 18, color: Colors.green),
                          SizedBox(width: 6),
                          _dateContainer(
                              'Start: ${_formatDate(exam_timetable.StartDate)}'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.event,
                              size: 18, color: Colors.red.shade600),
                          SizedBox(width: 6),
                          _dateContainer(
                              'End: ${_formatDate(exam_timetable.EndDate)}'),
                        ],
                      ),
                      SizedBox(height: 12),
                      // Description
                      Text(
                        exam_timetable.description,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.5,
                            color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Right Section (Image + Button)
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.deepOrange,
                height: 130,
                width: 150,
                child: Image.asset(
                  'assets/images/calendar.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade300,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      Text('View Time table', style: TextStyle(fontSize: 16.5)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper function to format date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Widget for date container
  Widget _dateContainer(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class Exam_time {
  final String title;
  final DateTime StartDate;
  final DateTime EndDate;
  final String description;

  Exam_time({
    required this.title,
    required this.EndDate,
    required this.StartDate,
    required this.description,
  });
}


// class ExamTimeTable_Card extends StatelessWidget {
//   final Exam_time exam_timetable;

//   ExamTimeTable_Card({Key? key, required this.exam_timetable})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 16.0),
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header with gradient background
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.lightGreen, Colors.green.shade400],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
//             ),
//             child: Text(
//               exam_timetable.title,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Start Date
//                 Container(
//                   child: Row(
//                     children: [
//                       Column(
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.event, size: 18, color: Colors.green),
//                               SizedBox(width: 6),
//                               _dateContainer(
//                                   'Start: ${_formatDate(exam_timetable.StartDate)}'),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Row(
//                             children: [
//                               Icon(Icons.event,
//                                   size: 18, color: Colors.red.shade600),
//                               SizedBox(width: 6),
//                               _dateContainer(
//                                   'End: ${_formatDate(exam_timetable.EndDate)}'),
//                             ],
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         height: 110,
//                         width: 140,
//                         child: Image.asset(
//                           'assets/images/calendar.png',
//                           fit: BoxFit.cover, // Covers the space properly
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Description
//                 Text(
//                   exam_timetable.description,
//                   style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 15.5,
//                       color: Colors.grey[800]),
//                 ),
//                 SizedBox(height: 16),

//                 // Button
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green.shade300,
//                       foregroundColor: Colors.white,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: Text('View Time table',
//                         style: TextStyle(fontSize: 14.5)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper function to format date
//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }

//   // Widget for date container
//   Widget _dateContainer(String text) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//             fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
//       ),
//     );
//   }
// }

// class Exam_time {
//   final String title;
//   final DateTime StartDate;
//   final DateTime EndDate;
//   final String description;

//   Exam_time({
//     required this.title,
//     required this.EndDate,
//     required this.StartDate,
//     required this.description,
//   });
// }