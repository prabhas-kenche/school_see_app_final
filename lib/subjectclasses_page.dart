import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
  VideoPlayerController? _videoController;
  bool isPlaying = false;
  bool showControls = false;
  Duration currentPosition = Duration.zero;

  final List<Map<String, String>> mathTopics = [
    {'title': 'Algebra Basics', 'image': 'assets/images/algebra.png', 'video': 'assets/videos/bagheera.mp4'},
    {'title': 'Geometry Fundamentals', 'image': 'assets/images/geometrics.png', 'video': 'assets/videos/geometry.mp4'},
    {'title': 'Trigonometry Essentials', 'image': 'assets/images/trigonometry.png', 'video': 'assets/videos/trigonometry.mp4'},
    {'title': 'Calculus - Differentiation', 'image': 'assets/images/calculas.jpg'},
    {'title': 'Calculus - Integration', 'image': 'assets/images/integration.webp'},
    {'title': 'Probability & Statistics', 'image': 'assets/images/statistics.png'},
    {'title': 'Linear Algebra', 'image': 'assets/images/linear_algebra.png'},
    {'title': 'Number Theory', 'image': 'assets/images/number_theory.png'},
    {'title': 'Set Theory', 'image': 'assets/images/set_theory.png'},
    {'title': 'Complex Numbers', 'image': 'assets/images/complex_numbers.png'},
    {'title': 'Vector Mathematics', 'image': 'assets/images/vector.jpg'},
    {'title': 'Differential Equations', 'image': 'assets/images/differential.png'},
    {'title': 'Discrete Mathematics', 'image': 'assets/images/discrete.png'},
    {'title': 'Logic and Reasoning', 'image': 'assets/images/logic.png'},
    {'title': 'Graphs and Networks', 'image': 'assets/images/graphs.png'},
    {'title': 'Combinatorics', 'image': 'assets/images/combinatorics.png'},
  ];

  @override
  void dispose() {
    _videoController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _playVideo(String videoPath) {
    if (_videoController != null) {
      _videoController!.dispose();
    }
    _videoController = VideoPlayerController.asset(videoPath)
      ..initialize().then((_) {
        setState(() {
          _videoController!.play();
          isPlaying = true;
          _videoController!.setVolume(1.0); // Set original volume
          _videoController!.addListener(() {
            setState(() {
              currentPosition = _videoController!.value.position;
            });
          });
        });
      });
  }

  void _togglePlayPause() {
    if (_videoController == null) return;
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
        isPlaying = false;
      } else {
        _videoController!.play();
        isPlaying = true;
      }
      showControls = true; // Show controls when toggling play/pause
      _hideControlsAfterDelay();
    });
  }

  void _seekForward() {
    if (_videoController != null) {
      final newPosition = _videoController!.value.position + Duration(seconds: 10);
      _videoController!.seekTo(newPosition);
    }
  }

  void _seekBackward() {
    if (_videoController != null) {
      final newPosition = _videoController!.value.position - Duration(seconds: 10);
      _videoController!.seekTo(newPosition);
    }
  }

  void _toggleFullScreen() {
    if (_videoController == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FullScreenVideoPlayer(controller: _videoController!)),
    );
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
                : _videoController != null && _videoController!.value.isInitialized
                ? Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
                if (showControls) ...[
                  Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: VideoControls(
                      controller: _videoController!,
                      isPlaying: isPlaying,
                      onPlayPause: _togglePlayPause,
                      onSeekForward: _seekForward,
                      onSeekBackward: _seekBackward,
                      onFullScreen: _toggleFullScreen,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Text(
                      '${currentPosition.inMinutes}:${(currentPosition.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showControls = !showControls; // Toggle controls on tap
                    });
                    if (showControls) {
                      _hideControlsAfterDelay();
                    }
                  },
                ),
              ],
            )
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
                      _playVideo(topic['video']!);
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

class VideoControls extends StatelessWidget {
  final VideoPlayerController controller;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onSeekForward;
  final VoidCallback onSeekBackward;
  final VoidCallback onFullScreen;

  const VideoControls({
    Key? key,
    required this.controller,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onSeekForward,
    required this.onSeekBackward,
    required this.onFullScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.replay_10, color: Colors.white),
          onPressed: onSeekBackward,
        ),
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
          onPressed: onPlayPause,
        ),
        IconButton(
          icon: const Icon(Icons.forward_10, color: Colors.white),
          onPressed: onSeekForward,
        ),
        IconButton(
          icon: const Icon(Icons.fullscreen, color: Colors.white),
          onPressed: onFullScreen,
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            // Show settings options (e.g., quality, playback speed)
            _showSettings(context);
          },
        ),
      ],
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Quality'),
                onTap: () {
                  // Handle quality change
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Playback Speed'),
                onTap: () {
                  // Handle playback speed change
                  Navigator.pop(context);
                },
              ),
              // Add more settings options as needed
            ],
          ),
        );
      },
    );
  }
}

class FullScreenVideoPlayer extends StatelessWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (controller.value.isPlaying) {
            controller.pause();
          } else {
            controller.play();
          }
        },
        child: Icon(
          controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}