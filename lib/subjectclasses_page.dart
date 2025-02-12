import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

void main() {
  runApp(const SubjectclassesPage());
}

class SubjectclassesPage extends StatelessWidget {
  const SubjectclassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CourseListPage(),
    );
  }
}

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  final ScrollController _scrollController = ScrollController();
  String? selectedTopicTitle;
  Player? _player;
  VideoController? _videoController;
  bool isPlaying = false;
  bool showControls = false;
  Duration currentPosition = Duration.zero;

  final List<Map<String, String>> mathTopics = [
    {'title': 'Algebra Basics', 'image': 'assets/images/algebra.png', 'video': 'assets/videos/bagheera.mp4'},
    {'title': 'Geometry Fundamentals', 'image': 'assets/images/geometrics.png', 'video': 'assets/videos/geometry.mp4'},
    {'title': 'Trigonometry Essentials', 'image': 'assets/images/trigonometry.png', 'video': 'assets/videos/trigonometry.mp4'},
    {'title': 'Calculus - Differentiation', 'image': 'assets/images/calculas.jpg'},
    {'title': 'Calculus - Integration', 'image': 'assets/images/integration.webp'},
  ];

  @override
  void dispose() {
    _player?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _playVideo(String videoPath) {
    _player?.dispose();
    _player = Player();
    _videoController = VideoController(_player!);
    _player!.open(Media(videoPath));
    setState(() {
      isPlaying = true;
      showControls = true;
    });
    _hideControlsAfterDelay();
  }

  void _togglePlayPause() {
    if (_player == null) return;
    setState(() {
      if (isPlaying) {
        _player!.pause();
      } else {
        _player!.play();
      }
      isPlaying = !isPlaying;
      showControls = true;
    });
    _hideControlsAfterDelay();
  }

  void _hideControlsAfterDelay() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showControls = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Topics'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: selectedTopicTitle == null
                ? Image.asset('assets/images/placeholder.png', fit: BoxFit.cover)
                : _videoController != null
                ? Video(controller: _videoController!)
                : const Center(child: CircularProgressIndicator()),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: mathTopics.length,
              itemBuilder: (context, index) {
                final topic = mathTopics[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTopicTitle = topic['title'];
                      if (topic.containsKey('video')) {
                        _playVideo(topic['video']!);
                      }
                    });
                  },
                  child: _buildTopicCard(topic['title']!, topic['image']!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(String title, String image) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(image, width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
